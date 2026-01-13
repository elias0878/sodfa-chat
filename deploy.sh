#!/bin/bash

# Script to deploy sodfa-enhanced to GitHub
# Usage: ./deploy.sh

set -e

echo "🚀 Starting deployment of sodfa-enhanced..."

# Check if git is initialized
if [ ! -d .git ]; then
    echo "📦 Initializing git repository..."
    git init
    git add .
    git commit -m "Initial commit - Sodfa Enhanced Version"
fi

# Configure git if needed
git config --global user.email "elias0878@github.com" 2>/dev/null || true
git config --global user.name "Elias" 2>/dev/null || true

# Add remote if not exists
if ! git remote get-url origin &>/dev/null; then
    echo "🔗 Adding GitHub remote..."
    git remote add origin https://github.com/elias0878/sodfa-enhanced.git
fi

# Check if origin remote is correct
current_origin=$(git remote get-url origin 2>/dev/null || echo "")
if [ "$current_origin" != "https://github.com/elias0878/sodfa-enhanced.git" ]; then
    echo "🔗 Setting correct remote origin..."
    git remote set-url origin https://github.com/elias0878/sodfa-enhanced.git
fi

# Stage all changes
echo "📝 Staging changes..."
git add -A

# Commit
echo "💾 Committing changes..."
read -p "Enter commit message (or press Enter for default): " commit_msg
if [ -z "$commit_msg" ]; then
    commit_msg="Sodfa Enhanced Version - $(date '+%Y-%m-%d %H:%M')"
fi
git commit -m "$commit_msg"

# Push to main
echo "🚀 Pushing to GitHub..."
git push -u origin main

echo ""
echo "✅ Deployment completed successfully!"
echo "🌐 Your site will be available at:"
echo "   https://elias0878.github.io/sodfa-enhanced/"
echo ""
echo "⏱️ Note: GitHub Pages may take 1-2 minutes to update."
