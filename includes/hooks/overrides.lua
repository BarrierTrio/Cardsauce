local restrict = SMODS.Challenges.c_jokerless_1.restrictions
table.insert(restrict.banned_tags, {id = 'tag_csau_corrupted'})
SMODS.Challenge:take_ownership('jokerless_1', {
    restrictions = restrict
}, true)