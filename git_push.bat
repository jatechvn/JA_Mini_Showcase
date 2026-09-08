@echo off
cd /d %~dp0

set /p commit_msg="Enter commit message (default 'Update JA Mini Showcase'): "
if "%commit_msg%"=="" set commit_msg=Update JA Mini Showcase

if not exist ".git" (
    git init
    git branch -M main
)

git add .
git commit -m "%commit_msg%"
git status
pause
