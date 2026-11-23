@echo off
chcp 65001 >nul
title Dealer Console
cd /d "%~dp0app"
where node >nul 2>nul
if errorlevel 1 (if exist "..\node\node.exe" (set "PATH=%~dp0node;%PATH%") else (echo Node nahi mila. node\ folder ke saath chalao. & pause & exit))
if not exist ".env" (
  copy .env.base .env >nul
  for /f %%k in ('node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"') do echo ENCRYPTION_KEY=%%k>>.env
)
start "" cmd /c "timeout /t 6 >nul & start http://localhost:4000"
node server.mjs
pause