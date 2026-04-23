#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
File Sync Agent
Handles actual file synchronization between OneDrive and local

Functions:
  - Read files safely
  - Write files safely
  - Detect changes
  - Perform sync operations
  - Validate sync results
"""

import pathlib
import hashlib
import logging
from typing import Optional, Tuple

logger = logging.getLogger(__name__)

class FileSyncAgent:
    """Agent for handling file synchronization"""

    def __init__(self, source_path: pathlib.Path, target_path: pathlib.Path):
        self.source = pathlib.Path(source_path)
        self.target = pathlib.Path(target_path)

    def compute_hash(self, file_path: pathlib.Path) -> Optional[str]:
        """Compute MD5 hash of file"""
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

    def read_file(self) -> Optional[str]:
        """Read source file content safely"""
        if not self.source.exists():
            logger.warning(f"Source file not found: {self.source}")
            return None

        try:
            with open(self.source, 'r', encoding='utf-8') as f:
                return f.read()
        except Exception as e:
            logger.error(f"Error reading source file: {e}")
            return None

    def write_file(self, content: str) -> bool:
        """Write content to target file safely"""
        try:
            self.target.parent.mkdir(parents=True, exist_ok=True)
            with open(self.target, 'w', encoding='utf-8') as f:
                f.write(content)
            logger.info(f"File written: {self.target}")
            return True
        except Exception as e:
            logger.error(f"Error writing target file: {e}")
            return False

    def sync(self) -> Tuple[bool, str]:
        """
        Perform sync operation

        Returns:
            (success: bool, message: str)
        """
        # Read source
        content = self.read_file()
        if content is None:
            return False, "Failed to read source file"

        # Write target
        if not self.write_file(content):
            return False, "Failed to write target file"

        # Verify sync
        source_hash = self.compute_hash(self.source)
        target_hash = self.compute_hash(self.target)

        if source_hash == target_hash:
            return True, f"Sync successful: {source_hash[:8]}..."
        else:
            return False, "Hash mismatch after sync"

    def has_changes(self, last_hash: Optional[str]) -> bool:
        """Check if file has changed since last sync"""
        current_hash = self.compute_hash(self.source)
        return current_hash != last_hash

    def get_size(self) -> Optional[int]:
        """Get file size in bytes"""
        if self.source.exists():
            return self.source.stat().st_size
        return None

    def get_modified_time(self) -> Optional[str]:
        """Get file modification time"""
        if self.source.exists():
            import datetime
            mtime = self.source.stat().st_mtime
            return datetime.datetime.fromtimestamp(mtime).isoformat()
        return None
