#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Phase 8: Memory-OneDrive Sync Manager
Main control logic for 2-layer agent architecture
Syncs CLAUDE.md between OneDrive and local with minimal token consumption

Strategy:
  - State caching: Use MD5 hash to detect changes
  - Diff-based sync: Only sync changed content
  - Batch processing: Combine multiple sync operations
  - Query optimization: Minimize API calls
"""

import os
import json
import hashlib
import datetime
import pathlib
import logging
from typing import Dict, Any, Optional, Tuple

# ============================================================
# Configuration
# ============================================================

# Primary sync paths (OneDrive is master)
ONEDRIVE_CLAUDE_PATH = pathlib.Path(
    os.path.expandvars(r"%USERPROFILE%\OneDrive\.claude\CLAUDE.md")
)
LOCAL_CLAUDE_PATH = pathlib.Path.home() / ".claude" / "CLAUDE.md"

# Cache and state files
CACHE_DIR = pathlib.Path.home() / ".claude"
SYNC_CACHE_FILE = CACHE_DIR / "sync_cache.json"
SYNC_LOG_FILE = CACHE_DIR / "sync_log.txt"

# Default cache structure
DEFAULT_CACHE = {
    "last_sync": None,
    "onedrive_hash": None,
    "local_hash": None,
    "sync_count": 0,
    "error_count": 0,
    "last_error": None,
}

# ============================================================
# Logging Setup
# ============================================================

def setup_logging():
    """Initialize logging to both file and console"""
    CACHE_DIR.mkdir(parents=True, exist_ok=True)

    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s',
        handlers=[
            logging.FileHandler(SYNC_LOG_FILE),
            logging.StreamHandler()
        ]
    )
    return logging.getLogger(__name__)

logger = setup_logging()

# ============================================================
# Utility Functions
# ============================================================

def compute_file_hash(file_path: pathlib.Path) -> Optional[str]:
    """Compute MD5 hash of file content"""
    if not file_path.exists():
        return None

    try:
        md5 = hashlib.md5()
        with open(file_path, 'rb') as f:
            for chunk in iter(lambda: f.read(8192), b''):
                md5.update(chunk)
        return md5.hexdigest()
    except Exception as e:
        logger.error(f"Error computing hash for {file_path}: {e}")
        return None

def load_cache() -> Dict[str, Any]:
    """Load sync state cache"""
    if SYNC_CACHE_FILE.exists():
        try:
            with open(SYNC_CACHE_FILE, 'r', encoding='utf-8') as f:
                return json.load(f)
        except Exception as e:
            logger.error(f"Error loading cache: {e}")
            return DEFAULT_CACHE.copy()
    return DEFAULT_CACHE.copy()

def save_cache(cache: Dict[str, Any]) -> None:
    """Save sync state cache"""
    try:
        CACHE_DIR.mkdir(parents=True, exist_ok=True)
        with open(SYNC_CACHE_FILE, 'w', encoding='utf-8') as f:
            json.dump(cache, f, indent=2, ensure_ascii=False)
    except Exception as e:
        logger.error(f"Error saving cache: {e}")

def read_file_safe(file_path: pathlib.Path) -> Optional[str]:
    """Safely read file content"""
    if not file_path.exists():
        return None
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return f.read()
    except Exception as e:
        logger.error(f"Error reading {file_path}: {e}")
        return None

def write_file_safe(file_path: pathlib.Path, content: str) -> bool:
    """Safely write file content"""
    try:
        file_path.parent.mkdir(parents=True, exist_ok=True)
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        return True
    except Exception as e:
        logger.error(f"Error writing {file_path}: {e}")
        return False

# ============================================================
# Change Detection
# ============================================================

def detect_changes() -> Tuple[bool, str]:
    """
    Detect if files have changed since last sync
    Returns: (has_changes, master_source)

    Priority:
    1. OneDrive (if exists and changed)
    2. Local (if exists and changed)
    3. None (no changes)
    """
    cache = load_cache()

    onedrive_exists = ONEDRIVE_CLAUDE_PATH.exists()
    local_exists = LOCAL_CLAUDE_PATH.exists()

    onedrive_hash = compute_file_hash(ONEDRIVE_CLAUDE_PATH) if onedrive_exists else None
    local_hash = compute_file_hash(LOCAL_CLAUDE_PATH) if local_exists else None

    cached_onedrive = cache.get("onedrive_hash")
    cached_local = cache.get("local_hash")

    # Check if OneDrive has changed
    if onedrive_hash and onedrive_hash != cached_onedrive:
        logger.info(f"OneDrive change detected: {cached_onedrive} → {onedrive_hash}")
        return True, "onedrive"

    # Check if Local has changed
    if local_hash and local_hash != cached_local:
        logger.info(f"Local change detected: {cached_local} → {local_hash}")
        return True, "local"

    return False, ""

# ============================================================
# Sync Operations
# ============================================================

def sync_onedrive_to_local() -> bool:
    """Sync from OneDrive (master) to local"""
    content = read_file_safe(ONEDRIVE_CLAUDE_PATH)
    if content is None:
        logger.warning("OneDrive file not readable")
        return False

    if write_file_safe(LOCAL_CLAUDE_PATH, content):
        logger.info("✓ OneDrive → Local sync completed")
        return True
    return False

def sync_local_to_onedrive() -> bool:
    """Sync from local to OneDrive"""
    content = read_file_safe(LOCAL_CLAUDE_PATH)
    if content is None:
        logger.warning("Local file not readable")
        return False

    if write_file_safe(ONEDRIVE_CLAUDE_PATH, content):
        logger.info("✓ Local → OneDrive sync completed")
        return True
    return False

def perform_sync(master_source: str) -> bool:
    """
    Perform sync operation based on master source

    Args:
        master_source: "onedrive" or "local"

    Returns:
        True if sync successful
    """
    if master_source == "onedrive":
        success = sync_onedrive_to_local()
    elif master_source == "local":
        success = sync_local_to_onedrive()
    else:
        logger.error(f"Invalid master source: {master_source}")
        return False

    if success:
        cache = load_cache()
        cache["onedrive_hash"] = compute_file_hash(ONEDRIVE_CLAUDE_PATH)
        cache["local_hash"] = compute_file_hash(LOCAL_CLAUDE_PATH)
        cache["last_sync"] = datetime.datetime.now().isoformat()
        cache["sync_count"] = cache.get("sync_count", 0) + 1
        save_cache(cache)

        logger.info(f"Sync cache updated (count: {cache['sync_count']})")

    return success

# ============================================================
# Main Control Loop
# ============================================================

def run_sync_check() -> None:
    """
    Main sync check - minimal token consumption

    Flow:
    1. Detect changes (local file operations only)
    2. If changes detected, perform sync
    3. Update cache
    4. Log results
    """
    logger.info("=" * 60)
    logger.info("Sync check started")

    try:
        has_changes, master_source = detect_changes()

        if not has_changes:
            logger.info("No changes detected - sync skipped")
            return

        logger.info(f"Changes detected from {master_source}")

        if perform_sync(master_source):
            logger.info("Sync completed successfully")
        else:
            cache = load_cache()
            cache["error_count"] = cache.get("error_count", 0) + 1
            cache["last_error"] = "Sync operation failed"
            save_cache(cache)
            logger.error("Sync failed - cache updated with error")

    except Exception as e:
        cache = load_cache()
        cache["error_count"] = cache.get("error_count", 0) + 1
        cache["last_error"] = str(e)
        save_cache(cache)
        logger.error(f"Unexpected error: {e}")

    logger.info("=" * 60)

# ============================================================
# Scheduled Execution
# ============================================================

def get_sync_status() -> Dict[str, Any]:
    """Get current sync status"""
    cache = load_cache()
    onedrive_exists = ONEDRIVE_CLAUDE_PATH.exists()
    local_exists = LOCAL_CLAUDE_PATH.exists()

    return {
        "cache": cache,
        "onedrive_exists": onedrive_exists,
        "local_exists": local_exists,
        "onedrive_hash": compute_file_hash(ONEDRIVE_CLAUDE_PATH),
        "local_hash": compute_file_hash(LOCAL_CLAUDE_PATH),
    }

# ============================================================
# Entry Point
# ============================================================

if __name__ == "__main__":
    import sys

    if len(sys.argv) > 1 and sys.argv[1] == "--status":
        status = get_sync_status()
        print(json.dumps(status, indent=2, default=str))
    else:
        run_sync_check()
