#!/usr/bin/env nu

def sir [resource: string] {
  ls
}

def get-hyperscaler [] {
  let hyperscaler = [aws azure google]
          | input list $"(ansi yellow_bold)Which Hyperscaler do you want to use?(ansi green_bold)"
      print $"(ansi reset)"

      $"export HYPERSCALER=($hyperscaler)\n" | save --append .env

      $hyperscaler
}

def get-shit [] {
  let hyperscaler = [ ds hard raw] | input list $""
  open settings.yaml
    | upsert hyperscaler $hyperscaler
    | save settings.yaml --force
}
