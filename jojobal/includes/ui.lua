-- Mod Icon in Mods tab
SMODS.Atlas({
	key = "modicon",
	path = "stand_icon.png",
	px = 32,
	py = 32
})

if JojobalMod.current_config['enable_Title'] then
	-- Title Screen Logo Texture
	SMODS.Atlas {
		key = 'balatro',
		path = 'jojobal_title_alt.png',
		px = 489,
		py = 216,
		prefix_config = { key = false }
	}
end

JojobalMod.config_tab = function()
	local ordered_config = {
		'enable_Stands',
		'enable_Jokers',
		'enable_Decks',
		'enable_Consumables',
		'enable_Vouchers',
		'enable_Tags',
		'enable_Title',
	}
	local left_settings = { n = G.UIT.C, config = { align = "tm" }, nodes = {} }
	local right_settings = { n = G.UIT.C, config = { align = "tm" }, nodes = {} }
	local left_count = 0
	local right_count = 0

	for i, k in ipairs(ordered_config) do
		if right_count < left_count then
			local main_node = create_toggle({
				label = localize("jojobal_options_"..ordered_config[i]),
				w = 1,
				ref_table = JojobalMod.config,
				ref_value = ordered_config[i],
				callback = G.FUNCS.jojobal_restart
			})
			main_node.config.align = 'tr'
			main_node.nodes[#main_node.nodes+1] = { n = G.UIT.C, config = { minw = 0.25, align = "cm" } }
			right_settings.nodes[#right_settings.nodes + 1] = main_node
			right_count = right_count + 1
		else
			local main_node = create_toggle({
				label = localize("jojobal_options_"..ordered_config[i]),
				w = 1,
				ref_table = JojobalMod.config,
				ref_value = ordered_config[i],
				callback = G.FUNCS.jojobal_restart
			})
			main_node.config.align = 'tr'
			main_node.nodes[#main_node.nodes+1] = { n = G.UIT.C, config = { minw = 0.25, align = "cm" } }
			left_settings.nodes[#left_settings.nodes + 1]  = main_node
			left_count = left_count + 1
		end
	end

	local jojobal_config_ui = { n = G.UIT.R, config = { align = "tm", padding = 0.25 }, nodes = { left_settings, right_settings } }
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
			jojobal_config_ui
		}
	}
end