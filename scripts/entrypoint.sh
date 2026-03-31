#!/bin/sh
# Fix volume permissions then drop to appuser
chown appuser:appuser /data 2>/dev/null || true
exec gosu appuser node server/index.js
