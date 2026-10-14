@echo off
chcp 65001 >nul
title Dealer Console
cd /d "%~dp0"
where git >nul 2>nul || (echo Git nahi mila - ek baar install karo: git-scm.com & pause & exit /b)
where node >nul 2>nul || (echo Node nahi mila - ek baar install karo: nodejs.org & pause & exit /b)
echo Naya update dekh rahe...
git fetch --quiet origin
git reset --hard origin/main --quiet
cd app
if not exist "node_modules" ( echo Pehli baar setup... thoda ruko & npm install --omit=dev --no-audit --no-fund --loglevel=error )
node -e "const fs=require('fs'),c=require('crypto');const h=c.createHash('md5').update(fs.readFileSync('package.json')).digest('hex');let o='';try{o=fs.readFileSync('node_modules/.pkghash','utf8')}catch{};process.exit(h===o?0:3)"
if errorlevel 3 ( echo Nayi cheezein aayi, update kar rahe... & npm install --omit=dev --no-audit --no-fund --loglevel=error & node -e "const fs=require('fs'),c=require('crypto');fs.writeFileSync('node_modules/.pkghash',c.createHash('md5').update(fs.readFileSync('package.json')).digest('hex'))" )
if not exist ".env" ( copy .env.base .env >nul & for /f %%k in ('node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"') do echo ENCRYPTION_KEY=%%k>>.env )
start "" cmd /c "timeout /t 6 >nul & start http://localhost:4000"
node server.mjs
pause