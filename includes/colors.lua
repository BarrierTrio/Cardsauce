-- TODO: move all color customization to arrow
if not csau_enabled['enableColors'] then
	return
end

---------------------------
--------------------------- Default value setups
---------------------------

if not G.SETTINGS.csau_color_selection then
	G.SETTINGS.csau_color_selection = "default_csau"
end

if not G.SETTINGS.CS_COLOR1 then
	G.SETTINGS.CS_COLOR1 = G.C.GREEN
end
if not G.SETTINGS.CS_COLOR2 then
	G.SETTINGS.CS_COLOR2 = G.C.PURPLE
end

G.C.COLOUR1 = G.SETTINGS.CS_COLOR1 or G.C.RED
G.C.COLOUR2 = G.SETTINGS.CS_COLOR2 or G.C.BLUE
G.C.BLIND.Small = G.SETTINGS.CS_COLOR3 or HEX('50846e')
G.C.BLIND.Big = G.SETTINGS.CS_COLOR3 or HEX('50846e')
G.C.BLIND.won = G.SETTINGS.CS_COLOR4 or HEX('50846e')
G.CUSTOMHEX1 = ""
G.CUSTOMHEX2 = ""
G.CUSTOMHEX3 = ""
G.CUSTOMHEX4 = ""

local function get_matching_color(name)
	for i, v in ipairs(G.color_presets) do
		if type(v[1]) == "string" then
			if name == v[1] then
				return G.C[name]
			end
		elseif type(v[1]) == "table" then
			if name == v[1][2] then
				return HEX(v[1][1])
			end
		end
		if type(v[2]) == "string" then
			if name == v[2] then
				return G.C[name]
			end
		elseif type(v[2]) == "table" then
			if name == v[2][2] then
				return HEX(v[2][1])
			end
		end
	end
end

function csau_save_color(colour, val)
	local color = get_matching_color(val)
	local set = 'CS_COLOR'..colour
	G.SETTINGS[set] = color
	G:save_settings()
end

local colors = {}
for _, preset in ipairs(G.color_presets) do
	if preset[#preset] ~= "customhex" then
		for i = 1, #preset - 1 do
			if type(preset[i]) == "string" then
				colors[preset[i]] = true
			elseif type(preset[i]) == "table" then
				colors[preset[i][2]] = true
			end
		end
	end
end

local function isRed(color)
	if type(color) ~= "table" or #color < 3 then
		return false, "Invalid color table"
	end
	local r, g, b = color[1], color[2], color[3]
	return r > g and r > b and r > 0.5
end

local function isBlack(color)
	if type(color) ~= "table" or #color < 3 then
		return false, "Invalid color table"
	end
	local r, g, b = color[1], color[2], color[3]
	local tolerance = 0.2
	local darkness_threshold = 0.3
	local is_grayish = math.abs(r - g) <= tolerance and math.abs(g - b) <= tolerance and math.abs(r - b) <= tolerance
	local is_dark = r <= darkness_threshold and g <= darkness_threshold and b <= darkness_threshold
	return is_grayish and is_dark
end

local function renoColors(color1, color2)
	local red = false
	local black = false
	if isRed(G.C.COLOUR1) and not isBlack(G.C.COLOUR1) then
		red = true
	elseif isBlack(G.C.COLOUR1) and not isRed(G.C.COLOUR1) then
		black = true
	end
	if isRed(G.C.COLOUR2) and not isBlack(G.C.COLOUR2) then
		if red == true then
			return false
		end
		red = true
	elseif isBlack(G.C.COLOUR2) and not isRed(G.C.COLOUR2) then
		if black == true then
			return false
		end
		black = true
	end
	return red and black
end

local function ach_reno_check()
	if renoColors(G.C.COLOUR1, G.C.COLOUR2) then
		check_for_unlock({ type = "reno_colors" })
	end
end

local function isShowdown()
	if G.GAME then
		local blindname = ((G.GAME.blind and G.GAME.blind.name ~= '' and G.GAME.blind.name)) or 'Small Blind'
		local blindname = (blindname == '' and 'Small Blind' or blindname)
		for k, v in pairs(G.P_BLINDS) do
			if v.name == blindname then
				if v.boss and v.boss.showdown then
					return true
				end
			end
		end
	end
	return false
end

for color, _ in pairs(colors) do
	G.FUNCS["change_color_1_" .. color] = function()
		G.C.COLOUR1 = G.C[color]
		csau_save_color(1, color)
		ach_reno_check()
		if isShowdown() then
			ease_background_colour{new_colour = G.C.COLOUR2, special_colour = G.C.COLOUR1, tertiary_colour = darken(G.C.BLACK, 0.4), contrast = 3}
		end
	end

	G.FUNCS["change_color_2_" .. color] = function()
		G.C.COLOUR2 = G.C[color]
		csau_save_color(2, color)
		ach_reno_check()
		if isShowdown() then
			ease_background_colour{new_colour = G.C.COLOUR2, special_colour = G.C.COLOUR1, tertiary_colour = darken(G.C.BLACK, 0.4), contrast = 3}
		end
	end

	G.FUNCS["change_color_3_" .. color] = function()
		G.C.BLIND.Small = G.C[color]
		G.C.BLIND.Big = G.C[color]
		if G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante < 9 then
			ease_background_colour{new_colour = G.C[color], contrast = 1}
		end
		csau_save_color(3, color)
	end

	G.FUNCS["change_color_4_" .. color] = function()
		G.C.BLIND.won = G.C[color]
		if G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante >= 9 then
			ease_background_colour{new_colour = G.C[color], contrast = 1}
		end
		csau_save_color(3, color)
	end
end

for i=1, 4 do
	G.FUNCS["paste_hex_"..i] = function(e)
		G.CONTROLLER.text_input_hook = e.UIBox:get_UIE_by_ID('hex_set_'..i).children[1].children[1]
		G.CONTROLLER.text_input_id = 'hex_set_'..i
		for i = 1, 6 do
			G.FUNCS.text_input_key({key = 'right'})
		end
		for i = 1, 6 do
			G.FUNCS.text_input_key({key = 'backspace'})
		end
		local clipboard = (G.F_LOCAL_CLIPBOARD and G.CLIPBOARD or love.system.getClipboardText()) or ''
		for i = 1, #clipboard do
			local c = clipboard:sub(i,i)
			if c ~= "#" then
				G.FUNCS.text_input_key({key = c})
			end
		end
		G.FUNCS.text_input_key({key = 'return'})
	end
end

function validHEX(str)
	local hex = str:match("^#?(%x%x%x%x%x%x)$") or str:match("^#?(%x%x%x)$")
	return hex ~= nil
end

local function replaceReplacedChars(str)
	return str:gsub("[Oo]", "0")
end

G.FUNCS.apply_colors = function()
	for i=1, 4 do
		if G["CUSTOMHEX"..i] then
			local hex = replaceReplacedChars(G["CUSTOMHEX"..i])
			if validHEX(hex) then
				if i== 4 then
					G.C.BLIND.won = HEX(hex)
					if G.GAME and G.GAME.round_resets.ante >= 9 then
						ease_background_colour{new_colour = HEX(hex), contrast = 1}
					end
					G:save_settings()
				end
				if i==3 then
					G.C.BLIND.Small = HEX(hex)
					G.C.BLIND.Big = HEX(hex)
					if G.GAME then
						if G.GAME.round_resets.ante < 9 then
							ease_background_colour{new_colour = HEX(hex), contrast = 1}
						end
					end
					G.SETTINGS["CS_COLOR"..i] = HEX(hex)
					G:save_settings()
				elseif i == 1 or i == 2 then
					G.C["COLOUR"..i] = HEX(hex)
					G.SETTINGS["CS_COLOR"..i] = HEX(hex)
					G:save_settings()
					if isShowdown() then
						ease_background_colour{new_colour = G.C.COLOUR2, special_colour = G.C.COLOUR1, tertiary_colour = darken(G.C.BLACK, 0.4), contrast = 3}
					end
				end
			end
		end
	end
	ach_reno_check()
end

local ebcb_ref = ease_background_colour_blind
function ease_background_colour_blind(state, blind_override)
	local blindname = ((blind_override or (G.GAME.blind and G.GAME.blind.name ~= '' and G.GAME.blind.name)) or 'Small Blind')
	local blindname = (blindname == '' and 'Small Blind' or blindname)
	for k, v in pairs(G.P_BLINDS) do
		if v.name == blindname then
			if v.boss and v.boss.showdown then
				if G.GAME.blind then
					G.GAME.blind:change_colour()
				end
				ease_background_colour{new_colour = G.C.COLOUR2, special_colour = G.C.COLOUR1, tertiary_colour = darken(G.C.BLACK, 0.4), contrast = 3}
				return
			end
		end
	end
	ebcb_ref(state, blind_override)
end


G.FUNCS.change_color_buttons = function()
	if G.OVERLAY_MENU then
		local swap_node = G.OVERLAY_MENU:get_UIE_by_ID('color_buttons')
		local focused_color_preset = G.SETTINGS.QUEUED_CHANGE.color_change
		local color = {}
		local key
		for _, v in ipairs(G.color_presets) do
			if v[#v] == focused_color_preset then
				key = v[#v]
				if v[#v] ~= "customhex" then
					for i=1, #v - 1 do
						color[i] = v[i][2] or v[i]
					end
				end
			end
		end
		if swap_node then
			for i=1, #swap_node.children do
				swap_node.children[i]:remove()
				swap_node.children[i] = nil
			end

			local new_color_buttons = {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={}}
			new_color_buttons.nodes[#new_color_buttons.nodes + 1] = {n=G.UIT.T, config={text = localize('b_color_selector_outer'), scale = 0.35, colour = G.C.WHITE, shadow = true}}
			if key == "customhex" then
				new_color_buttons.nodes[#new_color_buttons.nodes + 1] = create_text_input({id = 'hex_set_1', h = 0.05, w = 2, text_scale = 0.35, ref_table = G, ref_value = 'CUSTOMHEX1', max_length = 6, prompt_text = localize('b_color_selector_hex'), extended_corpus = true, config = { align = "cm" }})
				new_color_buttons.nodes[#new_color_buttons.nodes + 1] = {n = G.UIT.C, config = {padding = 0.2,align = "cm", }, nodes = {
					UIBox_button({minw = 1.25, minh = 0.5, button = "paste_hex_1", colour = G.C.RED, label = localize('b_color_selector_paste_hex'), scale = 0.35})
				}}
			else
				for i, color in ipairs(color) do
					new_color_buttons.nodes[#new_color_buttons.nodes + 1] = {n = G.UIT.C, config = {padding = 0.2,align = "cm", }, nodes = {
						UIBox_button({minw = 0.5, minh = 0.5, button = "change_color_1_"..color, colour = G.C[color], label = {" "}, scale = 0.35})
					}}
				end
			end
			new_color_buttons.nodes[#new_color_buttons.nodes + 1] = {n=G.UIT.T, config={text = "|", scale = 0.35, colour = G.C.WHITE, shadow = true}}
			if key == "customhex" then
				new_color_buttons.nodes[#new_color_buttons.nodes + 1] = {n = G.UIT.C, config = {padding = 0.2,align = "cm", }, nodes = {
					UIBox_button({minw = 1.25, minh = 0.5, button = "paste_hex_2", colour = G.C.RED, label = localize('b_color_selector_paste_hex'), scale = 0.35})
				}}
				new_color_buttons.nodes[#new_color_buttons.nodes + 1] = create_text_input({id = 'hex_set_2', h = 0.05, w = 2, text_scale = 0.35, ref_table = G, ref_value = 'CUSTOMHEX2', max_length = 6, prompt_text = localize('b_color_selector_hex'), config = { align = "cm" }})
			else
				for i, color in ipairs(color) do
					new_color_buttons.nodes[#new_color_buttons.nodes + 1] = {n = G.UIT.C, config = {padding = 0.2,align = "cm", }, nodes = {
						UIBox_button({minw = 0.5, minh = 0.5, button = "change_color_2_"..color, colour = G.C[color], label = {" "}, scale = 0.35})
					}}
				end
			end
			new_color_buttons.nodes[#new_color_buttons.nodes + 1] = {n=G.UIT.T, config={text = localize('b_color_selector_inner'), scale = 0.35, colour = G.C.WHITE, shadow = true}}
			local new_sub_caption = { n=G.UIT.R, config={ align = "cm", padding = 0}, nodes={ { n=G.UIT.T, config={ text = localize('b_color_selector_game'), scale = 0.35, colour = G.C.WHITE, shadow = true}}}}
			local new_sub_buttons = {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={}}
			if key == "customhex" then
				new_sub_buttons.nodes[#new_sub_buttons.nodes + 1] = create_text_input({id = 'hex_set_3', h = 0.05, w = 2, text_scale = 0.35, ref_table = G, ref_value = 'CUSTOMHEX3', max_length = 6, prompt_text = localize('b_color_selector_hex'), config = { align = "cm" }})
				new_sub_buttons.nodes[#new_sub_buttons.nodes + 1] = {n = G.UIT.C, config = {padding = 0.2, align = "cm", }, nodes = {
					UIBox_button({minw = 1.25, minh = 0.5, button = "paste_hex_3", colour = G.C.RED, label = localize('b_color_selector_paste_hex'), scale = 0.35})
				}}
			else
				for i, color in ipairs(color) do
					new_sub_buttons.nodes[#new_sub_buttons.nodes + 1] = {n = G.UIT.C, config = {padding = 0.2,align = "cm", }, nodes = {
						UIBox_button({minw = 0.5, minh = 0.5, button = "change_color_3_"..color, colour = G.C[color], label = {" "}, scale = 0.35})
					}}
				end
			end
			local new_sub_caption_2 = { n=G.UIT.R, config={ align = "cm", padding = 0}, nodes={ { n=G.UIT.T, config={ text = localize('b_color_selector_game_2'), scale = 0.35, colour = G.C.WHITE, shadow = true}}}}
			local new_sub_buttons_2 = {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={}}
			if key == "customhex" then
				new_sub_buttons_2.nodes[#new_sub_buttons_2.nodes + 1] = create_text_input({id = 'hex_set_4', h = 0.05, w = 2, text_scale = 0.35, ref_table = G, ref_value = 'CUSTOMHEX4', max_length = 6, prompt_text = localize('b_color_selector_hex'), config = { align = "cm" }})
				new_sub_buttons_2.nodes[#new_sub_buttons_2.nodes + 1] = {n = G.UIT.C, config = {padding = 0.2, align = "cm", }, nodes = {
					UIBox_button({minw = 1.25, minh = 0.5, button = "paste_hex_4", colour = G.C.RED, label = localize('b_color_selector_paste_hex'), scale = 0.35})
				}}
			else
				for i, color in ipairs(color) do
					new_sub_buttons_2.nodes[#new_sub_buttons_2.nodes + 1] = {n = G.UIT.C, config = {padding = 0.2,align = "cm", }, nodes = {
						UIBox_button({minw = 0.5, minh = 0.5, button = "change_color_4_"..color, colour = G.C[color], label = {" "}, scale = 0.35})
					}}
				end
			end
			local apply_button = {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={}}
			if key == "customhex" then
				apply_button.nodes[#apply_button.nodes + 1] = {n = G.UIT.C, config = {padding = 0.05,align = "cm", }, nodes = {
					UIBox_button({minw = 2, minh = 0.5, button = "apply_colors", colour = G.C.RED, label = localize('b_color_selector_hex_set'), scale = 0.35})
				}}
			end
			swap_node.UIBox:add_child(new_color_buttons, swap_node)
			swap_node.UIBox:add_child(new_sub_caption, swap_node)
			swap_node.UIBox:add_child(new_sub_buttons, swap_node)
			swap_node.UIBox:add_child(new_sub_caption_2, swap_node)
			swap_node.UIBox:add_child(new_sub_buttons_2, swap_node)
			swap_node.UIBox:add_child(apply_button, swap_node)
		end
	end
end

G.FUNCS.change_color_preset = function(args)
	G.ARGS.color_vals = G.ARGS.color_vals or G.color_presets_strings
	G.SETTINGS.QUEUED_CHANGE.color_change = G.ARGS.color_vals[args.to_key]
	G.SETTINGS.csau_color_selection = G.ARGS.color_vals[args.to_key]
	G.FUNCS.change_color_buttons()
end