#!/usr/bin/env zsh

# To Check the latest version of macOS X packages
# softwareupdate --list

# Best to just update the system
softwareupdate -ia

brew update

brew upgrade --greedy