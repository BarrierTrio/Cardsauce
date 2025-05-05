-- Removed the deprecated header metadata in favor of the current json one
-- look in Cardsauce.json for that info! ~Winter

SMODS.current_mod.optional_features = {
	retrigger_joker = true,
	post_trigger = true,
	cardareas = {
		deck = true,
		discard = true,
	},
}

UsableModPath = SMODS.current_mod.path:match("Mods/[^/]+")
PathPatternReplace = UsableModPath:gsub("(%W)","%%%1")  -- shoot me in the foot, why doesn't lua just have a str.replace
csau_config = SMODS.current_mod.config
csau_enabled = copy_table(csau_config)

SMODS.current_mod.DT = {
	twoPoint0 = true,
	def_deckskin = 'joel' -- 'vinny' or nil for Vine Characters, 'joel' for Joel characters
}

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
	'hooks/misc_functions',
	'hooks/UI_definitions',
	'hooks/smods',

	-- option files
	--- jokers are required for some following files so include them first
	
	'skins',
	'colors',
	'items',
	'achievements',
}

-- blank function that is run on starting the main menu,
-- other parts of the mod can hook into this to run code
-- that needs to be run after the game has initialized
G.FUNCS.initPostSplash = function() end

-- Talisman fix
local to_number = to_number or function(ass)
  return ass
end

for _, include in ipairs(includes) do
	local init, error = SMODS.load_file("includes/" .. include ..".lua")
	if error then sendErrorMessage("[Cardsauce] Failed to load "..include.." with error "..error) else
		local data = init()
		sendDebugMessage("[Cardsauce] Loaded hook: " .. include)
	end
end
