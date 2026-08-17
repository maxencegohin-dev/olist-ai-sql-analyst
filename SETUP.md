# 🚀 GitHub Setup Instructions

## Step 1: Initialize Git Repository Locally

```bash
cd C:\Users\Maxence Gohin\Documents\BB - PROJETS

# Initialize git
git init

# Configure your identity
git config user.name "Maxence Gohin"
git config user.email "maxencegohin@gmail.com"

# Optional: Set as global config
git config --global user.name "Maxence Gohin"
git config --global user.email "maxencegohin@gmail.com"
```

## Step 2: Verify .gitignore is Correct

The `.gitignore` file is already configured to exclude:
- ✅ `.env` (contains API keys)
- ✅ `*.csv` and `*.db` (large data files, 126 MB)
- ✅ `__pycache__/` and `.ipynb_checkpoints/`
- ✅ Python virtual environments (`venv/`, `env/`)
- ✅ IDE configuration (`.vscode/`, `.idea/`)

**Verify:**
```bash
git status
# Should NOT show .env or data files listed as "untracked"
```

## Step 3: Stage & Commit Files

```bash
# Add only tracked files (respecting .gitignore)
git add .

# Verify what will be committed
git status

# Create initial commit
git commit -m "Initial commit: Olist AI Analyst project

- Restructured project with src/, data/, notebooks/ directories
- Moved scripts: data_loader.py, agent.py, app.py
- Added requirements.txt with LangChain, Streamlit, Groq dependencies
- Added comprehensive README.md with architecture & usage guide
- Configured secure .gitignore (excludes .env, *.csv, *.db, etc.)
- Provided .env.example as credential template
- Added project documentation and setup instructions"
```

## Step 4: Create Remote Repository on GitHub

1. Go to https://github.com/new
2. Fill in details:
   - **Repository name:** `olist-ai-sql-analyst`
   - **Description:** "AI-powered data analysis system for Olist e-commerce using LLMs"
   - **Visibility:** Public (or Private if preferred)
   - ✅ **Do NOT** initialize with README (we have one)
   - ✅ **Do NOT** add .gitignore (we have one)
   - ✅ **Do NOT** add license (or choose one if desired)

3. Click "Create repository"

## Step 5: Link Remote & Push

```bash
# Add the remote repository
git remote add origin https://github.com/maxencegohin-dev/olist-ai-sql-analyst.git

# Verify the remote is configured correctly
git remote -v
# Should output:
# origin  https://github.com/maxencegohin-dev/olist-ai-sql-analyst.git (fetch)
# origin  https://github.com/maxencegohin-dev/olist-ai-sql-analyst.git (push)

# Set main as default branch (modern Git standard)
git branch -M main

# Push to GitHub (may prompt for credentials)
git push -u origin main
```

## Step 6: Verify on GitHub

Visit: https://github.com/maxencegohin-dev/olist-ai-sql-analyst

You should see:
- ✅ README.md displayed
- ✅ src/ folder with 4 files
- ✅ data/ folder (empty, with .gitkeep)
- ✅ notebooks/ folder (empty, with .gitkeep)
- ✅ requirements.txt
- ✅ .env.example
- ✅ .gitignore (hidden file, but present)

## Step 7: ⚠️ CRITICAL - Rotate API Keys

Your old `.env` file contained a Groq API key. Since it may have been exposed:

1. **Go to:** https://console.groq.com/keys
2. **Delete the old key:** `[REDACTED — check your Groq console for the exact key]`
3. **Generate a new key**
4. **Update your local `.env` file:**
   ```bash
   cp .env.example .env
   # Then edit .env and paste the new key
   ```

**DO NOT commit the new .env file!**

## Step 8: Future Pushes

For any future changes:

```bash
# Make changes to your code
# ...

# Stage changes
git add .

# Commit
git commit -m "Description of changes"

# Push to GitHub
git push origin main
```

## Troubleshooting

### "fatal: not a git repository"
```bash
cd C:\Users\Maxence Gohin\Documents\BB - PROJETS
git init
```

### "Authentication failed" when pushing
- **GitHub SSH:** Set up SSH keys if not already done
- **HTTPS with token:** Use a GitHub Personal Access Token (PAT) as password
  - Create PAT at: https://github.com/settings/tokens
  - Use PAT instead of password when prompted

### Files are still showing in `git status`
```bash
# Clear Git cache and re-add files
git rm --cached -r .
git add .
```

---

**You're all set! 🎉 Your project is now ready for GitHub.**
