#!/bin/bash
# -----------------------------------------------------
# gitpush.sh
# Helper script to push stcw-coverage-assistant to GitHub
# Repo (SSH): git@github.com:derickschaefer/stcw-coverage-assistant.git
# -----------------------------------------------------

set -e

# Define plugin directory
PLUGIN_DIR="/root/plugins/stcw-coverage-assistant"

# Move to plugin directory
cd "$PLUGIN_DIR"

# Ensure Git trusts this path
git config --global --add safe.directory "$PLUGIN_DIR"

# Ensure your Git identity is set
git config --global user.name "Derick Schaefer"
git config --global user.email "you@example.com"

# Ensure we're on the main branch
git branch -M main

# Add all changes
git add .

# Prompt for commit message
echo "Enter commit message:"
read COMMIT_MSG

# Default commit message if none entered
if [ -z "$COMMIT_MSG" ]; then
  COMMIT_MSG="Auto-commit: $(date +'%Y-%m-%d %H:%M:%S')"
fi

# Commit (ignore 'nothing to commit' case)
git commit -m "$COMMIT_MSG" || echo "⚠️ No changes to commit."

# Ensure remote uses SSH (no HTTPS prompt)
EXPECTED_REMOTE="git@github.com:derickschaefer/stcw-coverage-assistant.git"
CURRENT_REMOTE=$(git remote get-url origin 2>/dev/null || echo "")

if [ "$CURRENT_REMOTE" != "$EXPECTED_REMOTE" ]; then
  echo "🔧 Updating remote origin to SSH ($EXPECTED_REMOTE)"
  git remote set-url origin "$EXPECTED_REMOTE"
fi

# Push to GitHub via SSH
echo "🚀 Pushing to GitHub via SSH..."
git push -u origin main

echo "✅ Push complete!"
