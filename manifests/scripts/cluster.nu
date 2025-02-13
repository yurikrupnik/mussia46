#!/usr/bin/env nu

def get_pods[resource: string] {
  kubectl get $resource -A
}

# Function with a parameter
def greet [name: string] {
    print $"Hello, ($name)! Welcome to NuShell."
}
