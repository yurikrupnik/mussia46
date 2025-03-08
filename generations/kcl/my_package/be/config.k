import .functions as f

schema CrossplaneConfig:
    _claim: str = "claim"

    kind: str = option("kind", default="Default")
    plural: str = f.pluralize(kind).lower()
    group: str = option("group", default="example.com")
    owner: str = option("owner", default="Example name (example@gmail.com)")
    claimNamesKind: str = kind + _claim.capitalize()
    claimNamesPlural: str = plural + f.pluralize(_claim)
    #providers: [Provider] = _providersArray

    assert kind != "", "Error: 'kind' must not be empty"
    assert kind[0].isupper(), "Error: 'kind' parameter must start with a capital letter, received: '${kind}'"
    assert group != "", "Error: 'group' must not be empty"
    assert owner != "", "Error: 'owner' must not be empty"

config = CrossplaneConfig()

type Provider = "gcp" | "aws" | "azure"
_providersArray: [Provider] = ["azure", "gcp"]
schema Providers:
    provider: Provider

functionReady = {
    step = "automatically-detect-ready-composed-resources"
    functionRef.name = "function-auto-ready"
}
