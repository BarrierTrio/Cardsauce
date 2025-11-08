-- I replaced the old is_food() function by just making this a map instead ~Winter

---LIST OF FOOD JOKERS:
-- ✔️ = Bunji/Don Beveridge compatibility
G.foodjokers = {
	-- Balatro (Vanilla) ✔️
	['j_gros_michel'] = true, -- ✔️
	['j_ice_cream'] = true, -- ✔️
	['j_cavendish'] = true, -- ✔️
	['j_turtle_bean'] = true, -- ✔️
	['j_popcorn'] = true, -- ✔️
	['j_ramen'] = true, -- ✔️
	['j_selzer'] = true, -- ✔️
	['j_diet_cola'] = true, -- ❌
	['j_egg'] = true, -- ❌
	-- Cardsauce ✔️
	['j_csau_meat'] = true, -- ✔️
	['j_csau_fantabulous'] = true, -- ✔️
	['j_csau_crudeoil'] = true, -- ✔️
	['j_csau_grannycream'] = true, -- ✔️
	['j_csau_toeofsatan'] = true, -- ✔️
	['j_csau_chips'] = true, -- ✔️
	['j_csau_mug'] = true, -- ✔️
	-- Cryptid
	['j_cry_pickle'] = true,
	['j_cry_chili_pepper'] = true,
	['j_cry_tropical_smoothie'] = true,
	['j_cry_cotton_candy'] = true,
	['j_cry_wrapped'] = true,
	['j_cry_candy_cane'] = true,
	['j_cry_candy_buttons'] = true,
	['j_cry_jawbreaker'] = true,
	['j_cry_mellowcreme'] = true,
	['j_cry_brittle'] = true,
	['j_cry_caramel'] = true,
	['j_cry_oldcandy'] = true,
	-- Neato's Jokers ✔️
	['j_neat_icecreamsandwich'] = true, -- ✔️
	['j_neat_frostedprimerib'] = true, -- ✔️
	['j_neat_bananastand'] = true, -- ✔️
	-- Extra Credit
	['j_ExtraCredit_badapple'] = true, -- ✔️
	['j_ExtraCredit_espresso'] = true, -- ✔️
	['j_ExtraCredit_ambrosia'] = true, -- ✔️
	['j_ExtraCredit_candynecklace'] = true, -- ✔️
	['j_ExtraCredit_compost'] = true, -- ✔️
	['j_ExtraCredit_starfruit'] = true, -- ✔️
	-- Bunco
	['j_bunc_starfruit'] = true,
	-- Ortalab
	['j_ortalab_taliaferro'] = true,
	['j_ortalab_sunnyside'] = true,
	['j_ortalab_hot_chocolate'] = true,
	['j_ortalab_royal_gala'] = true,
	['j_ortalab_fine_wine'] = true,
	['j_ortalab_mystery_soda'] = true,
	['j_ortalab_popcorn_bag'] = true,
	['j_ortalab_salad'] = true,
	-- Paperback
	['j_paperback_apple'] = true,
	['j_paperback_joker_cookie'] = true,
	['j_paperback_nachos'] = true,
	['j_paperback_crispy_taco'] = true,
	['j_paperback_soft_taco'] = true,
	['j_paperback_complete_breakfast'] = true,
	['j_paperback_ghost_cola'] = true,
	['j_paperback_b_soda'] = true,
	['j_paperback_ice_cube'] = true,
	['j_paperback_cream_liqueur'] = true,
	['j_paperback_champagne'] = true,
	['j_paperback_coffee'] = true,
	['j_paperback_matcha'] = true,
	['j_paperback_epic_sauce'] = true,
	['j_paperback_dreamsicle'] = true,
	['j_paperback_cakepop'] = true,
	['j_paperback_caramel_apple'] = true,
	['j_paperback_charred_marshmallow'] = true,
	['j_paperback_rock_candy'] = true,
	['j_paperback_tanghulu'] = true,
	-- Buffoonery
	['j_buf_gfondue'] = true,
	['j_buf_camarosa'] = true,
	-- Aikoyori's Shenanigans ❌
	['j_akyrs_eat_pant'] = true, -- ❌
	-- Prism
	['j_prism_pizza_cap'] = true,
	['j_prism_pizza_mar'] = true,
	['j_prism_pizza_for'] = true,
	['j_prism_pizza_ruc'] = true,
	['j_prism_pizza_haw'] = true,
	['j_prism_pizza_det'] = true,
	['j_prism_cookie'] = true,
	['j_prism_whiskey'] = true,
	-- JoeyJokers
	['j_joey_vegemite'] = true,
	-- Plantain ✔️
	['j_pl_plantain'] = true, -- ✔️
	['j_pl_apple_pie'] = true, -- ✔️
	['j_pl_grape_soda'] = true, -- ✔️
	['j_pl_raw_meat'] = true, -- ❌
}

local function inject(self)
	for k, v in pairs(G.foodjokers) do
		if G.P_CENTERS[k] or SMODS.Centers[k] then
			local center = G.P_CENTERS[k] or SMODS.Centers[k]
			if not table.contains(self, center) then
				self:inject_card(center)
			end
		end
	end
end

--- ObjectType representing "food" jokers, including vanilla Balatro jokers like Ice Cream and Ramen. Compatible with Cryptid
if not SMODS.ObjectTypes.Food then
	SMODS.ObjectType({
		key = "Food",
		default = "j_reserved_parking",
		cards = {},
		inject = function(self)
			SMODS.ObjectType.inject(self)
			inject(self)
		end,
	})
else
	local inj_ref = SMODS.ObjectTypes.Food.inject
	SMODS.ObjectType:take_ownership("Food", {
		inject = function(self)
			inj_ref(self)
			inject(self)
		end
	})
end


-- TODO: update to use Arrow automated crediting

--- Table representing the credits for collab artwork. Properties are tables containing localizaiton info for each face card
G.csau_collab_credits = {
	csau_default_spades = {
		Ace = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.keku } },
	},
	csau_default_hearts = {
		Ace = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.keku } },
	},
	csau_default_clubs = {
		Ace = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.keku } },
	},
	csau_default_diamonds = {
		Ace = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.keku } },
	},
	default_varg_spades = {
		Ace = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.keku } },
	},
	default_varg_hearts = {
		Ace = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.keku } },
	},
	default_varg_clubs = {
		Ace = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.keku } },
	},
	default_varg_diamonds = {
		Ace = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.keku } },
	},
	-- Vine
	csau_wildcards = {
		Ace = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.keku }, specific = { ['csau_default'] = true, ['csau_lightshrooms'] = true, } },
		King = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.frada } },
		Queen = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.cheesy } },
		Jack = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.cheesy } },
	},
	csau_mascots = {
		Ace = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.keku }, specific = { ['csau_default'] = true, ['csau_lightshrooms'] = true, } },
		King = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.cheesy } },
		Queen = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.greg } },
		Jack = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.cherry } },
	},
	csau_classics = {
		Ace = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.keku }, specific = { ['csau_default'] = true, ['csau_lightshrooms'] = true, } },
		King = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.winterg } },
		Queen = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.winterg } },
		Jack = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.winterg } },
	},
	csau_confidants = {
		Ace = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.keku }, specific = { ['csau_default'] = true, ['csau_lightshrooms'] = true, } },
		King = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.jen } },
		Queen = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.jen } },
		Jack = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.jen } },
	},
	-- Varg
	csau_americans = {
		Ace = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.keku }, specific = { ['csau_varg_aces'] = true } },
		King = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.burd } },
		Queen = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.guff } },
		Jack = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.plunch } },
	},
	csau_voices = {
		Ace = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.keku }, specific = { ['csau_varg_aces'] = true } },
		King = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.lyzerus } },
		Queen = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.crispy } },
		Jack = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.lyzerus } },
	},
	csau_duendes = {
		Ace = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.keku }, specific = { ['csau_varg_aces'] = true } },
		King = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.winterg } },
		Queen = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.cejai } },
		Jack = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.guff } },
	},
	csau_powerful = {
		Ace = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.keku }, specific = { ['csau_varg_aces'] = true } },
		King = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } },
		Queen = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.chvsau } },
		Jack = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.retro } },
	},
	-- Mike
	csau_poops = {
		Ace = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.wario }, specific = { ['csau_jazz_aces'] = true } },
		King = {key = "csau_artistcredit_2", set = "Other", vars = { G.csau_team.gote, G.csau_team.cejai } , plural = true},
		Queen = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } },
		Jack = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.cejai } },
	},
	csau_ocs = {
		Ace = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.wario }, specific = { ['csau_jazz_aces'] = true } },
		King = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.eld } },
		Queen = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.guff } },
		Jack = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } },
	},
	csau_pets = {
		Ace = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.wario }, specific = { ['csau_jazz_aces'] = true } },
		King = {key = "vacredit", set = "Other", vars = { G.csau_team.fenix } },
		Queen = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.winterg } },
		Jack = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.winterg } },
	},
	csau_fingies = {
		Ace = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.wario }, specific = { ['csau_jazz_aces'] = true }},
		King = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.winterg } },
		Queen = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.lwb } },
		Jack = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } },
	},
}

-- Automatically inserts vanilla friends of Jimbo credits into G.csau_collab_credits. cause why not
local ref_ips = G.FUNCS.initPostSplash
G.FUNCS.initPostSplash = function()
	ref_ips()
	local visited = {}
	local function recursive_search(t)
		if visited[t] then return false end
		visited[t] = true
		if type(t) == "table" and t.label == "Collabs" and type(t.tab_definition_function) == "function" then
			t.tab_definition_function()
			return true
		end
		for _, v in ipairs(t) do
			if type(v) == "table" and recursive_search(v) then
				return true
			end
		end
		for k, v in pairs(t) do
			if type(v) == "table" and recursive_search(v) then
				return true
			end
		end
		return false
	end
	G.FUNCS.show_credits()
	local result = recursive_search(G.OVERLAY_MENU)
	G.FUNCS:exit_overlay_menu()
	if result then
		for k, v in pairs(G.collab_credits) do
			if v.artist then
				G.csau_collab_credits[v.art] = {
					King = {key = "csau_artistcredit", set = "Other", vars = { v.artist } },
					Queen = {key = "csau_artistcredit", set = "Other", vars = { v.artist } },
					Jack = {key = "csau_artistcredit", set = "Other", vars = { v.artist } },
				}
			end
			G.csau_collab_credits[v.art] = G.csau_collab_credits[v.art] or {}
			G.csau_collab_credits[v.art].Ace = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.keku }, specific = { ['csau_default'] = { G.csau_team.keku }, ['csau_lightshrooms'] = { G.csau_team.keku }, ['csau_varg_aces'] = { G.csau_team.keku }, ['csau_jazz_aces'] = { G.csau_team.wario }, } }
		end
	end
end

-- A table of preset color settings when Colors are enabled in mod configs
G.color_presets = {
	{
		"GREEN",
		"PURPLE",
		{'50846e', "BAL_DEF_SMALLBIGGREEN"},
		{"4f6367", "BAL_DEF_ENDLESSBLUEGREY"},
		'default_csau'
	},
	{
		"RED",
		"BLUE",
		{'50846e', "BAL_DEF_SMALLBIGGREEN"},
		{"4f6367", "BAL_DEF_ENDLESSBLUEGREY"},
		'default_bal'
	},
	{
		{'2c997f', "DS_GREENCYAN"},
		{'09271d', "DS_DARKGREEN"},
		{'3a6658', "DS_BGGREEN"},
		'darkshroom',
	},
	{
		{'60b283', "VS_GREEN"},
		{'a3c86f', "VS_YELLOWGREEN"},
		{'3a664c', "VS_BGGREEN"},
		'vineshroom',
	},
	{
		{"547bb8", "FS_BLUE"},
		{"67b874", "FS_PALEGREEN"},
		{"3a4b66", "FS_BGBLUE"},
		'fullsauce',
	},
	{
		{'e26565', "ES_PALERED"},
		{'a53b38', "ES_DARKRED"},
		{'704b4b', "ES_BGRED"},
		'extrasauce',
	},
	{
		{'9967a7', "TWITCH_PALEPURPLE"},
		{'483062', "TWITCH_DARKPURPLE"},
		{'655478', "TWITCH_BGPURPLE"},
		'twitch',
	},
	{
		{"b5e61d", "FREN_NEONGREEN"},
		{"04a1e5", "FREN_LIGHTBLUE"},
		{"446138", "FREN_BGGREEN"},
		'fren',
	},
	{
		"PURPLE",
		"YELLOW",
		{"655478", "JM_BGPURPLE"},
		'jabroni',
	},
	{
		"JOKER_GREY",
		"BLACK",
		{'404040', "UZU_BGGRAY"},
		'uzumaki',
	},
	{
		"customhex"
	}
}

-- colors used for dynamic badges, used to be in localization file which is a bad place to put hex codes -keku
G.csau_badge_colours = {
	co_vinny = "32A852",
	te_vinny = "FFFFFF",
	co_joel = "3b4635",
	te_joel = "b0cf56",
	co_mike = "8867a5",
	te_mike = "FFFF00",
	co_redvox = "841f20",
	te_redvox = "cac5b7",
	co_rlm = "FFFFFF",
	te_rlm = "b1212a",
	co_uzumaki = "374244",
	te_uzumaki = "bfc7d5",
	co_monkeywrench = "194528",
	te_monkeywrench = "edffee",

	-- badge colors for jojo parts
	co_phantom = '245482',
	te_phantom = 'eee4a6',
	co_battle = 'DD5668',
	te_battle = '338FC4',
	co_stardust = '425F7C',
	te_stardust = 'EFCB70',
	co_diamond = 'BEE5E5',
	te_diamond = 'C479BE',
	co_vento = 'EDCE49',
	te_vento = 'D168BC',
	co_feedback = '7e2786',
	te_feedback = 'fe9818',
	co_stone = '0076b2',
	te_stone = '97c348',
	co_steel = 'A38168',
	te_steel = 'A9CF3C',
	co_lion = 'dcf5fc',
	te_lion = '7832c4',
	co_lands = '394E90',
	te_lands = '409CE8',
}

G.csau_animated_centers = {}

G.color_presets_nums = {}
G.color_presets_strings = {}
for i, v in ipairs(G.color_presets) do
	local k = v[#v]
	table.insert(G.color_presets_strings, k)
	G.color_presets_nums[k] = i
	if k ~= "customhex" then
		for i = 1, #v - 1 do
			local func_name, color_name
			if type(v[i]) == "string" then
				func_name = "cs_"..v[i].."c"
				color_name = v[i]
			elseif type(v[i]) == "table" then
				G.C[v[i][2]] = HEX(v[i][1])
				func_name = "cs_"..v[i][2].."c"
				color_name = v[i][2]
			end
		end
	end
end

-- I'll be honest, I have no idea what this does
-- But it's a global table, so it goes here
mgt = {"m", "e", "t", "a", "l", "g", "e", "a", "r", "t", "a", "c", "o"}
mgt_num = 1
