local arrow_init, arrow_error = SMODS.load_file("arrowapi/main.lua")
if arrow_error then
	sendErrorMessage("[ArrowAPI] Failed to load with error "..arrow_error)
else
	arrow_init()
end

-- Removed the deprecated header metadata in favor of the current json one
-- look in Cardsauce.json for that info! ~Winter
Cardsauce = SMODS.current_mod
Cardsauce.current_config = copy_table(Cardsauce.config)
Cardsauce.optional_features = {
	retrigger_joker = true,
	quantum_enhancements = true,
}
Cardsauce.mgt = {"m", "e", "t", "a", "l", "g", "e", "a", "r", "t", "a", "c", "o"}
Cardsauce.mgt_num = 1

--- chadnova easter egg
math.randomseed(os.time())
if math.random() < 0.001 then
	ArrowAPI.config_tools.update_config(Cardsauce, 'enable_Chadnova', true)
end

Cardsauce.usable_path = Cardsauce.path:match("Mods/[^/]+")
Cardsauce.default_ds = 'joel'
Cardsauce.ortalab_dlc = false

Cardsauce.calculate = function(self, context)
	if context.removed_card and context.removed_card.config.center.set == 'Joker' and context.getting_sliced then
		check_for_unlock({ type = "unlock_killjester" })
	end

	if context.using_consumeable then
		if context.consumeable.config.center.key == 'c_immolate' then
			check_for_unlock({type = 'unlock_kings'})
		elseif context.consumeable.config.center.key == 'c_tower' then
			for _, v in ipairs(G.hand.highlighted) do
				if v:get_id() == 12 then
					check_for_unlock({ type = "unlock_villains" })
					break
				end
			end
		end
	end

	if G.GAME.modifiers.csau_nmbb and context.debuff_hand and not next(context.poker_hands['csau_Blackjack']) then
		return {
			prevent_debuff = false,
			debuff = true,
			debuff_text = localize("k_not_bj"),
			debuff_source = Cardsauce
		}
	end

	if context.splash_card and Cardsauce.chadnova then
		return {
			splash_center = 'j_csau_chad'
		}
	end

	if context.title_card then
		local title_center = Cardsauce.chadnova and 'j_csau_chad' or nil
		local title_front = not Cardsauce.chadnova and Cardsauce.config['enable_Logo'] and 'C_A' or nil

		if title_center or title_front then
			return {
				title_center = title_center,
				title_front = title_front
			}
		end
	end
end

ArrowAPI.misc.add_colors({
	['CARDSAUCE'] = copy_table(Cardsauce.badge_colour),
	['MUG'] = HEX('db9a4d'),
    ['CSAU_ACH_RARE_1'] = HEX('6FDCB0'),
    ['CSAU_ACH_RARE_2'] = HEX('FFA551'),
    ['CSAU_ACH_RARE_3'] = HEX('FFD654'),
    ['CSAU_ACH_RARE_4'] = HEX('E096F2'),
})

ArrowAPI.ui.add_badge_colors(Cardsauce, {
	co_cardsauce = copy_table(Cardsauce.badge_colour),
	te_cardsauce = HEX("FFFFFF"),
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

ArrowAPI.config_tools.use_credits(Cardsauce, {
    matrix = {col = 18.5, row = 7},
    {
        key = 'direction',
        title_colour = G.C.GOLD,
        pos_start = {col = 0, row = 0},
        pos_end = {col = 4.5, row = 2.25},
        contributors = {
            {name = "BarrierTrio/Gote"},
			{name = "Kekulism"},
            {name = "Vivian Giacobbi"},
        }
    },
	{
		key = 'music',
        title_colour = G.C.RED,
        pos_start = {col = 0, row = 2.25},
        pos_end = {col = 4.5, row = 4.5},
		contributors = {
			{name = 'bassclefff', name_scale = 1.1},
			{name = '(bassclefff.bandcamp.com)', name_colour = G.C.JOKER_GREY, name_scale = 0.8}
		}
	},
	{
		key = 'voice',
        title_colour = G.C.BLUE,
        pos_start = {col = 0, row = 4.5},
        pos_end = {col = 4.5, row = 7},
		contributors = {
			{
				name = function()
					return G.SETTINGS.roche and 'Austin L. Matthews' or '?????'
				end,
				name_scale = 1.1
			},
			{
				name = function()
					return G.SETTINGS.roche and '(AmtraxVA)' or '?????'
				end,
				name_color = G.C.UI.TEXT_INACTIVE,
				name_scale = 0.8
			}
		}
	},
    {
        key = 'artist',
        title_colour = G.C.ETERNAL,
        pos_start = {col = 4.5, row = 0},
        pos_end = {col = 11.5, row = 7}
    },
	{
        key = 'logo',
        title_colour = G.C.PURPLE,
        pos_start = {col = 11.5, row = 0},
        pos_end = {col = 15, row = 2.5},
		contributors = {
			{name = 'AlizarinRed', name_scale = 1.1},
			{name = '(alizarin.red)', name_colour = G.C.JOKER_GREY, name_scale = 0.8}
		}
    },
	{
        key = 'graphics',
        title_colour = G.C.DARK_EDITION,
        pos_start = {col = 11.5, row = 2.5},
        pos_end = {col = 15, row = 5},
        contributors = {
			{name = "Sir. Gameboy"},
            {name = "Vivian Giacobbi"},
        }
    },
	{
        key = 'programmer',
        title_colour = G.C.ORANGE,
        pos_start = {col = 15, row = 0},
        pos_end = {col = 18.5, row = 5},
        contributors = {
			{name = "BarrierTrio/Gote"},
            {name = "Nether"},
			{name = "Numbuh214"},
			{name = "Aurelius7309"}
        }
    },
    {
        key = 'special',
        title_colour = G.C.GREEN,
        pos_start = {col = 11.5, row = 5},
        pos_end = {col = 18.5, row = 7},
        contributors = {
            {name = "Vinny"},
			{name = "Joel"},
			{name = "Mike"},
			{name = "tortoise"},
			{name = "Protokyuuu"},
			{name = "ShrineFox"},
			{name = "ReconBox"},
			{name = "cryobolic"},
			{name = "SinCityAssassin"},
			{name = "Aurelius7309"},
			{name = "Victin"},
			{name = "TheVoyger1234"},
        }
    },
})

ArrowAPI.config_tools.use_config(Cardsauce, {
	{key = 'enable_VinnyContent', order = 1, before_auto = true, default_value = true},
	{key = 'enable_JoelContent', order = 2, before_auto = true, default_value = true},
	{key = 'enable_Logo', order = 1, default_value = true},
	{key = 'enable_EasterEggs', order = 2, default_value = true},
	{key = 'enable_ItemCredits', default_value = true, order = 3},
	{key = 'enable_DetailedDescs', default_value = false, order = 4},
	{key = 'muteWega', default_value = false, exclude_from_ui = true},
	{key = 'forceDisableOrtalab', default_value = false, exclude_from_ui = true},
	{key = 'forceEnableOrtalab', default_value = false, exclude_from_ui = true},
	{key = 'rows', default_value = 2, exclude_from_ui = true},
	{key = 'cols', default_value = 6, exclude_from_ui = true},
	{key = 'loaded_packs', default_value = {
		[1] = "sp_csau_cardsauce",
		[2] = "sp_balatro",
		replace_map = {}
	}, exclude_from_ui = true},
	{key = 'saved_palettes', default_value = {
		["Spectral"] = {
			{
				{61,68,96,["key"]="61-68-96",["default"]=true},
				{106,101,81,["key"]="106-101-81",["default"]=true},
				{78,87,121,["key"]="78-87-121",["default"]=true},
				{79,99,103,["key"]="79-99-103",["default"]=true},
				{92,120,125,["key"]="92-120-125",["default"]=true},
				{139,131,97,["key"]="139-131-97",["default"]=true},
				{167,156,103,["key"]="167-156-103",["default"]=true},
				{199,178,74,["key"]="199-178-74",["default"]=true},
				{232,214,127,["key"]="232-214-127",["default"]=true},
				{94,114,151,["key"]="94-114-151",["default"]=true},
				{82,100,162,["key"]="82-100-162",["default"]=true},
				{91,127,193,["key"]="91-127-193",["default"]=true},
				{114,151,217,["key"]="114-151-217",["default"]=true},
				{99,143,225,["key"]="99-143-225",["default"]=true},
				{122,164,242,["key"]="122-164-242",["default"]=true},
				{225,235,133,["key"]="225-235-133",["default"]=true},
				{239,241,156,["key"]="239-241-156",["default"]=true},
				{192,223,174,["key"]="192-223-174",["default"]=true},
				{207,229,185,["key"]="207-229-185",["default"]=true},
				{150,170,203,["key"]="150-170-203",["default"]=true},
				{137,198,234,["key"]="137-198-234",["default"]=true},
				{191,204,227,["key"]="191-204-227",["default"]=true},
				{144,226,249,["key"]="144-226-249",["default"]=true},
				{169,226,242,["key"]="169-226-242",["default"]=true},
				{226,235,249,["key"]="226-235-249",["default"]=true},
				{239,250,254,["key"]="239-250-254",["default"]=true},
				{255,84,104,["key"]="255-84-104",["default"]=true},
				{170,64,92,["key"]="170-64-92",["default"]=true},
				{255,255,255,["key"]="255-255-255",["default"]=true},
				["name"] = "Default",
			}, {
				{93,141,181,["key"]="94-114-151"},
				{81,110,146,["key"]="78-87-121"},
				{94,181,240,["key"]="99-143-225"},
				{91,166,221,["key"]="91-127-193"},
				{245,169,184,["key"]="199-178-74"},
				{249,136,153,["key"]="167-156-103"},
				{91,206,250,["key"]="122-164-242"},
				{248,196,203,["key"]="232-214-127"},
				{251,113,131,["key"]="139-131-97"},
				{51,65,89,["key"]="61-68-96"},
				{132,140,174,["key"]="92-120-125"},
				{86,136,168,["key"]="82-100-162"},
				{171,94,105,["key"]="106-101-81"},
				{89,135,187,["key"]="114-151-217"},
				{198,233,244,["key"]="169-226-242"},
				{250,222,227,["key"]="225-235-133"},
				{252,190,198,["key"]="192-223-174"},
				{251,177,188,["key"]="207-229-185"},
				{156,219,249,["key"]="144-226-249"},
				{250,219,223,["key"]="239-241-156"},
				{156,209,235,["key"]="137-198-234"},
				{251,113,131,["key"]="255-84-104"},
				{179,94,105,["key"]="170-64-92"},
				["name"] = "Spectrans",
				["badge_colour"] = "arrow_spectrans",
			},
			["saved_index"] = 2,
		},
		["Tarot"] = {
			{
				{79,99,103,["key"]="79-99-103",["default"]=true},
				{255,229,180,["key"]="255-229-180",["default"]=true},
				{218,183,114,["key"]="218-183-114",["default"]=true},
				{243,198,89,["key"]="243-198-89",["default"]=true},
				{165,133,71,["key"]="165-133-71",["default"]=true},
				{233,216,254,["key"]="233-216-254",["default"]=true},
				{214,186,249,["key"]="214-186-249",["default"]=true},
				{183,162,253,["key"]="183-162-253",["default"]=true},
				{167,145,243,["key"]="167-145-243",["default"]=true},
				{153,129,234,["key"]="153-129-234",["default"]=true},
				{138,113,225,["key"]="138-113-225",["default"]=true},
				{107,97,139,["key"]="107-97-139",["default"]=true},
				{255,255,255,["key"]="255-255-255",["default"]=true},
				["name"]="Default"
			},
			["saved_index"] = 1,
		},
		["Background"] = {
			{
				{80,132,110,["key"]="Small",["default"]=true},
				{79,99,103,["key"]="won",["default"]=true},
				{254,95,85,["key"]="SHOWDOWN_COL_1",["default"]=true},
				{0,157,255,["key"]="SHOWDOWN_COL_2",["default"]=true},
				["name"]="Default"
			},{
				{75,194,146,["key"]="SHOWDOWN_COL_1"},
				{136,103,165,["key"]="SHOWDOWN_COL_2"},
				["name"]="Cardsauce"
			},{
				{58,102,88,["key"]="Small"},
				{44,153,127,["key"]="SHOWDOWN_COL_1"},
				{9,39,29,["key"]="SHOWDOWN_COL_2"},
				["name"]="Darkshroom"
			},{
				{58,102,76,["key"]="Small"},
				{96,178,131,["key"]="SHOWDOWN_COL_1"},
				{163,200,111,["key"]="SHOWDOWN_COL_2"},
				["name"]="Vineshroom"
			},{
				{58,75,102,["key"]="Small"},
				{84,123,184,["key"]="SHOWDOWN_COL_1"},
				{103,184,116,["key"]="SHOWDOWN_COL_2"},
				["name"]="Fullsauce"
			},{
				{112,75,75,["key"]="Small"},
				{226,101,101,["key"]="SHOWDOWN_COL_1"},
				{165,59,56,["key"]="SHOWDOWN_COL_2"},
				["name"]="Extrasauce"
			},{
				{201,84,120,["key"]="Small"},
				{153,103,167,["key"]="SHOWDOWN_COL_1"},
				{72,48,98,["key"]="SHOWDOWN_COL_2"},
				["name"]="Twitch"
			},{
				{68,97,56,["key"]="Small"},
				{181,230,29,["key"]="SHOWDOWN_COL_1"},
				{4,161,229,["key"]="SHOWDOWN_COL_2"},
				["name"]="Fren"
			},{
				{101,84,120,["key"]="Small"},
				{136,103,165,["key"]="SHOWDOWN_COL_1"},
				{255,255,0,["key"]="SHOWDOWN_COL_2"},
				["name"]="Jabroni"
			},{
				{64,64,640,["key"]="Small"},
				{191,199,213,["key"]="SHOWDOWN_COL_1"},
				{55,66,68,["key"]="SHOWDOWN_COL_2"},
				["name"]="Uzumaki"
			},
			["saved_index"] = 2,
		},
		["Planet"] = {
			{
				{61,68,96,["key"] = "61-68-96",["default"] = true},
				{79,99,103,["key"]="79-99-103",["default"]=true},
				{88,96,127,["key"]="88-96-127",["default"]=true,},
				{59,102,131,["key"]="59-102-131",["default"]=true},
				{54,116,157,["key"]="54-116-157",["default"]=true},
				{72,94,137,["key"]="72-94-137",["default"]=true},
				{87,125,136,["key"]="87-125-136",["default"]=true},
				{102,99,149,["key"]="102-99-149",["default"]=true},
				{66,86,186,["key"]="66-86-186",["default"]=true},
				{135,119,176,["key"]="135-119-176",["default"]=true},
				{91,155,170,["key"]="91-155-170",["default"]=true},
				{77,138,223,["key"]="77-138-223",["default"]=true},
				{103,176,209,["key"]="103-176-209",["default"]=true},
				{116,198,208,["key"]="116-198-208",["default"]=true},
				{113,206,233,["key"]="113-206-233",["default"]=true},
				{253,220,160,["key"]="253-220-160",["default"]=true},
				{140,157,199,["key"]="140-156-199",["default"]=true},
				{176,189,214,["key"]="176-189-214",["default"]=true},
				{183,162,253,["key"]="183-162-253",["default"]=true},
				{132,197,210,["key"]="132-197-210",["default"]=true},
				{137,232,253,["key"]="137-232-253",["default"]=true},
				{223, 245, 252, ["key"] = "223-245-252", ["default"] = true,},
				{255, 255, 255, ["key"] = "255-255-255", ["default"] = true},
				["name"] = "Default",
			},
			["saved_index"] = 1,
		},
	}, exclude_from_ui = true},
})

ArrowAPI.game.add_game_globals_func(Cardsauce, function(run_start)
    if run_start then
        G.GAME.morshu_cards = 0
		G.GAME.csau_saved_deathcards = {}

		if G.GAME.modifiers.csau_marathon then
			-- set all consumable types besides VHS to 0 shop rate
			for _, v in pairs(SMODS.ConsumableTypes) do
				if v.key ~= 'VHS' then
					local key = v.key:lower() .. '_rate'
					G.GAME[key] = 0
				end
			end
		end
    end

    G.GAME.current_round.koffing_rerolls = #SMODS.find_card('j_csau_koffing')

	csau_reset_joeycastle()
	csau_reset_choicevoice()
	csau_reset_duane()
end)

local includes = {
	-- includes utility functions required for following files

	'tables',
	'utility',
	'ui',
	'shaders',
	'compat',

	-- object hooks
	'hooks/game',
	'hooks/button_callbacks',
	'hooks/sprite',
	'hooks/card',
	'hooks/controller',
	'hooks/common_events',
	'hooks/misc_functions',
	'hooks/UI_definitions',
	'hooks/overrides',
	'hooks/smods',

	-- option files
	--- jokers are required for some following files so include them first

	'skins',
	'items',

	Cardsauce.ortalab_dlc and 'ortalab_dlc' or nil
}

for _, include in ipairs(includes) do
	local init, error = SMODS.load_file("includes/" .. include ..".lua")
	if error then sendErrorMessage("[Cardsauce] Failed to load "..include.." with error "..error) else
		local data = init()
		sendDebugMessage("[Cardsauce] Loaded hook: " .. include)
	end
end

local jojobal_init, jojobal_error = SMODS.load_file("jojobal/main.lua")
if jojobal_error then sendErrorMessage("[Jojobal] Failed to load with error "..jojobal_error)
else jojobal_init() end
