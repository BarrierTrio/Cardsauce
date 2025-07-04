-- Mod Icon in Mods tab
SMODS.Atlas({
	key = "modicon",
	path = "csau_icon.png",
	px = 32,
	py = 32
})

-- this inner check for config was originally a local function
-- but it was only used here, so I combined them ~Winter
function G.FUNCS.csau_restart()
	local settingsMatch = true
	for k, v in pairs(csau_enabled) do
		if v ~= csau_config[k] then
			settingsMatch = false
		end
	end

	if settingsMatch then
		send("SETTINGS MATCH :)")
		SMODS.full_restart = 0
	else
		send("SETTINGS DONT MATCH!")
		SMODS.full_restart = 1
	end
end





---------------------------
--------------------------- Title Screen Easter eggs
---------------------------

if csau_enabled['enableLogo'] then
	-- Title Screen Logo Texture
	local logo = "Logo.png"
	if G.chadnova and csau_enabled['enableEasterEggs'] then
		logo = "Logo-C.png"
	end
	SMODS.Atlas {
		key = "balatro",
		path = logo,
		px = 333,
		py = 216,
		prefix_config = { key = false }
	}
end


if csau_enabled['enableEasterEggs'] then
	G.chadnova = externalPseudorandom(1, 1000)

    SMODS.Atlas({
		key = "jimbo_shot",
		atlas_table = "ASSET_ATLAS",
		path = "jimbo_shot.png",
		px = 71,
		py = 95
	})

	SMODS.Sound({
		key = "gunshot",
		path = "gunshot.ogg",
		pitch = 1,
		volume = 0.7
	})
	local initref = Card_Character.init
	function Card_Character:init(args)
		initref(self, args)
		self.children.card.click = Card.gunshot_func
	end
end

if G.chadnova then
	G.TITLE_SCREEN_CARD = 'j_csau_chad'
else
	G.TITLE_SCREEN_CARD = G.P_CARDS.C_A
end

G.FUNCS.center_splash_screen_card = function(SC_scale)
	if G.chadnova then
		return Card(G.ROOM.T.w/2 - SC_scale*G.CARD_W/2, 10. + G.ROOM.T.h/2 - SC_scale*G.CARD_H/2, SC_scale*G.CARD_W, SC_scale*G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[G.TITLE_SCREEN_CARD])
	else
		return Card(G.ROOM.T.w/2 - SC_scale*G.CARD_W/2, 10. + G.ROOM.T.h/2 - SC_scale*G.CARD_H/2, SC_scale*G.CARD_W, SC_scale*G.CARD_H, G.P_CARDS.empty, G.P_CENTERS['j_joker'])
	end
end

G.FUNCS.splash_screen_card = function(card_pos, card_size)
	if G.chadnova then
		return Card(  card_pos.x + G.ROOM.T.w/2 - G.CARD_W*card_size/2,
				card_pos.y + G.ROOM.T.h/2 - G.CARD_H*card_size/2,
				card_size*G.CARD_W, card_size*G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[G.TITLE_SCREEN_CARD])
	else
		return Card(  card_pos.x + G.ROOM.T.w/2 - G.CARD_W*card_size/2,
				card_pos.y + G.ROOM.T.h/2 - G.CARD_H*card_size/2,
				card_size*G.CARD_W, card_size*G.CARD_H, pseudorandom_element(G.P_CARDS), G.P_CENTERS.c_base)
	end
end

G.FUNCS.title_screen_card = function(self, SC_scale)
	if G.chadnova then
		if type(G.TITLE_SCREEN_CARD) == "table" then
			return Card(self.title_top.T.x, self.title_top.T.y, 1.2*G.CARD_W*SC_scale, 1.2*G.CARD_H*SC_scale, G.TITLE_SCREEN_CARD, G.P_CENTERS.c_base)
		elseif type(G.TITLE_SCREEN_CARD) == "string" then
			return  Card(self.title_top.T.x, self.title_top.T.y, 1.2*G.CARD_W*SC_scale, 1.2*G.CARD_H*SC_scale, G.P_CARDS.empty, G.P_CENTERS[G.TITLE_SCREEN_CARD])
		else
			return Card(self.title_top.T.x, self.title_top.T.y, 1.2*G.CARD_W*SC_scale, 1.2*G.CARD_H*SC_scale, G.P_CARDS.C_A, G.P_CENTERS.c_base)
		end
	elseif csau_enabled['enableLogo'] then
		return Card(self.title_top.T.x, self.title_top.T.y, 1.2*G.CARD_W*SC_scale, 1.2*G.CARD_H*SC_scale, G.P_CARDS.C_A, G.P_CENTERS.c_base)
	else
		return Card(self.title_top.T.x, self.title_top.T.y, 1.2*G.CARD_W*SC_scale, 1.2*G.CARD_H*SC_scale, G.P_CARDS.S_A, G.P_CENTERS.c_base)
	end
end





---------------------------
--------------------------- SMODS Tabs
---------------------------

-- this function was originally stored in a local function first
-- couldn't figure why, so I directly assigned it instead ~Winter
local text_scale = 0.9
SMODS.current_mod.extra_tabs = function() 
    return {
	{
		label = localize("b_options"),
		chosen = true,
		tab_definition_function = function()
			local csau_opts = { n = G.UIT.C, config = { align = "tm", padding = 0.05 }, nodes = {
				{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
					{n=G.UIT.T, config={text = localize("b_options"), scale = text_scale*0.9, colour = G.C.GREEN, shadow = true}},
				}},
				--[[{n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
					{n=G.UIT.T, config={text = localize("vs_options_sub"), scale = text_scale*0.5, colour = G.C.GREEN, shadow = true}},
				}},]]--
			}}
			if localize("vs_options_muteWega") then
				csau_opts.nodes[#csau_opts.nodes+1] = {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
					{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
						create_toggle({n=G.UIT.T, label = localize("vs_options_muteWega"), ref_table = csau_config, ref_value = 'muteWega' })
					}},
					{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
						{n=G.UIT.T, config={text = localize("vs_options_muteWega_desc"), scale = text_scale*0.35, colour = G.C.JOKER_GREY, shadow = true}}
					}},
				}}
			end
			if localize("vs_options_detailedDescs") then
				csau_opts.nodes[#csau_opts.nodes+1] = {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
					{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
						create_toggle({n=G.UIT.T, label = localize("vs_options_detailedDescs"), ref_table = csau_config, ref_value = 'detailedDescs' })
					}},
					{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
						{n=G.UIT.T, config={text = localize("vs_options_detailedDescs_desc"), scale = text_scale*0.35, colour = G.C.JOKER_GREY, shadow = true}}
					}},
				}}
			end
			if localize("vs_options_resetAchievements_r") then
				csau_opts.nodes[#csau_opts.nodes+1] = {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
					{n=G.UIT.R, config={align = "cm", minw = 0.5, maxw = 2, minh = 0.6, padding = 0, r = 0.1, hover = true, colour = G.C.RED, button = "reset_trophies", shadow = true, focus_args = {nav = 'wide'}}, nodes={
						{n=G.UIT.T, config={text = localize("vs_options_resetAchievements_r"), scale = text_scale*0.55, colour = G.C.UI.TEXT_LIGHT}}
					}},
					{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
						{n=G.UIT.T, config={text = localize("vs_options_resetAchievements_desc"), scale = text_scale*0.35, colour = G.C.JOKER_GREY, shadow = true}}
					}},
				}}
			end
			csau_opts.nodes[#csau_opts.nodes+1] = {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
				{n=G.UIT.T, config={id = 'warn', text = localize('ph_click_confirm'), scale = 0.4, colour = G.C.CLEAR}}
			}}
			return {
				n = G.UIT.ROOT,
				config = {
					emboss = 0.05,
					minh = 6,
					r = 0.1,
					minw = 10,
					align = "cm",
					padding = 0.05,
					colour = G.C.BLACK,
				},
				nodes = {
					csau_opts
				}
			}
		end
	}
} end

local ortalab = false
if SMODS.current_mod.DT.ortalab_dlc then
	ortalab = true
end

SMODS.current_mod.config_tab = function()
	local ordered_config = {
		'enableVinnyContent',
		'enableJoelContent',
		'enableVHSs',
		'enableStands',
		'enableJokers',
		'enableConsumables',
		'enableVouchers',
		'enableBoosters',
		'enableEditions',
		'enableTags',
		'enableBlinds',
		'enableDecks',
		'enableSkins',
		'enableChallenges',
		'enableMusic',
		'enableAchievements',
		'enableLogo',
		'enableColors',
		'enableTarotSkins',
		'enableEasterEggs',
	}
	if ortalab then
		ordered_config[#ordered_config+1] = 'forceDisableOrtalab'
		ordered_config[#ordered_config+1] = 'forceEnableOrtalab'
	end
	local left_settings = { n = G.UIT.C, config = { align = "tm" }, nodes = {} }
	local right_settings = { n = G.UIT.C, config = { align = "tm" }, nodes = {} }
	local left_count = 0
	local right_count = 0

	for i, k in ipairs(ordered_config) do
		if right_count < left_count then
			local main_node = create_toggle({
				label = localize("vs_options_"..ordered_config[i]) ~= 'ERROR' and localize("vs_options_"..ordered_config[i]) or ordered_config[i],
				w = 1,
				ref_table = csau_config,
				ref_value = ordered_config[i],
				callback = G.FUNCS.csau_restart
			})
			main_node.config.align = 'tr'
			main_node.nodes[#main_node.nodes+1] = { n = G.UIT.C, config = { minw = 0.25, align = "cm" } }
			right_settings.nodes[#right_settings.nodes + 1] = main_node
			right_count = right_count + 1
		else
			local main_node = create_toggle({
				label = (localize("vs_options_"..ordered_config[i]) ~= 'ERROR' and localize("vs_options_"..ordered_config[i])) or ordered_config[i],
				w = 1,
				ref_table = csau_config,
				ref_value = ordered_config[i],
				callback = G.FUNCS.csau_restart
			})
			main_node.config.align = 'tr'
			main_node.nodes[#main_node.nodes+1] = { n = G.UIT.C, config = { minw = 0.25, align = "cm" } }
			left_settings.nodes[#left_settings.nodes + 1]  = main_node
			left_count = left_count + 1
		end
	end

	local csau_config_ui = { n = G.UIT.R, config = { align = "tm", padding = 0.25 }, nodes = { left_settings, right_settings } }
	return {
		n = G.UIT.ROOT,
		config = {
			emboss = 0.05,
			minh = 6,
			r = 0.1,
			minw = 10,
			align = "cm",
			padding = 0.05,
			colour = G.C.BLACK,
		},
		nodes = {
			csau_config_ui
		}
	}
end

local header_scale = 1.1
local bonus_padding = 1.15
local support_padding = 0.015
local artist_size = 0.3675
local seperator_mod = 1
local first_column_text_mod = 1.15
local special_thanks_mod = 1
local special_thanks_padding = 0
local artist_padding = 0.015
local coding_scale = 0.90
local logo_scale = 0.9
local shader_scale = 0.9
local logo_shader_padding_mod = 1.5
text_scale = 0.98

SMODS.current_mod.credits_tab = function()
	chosen = true
	return {n=G.UIT.ROOT, config={align = "cm", padding = 0.2, colour = G.C.BLACK, r = 0.1, emboss = 0.05, minh = 6, minw = 10}, nodes={
		{n = G.UIT.C, config = { align = "tm", padding = 0.2 }, nodes = {
			{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
				{n=G.UIT.T, config={text = localize("b_credits"), scale = text_scale*1.2, colour = G.C.GREEN, shadow = true}},
			}},
			{n=G.UIT.R, config={align = "cm", padding = 0.05,outline_colour = G.C.GREEN, r = 0.1, outline = 1}, nodes= {
				{n=G.UIT.C, config={align = "tm", padding = 0.1, r = 0.1}, nodes={
					{n=G.UIT.C, config={align = "tm", padding = 0}, nodes={
						{n=G.UIT.R, config={align = "tm", padding = 0.1,outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
							{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
								{n=G.UIT.T, config={text = localize('vs_credits1'), scale = header_scale * 0.6, colour = G.C.GOLD, shadow = true}},
							}},
							{n=G.UIT.R, config={align = "cm", padding = 0}, nodes= {
								{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = G.csau_team.gote, scale = text_scale*0.55*first_column_text_mod, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = G.csau_team.keku, scale = text_scale*0.55*first_column_text_mod, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = G.csau_team.winterc, scale = text_scale*0.55*first_column_text_mod, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
							}},
						}},
						{n=G.UIT.R, config={align = "tm", padding = 0,outline_colour = G.C.CLEAR, r = 0.1, outline = 1}, nodes={
							{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
								{n=G.UIT.T, config={text = "SEPARATOR LMAO", scale = (text_scale*0.4)*seperator_mod, colour = G.C.CLEAR, shadow = true}},
							}},
						}},
						{n=G.UIT.R, config={align = "tm", padding = 0.1,outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
							{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
								{n=G.UIT.T, config={text = localize('vs_credits7'), scale = header_scale * 0.6, colour = G.C.RED, shadow = true}},
							}},
							{n=G.UIT.R, config={align = "cm", padding = 0}, nodes= {
								{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = G.csau_team.bass, scale = text_scale*0.55*first_column_text_mod, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = G.csau_team.extra.bass, scale = text_scale*0.45*first_column_text_mod, colour = G.C.JOKER_GREY, shadow = true}},
								}},
								{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = "SEPARATOR LMAO", scale = text_scale*0.05, colour = G.C.CLEAR, shadow = true}},
								}},
							}},
						}},
						{n=G.UIT.R, config={align = "tm", padding = 0,outline_colour = G.C.CLEAR, r = 0.1, outline = 1}, nodes={
							{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
								{n=G.UIT.T, config={text = "SEPARATOR LMAO", scale = (text_scale*0.4)*seperator_mod, colour = G.C.CLEAR, shadow = true}},
							}},
						}},
						{n=G.UIT.R, config={align = "tm", padding = 0.1,outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
							{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
								{n=G.UIT.T, config={text = G.SETTINGS.roche and localize('vs_credits4') or "?????", scale = header_scale * 0.6, colour = G.C.BLUE, shadow = true}},
							}},
							{n=G.UIT.R, config={align = "cm", padding = 0}, nodes= {
								{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = G.SETTINGS.roche and G.csau_team.amtrax or "?????", scale = text_scale*0.55*first_column_text_mod, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = G.SETTINGS.roche and G.csau_team.extra.amtrax or "?????", scale = text_scale*0.45*first_column_text_mod, colour = G.C.JOKER_GREY, shadow = true}},
								}},
							}},
						}},
					}},
				}},
				{n=G.UIT.C, config={align = "tm", padding = 0.1, r = 0.1}, nodes= {
					{ n = G.UIT.C, config = { align = "tm", padding = 0.1 * bonus_padding, minh = 6.140, outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1 }, nodes = {
						{ n = G.UIT.R, config = { align = "cm", padding = 0 }, nodes = {
							{ n = G.UIT.T, config = { text = localize('vs_credits2'), scale = header_scale * 0.6, colour = HEX('f75294'), shadow = true } },
						} },
						{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
							{n=G.UIT.C, config={align = "tl", padding = 0}, nodes={
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.gote, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.cejai, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.keku, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.gappie, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.winterg, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.fenix, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.cherry, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.trance, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.lyzerus, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.bard, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.guff, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.jen, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.sine, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.frada, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.greg, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.cheesy, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
							}},
							{n=G.UIT.C, config={align = "tl", padding = 0}, nodes={
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.akai, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.alli, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.swizik, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.burd, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.crispy, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.lyman, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.alizarin, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.moon, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.yunkie, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.wario, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.plunch, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.rerun, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.cauthen, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.burlap, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.chvsau, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.dolos, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
							}},
							{n=G.UIT.C, config={align = "tl", padding = 0}, nodes={
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.joey, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.kuro, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.donk, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.greeky, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.gong, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.zeurel, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.eld, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.retro, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.mary, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.ele, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.lwb, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.creachure, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.yumz, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.stup, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = artist_padding }, nodes = {
									{ n = G.UIT.T, config = { text = G.csau_team.reda, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
							}}
						}},
					} },
				}},
				{n=G.UIT.C, config={align = "tm", padding = 0.1, r = 0.1}, nodes= {
					{ n = G.UIT.C, config = { align = "tm", padding = 0, r = 0.1, }, nodes = {
						{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
							{n=G.UIT.C, config={align = "tl", padding = 0}, nodes={
								{n=G.UIT.R, config={align = "tm", padding = 0.1, minh=1.85, outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
									{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = localize('vs_credits9'), scale = header_scale * 0.6, colour = G.C.PURPLE, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "cm", padding = 0}, nodes= {
										{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
											{n=G.UIT.T, config={text = G.csau_team.alizarin, scale = text_scale*0.675*logo_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
										}},
										{n=G.UIT.R, config={align = "tm", padding = support_padding}, nodes={
											{n=G.UIT.T, config={text = G.csau_team.extra.alizarin, scale = text_scale*0.475*logo_scale, colour = G.C.JOKER_GREY, shadow = true}},
										}},
									}},
								}},
								{n=G.UIT.R, config={align = "tm", padding = 0 ,outline_colour = G.C.CLEAR, r = 0.1, outline = 1}, nodes={
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = "SEPARATOR LMAO", scale = (text_scale*0.3), colour = G.C.CLEAR, shadow = true}},
									}},
								}},
								{n=G.UIT.R, config={align = "tm", padding = 0.1, minh=1.85, outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
									{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = localize('vs_credits8'), scale = header_scale * 0.515, colour = G.C.DARK_EDITION, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "cm", padding = support_padding}, nodes= {
										{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
											{n=G.UIT.T, config={text = G.csau_team.gameboy, scale = text_scale*0.55*shader_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
										}},
										{n=G.UIT.R, config={align = "tm", padding = support_padding}, nodes={
											{n=G.UIT.T, config={text = G.csau_team.winterc, scale = text_scale*0.55*shader_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
										}},
									}},
								}},
							}},
							{n=G.UIT.C, config={align = "tm", padding = 0,outline_colour = G.C.CLEAR, r = 0.1, outline = 1}, nodes={
								{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = "SEPARATOR LMAO", scale = text_scale*0.3, colour = G.C.CLEAR, vert = true, shadow = true}},
								}},
							}},
							{n=G.UIT.C, config={align = "tl", padding = 0.1*bonus_padding,outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
								{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = localize('vs_credits3'), scale = header_scale*0.6, colour = G.C.ORANGE, shadow = true}},
								}},
								{n=G.UIT.R, config={align = "cm", padding = 0}, nodes= {
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = G.csau_team.gote, scale = text_scale*0.44*coding_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = G.csau_team.dps, scale = text_scale*0.45*coding_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = G.csau_team.nether, scale = text_scale*0.45*coding_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = G.csau_team.myst, scale = text_scale*0.45*coding_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = G.csau_team.numbuh, scale = text_scale*0.45*coding_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = G.csau_team.aure, scale = text_scale*0.45*coding_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = G.csau_team.keku, scale = text_scale*0.45*coding_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = G.csau_team.winterc, scale = text_scale*0.45*coding_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = G.csau_team.eremel, scale = text_scale*0.45*coding_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
								}},
							}},
						}},
						{n=G.UIT.R, config={align = "tm", padding = 0,outline_colour = G.C.CLEAR, r = 0.1, outline = 1}, nodes={
							{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
								{n=G.UIT.T, config={text = "SEPARATOR LMAO", scale = text_scale*0.3, colour = G.C.CLEAR, shadow = true}},
							}},
						}},
						{n=G.UIT.R, config={align = "tm", padding = 0.1,outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
							{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
								{n=G.UIT.T, config={text = localize('vs_credits6'), scale = header_scale*0.55, colour = G.C.GREEN, shadow = true}},
							}},
							{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
								{n=G.UIT.C, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.R, config={align = "tm", padding = special_thanks_padding}, nodes={
										{n=G.UIT.T, config={text = G.csau_team.vinny, scale = text_scale*0.36*special_thanks_mod, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = special_thanks_padding}, nodes={
										{n=G.UIT.T, config={text = G.csau_team.tort, scale = text_scale*0.36*special_thanks_mod, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = special_thanks_padding}, nodes={
										{n=G.UIT.T, config={text = G.csau_team.recon, scale = text_scale*0.36*special_thanks_mod, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = special_thanks_padding}, nodes={
										{n=G.UIT.T, config={text = G.csau_team.aure, scale = text_scale*0.36*special_thanks_mod, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
								}},
								{n=G.UIT.C, config={align = "tm", padding = 0,outline_colour = G.C.CLEAR, r = 0.1, outline = 1}, nodes={
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = "SEPARATOR LMAO", scale = text_scale*0.05, colour = G.C.CLEAR, shadow = true}},
									}},
								}},
								{n=G.UIT.C, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.R, config={align = "tm", padding = special_thanks_padding}, nodes={
										{n=G.UIT.T, config={text = G.csau_team.joel, scale = text_scale*0.36*special_thanks_mod, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = special_thanks_padding}, nodes={
										{n=G.UIT.T, config={text = G.csau_team.proto, scale = text_scale*0.36*special_thanks_mod, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = special_thanks_padding}, nodes={
										{n=G.UIT.T, config={text = G.csau_team.cyro, scale = text_scale*0.36*special_thanks_mod, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = special_thanks_padding}, nodes={
										{n=G.UIT.T, config={text = G.csau_team.victin, scale = text_scale*0.36*special_thanks_mod, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
								}},
								{n=G.UIT.C, config={align = "tm", padding = 0,outline_colour = G.C.CLEAR, r = 0.1, outline = 1}, nodes={
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = "SEPARATOR LMAO", scale = text_scale*0.05, colour = G.C.CLEAR, shadow = true}},
									}},
								}},
								{n=G.UIT.C, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.R, config={align = "tm", padding = special_thanks_padding}, nodes={
										{n=G.UIT.T, config={text = G.csau_team.mike, scale = text_scale*0.36*special_thanks_mod, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = special_thanks_padding}, nodes={
										{n=G.UIT.T, config={text = G.csau_team.shrine, scale = text_scale*0.36*special_thanks_mod, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = special_thanks_padding}, nodes={
										{n=G.UIT.T, config={text = G.csau_team.sin, scale = text_scale*0.36*special_thanks_mod, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = special_thanks_padding}, nodes={
										{n=G.UIT.T, config={text = G.csau_team.voyager, scale = text_scale*0.36*special_thanks_mod, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
								}}
							}},
						}},
					}},
				}},
			}}
		}}
	}}
end
