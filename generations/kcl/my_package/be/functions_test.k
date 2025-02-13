test_pluralize = lambda {
    # ✅ Regular pluralization cases
    assert pluralize("car") == "cars"
    assert pluralize("dog") == "dogs"
    assert pluralize("apple") == "apples"
    # ✅ Words ending in "y" (consonant before "y")
    assert pluralize("baby") == "babies"
    assert pluralize("city") == "cities"
    assert pluralize("penny") == "pennies"
    # ✅ Words ending in "y" (vowel before "y" - should NOT change)
    assert pluralize("boy") == "boys"
    assert pluralize("day") == "days"
    assert pluralize("monkey") == "monkeys"
    # ✅ Words ending in "s", "x", "z", "ch", "sh"
    assert pluralize("bus") == "buses"
    assert pluralize("box") == "boxes"
    assert pluralize("quiz") == "quizzes"
    assert pluralize("buzz") == "buzzes"
    assert pluralize("blitz") == "blitzes"
    assert pluralize("church") == "churches"
    assert pluralize("dish") == "dishes"
    # ✅ Edge Cases
    # Empty string case
    assert pluralize("") == "s"
    # Numbers should just add "s"
    assert pluralize("123") == "123s"
    # Single letter should add "s"
    assert pluralize("O") == "Os"
}
