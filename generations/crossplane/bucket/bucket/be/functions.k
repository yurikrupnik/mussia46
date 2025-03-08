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
_asd = lambda storageProps: StroageParams -> any {
    {
      Api = storageProps.location
      Ver = storageProps.zone
    }
}

sstorage = StroageParams {
  location = "eu"
  zone = "us-west1"
}

dsa = _asd(sstorage)
schema StroageParams:
  location?: str
  zone: str = "eu-west1"

schema Storage:
  parameters: StroageParams
  id: str

providers = ["aws", "gcp", "azure"]
comtaimer_wf = ["kaniko", "docker", "custm"]
providers1 = ["gha", "teckton", "argo-workspace"]
providers2 = ["flux-cd", "argo-cd"]
providers3 = ["ghr", "ecr", "artifact-registry", "docker-hub", "more"]
