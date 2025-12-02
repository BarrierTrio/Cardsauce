local tagInfo = {
    name = "Banned Tags",
    no_doe = true,
    no_mod_badges = true,
    no_collection = true,
    width = 169,
	height = 123,
}

function tagInfo.in_pool(self, args)
    return false
end

return tagInfo