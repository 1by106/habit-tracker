#!/bin/bash
# 习惯打卡网站 - 一键部署脚本
cd "$(dirname "$0")"
echo "=========================================="
echo "  习惯打卡网站 一键部署"
echo "=========================================="
echo ""
echo "请选择："
echo "  1) 使用已保存的 token 推送"
echo "  2) 输入新的 GitHub Token"
read -p "请输入数字 (1/2): " choice

if [ "$choice" = "2" ]; then
  read -s -p "请输入 GitHub Token: " TOKEN
  echo ""
else
  TOKEN_FILE="$HOME/.habit-tracker-token"
  if [ -f "$TOKEN_FILE" ]; then
    TOKEN=$(cat "$TOKEN_FILE")
  else
    read -s -p "请输入 GitHub Token: " TOKEN
    echo ""
    echo "$TOKEN" > "$TOKEN_FILE"
    chmod 600 "$TOKEN_FILE"
  fi
fi

GIT_SSL_NO_VERIFY=true git add -A
GIT_SSL_NO_VERIFY=true git -c user.name="1by106" -c user.email="1by106@users.noreply.github.com" commit -m "update: $(date '+%Y-%m-%d %H:%M')"
echo "正在推送..."
GIT_SSL_NO_VERIFY=true git push "https://1by106:${TOKEN}@github.com/1by106/habit-tracker.git" main
if [ $? -eq 0 ]; then
  echo ""
  echo "✅ 部署成功！约 1-2 分钟后线上更新"
  echo "   网址: https://1by106.github.io/habit-tracker/"
else
  echo ""
  echo "❌ 推送失败，请检查网络或 Token"
fi
echo ""
read -p "按回车关闭窗口..."
