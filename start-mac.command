#!/bin/bash
cd -- "$(dirname -- "$0")" || exit 1
if ! command -v python3 >/dev/null 2>&1; then
  echo "请先从 https://www.python.org/downloads/ 安装 Python 3.9 或以上版本。"
  read -r -p "按回车关闭…"
  exit 1
fi
python3 server.py
read -r -p "服务已停止，按回车关闭…"
