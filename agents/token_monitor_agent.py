#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Token Monitor Agent
Tracks token consumption and ensures minimal API usage

Target: < 5% of session token budget
Budget: 200,000 tokens total
Sync System Budget: 5,000-10,000 tokens max

Functions:
  - Track token usage
  - Log API calls
  - Calculate efficiency metrics
  - Alert on over-consumption
"""

import json
import pathlib
import datetime
import logging
from typing import Dict, Any, Optional

logger = logging.getLogger(__name__)

# Token budget
TOTAL_SESSION_BUDGET = 200000
SYNC_SYSTEM_BUDGET = 5000
DAILY_BUDGET = SYNC_SYSTEM_BUDGET

# Log file
TOKEN_LOG_DIR = pathlib.Path.home() / ".claude"
TOKEN_LOG_FILE = TOKEN_LOG_DIR / "token_usage.json"

class TokenMonitorAgent:
    """Agent for monitoring token consumption"""

    def __init__(self):
        self.log_dir = TOKEN_LOG_DIR
        self.log_file = TOKEN_LOG_FILE
        self.daily_usage = 0
        self.total_usage = 0
        self._load_usage()

    def _load_usage(self) -> None:
        """Load token usage from log"""
        if self.log_file.exists():
            try:
                with open(self.log_file, 'r', encoding='utf-8') as f:
                    log_data = json.load(f)
                    self.total_usage = log_data.get("total_usage", 0)
                    # Reset daily if new day
                    last_date = log_data.get("last_date")
                    today = datetime.date.today().isoformat()
                    if last_date == today:
                        self.daily_usage = log_data.get("daily_usage", 0)
                    else:
                        self.daily_usage = 0
            except Exception as e:
                logger.warning(f"Failed to load token usage: {e}")
                self.total_usage = 0
                self.daily_usage = 0

    def _save_usage(self) -> None:
        """Save token usage to log"""
        try:
            self.log_dir.mkdir(parents=True, exist_ok=True)
            usage_data = {
                "timestamp": datetime.datetime.now().isoformat(),
                "date": datetime.date.today().isoformat(),
                "daily_usage": self.daily_usage,
                "total_usage": self.total_usage,
                "daily_budget": DAILY_BUDGET,
                "total_budget": TOTAL_SESSION_BUDGET,
            }
            with open(self.log_file, 'w', encoding='utf-8') as f:
                json.dump(usage_data, f, indent=2)
        except Exception as e:
            logger.error(f"Failed to save token usage: {e}")

    def log_operation(self, operation: str, tokens: int) -> None:
        """Log a token-consuming operation"""
        self.daily_usage += tokens
        self.total_usage += tokens

        remaining_daily = max(0, DAILY_BUDGET - self.daily_usage)
        remaining_total = max(0, TOTAL_SESSION_BUDGET - self.total_usage)

        logger.info(
            f"Operation: {operation} | "
            f"Tokens: {tokens} | "
            f"Daily: {self.daily_usage}/{DAILY_BUDGET} ({remaining_daily} left) | "
            f"Total: {self.total_usage}/{TOTAL_SESSION_BUDGET}"
        )

        # Alert if over budget
        if self.daily_usage > DAILY_BUDGET:
            logger.warning(
                f"⚠️  Daily token budget EXCEEDED: "
                f"{self.daily_usage}/{DAILY_BUDGET}"
            )

        self._save_usage()

    def log_sync_check(self) -> None:
        """Log a sync check operation (minimal cost)"""
        self.log_operation("sync_check", 0)  # File operations only

    def log_file_read(self, file_size: int) -> None:
        """Log file read operation"""
        # Estimate: ~4 chars per token
        estimated_tokens = max(1, file_size // 4 // 1000)
        self.log_operation("file_read", estimated_tokens)

    def log_file_write(self, file_size: int) -> None:
        """Log file write operation"""
        # No token cost for local writes
        self.log_operation("file_write", 0)

    def log_cache_update(self) -> None:
        """Log cache update operation"""
        self.log_operation("cache_update", 0)  # File-based, no token cost

    def get_usage_summary(self) -> Dict[str, Any]:
        """Get token usage summary"""
        daily_remaining = max(0, DAILY_BUDGET - self.daily_usage)
        total_remaining = max(0, TOTAL_SESSION_BUDGET - self.total_usage)

        daily_pct = (self.daily_usage / DAILY_BUDGET * 100) if DAILY_BUDGET > 0 else 0
        total_pct = (self.total_usage / TOTAL_SESSION_BUDGET * 100) if TOTAL_SESSION_BUDGET > 0 else 0

        return {
            "timestamp": datetime.datetime.now().isoformat(),
            "daily_usage": self.daily_usage,
            "daily_budget": DAILY_BUDGET,
            "daily_remaining": daily_remaining,
            "daily_percent": round(daily_pct, 2),
            "total_usage": self.total_usage,
            "total_budget": TOTAL_SESSION_BUDGET,
            "total_remaining": total_remaining,
            "total_percent": round(total_pct, 2),
            "status": self._get_status(),
        }

    def _get_status(self) -> str:
        """Get status indicator"""
        daily_pct = (self.daily_usage / DAILY_BUDGET * 100) if DAILY_BUDGET > 0 else 0
        if daily_pct >= 100:
            return "🔴 OVER BUDGET"
        elif daily_pct >= 80:
            return "🟠 WARNING"
        else:
            return "🟢 OK"

    def is_over_budget(self) -> bool:
        """Check if over daily budget"""
        return self.daily_usage > DAILY_BUDGET

    def print_summary(self) -> None:
        """Print token usage summary"""
        summary = self.get_usage_summary()
        print(
            f"\n{'='*60}\n"
            f"Token Usage Summary\n"
            f"{'='*60}\n"
            f"Daily: {summary['daily_usage']}/{summary['daily_budget']} "
            f"({summary['daily_percent']}%)\n"
            f"Total: {summary['total_usage']}/{summary['total_budget']} "
            f"({summary['total_percent']}%)\n"
            f"Status: {summary['status']}\n"
            f"{'='*60}\n"
        )
