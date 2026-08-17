# GitHub Initialization & Push Script (PowerShell)
# Usage: .\GITHUB_PUSH.ps1

$ErrorActionPreference = "Stop"

Write-Host "🚀 Initializing Git repository for Olist AI Analyst..." -ForegroundColor Green
Write-Host ""

# Step 1: Initialize Git
Write-Host "Step 1️⃣  - Initializing Git repository..." -ForegroundColor Blue
git init
Write-Host "✅ Git initialized" -ForegroundColor Green
Write-Host ""

# Step 2: Configure user
Write-Host "Step 2️⃣  - Configuring user identity..." -ForegroundColor Blue
git config user.name "Maxence Gohin"
git config user.email "maxencegohin@gmail.com"
Write-Host "✅ Git user configured" -ForegroundColor Green
Write-Host ""

# Step 3: Check .gitignore
Write-Host "Step 3️⃣  - Verifying .gitignore..." -ForegroundColor Blue
if (Test-Path ".gitignore") {
    Write-Host "✅ .gitignore found" -ForegroundColor Green
    $gitignoreContent = Get-Content ".gitignore" -Raw
    if ($gitignoreContent -match "^\.env$") {
        Write-Host "✅ .env is properly excluded" -ForegroundColor Green
    }
    if ($gitignoreContent -match "\*.csv") {
        Write-Host "✅ CSV files are properly excluded" -ForegroundColor Green
    }
} else {
    Write-Host "❌ ERROR: .gitignore not found!" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Step 4: Stage all files
Write-Host "Step 4️⃣  - Staging files..." -ForegroundColor Blue
git add .
Write-Host "✅ Files staged (respecting .gitignore)" -ForegroundColor Green
Write-Host ""

# Step 5: Show what will be committed
Write-Host "Step 5️⃣  - Files to be committed:" -ForegroundColor Blue
git status --short
Write-Host ""

# Step 6: Verify no secrets in staging
Write-Host "Step 6️⃣  - Security check (verifying no .env file is staged)..." -ForegroundColor Blue
$stagedFiles = git diff --cached --name-only
if ($stagedFiles -contains ".env") {
    Write-Host "⚠️  WARNING: .env file is staged! Removing..." -ForegroundColor Yellow
    git reset .env
    Write-Host "✅ .env removed from staging" -ForegroundColor Green
} else {
    Write-Host "✅ No .env file in staging (safe!)" -ForegroundColor Green
}
Write-Host ""

# Step 7: Commit
Write-Host "Step 7️⃣  - Creating initial commit..." -ForegroundColor Blue
git commit -m @"
Initial commit: Olist AI Analyst project

- Restructured project with src/, data/, notebooks/ directories
- Moved Python modules: data_loader.py, agent.py, app.py
- Added requirements.txt with dependency versions
- Added comprehensive README.md with architecture and usage guide
- Configured secure .gitignore (excludes .env, *.csv, *.db, etc.)
- Provided .env.example as credential template
- Added SETUP.md with GitHub setup instructions
- Added AUDIT_REPORT.md documenting cleanup process

Project is now ready for collaboration and deployment.
"@
Write-Host "✅ Initial commit created" -ForegroundColor Green
Write-Host ""

# Step 8: Configure remote
Write-Host "Step 8️⃣  - Setting up GitHub remote..." -ForegroundColor Blue
$remoteUrl = "https://github.com/maxencegohin-dev/olist-ai-sql-analyst.git"
git remote add origin $remoteUrl
Write-Host "✅ Remote configured: $remoteUrl" -ForegroundColor Green
Write-Host ""

# Step 9: Set main branch
Write-Host "Step 9️⃣  - Renaming to 'main' branch..." -ForegroundColor Blue
git branch -M main
Write-Host "✅ Default branch set to 'main'" -ForegroundColor Green
Write-Host ""

# Step 10: Final instructions
Write-Host "Step 🔟 - IMPORTANT: Before pushing, follow these steps:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. ⚠️  ROTATE YOUR API KEY:" -ForegroundColor Yellow
Write-Host "   - Visit: https://console.groq.com/keys" -ForegroundColor Gray
Write-Host "   - Delete the old key from your account" -ForegroundColor Gray
Write-Host "   - Generate a new key" -ForegroundColor Gray
Write-Host "   - Update your .env file (NOT in git)" -ForegroundColor Gray
Write-Host ""
Write-Host "2. 🔐 VERIFY YOUR LOCAL .env IS NOT STAGED:" -ForegroundColor Yellow
$status = git status --porcelain
if ($status -match "\.env") {
    Write-Host "❌ ERROR: .env is showing in git status!" -ForegroundColor Red
} else {
    Write-Host "✅ .env is properly ignored" -ForegroundColor Green
}
Write-Host ""
Write-Host "3. 🚀 WHEN READY, PUSH TO GITHUB:" -ForegroundColor Yellow
Write-Host "   git push -u origin main" -ForegroundColor Gray
Write-Host ""
Write-Host "4. ✅ VERIFY ON GITHUB:" -ForegroundColor Yellow
Write-Host "   https://github.com/maxencegohin-dev/olist-ai-sql-analyst" -ForegroundColor Gray
Write-Host ""
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "✅ Repository is initialized and ready!" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green
