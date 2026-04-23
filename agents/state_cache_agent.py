#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
State Cache Agent
Responsible for managing sync state cache with minimal overhead

Functions:
  - Load/save cache state
  - Validate cache integrity
  - Provide cache statistics
  - Handle cache expiration
"""

import json
import pathlib
import datetime
import logging
from typing import Dict, Any, Optional

logger = logging.getLogger(__name__)

# Cache file location
CACHE_DIR = pathlib.Path.home() / ".claude"
SYNC_CACHE_FILE = CACHE_DIR / "sync_cache.json"

# Default cache structure
DEFAULT_CACHE = {
    "version": "1.0",
    "created_at": None,
    "last_sync": None,
    "onedrive_hash": None,
    "local_hash": None,
    "sync_count": 0,
    "error_count": 0,
    "last_error": None,
    "stats": {
        "total_syncs": 0,
        "successful_syncs": 0,
        "failed_syncs": 0,
        "avg_sync_time": 0,
    }
}

class StateCacheAgent:
    """Agent for managing sync state cache"""

    def __init__(self):
        self.cache_file = SYNC_CACHE_FILE
        self.cache = self._load_or_create()

    def _load_or_create(self) -> Dict[str, Any]:
        """Load existing cache or create new one"""
        if self.cache_file.exists():
            try:
                with open(self.cache_file, 'r', encoding='utf-8') as f:
                    cache = json.load(f)
                    # Validate cache structure
                    if self._validate_cache(cache):
                        return cache
            except Exception as e:
                logger.warning(f"Failed to load cache: {e}")

        # Create new cache
        new_cache = DEFAULT_CACHE.copy()
        new_cache["created_at"] = datetime.datetime.now().isoformat()
        self._save(new_cache)
        return new_cache

    def _validate_cache(self, cache: Dict[str, Any]) -> bool:
        """Validate cache structure"""
        required_keys = ["version", "sync_count", "error_count"]
        return all(key in cache for key in required_keys)

    def _save(self, cache: Dict[str, Any]) -> bool:
        """Save cache to file"""
        try:
            self.cache_file.parent.mkdir(parents=True, exist_ok=True)
            with open(self.cache_file, 'w', encoding='utf-8') as f:
                json.dump(cache, f, indent=2, ensure_ascii=False)
            return True
        except Exception as e:
            logger.error(f"Failed to save cache: {e}")
            return False

    def get(self, key: str, default=None) -> Any:
        """Get value from cache"""
        return self.cache.get(key, default)

    def set(self, key: str, value: Any) -> bool:
        """Set value in cache and save"""
        self.cache[key] = value
        return self._save(self.cache)

    def update(self, updates: Dict[str, Any]) -> bool:
        """Update multiple cache values"""
        self.cache.update(updates)
        return self._save(self.cache)

    def increment_sync_count(self, success: bool = True) -> None:
        """Increment sync count"""
        self.cache["sync_count"] = self.cache.get("sync_count", 0) + 1
        if success:
            stats = self.cache.setdefault("stats", {})
            stats["successful_syncs"] = stats.get("successful_syncs", 0) + 1
        else:
            self.cache["error_count"] = self.cache.get("error_count", 0) + 1
            stats = self.cache.setdefault("stats", {})
            stats["failed_syncs"] = stats.get("failed_syncs", 0) + 1
        self._save(self.cache)

    def get_stats(self) -> Dict[str, Any]:
        """Get cache statistics"""
        stats = self.cache.get("stats", {})
        stats["total_syncs"] = self.cache.get("sync_count", 0)
        stats["error_count"] = self.cache.get("error_count", 0)
        stats["last_sync"] = self.cache.get("last_sync")
        return stats

    def clear_errors(self) -> bool:
        """Clear error state"""
        self.cache["error_count"] = 0
        self.cache["last_error"] = None
        return self._save(self.cache)

    def get_summary(self) -> str:
        """Get human-readable cache summary"""
        stats = self.get_stats()
        return (
            f"Sync Cache Summary:\n"
            f"  Total Syncs: {stats.get('total_syncs', 0)}\n"
            f"  Successful: {stats.get('successful_syncs', 0)}\n"
            f"  Failed: {stats.get('failed_syncs', 0)}\n"
            f"  Errors: {self.cache.get('error_count', 0)}\n"
            f"  Last Sync: {self.cache.get('last_sync', 'Never')}"
        )
