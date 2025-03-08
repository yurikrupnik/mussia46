#!/usr/bin/env nu


# Function with a parameter
def greetings [name: string] {
    print $"Hello, ($name)! Welcome to NuShell..."
}

def my-ls [] { ls }
