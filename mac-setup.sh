#!/bin/bash
set -x

curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
eval "$(/opt/homebrew/bin/brew shellenv)"

set -e
brew install --cask rectangle
brew install --cask alt-tab
brew install --cask iterm2
brew install --cask visual-studio-code
