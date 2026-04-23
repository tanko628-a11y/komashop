#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Task Dispatcher Agent (Parent)
Decision-making layer for sync operations
Routes tasks to child agents with minimal token overhead

Responsibility:
  - Monitor file states
  - Decide if sync is needed
  - Route to appropriate child agent
  - Collect results and report
"""

import pathlib
import logging
from typing import Dict, Any, Optional, Tuple
from datetime import datetime

logger = logging.getLogger(__name__)

class TaskDispatcher:
    """Parent agent for task routing and decision-making"""

    def __init__(self, cache_agent, file_sync_agent, token_monitor):
        self.cache = cache_agent
        self.file_sync = file_sync_agent
        self.token_monitor = token_monitor

    def should_sync(self) -> Tuple[bool, str]:
        """
        Decide if sync is needed

        Returns:
            (needs_sync: bool, reason: str)
        """
        # Check cache
        cached_hash = self.cache.get("source_hash")
        current_hash = self.file_sync.compute_hash(self.file_sync.source)

        if current_hash is None:
            return False, "Source file not found"

        if cached_hash is None:
            return True, "First sync - cache empty"

        if current_hash != cached_hash:
            return True, f"File changed: {cached_hash[:8]}... → {current_hash[:8]}..."

        return False, "No changes detected"

    def dispatch_sync_task(self, force: bool = False) -> Dict[str, Any]:
        """
        Dispatch sync task to file sync agent

        Args:
            force: Force sync even if no changes detected

        Returns:
            Result dictionary
        """
        logger.info("Dispatcher: Evaluating sync necessity...")

        # Check if sync needed
        needs_sync, reason = self.should_sync()

        if not needs_sync and not force:
            logger.info(f"Dispatcher: Skipping sync - {reason}")
            return {
                "status": "skipped",
                "reason": reason,
                "timestamp": datetime.now().isoformat(),
            }

        if force:
            logger.info("Dispatcher: Force sync requested")

        # Log operation
        self.token_monitor.log_sync_check()

        # Dispatch to file sync agent
        logger.info(f"Dispatcher: Dispatching sync task - {reason}")
        success, message = self.file_sync.sync()

        # Update cache on success
        if success:
            new_hash = self.file_sync.compute_hash(self.file_sync.source)
            self.cache.update({
                "source_hash": new_hash,
                "target_hash": new_hash,
                "last_sync": datetime.now().isoformat(),
            })
            self.cache.increment_sync_count(success=True)
            self.token_monitor.log_operation("sync_success", 0)

            result = {
                "status": "success",
                "message": message,
                "hash": new_hash[:8] if new_hash else None,
                "timestamp": datetime.now().isoformat(),
            }
        else:
            self.cache.increment_sync_count(success=False)
            self.token_monitor.log_operation("sync_failure", 0)

            result = {
                "status": "failure",
                "message": message,
                "timestamp": datetime.now().isoformat(),
            }

        logger.info(f"Dispatcher: Sync completed - {result['status']}")
        return result

    def get_status_report(self) -> Dict[str, Any]:
        """Get comprehensive status report"""
        return {
            "timestamp": datetime.now().isoformat(),
            "cache_stats": self.cache.get_stats(),
            "token_usage": self.token_monitor.get_usage_summary(),
            "file_source": {
                "exists": self.file_sync.source.exists(),
                "size": self.file_sync.get_size(),
                "modified": self.file_sync.get_modified_time(),
                "hash": self.file_sync.compute_hash(self.file_sync.source),
            },
            "file_target": {
                "exists": self.file_sync.target.exists(),
                "size": self.file_sync.target.stat().st_size
                    if self.file_sync.target.exists() else None,
                "modified": self.file_sync.get_modified_time()
                    if self.file_sync.target.exists() else None,
                "hash": self.file_sync.compute_hash(self.file_sync.target),
            },
        }

    def print_status(self) -> None:
        """Print status report"""
        report = self.get_status_report()
        cache_stats = report.get("cache_stats", {})
        token_stats = report.get("token_usage", {})
        file_source = report.get("file_source", {})
        file_target = report.get("file_target", {})

        print(
            f"\n{'='*60}\n"
            f"Sync Status Report\n"
            f"{'='*60}\n"
            f"\nCache:\n"
            f"  Total Syncs: {cache_stats.get('total_syncs', 0)}\n"
            f"  Successful: {cache_stats.get('successful_syncs', 0)}\n"
            f"  Failed: {cache_stats.get('failed_syncs', 0)}\n"
            f"\nToken Usage:\n"
            f"  Daily: {token_stats.get('daily_usage', 0)}/{token_stats.get('daily_budget', 0)}\n"
            f"  Status: {token_stats.get('status', 'unknown')}\n"
            f"\nSource File:\n"
            f"  Exists: {file_source.get('exists', False)}\n"
            f"  Hash: {file_source.get('hash', 'N/A')}\n"
            f"  Size: {file_source.get('size', 'N/A')} bytes\n"
            f"\nTarget File:\n"
            f"  Exists: {file_target.get('exists', False)}\n"
            f"  Hash: {file_target.get('hash', 'N/A')}\n"
            f"  Size: {file_target.get('size', 'N/A')} bytes\n"
            f"{'='*60}\n"
        )
