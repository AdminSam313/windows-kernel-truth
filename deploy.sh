#!/bin/bash
# Deploy script for Windows Kernel Truth blog

set -e

REPO_NAME="windows-kernel-truth"
USERNAME="AdminSam313"

echo "🚀 Deploying Windows Kernel Truth blog to GitHub..."
echo ""

# Check if gh is authenticated
if ! gh auth status &>/dev/null; then
    echo "❌ GitHub CLI is not authenticated. Please run: gh auth login"
    exit 1
fi

# Try to create repository if it doesn't exist
echo "📦 Creating repository..."
if ! gh repo view "$USERNAME/$REPO_NAME" &>/dev/null; then
    echo "Repository doesn't exist, creating..."
    gh repo create "$REPO_NAME" --public --description "Windows Kernel Reverse Engineering - Myths vs Reality" || {
        echo "⚠️  Could not create repository automatically."
        echo ""
        echo "Please create the repository manually:"
        echo "1. Go to https://github.com/new"
        echo "2. Repository name: $REPO_NAME"
        echo "3. Set as Public"
        echo "4. Click 'Create repository'"
        echo ""
        echo "Then run: git push -u origin master"
        exit 1
    }
else
    echo "✓ Repository already exists"
fi

# Push to GitHub
echo ""
echo "📤 Pushing to GitHub..."
git push -u origin master

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📖 View your blog at:"
echo "   https://$USERNAME.github.io/$REPO_NAME/"
echo ""
echo "🔗 Direct link to repository:"
echo "   https://github.com/$USERNAME/$REPO_NAME"
echo ""

# Enable GitHub Pages
echo "📄 Enabling GitHub Pages..."
gh api \
    --method PUT \
    -f source='{"branch":"master","path":"/"}' \
    /repos/$USERNAME/$REPO_NAME/pages 2>/dev/null || {
    echo "⚠️  Could not enable Pages automatically."
    echo "Please enable GitHub Pages manually:"
    echo "1. Go to https://github.com/$USERNAME/$REPO_NAME/settings/pages"
    echo "2. Source: Deploy from a branch"
    echo "3. Branch: master, Folder: / (root)"
    echo "4. Click Save"
}

echo ""
echo "🎉 Done!"
