#!/bin/bash
# Clone all development repositories after fresh install
# Requires SSH host aliases configured in ~/.ssh/config:
#   - github.com-personal (for personal repos)
#   - github.com-work (for work repos)
# Configure which 1Password key to use for each in 1Password SSH settings

set -e

echo "Creating directory structure..."
mkdir -p ~/dev/city-fm ~/dev/sepa

echo ""
echo "=== Personal Projects ==="

echo "Cloning city-fm-website..."
git clone git@github.com-personal:Bucurenciu-Cristian/city-fm-website.git ~/dev/city-fm/city-fm-website || echo "Already exists or failed"

echo "Cloning flux_app..."
git clone git@github.com-personal:Bucurenciu-Cristian/flux_app.git ~/dev/flux_app || echo "Already exists or failed"

echo "Cloning content-production-pipeline (supabase+fastapi)..."
git clone git@github.com-personal:Bucurenciu-Cristian/content-production-pipeline.git ~/dev/sepa/supabase+fastapi || echo "Already exists or failed"

echo ""
echo "=== Work Projects ==="

echo "Cloning hausfabrik..."
git clone git@github.com-work:sepaengineering/hausfabrik.git ~/dev/sepa/hausfabrik || echo "Already exists or failed"

echo "Cloning kubernetes-fastapi..."
git clone git@github.com-work:sepaengineering/kubernetes-fastapi.git ~/dev/sepa/kubernetes-fastapi || echo "Already exists or failed"

echo "Cloning n8n-integration-blueprint..."
git clone git@github.com-work:emanuelplopu/n8n-integration-blueprint.git ~/dev/sepa/n8n-integration-blueprint || echo "Already exists or failed"

echo "Cloning thelia-react..."
git clone git@github.com-work:sepaengineering/thelia-react.git ~/dev/sepa/thelia-react || echo "Already exists or failed"

echo "Cloning web-ui (browser-use)..."
git clone https://github.com/browser-use/web-ui.git ~/dev/sepa/web-ui || echo "Already exists or failed"

echo ""
echo "=== Cargo Packages ==="

echo "Installing tmux-sessionizer..."
cargo install tmux-sessionizer || echo "Already installed or failed"

echo ""
echo "=== Done ==="
echo "All repositories cloned to ~/dev/"
echo "Cargo packages installed to ~/.cargo/bin/"
