test_cc_default = lambda {
    cc = CrossplaneConfig {}

    assert cc._claim == "claim"
    assert cc.group == "yurikrupnik.com"
    assert cc.owner == "Yuri Krupnik (krupnik.yuri@gmail.com)"
    assert cc.claimNamesKind == "DefaultClaim"
    assert cc.claimNamesPlural == "defaultsclaims"
}

test_cc_cystoms = lambda {
    cc = CrossplaneConfig {
        kind = "Resource"
        _claim = "clam"
        group = "my-group.com"
        owner = "test@test.com"
    }
    assert cc._claim == "clam"
    assert cc.group == "my-group.com"
    assert cc.owner == "test@test.com"
    assert cc.claimNamesKind == "ResourceClam"
    assert cc.claimNamesPlural == "resourcesclams"
}
