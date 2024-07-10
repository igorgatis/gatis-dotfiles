#!/bin/bash

set -e
set -x

curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh

brew install --cask rectangle
brew install --cask alt-tab
brew install --cask iterm2
brew install --cask visual-studio-code
