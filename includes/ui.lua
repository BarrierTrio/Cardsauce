-- Mod Icon in Mods tab
SMODS.Atlas({
	key = "modicon",
	path = "csau_icon.png",
	px = 32,
	py = 32
})

-- TODO: add automated config tab creation and settings updating
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

-- TODO: figure out how to do multiple title replacements with atlas declarations
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

-- TODO: move title screen card replacement to arrow API functions





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

-- TODO: use new arrow credits system
