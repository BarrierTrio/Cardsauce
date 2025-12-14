SMODS.Atlas({key = 'banned_tags', path = 'banned_tags.png', px = 169, py = 123})

local tagInfo = {
    name = "Banned Tags",
    atlas = 'banned_tags',
    no_doe = true,
    no_mod_badges = true,
    no_collection = true,
}

function tagInfo.in_pool(self, args)
    return false
end

return tagInfo