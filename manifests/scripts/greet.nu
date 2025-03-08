#!/usr/bin/env nu
source "ai.nu"
source "cluster.nu"
source "nx.nu"
let original_list = [ 40 -4 0 8 12 16 -16 ]
$original_list | filter $compare_closure

let compare_closure = {|a| $a > 5 }

def greet [name] {
  gh auth status
  ls -lt
  #nu greetings aris
  echo "$GITHUB_USER"
  $"Hello, ($name)!"
  #nu get-hyperscaler
  #nu greetings
  nu nxa aris
  kubectl get pods -A
}


def _create_cluster [name, aris: string] {
  kind create cluster
}

def check [] {
  kubectl wait "providers.pkg.crossplane.io/provider-gcp-storage" --for=condition=Healthy --timeout=600s
  kubectl wait "providers.pkg.crossplane.io/provider-gcp-storage" --for=condition=Installed --timeout=600s
}
