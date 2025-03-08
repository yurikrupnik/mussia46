#!/usr/bin/env nu

use ai.nu

def nxa [name] {
  #export GITHUB_USER=yurikrupnik
  # export GITHUB_TOKEN="gh auth token"
  ls
}

def graph [] {
   bun nx graph
}

def _build [] {
   bun nx graph
}
