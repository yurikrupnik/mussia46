import .functions as f

resourceName = option("kind", required=True)

assert resourceName[0].isupper(), "Error: kind parameter must start with a capital letter, recieved: '${resourceName}'"

_composite = "Composite"
_claim = "claim"

config = {
    kind = resourceName
    plural = f.pluralize(resourceName).lower()
    group = "yurikrupnik.com"
    owner: "Yuri Krupnik (krupnik.yuri@gmail.com)"
    claimNamesKind = kind + _claim.capitalize()
    claimNamesPlural = plural + f.pluralize(_claim)
}

type Provider = "gcp" | "aws" | "azure"
_providersArray: [Provider] = ["gcp", "aws", "azure"]

schema Providers:
  provider: Provider

# ls:Provider = ad[1]
schema Shit:
    kind: str = option("kind", required=True).capitalize()
    plural: str = f.pluralize(kind)

functionReady = {
    step = "automatically-detect-ready-composed-resources"
    functionRef.name = "function-auto-ready"
}
