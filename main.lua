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


ArrowAPI.misc.add_colors({
	['CARDSAUCE'] = copy_table(Cardsauce.badge_colour),
	['MUG'] = HEX('db9a4d'),
    ['STREETLIGHT'] = HEX('139194'),
    ['CSAU_ACH_RARE_1'] = HEX('6FDCB0'),
    ['CSAU_ACH_RARE_2'] = HEX('FFA551'),
    ['CSAU_ACH_RARE_3'] = HEX('FFD654'),
    ['CSAU_ACH_RARE_4'] = HEX('E096F2'),
})

ArrowAPI.ui.add_badge_colors(Cardsauce, {
	co_vinny = HEX("32A852"),
	te_vinny = HEX("FFFFFF"),
	co_joel = HEX("3B4635"),
	te_joel = HEX("b0Cf56"),
	co_mike = HEX("8867A5"),
	te_mike = HEX("FFFF00"),
	co_redvox = HEX("841F20"),
	te_redvox = HEX("CAC5B7"),
	co_rlm = HEX("FFFFFF"),
	te_rlm = HEX("B1212A"),
	co_uzumaki = HEX("374244"),
	te_uzumaki = HEX("BfC7D5"),
	co_monkeywrench = HEX("194528"),
	te_monkeywrench = HEX("EDFFEE"),

	-- badge colors for jojo parts
	co_jojo = G.C.STAND,
    te_jojo = HEX('FFFFFF'),
	co_phantom = HEX('245482'),
	te_phantom = HEX('eee4a6'),
	co_battle = HEX('DD5668'),
	te_battle = HEX('338FC4'),
	co_stardust = HEX('425F7C'),
	te_stardust = HEX('EFCB70'),
	co_diamond = HEX('BEE5E5'),
	te_diamond = HEX('C479BE'),
	co_vento = HEX('EDCE49'),
	te_vento = HEX('D168BC'),
	co_feedback = HEX('7e2786'),
	te_feedback = HEX('fe9818'),
	co_stone = HEX('0076b2'),
	te_stone = HEX('97c348'),
	co_steel = HEX('A38168'),
	te_steel = HEX('A9CF3C'),
	co_lion = HEX('dcf5fc'),
	te_lion = HEX('7832c4'),
	co_lands = HEX('394E90'),
	te_lands = HEX('409CE8'),
})

ArrowAPI.credits.use_credits(Cardsauce, {
    matrix = {col = 20, row = 7},
    {
        key = 'direction',
        title_colour = G.C.GOLD,
        pos_start = {col = 0, row = 0},
        pos_end = {col = 5.5, row = 3},
        contributors = {
            ["BarrierTrio/Gote"] = true,
			["Kekulism"] = true,
            ["Vivian Giacobbi"] = true,
        }
    },
	{
		key = 'music',
        title_colour = G.C.RED,
        pos_start = {col = 0, row = 3},
        pos_end = {col = 5.5, row = 5},
		contributors = {
			['Baseclefff'] = true,
			['bassclefff.bandcamp.com'] = {name_color = G.C.UI.TEXT_INACTIVE, scale_mod = 0.8}
		}
	},
	{
		key = 'voice',
        title_colour = G.C.BLUE,
        pos_start = {col = 0, row = 5},
        pos_end = {col = 5.5, row = 7},
		contributors = {
			['Austin L. Matthews'] = {
				name_func = function()
					return G.SETTINGS.roche and 'Austin L. Matthews' or '?????'
				end
			},
			['(AmtraxVA)'] = {
				name_func = function()
					return G.SETTINGS.roche and '(AmtraxVA)' or '?????'
				end,
				name_color = G.C.UI.TEXT_INACTIVE,
				scale_mod = 0.8
			}
		}
	},
    {
        key = 'artist',
        title_colour = G.C.ETERNAL,
        pos_start = {col = 5.5, row = 0},
        pos_end = {col = 13, row = 7}
    },
    {
        key = 'logo',
        title_colour = G.C.PURPLE,
        pos_start = {col = 13, row = 0},
        pos_end = {col = 16.5, row = 2.5},
		contributors = {
			['AlizarinRed'] = true,
			['(alizarin.red)'] = {name_color = G.C.UI.TEXT_INACTIVE, scale_mod = 0.8}
		}
    },
    {
        key = 'shader',
        title_colour = G.C.DARK_EDITION,
        pos_start = {col = 13, row = 2.5},
        pos_end = {col = 16.5, row = 5},
        contributors = {
			["Sir. Gameboy"] = true,
            ["Vivian Giacobbi"] = true,
        }
    },
	{
        key = 'programmer',
        title_colour = G.C.ORANGE,
        pos_start = {col = 16.5, row = 0},
        pos_end = {col = 20, row = 5},
        contributors = {
			["BarrierTrio/Gote"] = true,
            ["Nether"] = true,
			["Numbuh214"] = true,
			["Aurelius7309"] = true,
        }
    },
    {
        key = 'special',
        title_colour = G.C.GREEN,
        pos_start = {col = 13, row = 5},
        pos_end = {col = 20, row = 7},
        contributors = {
            ["Hirohiko Araki"] = true,
            ["LuckyLand Communications"] = true,
            ["Nico Abrams (LuaNES)"] = true,
        }
    },
})

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
	'hooks/state_events',
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
