local independent_arrow = ArrowAPI
if not independent_arrow then
	SMODS.load_file("modules/Arrow/main.lua")()
end


-- Removed the deprecated header metadata in favor of the current json one
-- look in Cardsauce.json for that info! ~Winter
Cardsauce = SMODS.current_mod
Cardsauce.optional_features = {
	arrow_palettes = true,
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
		local title_center = Cardsauce.chadnova and 'j_csau_chad' or 'c_base'
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
    ['CSAU_ACH_RARE_1'] = HEX('CB755f'),
    ['CSAU_ACH_RARE_2'] = HEX('CECECE'),
    ['CSAU_ACH_RARE_3'] = HEX('EBB04F'),
    ['CSAU_ACH_RARE_4'] = copy_table(Cardsauce.badge_colour),
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
				name = 'Austin L. Matthews',
				name_func = function()
					return G.SETTINGS.roche and 'Austin L. Matthews' or '?????'
				end,
				name_scale = 1.1
			},
			{
				name = '(AmtraxVA)',
				name_func = function()
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

if independent_arrow then
	ArrowAPI.config_tools.use_default_config(ArrowAPI, {
		{key = 'loaded_packs', default_value = {
			[1] = 'sp_csau_cardsauce',
			[2] = "sp_balatro",
			replace_map = {}
		}, exclude_from_ui = true},
	})

	ArrowAPI.config_tools.use_default_config(Cardsauce, {
		{key = 'enable_VinnyContent', before_auto = true, default_value = true},
		{key = 'enable_JoelContent', before_auto = true, default_value = true},
		{key = 'enable_Logo', default_value = true},
		{key = 'enable_EasterEggs', default_value = true},
		{key = 'muteWega', default_value = false, exclude_from_ui = true},
		{key = 'forceDisableOrtalab', default_value = false, exclude_from_ui = true},
		{key = 'forceEnableOrtalab', default_value = false, exclude_from_ui = true},
	})
else
	ArrowAPI.config_tools.use_default_config(Cardsauce, {
		{key = 'enable_VinnyContent', before_auto = true, default_value = true},
		{key = 'enable_JoelContent', before_auto = true, default_value = true},
		{key = 'enable_Logo', default_value = true},
		{key = 'enable_EasterEggs', default_value = true},
		{key = 'muteWega', default_value = false, exclude_from_ui = true},
		{key = 'forceDisableOrtalab', default_value = false, exclude_from_ui = true},
		{key = 'forceEnableOrtalab', default_value = false, exclude_from_ui = true},
		{key = 'loaded_packs', default_value = {
			[1] = 'sp_csau_cardsauce',
			[2] = "sp_balatro",
			replace_map = {}
		}, exclude_from_ui = true},
	})
end


ArrowAPI.config_tools.add_default_palette(ArrowAPI, 'Spectral', {
	{51,65,89,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="61-68-96"},
	{171,94,105,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="106-101-81"},
	{81,110,146,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="78-87-121"},
	{79,99,103,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="79-99-103"},
	{132,140,174,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="92-120-125"},
	{251,113,131,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="139-131-97"},
	{249,136,153,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="167-156-103"},
	{245,169,184,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="199-178-74"},
	{248,196,203,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="232-214-127"},
	{93,141,181,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="94-114-151"},
	{86,136,168,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="82-100-162"},
	{91,166,221,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="91-127-193"},
	{89,135,187,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="114-151-217"},
	{94,181,240,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="99-143-225"},
	{91,206,250,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="122-164-242"},
	{250,222,227,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="225-235-133"},
	{250,219,223,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="239-241-156"},
	{252,190,198,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="192-223-174"},
	{251,177,188,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="207-229-185"},
	{150,170,203,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="150-170-203"},
	{156,209,235,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="137-198-234"},
	{191,204,227,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="191-204-227"},
	{156,219,249,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="144-226-249"},
	{198,233,244,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="169-226-242"},
	{226,235,249,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="226-235-249"},
	{239,250,254,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="239-250-254"},
	{255,84,104,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="255-84-104"},
	{170,64,92,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="170-64-92"},
	{255,255,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="255-255-255"},
	{69,132,250,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="badge"},
	["name"] = "Spectrans",
}, true)

ArrowAPI.config_tools.add_default_palette(ArrowAPI, 'Hearts', {
	{174,27,79,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="174-27-67"},
	{204,68,75,244,88,120,["grad_pos"]={0,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["overrides"]={},["key"]="240-52-100"},
	{244,88,120,204,68,75,["grad_pos"]={0,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["overrides"]={},["key"]="255-99-136"},
	{251,166,178,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="253-160-182"},
	{252,191,200 ,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="253-189-207"},
	{253,213,218,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="253-211-223"},
	{255,163,0,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="255-163-0"},
	{0,156,253,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="0-156-253"},
	{55,70,73,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="55-70-73"},
	{255,255,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="255-255-255"},
	{244,88,120,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="badge"},
	["name"] = "Cardsauce",
}, true)

ArrowAPI.config_tools.add_default_palette(ArrowAPI, 'Diamonds', {
	{38,55,104,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="141-79-29"},
	{60,82,149,60,82,149,67,97,185,67,97,185,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["overrides"]={},["key"]="207-84-27"},
	{46,53,150,46,53,150,83,125,181,83,125,181,["grad_pos"]={0,0.2,0.8,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["overrides"]={},["key"]="240-107-63"},
	{88,127,193,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="246-142-84"},
	{108,148,215,1 ,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="251-165-133"},
	{109,149,219,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="225-179-131"},
	{139,174,233,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="246-207-177"},
	{197,219,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="255-222-194"},
	{46,53,150, 46,53,150, 83,125,181, 83,125,181,["grad_pos"]={0,0.2,0.8,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["overrides"]={},["key"]="255-163-0"},
	{235,71,63,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="0-156-253"},
	{255,163,0,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="240-52-100"},
	{55,70,73,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="55-70-73"},
	{255,255,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="255-255-255"},
	{94,116,180,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="badge"},
	["name"] = "Cardsauce",
}, true)

ArrowAPI.config_tools.add_default_palette(ArrowAPI, 'Clubs', {
	{32,165,128,32,165,128,108,179,125,108,179,125,["grad_pos"]={0,0.2,0.8,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["overrides"]={},["key"]="37-93-89"},
	{56,125,96,56,125,96,54,101,81,54,101,81,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["overrides"]={},["key"]="28-112-106"},
	{77,171,131,77,171,131,70,132,106,70,132,106,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["overrides"]={},["key"]="58-143-135"},
	{99,182,147,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="72-147-141"},
	{143,213,189,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="137-179-180"},
	{186,239,222,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="184-210-212"},
	{83,128,97,83,128,97,106,163,120,106,163,120,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["overrides"]={},["key"]="96-143-155"},
	{127,172,142,127,172,142,154,207,169,154,207,169,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["overrides"]={},["key"]="131-175-187"},
	{159,220,179,159,220,179,185,255,204,185,255,204,["grad_pos"]={0,0.1,0.9,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["overrides"]={},["key"]="207-233-231"},
	{255,181,51,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="255-163-0"},
	{235,71,63 ,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="0-156-253"},
	{32,165,128,32,165,128,108,179,125,108,179,125,["grad_pos"]={0,0.2,0.8,1},["grad_config"]={["mode"]="linear",["val"]=1.571,["pos"]={0,0}},["overrides"]={},["key"]="240-52-100"},
	{55,70,73,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="55-70-73"},
	{255,255,255,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="255-255-255"},
	{32,165,128,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="badge"},
	["name"] = "Cardsauce",
}, true)

ArrowAPI.config_tools.add_default_palette(ArrowAPI, 'Background', {
	{80,132,110,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="Small"},
	{79,99,103,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="won"},
	{75,194,146,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="SHOWDOWN_COL_1"},
	{136,103,165,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="SHOWDOWN_COL_2"},
	["name"]="Cardsauce"
}, true)

ArrowAPI.config_tools.add_default_palette(ArrowAPI, 'Background', {
	{58,102,88,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="Small"},
	{79,99,103,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="won"},
	{44,153,127,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="SHOWDOWN_COL_1"},
	{9,39,29,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="SHOWDOWN_COL_2"},
	["name"]="Darkshroom"
})

ArrowAPI.config_tools.add_default_palette(ArrowAPI, 'Background', {
	{58,102,76,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="Small"},
	{79,99,103,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="won"},
	{96,178,131,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="SHOWDOWN_COL_1"},
	{163,200,111,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="SHOWDOWN_COL_2"},
	["name"]="Vineshroom"
})

ArrowAPI.config_tools.add_default_palette(ArrowAPI, 'Background', {
	{58,75,102,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="Small"},
	{79,99,103,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="won"},
	{84,123,184,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="SHOWDOWN_COL_1"},
	{103,184,116,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="SHOWDOWN_COL_2"},
	["name"]="Fullsauce"
})

ArrowAPI.config_tools.add_default_palette(ArrowAPI, 'Background', {
	{112,75,75,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="Small"},
	{79,99,103,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="won"},
	{226,101,101,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="SHOWDOWN_COL_1"},
	{165,59,56,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="SHOWDOWN_COL_2"},
	["name"]="Extrasauce"
})

ArrowAPI.config_tools.add_default_palette(ArrowAPI, 'Background', {
	{201,84,120,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="Small"},
	{79,99,103,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="won"},
	{153,103,167,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="SHOWDOWN_COL_1"},
	{72,48,98,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="SHOWDOWN_COL_2"},
	["name"]="Twitch"
})

ArrowAPI.config_tools.add_default_palette(ArrowAPI, 'Background', {
	{68,97,56,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="Small"},
	{79,99,103,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="won"},
	{181,230,29,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="SHOWDOWN_COL_1"},
	{4,161,229,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="SHOWDOWN_COL_2"},
	["name"]="Fren"
})

ArrowAPI.config_tools.add_default_palette(ArrowAPI, 'Background', {
	{101,84,120,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="Small"},
	{79,99,103,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="won"},
	{136,103,165,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="SHOWDOWN_COL_1"},
	{255,255,0,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="SHOWDOWN_COL_2"},
	["name"]="Jabroni"
})

ArrowAPI.config_tools.add_default_palette(ArrowAPI, 'Background', {
	{64,64,64,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="Small"},
	{79,99,103,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="won"},
	{191,199,213,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="SHOWDOWN_COL_1"},
	{55,66,68,1,["grad_pos"]={0},["grad_config"]={["mode"]="linear",["val"]=0,["pos"]={0,0}},["overrides"]={},["key"]="SHOWDOWN_COL_2"},
	["name"]="Uzumaki"
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

if not JojobalMod then
	SMODS.load_file("modules/jojobal/main.lua")()
end

