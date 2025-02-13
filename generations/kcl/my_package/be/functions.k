# Lambda function for pluralizing a word
pluralize = lambda word: str -> str {
    _result = ""
    if word.endswith("y") and word[-2] not in "aeiou":
        _result = word[:-1:] + "ies"
    elif word.endswith("z") and word[-2] in "aeiou":
        _result = word + "zes"
    elif word.endswith("s") or word.endswith("z") or word.endswith("x") or word.endswith("ch") or word.endswith("sh"):
        _result = word + "es"
    else:
        _result = word + "s"
    _result
}

schema StroageShit:
  location: str

schema Storage:
  parameters: StroageShit
  id: str

providers = ["aws", "gcp", "azure"]
providers1 = ["gha", "tecktonn", "argo-workspace"]
providers2 = ["flux-cd", "argo-cd"]
providers3 = ["ghr", "ecr", "artifact-registry", "docker-hub", "more"]
