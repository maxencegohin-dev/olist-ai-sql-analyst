#!/bin/bash
# GitHub Initialization & Push Script
# Usage: bash GITHUB_PUSH.sh

set -e  # Exit on error

echo "🚀 Initializing Git repository for Olist AI Analyst..."
echo ""

# Step 1: Initialize Git
echo "Step 1️⃣  - Initializing Git repository..."
git init
echo "✅ Git initialized"
echo ""

# Step 2: Configure user (if not already set)
echo "Step 2️⃣  - Configuring user identity..."
git config user.name "Maxence Gohin" 2>/dev/null || git config --global user.name "Maxence Gohin"
git config user.email "maxencegohin@gmail.com" 2>/dev/null || git config --global user.email "maxencegohin@gmail.com"
echo "✅ Git user configured"
echo ""

# Step 3: Check .gitignore
echo "Step 3️⃣  - Verifying .gitignore..."
if [ -f .gitignore ]; then
    echo "✅ .gitignore found"
    if grep -q "^\.env$" .gitignore; then
        echo "✅ .env is properly excluded"
    fi
    if grep -q "\*.csv" .gitignore; then
        echo "✅ CSV files are properly excluded"
    fi
else
    echo "❌ ERROR: .gitignore not found!"
    exit 1
fi
echo ""

# Step 4: Stage all files
echo "Step 4️⃣  - Staging files..."
git add .
echo "✅ Files staged (respecting .gitignore)"
echo ""

# Step 5: Show what will be committed
echo "Step 5️⃣  - Files to be committed:"
git status --short
echo ""

# Step 6: Verify no secrets in staging
echo "Step 6️⃣  - Security check (verifying no .env file is staged)..."
if git diff --cached --name-only | grep -q "\.env$"; then
    echo "⚠️  WARNING: .env file is staged! Removing..."
    git reset .env
    echo "✅ .env removed from staging"
else
    echo "✅ No .env file in staging (safe!)"
fi
echo ""

# Step 7: Commit
echo "Step 7️⃣  - Creating initial commit..."
git commit -m "Initial commit: Olist AI Analyst project

- Restructured project with src/, data/, notebooks/ directories
- Moved Python modules: data_loader.py, agent.py, app.py
- Added requirements.txt with dependency versions
- Added comprehensive README.md with architecture and usage guide
- Configured secure .gitignore (excludes .env, *.csv, *.db, etc.)
- Provided .env.example as credential template
- Added SETUP.md with GitHub setup instructions
- Added AUDIT_REPORT.md documenting cleanup process

Project is now ready for collaboration and deployment."

echo "✅ Initial commit created"
echo ""

# Step 8: Configure remote
echo "Step 8️⃣  - Setting up GitHub remote..."
REMOTE_URL="https://github.com/maxencegohin-dev/olist-ai-sql-analyst.git"
git remote add origin "$REMOTE_URL"
echo "✅ Remote configured: $REMOTE_URL"
echo ""

# Step 9: Set main branch
echo "Step 9️⃣  - Renaming to 'main' branch..."
git branch -M main
echo "✅ Default branch set to 'main'"
echo ""

# Step 10: Final instructions
echo "Step 🔟 - IMPORTANT: Before pushing, follow these steps:"
echo ""
echo "1. ⚠️  ROTATE YOUR API KEY:"
echo "   - Visit: https://console.groq.com/keys"
echo "   - Delete: [REDACTED — check your Groq console for the exact key]"
echo "   - Generate new key"
echo "   - Update your .env file (NOT in git)"
echo ""
echo "2. 🔐 VERIFY YOUR LOCAL .env IS NOT STAGED:"
git status | grep -q ".env" && echo "❌ ERROR: .env is showing in git status!" || echo "✅ .env is properly ignored"
echo ""
echo "3. 🚀 WHEN READY, PUSH TO GITHUB:"
echo "   git push -u origin main"
echo ""
echo "4. ✅ VERIFY ON GITHUB:"
echo "   https://github.com/maxencegohin-dev/olist-ai-sql-analyst"
echo ""
echo "════════════════════════════════════════════════════════════════"
echo "✅ Repository is initialized and ready!"
echo "════════════════════════════════════════════════════════════════"
