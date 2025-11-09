-- Removed the deprecated header metadata in favor of the current json one
-- look in Cardsauce.json for that info! ~Winter
Cardsauce = SMODS.current_mod
Cardsauce.optional_features = {
	retrigger_joker = true,
	quantum_enhancements = true,
}
Cardsauce.current_config = copy_table(Cardsauce.config)
Cardsauce.usable_path = Cardsauce.path:match("Mods/[^/]+")
Cardsauce.default_ds = 'joel'
Cardsauce.ortalab_dlc = false

-- I put the colors here I guess
G.C.STAND = HEX('B85F8E')
G.C.VHS = HEX('a2615e')
G.C.MUG = HEX('db9a4d')

local includes = {
	-- includes utility functions required for following files
	'tables',
	'utility',
	'ui',
	'shaders',
	'compat',
	'music',

	-- object hooks
	'hooks/game',
	'hooks/button_callbacks',
	'hooks/card',
	'hooks/cardarea',
	'hooks/state_events',
	'hooks/common_events',
	'hooks/misc_functions',
	'hooks/UI_definitions',
	'hooks/overrides',
	'hooks/smods',

	-- option files
	--- jokers are required for some following files so include them first

	'skins',
	'colors',
	'items',
	'achievements',
}

for _, include in ipairs(includes) do
	local init, error = SMODS.load_file("includes/" .. include ..".lua")
	if error then sendErrorMessage("[Cardsauce] Failed to load "..include.." with error "..error) else
		local data = init()
		sendDebugMessage("[Cardsauce] Loaded hook: " .. include)
	end
end
