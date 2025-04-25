local mod = SMODS.current_mod
local mod_path = SMODS.current_mod.path:match("Mods/[^/]+")..'/'

---------------------------
--------------------------- Loading/Debug Functions
---------------------------

-- Modified code from Cryptid
local function dynamic_badges(info)
	if not SMODS.config.no_mod_badges then
		local function calc_scale_fac(text)
			local size = 0.9
			local font = G.LANG.font
			local max_text_width = 2 - 2 * 0.05 - 4 * 0.03 * size - 2 * 0.03
			local calced_text_width = 0
			-- Math reproduced from DynaText:update_text
			for _, c in utf8.chars(text) do
				local tx = font.FONT:getWidth(c) * (0.33 * size) * G.TILESCALE * font.FONTSCALE
						+ 2.7 * 1 * G.TILESCALE * font.FONTSCALE
				calced_text_width = calced_text_width + tx / (G.TILESIZE * G.TILESCALE)
			end
			local scale_fac = calced_text_width > max_text_width and max_text_width / calced_text_width or 1
			return scale_fac
		end
		local scale_fac = {}
		local min_scale_fac = 1
		local strings = { "Cardsauce" }
		local badge_colour = HEX('32A852')
		local text_colour = G.C.WHITE
		if info.origin then
			if type(info.origin) == 'table' then
				for i, v in ipairs(info.origin) do
					strings[#strings + 1] = localize('ba_'..v)
				end
				badge_colour = HEX(G.csau_badge_colours['co_'..info.origin.color]) or badge_colour
				text_colour = HEX(G.csau_badge_colours['te_'..info.origin.color]) or text_colour
			else
				strings[#strings + 1] = localize('ba_'..info.origin)
				badge_colour = HEX(G.csau_badge_colours['co_'..info.origin]) or badge_colour
				text_colour = HEX(G.csau_badge_colours['te_'..info.origin]) or text_colour
			end
		elseif info.part then
			strings[#strings + 1] = localize('ba_jojo')
			if info.part == "jojo" then
				badge_colour = G.C.STAND
				text_colour = G.C.WHITE
			else
				strings[#strings + 1] = localize('ba_'..info.part)
				badge_colour = HEX(G.csau_badge_colours['co_'..info.part]) or badge_colour
				text_colour = HEX(G.csau_badge_colours['te_'..info.part]) or text_colour
			end
		elseif info.streamer then
			strings[#strings + 1] = localize('ba_'..info.streamer)
			badge_colour = HEX(G.csau_badge_colours['co_'..info.streamer]) or badge_colour
			text_colour = HEX(G.csau_badge_colours['te_'..info.streamer]) or text_colour
		end
		for i = 1, #strings do
			scale_fac[i] = calc_scale_fac(strings[i])
			min_scale_fac = math.min(min_scale_fac, scale_fac[i])
		end
		local ct = {}
		for i = 1, #strings do
			ct[i] = {
				string = strings[i],
			}
		end
		return {
			n = G.UIT.R,
			config = { align = "cm" },
			nodes = {
				{
					n = G.UIT.R,
					config = {
						align = "cm",
						colour = badge_colour,
						r = 0.1,
						minw = 2 / min_scale_fac,
						minh = 0.36,
						emboss = 0.05,
						padding = 0.03 * 0.9,
					},
					nodes = {
						{ n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
						{
							n = G.UIT.O,
							config = {
								object = DynaText({
									string = ct or "ERROR",
									colours = { text_colour },
									silent = true,
									float = true,
									shadow = true,
									offset_y = -0.03,
									spacing = 1,
									scale = 0.33 * 0.9,
								}),
							},
						},
						{ n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
					},
				},
			},
		}
	end
end

function csau_filter_loading(item_type, args)
	item_type = item_type or 'item'
	if item_type == 'item' then
		if args.dependencies then
			for i, key in ipairs(args.dependencies) do
				if not csau_enabled[key] then
					return false
				end
			end
			return true
		elseif args.streamer then
			if ((args.streamer == 'vinny' or args.streamer == 'othervinny') and not csau_enabled['enableVinnyContent'])
			or ((args.streamer == 'joel' or args.streamer == 'otherjoel') and not csau_enabled['enableJoelContent']) then
				return false
			else
				return true
			end
		end
	elseif item_type == 'set' then
		return csau_enabled['enable'..args.key..'s']
	end
end

--- Load an item definition using SMODS
--- @param file_key string file name to load within the "Items" directory, excluding file extension
--- @param item_type string SMODS item type (such as Joker, Consumable, Deck, etc)
--- @param no_badges boolean | nil Whether or not to display mod badges on this item
function load_cardsauce_item(file_key, item_type, no_badges)
	local key = string.lower(item_type)..(item_type == 'VHS' and '' or 's')
	local info = assert(SMODS.load_file("items/" .. key .. "/" .. file_key .. ".lua"))()

	if info.csau_dependencies then
		if not csau_filter_loading('item', { key = file_key, type = item_type, dependencies = info.csau_dependencies }) then
			return
		end
	elseif info.streamer then
		if not csau_filter_loading('item', { key = file_key, type = item_type, streamer = info.streamer }) then
			return
		end
	end

	info.key = file_key
	if item_type ~= 'Challenge' and item_type ~= 'Edition' then
		info.atlas = file_key
		info.pos = { x = 0, y = 0 }
		if info.hasSoul then
			info.pos = { x = 1, y = 0 }
			info.soul_pos = { x = 2, y = 0 }
		end
	end

	if no_badges then
		info.no_mod_badges = true
	elseif info.origin or info.part or (info.streamer and (info.streamer== 'vinny' or info.streamer== 'joel' or info.streamer== 'mike')) then
		info.no_mod_badges = true
		local sb_ref = function(self, card, badges) end
		if info.set_badges then
			sb_ref = info.set_badges
		end
		info.set_badges = function(self, card, badges)
			sb_ref(self, card, badges)
			if card.area and card.area == G.jokers or card.config.center.discovered then
				badges[#badges+1] = dynamic_badges(info)
			end
		end
	end

	if item_type == 'Blind' and info.color then
		info.boss_colour = info.color
		info.color = nil
	end

	-- tape image loading
	if item_type == 'VHS' then
		mod['c_csau_'..info.key..'_tape'] = love.graphics.newImage(mod_path..'assets/1x/vhs/'..(info.tapeKey or 'blackspine')..'.png')
		mod['c_csau_'..info.key..'_sleeve'] = love.graphics.newImage(mod_path..'assets/1x/vhs/'..info.key..'.png')
	end

	local smods_item = item_type
	if item_type == 'Stand' or item_type == 'VHS' then
		smods_item = 'Consumable'
		local atd_ref = function(self, card) end
		if info.add_to_deck then
			atd_ref = info.add_to_deck
		end
		function info.add_to_deck(self, card)
			atd_ref(self, card)
			set_consumeable_usage(card)
		end
		if item_type == 'Stand' and info.rarity == 'csau_EvolvedRarity' then
			local sctb_ref = function(self, card, badges) end
			if info.set_card_type_badge then
				sctb_ref = info.set_card_type_badge
			end
			function info.set_card_type_badge(self, card, badges)
				badges[1] = create_badge(localize('k_csau_evolved'), get_type_colour(self or card.config, card), nil, 1.2)
				sctb_ref(self, card)
			end
		end
	end

	if item_type == 'Deck' then smods_item = 'Back' end
	local new_item = SMODS[smods_item](info)
	for k_, v_ in pairs(new_item) do
		if type(v_) == 'function' then
			new_item[k_] = info[k_]
		end
	end

    if item_type == 'Challenge' or item_type == 'Edition' then
        -- these dont need visuals
        return
    end

	if info.animated then
		G.csau_animated_centers[info.key] = info.animated
		G.csau_animated_centers[info.key].dt = 0
	end

    if item_type == 'Blind' then
        -- separation for animated spritess
        SMODS.Atlas({ key = file_key, atlas_table = "ANIMATION_ATLAS", path = "blinds/" .. file_key .. ".png", px = 34, py = 34, frames = 21, })
	else
		local width = 71
		local height = 95
		if item_type == 'Tag' then width = 34; height = 34 end
        SMODS.Atlas({ key = file_key, path = key .. "/" .. file_key .. ".png", px = new_item.width or width, py = new_item.height or height })
    end
end

math.randomseed(os.time())
--- External random function for on-load purposes
--- @param chance number Postive integer to compare using math.random()
--- @returns boolean # Result of the random roll
function externalPseudorandom(chance, total)
	if total <= 0 then return false end
	local randomNumber = math.random(1, total)
	return randomNumber <= chance
end

--- Table extension, finds a value in a table
--- @param table table table to traverse for element
--- @param element any value to find in the table
--- @return boolean # true if this table contains this element paired with any key
function table.contains(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end

--- x^4 easing function both in and out
--- @param x number Value to ease (between 0 and 1)
--- @return number # Eased value between 0 and 1
function ease_in_out_quart(x) 
	return x < 0.5 and 8 * x * x * x * x or 1 - (-2 * x + 2)^4 / 2;
end

--- Parses a multi-entry string table as a single-line, human readable string
--- @param tbl table Array table of strings
--- @param sep string | nil String separator between entries. Default is a single space
--- @return string # Single-line return string
function tableToString(tbl, sep)
    local result = {}
    for _, line in ipairs(tbl) do
        local cleanedLine = line:gsub("{.-}", "")
        table.insert(result, cleanedLine)
    end
    return table.concat(result, (sep or " "))
end

--- Checks if a string starts with a specified substring
--- @param str string String to check
--- @param start string Substring to search for within str
--- @return boolean # If the string starts with the substring
function starts_with(str, start)
	return string.sub(str, 1, #start) == start
end

--- Checks if a string ends with a specified substring
--- @param str string String to check
--- @param ending string Substring to search for within str
--- @return boolean # If the string end with the substring
function ends_with(str, ending)
	return string.sub(str, -#ending) == ending
end

--- Finds a substring within a given string, not case sensitive
--- @param str string String to check
--- @param substring string Substring to search for within str
--- @return boolean # If the substring is found anywhere within str
function containsString(str, substring)
	local lowerStr = string.lower(str)
	local lowerSubstring = string.lower(substring)
	return string.find(lowerStr, lowerSubstring, 1, true) ~= nil
end

--- Wrapper for SMODS debug mesage functions
--- @param message string Message text
--- @param level string Debug level ('debug', 'info', 'warn')
function send(message, level)
	level = level or 'debug'
	if type(message) == 'table' then
		if level == 'debug' then sendDebugMessage(tprint(message))
		elseif level == 'info' then sendInfoMessage(tprint(message))
		elseif level == 'error' then sendErrorMessage(tprint(message)) end
	else
		if level == 'debug' then sendDebugMessage(message)
		elseif level == 'info' then sendInfoMessage(message)
		elseif level == 'error' then sendErrorMessage(message) end
	end
end

--- Recursively finds the full file tree at a specified path
--- @param folder string The folder path to enumerate. Function fails if folder is not an OS directory
--- @return string fileTree A string, separated by newlines, of all enumerated paths
function recursiveEnumerate(folder)
	local fileTree = ""
	for _, file in ipairs(love.filesystem.getDirectoryItems(folder)) do
		local path = folder .. "/" .. file
		local info = love.filesystem.getInfo(path)
		fileTree = fileTree .. "\n" .. path .. (info.type == "directory" and " (DIR)" or "")
		if info.type == "directory" then
			fileTree = fileTree .. recursiveEnumerate(path)
		end
	end
	return fileTree
end





---------------------------
--------------------------- Csau Joker helper functions
---------------------------

--- Sets sprite dimensions and scale for a center that has a specified width and height property
--- @param centerInfo table An SMODS center table, such as a Joker or Consumable
--- @param card Card A Balatro card object represent an instance of the given center
G.FUNCS.csau_set_big_sprites = function(centerInfo, card)
	if card.config.center.discovered or card.bypass_discovery_center then
		card.children.center.scale = {x=centerInfo.width,y=centerInfo.height}
		card.children.center.scale_mag = math.min(centerInfo.width/card.children.center.T.w,centerInfo.height/card.children.center.T.h)
		card.children.center:reset()

		if centerInfo.hasSoul then
			card.children.floating_sprite.scale = {x=centerInfo.width,y=centerInfo.height}
			card.children.floating_sprite.scale_mag = math.min(centerInfo.width/card.children.floating_sprite.T.w,centerInfo.height/card.children.floating_sprite.T.h)
			card.children.floating_sprite:reset()
		end
	end
end

local function cardarea_check(card)
	local cardarea = card.ability.set == 'Joker' and G.jokers or G.consumeables
	return card.area == cardarea
end

--- Contextually swaps descriptions for cards based on the "detailedDescs" settings in mod config, params identical to center.generate_ui
G.FUNCS.csau_generate_detail_desc = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table, key, no_title)
	no_title = no_title or false
	key = key or card.config.center.key
	if (cardarea_check(card) or card.config.center.discovered) and not no_title then
		-- If statement makes it so that this function doesnt activate in the "Joker Unlocked" UI and cause 'Not Discovered' to be stuck in the corner
		full_UI_table.name = localize{type = 'name', key = key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
	end

	if mod.config['detailedDescs'] and G.localization.descriptions.Joker[key.."_detailed"] then
		localize{type = 'descriptions', key = key.."_detailed", set = self.set, nodes = desc_nodes, vars = self.loc_vars and self.loc_vars(self, info_queue, card).vars or {}}
	else
		localize{type = 'descriptions', key = key, set = self.set, nodes = desc_nodes, vars = self.loc_vars and self.loc_vars(self, info_queue, card).vars or {}}
	end
end

--- Utility function to check if all cards in hand are of the same suit. DO NOT USE WHEN RETURNING QUANTUM ENHANCEMENTS
--- @param hand table Array table of Balatro card objects, representing a played hand
--- @param suit string Key of the suit to check
--- @return boolean # True if all cards in hand are the same suit
G.FUNCS.csau_all_suit = function(hand, suit)
	for k, v in ipairs(hand) do
		if not v:is_suit(suit, nil, true) then
			return false
		end
	end
	return true
end

G.FUNCS.csau_add_chance = function(num, multiply, startAtOne)
	multiply = multiply or false
	startAtOne = startAtOne or false
	if G.FUNCS.powers_active and G.FUNCS.powers_active() then
		return 0
	else
		if multiply then
			if G.GAME.probabilities and G.GAME.probabilities.normal then
				if startAtOne then
					return (1 + num) * G.GAME.probabilities.normal
				else
					return (num <= 0 and 0 or (1 + num)) * G.GAME.probabilities.normal
				end
			else
				if startAtOne then
					return 1 + num
				else
					return num
				end
			end
		else
			if startAtOne then
				return 1 + num
			else
				return num
			end
		end
	end
end

-- Based on code from Ortalab
--- Replaces a card in-place with a card of the specified key
--- @param card Card Balatro card table of the card to replace
--- @param to_key string string key (including prefixes) to replace the given card
--- @param evolve boolean boolean for stand evolution
G.FUNCS.csau_transform_card = function(card, to_key, evolve)
	evolve = evolve or false
	local old_card = card
	local new_card = G.P_CENTERS[to_key]
	card.children.center = Sprite(card.T.x, card.T.y, G.CARD_W, G.CARD_H, G.ASSET_ATLAS[new_card.atlas], new_card.pos)
	card.children.center.scale = {
		x = 71,
		y = 95
	}
	card.children.center.states.hover = card.states.hover
	card.children.center.states.click = card.states.click
	card.children.center.states.drag = card.states.drag
	card.children.center.states.collide.can = false
	card.children.center:set_role({major = card, role_type = 'Glued', draw_major = card})
	card:set_ability(new_card)
	card:set_cost()
	if old_card.on_evolve and type(old_card.on_evolve) == 'function' then
		send('uh')
		old_card:on_evolve(old_card, card)
	end
	if new_card.soul_pos then
		card.children.floating_sprite = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS[new_card.atlas], new_card.soul_pos)
		card.children.floating_sprite.role.draw_major = card
		card.children.floating_sprite.states.hover.can = false
		card.children.floating_sprite.states.click.can = false
	end
	if not card.edition then
		card:juice_up()
		play_sound('generic1')
	else
		card:juice_up(1, 0.5)
		if card.edition.foil then play_sound('foil1', 1.2, 0.4) end
		if card.edition.holo then play_sound('holo1', 1.2*1.58, 0.4) end
		if card.edition.polychrome then play_sound('polychrome1', 1.2, 0.7) end
		if card.edition.negative then play_sound('negative', 1.5, 0.4) end
	end
end





---------------------------
--------------------------- Sticker Scaling
---------------------------

--- Scales a physical card with nonstandard dimensions relative to the standardized joker sticker size
--- @param sticker table A balatro/SMODS table representing a sticker
--- @param card Card A balatro card object n which this sticker is drawn
--- @return table | nil transform The underlying width and height values of the original, unscaled card
--- @return table | nil visualTransform The visual width and height values of the original, unscaled card
function scale_joker_sticker(sticker, card)
    if not sticker or not card then
        return nil, nil
    end

    if sticker.atlas.px ~= card.children.center.atlas.px and sticker.atlas.py ~= card.children.center.atlas.px then
        local x_scale = sticker.atlas.px / card.children.center.atlas.px
        local y_scale = sticker.atlas.py / card.children.center.atlas.py
		-- dividing 71/95 is 0.74736842105, using this we can make sure that stickers are not too wide or too tall
		-- if the aspect ratio of a card is not the same as a standard card
		if card.config.center.display_size then
			local target_ratio = 71/95
			local ratio = card.config.center.display_size.w / card.config.center.display_size.h
			if ratio > target_ratio then
				-- Too wide
				x_scale = x_scale * (ratio*2)
			else
				-- Too tall
				y_scale = y_scale * (ratio*2)
			end
		end
		local x_mod = 0
		local y_mod = 0
		if card.config.center.sticker_offset then
			if card.config.center.sticker_offset.x then
				x_mod = card.config.center.sticker_offset.x
			end
			if card.config.center.sticker_offset.y then
				y_mod = card.config.center.sticker_offset.y
			end
		end
        local t = {w = card.T.w, h = card.T.h, x = card.T.x, y = card.T.y}
        local vt = {w = card.VT.w, h = card.VT.h, x = card.VT.x, y = card.VT.y}
		card.T.x = sticker.T.x + x_mod
		card.VT.x = sticker.T.x + x_mod
		card.T.y = sticker.T.y + y_mod
		card.VT.y = sticker.T.y + y_mod

        card.T.w  = sticker.T.w * x_scale
        card.VT.w = sticker.T.w * x_scale
        card.T.h = sticker.T.h * y_scale
        card.VT.h = sticker.T.h * y_scale
        return t, vt
    end

    return nil, nil
end

--- Resets a card's dimensions and scale based on the given transform values
--- @param card Card A balatro card object
--- @param t table Underlying transform values to reset to
--- @param vt table Visual transform values to reset to
function reset_sticker_scale(card, t, vt)
    if not t and not vt then return end
	card.T.x = t and t.x
	card.VT.x = vt and vt.x
	card.T.y = t and t.y
	card.VT.y = vt and vt.y
    card.T.w = t and t.w or G.CARD_W
    card.VT.w = vt and vt.w or G.CARD_W
    card.T.h = t and t.h or G.CARD_H
    card.VT.h = vt and vt.h or G.CARD_H
end





---------------------------
--------------------------- VHS Helper Functios
---------------------------

--- Retrieves the number of VHS tapes in your consumable slots
--- @return number # Count of current VHS tapes
G.FUNCS.get_vhs_count = function()
	if not G.consumables then return 0 end
	local count = 0
	for i, v in ipairs(G.consumeables.cards) do
		if v.ability.set == "VHS" then
			count = count+1
		end
	end
	return count
end

--- Sends feedback for VHS tape activatio
--- @param card Card Balatro Card object of activated VHS tape
G.FUNCS.tape_activate = function(card)
    if not card.ability.activation then return end
    if card.ability.activated then
        card.ability.activated = false
        play_sound('csau_vhsclose', 0.9 + math.random()*0.1, 0.4)
    else
        card.ability.tape_move = 9
        card.ability.sleeve_move = -9
        card.ability.activated = true
        play_sound('csau_vhsopen', 0.9 + math.random()*0.1, 0.4)
    end
end

--- Destroys a VHS tape and calls all relevant contexts
--- @param card Card Balatro Card object of VHS tape to destroy
--- @param delay number Event delay in seconds
--- @param ach string | nil Achievement type key, will check for achievement unlock if not nil
--- @param silent boolean | nil Plays tarot sound effect on destruction if true
G.FUNCS.destroy_tape = function(card, delay, ach, silent)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = delay,
        func = function()
            if not silent then
                play_sound('tarot1')
            end
            card.T.r = -0.2
            card:juice_up(0.3, 0.4)
            card.states.drag.is = true
            card.children.center.pinch.x = true
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                 func = function()
					 if card.config.center.activate and type(card.config.center.activate) == 'function' then
						 card.config.center.activate(card.config.center, card, false)
					 end
                     card:start_dissolve({ G.C.VHS, G.C.RED })
                     --G.consumeables:remove_card(card)
                     --card:remove()
                     --card = nil
                     return true
                 end
            }))
            G.E_MANAGER:add_event(Event({trigger = 'after',
                 func = function()
                     SMODS.calculate_context({vhs_death = true, card = card})
                     return true
                 end
            }))
            if ach then
                check_for_unlock({ type = ach })
            end
            return true
        end
    }))
end


--Modified Code from Betmma's Vouchers
G.FUNCS.can_reserve_card = function(e)
	if #G.consumeables.cards < G.consumeables.config.card_limit then
		if not e.config.colour == G.C.IMPORTANT then
			e.config.colour = G.C.RED
		end
		if (e.config.ref_table.config.center.activation and e.config.activate) or e.config.pull then
			e.config.button = "reserve_card"
		else
			e.config.button = "use_card"
		end
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

G.FUNCS.reserve_card = function(e)
	local c1 = e.config.ref_table
	if e.config.activate then
		G.FUNCS.tape_activate(c1)
	end
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0.1,
		func = function()
			c1.area:remove_card(c1)
			c1:add_to_deck()
			if c1.children.price then
				c1.children.price:remove()
			end
			c1.children.price = nil
			if c1.children.buy_button then
				c1.children.buy_button:remove()
			end
			c1.children.buy_button = nil
			remove_nils(c1.children)
			G.consumeables:emplace(c1)
			G.GAME.pack_choices = G.GAME.pack_choices - 1
			if G.GAME.pack_choices <= 0 then
				G.FUNCS.end_consumeable(nil, delay_fac)
			end
			return true
		end,
	}))
end





---------------------------
--------------------------- Stand Helper Functions
---------------------------

--- Gets the leftmost stand in the consumable slots
--- @return Card | nil # The first Stand in the consumables slot, or nil if you have no Stands
G.FUNCS.csau_get_leftmost_stand = function()
    if not G.consumeables then return nil end

    local stand = nil
    for i, card in ipairs(G.consumeables.cards) do
        if card.ability.set == "csau_Stand" then
            stand = card
            break
        end
    end

    return stand
end

--- Gets the number of stands in your consumable slots
--- @return integer
G.FUNCS.csau_get_num_stands = function()
    if not G.consumeables then return 0 end

    local count = 0
    for i, v in ipairs(G.consumeables.cards) do
        if v.ability.set == "csau_Stand" then
            count = count+1
        end
    end

   return count
end

--- Evolves a Stand. A Stand must have an 'evolve_key' field to evolve
--- @param stand Card Balatro card table representing a Stand consumable
G.FUNCS.csau_evolve_stand = function(stand)
	G.E_MANAGER:add_event(Event({
        func = function()
			G.FUNCS.csau_transform_card(stand, stand.ability.evolve_key, true)
			check_for_unlock({ type = "evolve_stand" })

			attention_text({
                text = localize('k_stand_evolved'),
                scale = 0.7, 
                hold = 0.55,
                backdrop_colour = G.C.STAND,
                align = 'bm',
                major = stand,
                offset = {x = 0, y = 0.05*stand.T.h}
            })

			if not stand.edition then
				play_sound('polychrome1')
			end
			stand:juice_up(0.3, 0.5)

			return true
		end
    }))
end

--- Creates a new stand in the consumables card area, on the side of Stands
--- @param evolved boolean Whether or not to use the Evolved Stand pool
G.FUNCS.csau_new_stand = function(evolved)
	local pool_key = evolved and 'csau_EvolvedPool' or 'csau_StandPool'
    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
	local stand = create_card(pool_key, G.consumeables, nil, nil, nil, nil, nil, 'arrow')
	stand:add_to_deck()
	G.consumeables:emplace(stand, nil, nil, nil, nil, G.FUNCS.csau_get_num_stands() + 1)
	stand:juice_up(0.3, 0.5)
	G.GAME.consumeable_buffer = 0
end

--- Queues a stand aura to flare for delay_time if a Stand has an aura attached
--- @param stand Card Balatro card table representing a stand
--- @param delay_time delay_time length of flare in seconds
G.FUNCS.csau_flare_stand_aura = function(stand, delay_time)
	if not stand.children.stand_aura then
		return
	end
	
	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		delay = 0.05,
		func = function()
			stand.ability.aura_flare_queued = true
			stand.ability.aura_flare_target = (delay_time or 1) / 2
        	return true
		end 
	}))
end

--- Sets relevant sprites for stand auras and overlays (if applicable)
--- @param stand Card Balatro card table representing a stand
G.FUNCS.csau_set_stand_sprites = function(stand)
	-- add stand aura
	if stand.ability.aura_colors and #stand.ability.aura_colors == 2 then
		stand.no_shadow = true
		G.ASSET_ATLAS['csau_noise'].image:setWrap('repeat', 'repeat', 'clamp')

		local blank_atlas = G.ASSET_ATLAS['csau_blank']
		local aura_scale_x = blank_atlas.px / stand.children.center.atlas.px
		local aura_scale_y = blank_atlas.py / stand.children.center.atlas.py
		local aura_width = stand.T.w * aura_scale_x
		local aura_height = stand.T.h * aura_scale_y
		local aura_x_offset = (aura_width - stand.T.w) / 2
		local aura_y_offset = (aura_height - stand.T.h) / 1.1
		
		stand.ability.aura_spread = 0.45
		stand.ability.aura_rate = 0.7
		stand.ability.aura_offset = math.random(0, 10)
		stand.children.stand_aura = Sprite(
			stand.T.x - aura_x_offset,
			stand.T.y - aura_y_offset,
			aura_width,
			aura_height,
			blank_atlas,
			stand.children.center.config.pos
		)
		stand.children.stand_aura:set_role({
			role_type = 'Minor',
			major = stand,
			offset = { x = -aura_x_offset, y = -aura_y_offset },
			xy_bond = 'Strong',
			wh_bond = 'Weak',
			r_bond = 'Strong',
			scale_bond = 'Strong',
			draw_major = stand
		})
		stand.children.stand_aura:align_to_major()
		stand.children.stand_aura.custom_draw = true
	end

	if stand.ability.stand_overlay then
		stand.children.stand_overlay = Sprite(
			stand.T.x,
			stand.T.y,
			stand.T.w,
			stand.T.h,
			G.ASSET_ATLAS[stand.config.center.atlas],
			{x = 3, y = 0}
		)
		stand.children.stand_overlay:set_role({
			role_type = 'Glued',
			major = stand,
			offset = { x = 0, y = 0 },
			xy_bond = 'Strong',
			wh_bond = 'Strong',
			r_bond = 'Strong',
			scale_bond = 'Strong',
			draw_major = stand
		})
		stand.children.stand_overlay.custom_draw = true
	end
end

G.FUNCS.discovery_check = function(args)
	local csau_only = args.csau_only or false
	if not args.mode then return end
	if args.mode == 'key' and args.key then
		for k, v in pairs(SMODS.Centers) do
			if (csau_only and starts_with(k, 'j_csau_')) or not csau_only then
				if k == args.key then
					if v.discovered == true then
						return true
					end
				end
			end
		end
		return false
	end
end

local function check_secret(name, visible)
	for k, v in pairs(SMODS.PokerHands) do
		if k == name then
			if v.visible == visible then
				return true
			end
		end
	end
end

G.FUNCS.recheck_hand = function(last_hand, scoring)
	local text,disp_text,poker_hands,scoring_hand,non_loc_disp_text = G.FUNCS.get_poker_hand_info(scoring)
	G.FUNCS.ach_pepsecretunlock(text)
	if G.GAME.current_round.current_hand.handname ~= disp_text then delay(0.3) end
	G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0, blockable = false,
		 func = function()
			 if text ~= G.GAME.last_hand_played then
				 G.GAME.hands[G.GAME.last_hand_played].played = G.GAME.hands[G.GAME.last_hand_played].played - 1
				 G.GAME.hands[G.GAME.last_hand_played].played_this_round = G.GAME.hands[G.GAME.last_hand_played].played_this_round + 1
			 end
			 if check_secret(G.GAME.last_hand_played, true) and check_secret(text, false) then
				 check_for_unlock({ type = "red_convert" })
			 end
			 G.GAME.hands[text].played = G.GAME.hands[text].played + 1
			 G.GAME.hands[text].played_this_round = G.GAME.hands[text].played_this_round + 1
			 G.GAME.last_hand_played = text
			 set_hand_usage(text)
			 G.GAME.hands[text].visible = true
			 update_hand_text({sound = G.GAME.current_round.current_hand.handname ~= disp_text and 'button' or nil, volume = 0.4, immediate = true, nopulse = true,
							   delay = G.GAME.current_round.current_hand.handname ~= disp_text and 0.4 or 0}, {handname=disp_text, level=G.GAME.hands[text].level, mult = G.GAME.hands[text].mult, chips = G.GAME.hands[text].chips})
			 hand_chips = G.GAME.hands[text].chips
			 mult = G.GAME.hands[text].mult
			 return true
		 end
	}))
	G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0, blockable = false,
		 func = function()
			 update_hand_text({sound = G.GAME.current_round.current_hand.handname ~= last_hand and 'button' or nil, volume = 0.4, immediate = true, nopulse = true,
							   delay = G.GAME.current_round.current_hand.handname ~= last_hand and 0.4 or 0}, {handname=last_hand, level=G.GAME.hands[last_hand].level, mult = G.GAME.hands[last_hand].mult, chips = G.GAME.hands[last_hand].chips})
			 return true
		 end
	}))
	G.E_MANAGER:add_event(Event({trigger = 'after', delay = 4.5, blockable = false,
		 func = function()
			 update_hand_text({sound = G.GAME.current_round.current_hand.handname ~= disp_text and 'button' or nil, volume = 0.4, immediate = true, nopulse = nil,
							   delay = G.GAME.current_round.current_hand.handname ~= disp_text and 0.4 or 0}, {handname=disp_text, level=G.GAME.hands[text].level, mult = G.GAME.hands[text].mult, chips = G.GAME.hands[text].chips})
			 return true
		 end
	}))
	return text
end

--- Formats a numeral for display. Numerals between 0 and 1 are written out fully
--- @param n number Numeral to format
--- @param number_type string Type of display number ('number', 'order')
--- @param caps_style string | nil Style of capitalization ('lower', 'upper', 'first')
function csau_format_display_number(n, number_type, caps_style)
	number_type = number_type or 'number'
	local dict = {
		[0] = {number = 'zero', order = 'zeroth'},
		[1] = {number = 'one', order = 'first'},
		[2] = {number = 'two', order = 'second'},
		[3] = {number = 'three', order = 'third'},
		[4] = {number = 'four', order = 'fourth'},
		[5] = {number = 'five', order = 'fifth'},
		[6] = {number = 'six', order = 'sixth'},
		[7] = {number = 'seven', order = 'seventh'},
		[8] = {number = 'eight', order = 'eighth'},
		[9] = {number = 'nine', order = 'ninth'},
		[10] = {number = 'ten', order = 'tenth'},
		[11] = {number = '11', order = '11th'},
		[12] = {number = '12', order = '12th'},
	}
	if n < 0 or n > #dict then
		if number_type == 'number' then return n end

		local ret = ''
		local mod = n % 10
		if mod == 1 then 
			ret = n..'st'
		elseif mod == 2 then
			ret = n..'nd'
		elseif mod == 3 then
			ret = n..'rd'
		else
			ret = n..'th'
		end
		return ret
	end

	local ret = dict[n][number_type]
	local style = caps_style and string.lower(caps_style) or 'lower'
	if style == 'upper' then
		ret = string.upper(ret)
	elseif n < 11 and style == 'first' then
		ret = ret:gsub("^%l", string.upper)
	end

	return ret
end

G.FUNCS.csau_center_discovered = function(key)
	for k, v in pairs(SMODS.Centers) do
		if k == key and v.discovered == true then
			return true
		end
	end
	return false
end

G.FUNCS.find_activated_tape = function(key)
	local tapes = SMODS.find_card(key)
	if tapes and #tapes > 0 then
		for i, v in ipairs(tapes) do
			if v.ability.activated then
				return v
			end
		end
	end
	return false
end

SMODS.food_expires = function(context)
	if next(SMODS.find_card('j_csau_bunji')) then return false end
	return true
end

SMODS.return_to_hand = function(card, context)
	if G.GAME.blind.boss and G.GAME.blind.name == "The Vod" then return true end
	if G.FUNCS.find_activated_tape('c_csau_yoyoman') and table.contains(context.scoring_hand, card) then return true end
	if context.scoring_name == "High Card" and next(SMODS.find_card("j_csau_besomeone")) and table.contains(context.scoring_hand, card) then return true end
	return false
end

G.FUNCS.hand_contains_rank = function(hand, ranks, require_all)
	require_all = require_all or false
	local found = {}

	for _, card in ipairs(hand) do
		if card.ability.effect == "Base" then
			local rank = card:get_id()
			for _, target in ipairs(ranks) do
				if rank == target then
					found[target] = true
				end
			end
		end
	end
	if require_all then
		for _, target in ipairs(ranks) do
			if not found[target] then
				return false
			end
		end
		return true
	else
		return next(found) ~= nil
	end
end

function SMODS.skip_cards_until(requirements)
	if not requirements then return end
	local len = #G.deck.cards
	for i = 1, len do
		local card = G.deck.cards[#G.deck.cards]
		local results = {}

		if requirements.rank_min then
			send(card.base.nominal)
			results.rank_min = card.base.nominal >= requirements.rank_min
		end

		local requirements_met = true
		for _, met in pairs(results) do
			if not met then
				requirements_met = false
				break
			end
		end

		if requirements_met then
			return card
		else
			table.remove(G.deck.cards, #G.deck.cards)
			table.insert(G.deck.cards, 1, card)
		end
	end
	return nil
end

function SMODS.draw_card_filtered(i, hand_space, mod_table)
	if mod_table.roar then
		local card = SMODS.skip_cards_until({ rank_min = 6 })
		if not card then return end
	end
	draw_card(G.deck,G.hand, i*100/hand_space,'up', true)
end

function SMODS.draw_cards_from_deck(hand_space, mod_table)
	mod_table = mod_table or {}
	local roar = G.FUNCS.find_activated_tape('c_csau_roar')
	local draw = true
	if roar and not roar.ability.destroyed then
		mod_table.roar = true
		roar.ability.extra.uses = roar.ability.extra.uses+1
		if roar.ability.extra.uses >= roar.ability.extra.runtime then
			G.FUNCS.destroy_tape(roar)
			roar.ability.destroyed = true
		end
	end
	for i=1, hand_space do --draw cards from deckL
		SMODS.draw_card_filtered(i, hand_space, mod_table)
	end
end

function G.FUNCS.stand_preview_deck(amount)
	local preview_cards = {}
	local roar = G.FUNCS.find_activated_tape('c_csau_roar')
	local count = 0
	local i = #G.deck.cards

	while count < amount and i >= 1 do
		local card = G.deck.cards[i]
		if card then
			if roar then
				if card.base.nominal >= 6 then
					table.insert(preview_cards, card)
					count = count + 1
				end
			else
				table.insert(preview_cards, card)
				count = count + 1
			end
		end
		i = i - 1
	end

	return preview_cards
end

SMODS.spectral_lower_handsize = function(context)
	local rem = G.FUNCS.find_activated_tape('c_csau_remlezar')
	if rem and not rem.ability.destroyed  then
		rem.ability.extra.uses = rem.ability.extra.uses+1
		if rem.ability.extra.uses >= rem.ability.extra.runtime then
			G.FUNCS.destroy_tape(rem)
			rem.ability.destroyed = true
		end
		return false
	end
	return true
end

SMODS.will_destroy_card = function(context)
	local sew = G.FUNCS.find_activated_tape('c_csau_sew')
	if sew and not sew.ability.destroyed then
		sew.ability.extra.uses = sew.ability.extra.uses+1
		if sew.ability.extra.uses >= sew.ability.extra.runtime then
			G.FUNCS.destroy_tape(sew)
			sew.ability.destroyed = true
		end
		return false
	end
	return true
end

G.FUNCS.have_multiple_jokers = function(tbl, amount)
	local found = 0
	for i, v in ipairs(tbl) do
		if next(SMODS.find_card(v)) then
			found = found + 1
		end
	end
	if amount then
		return found >= amount
	else
		return found == #tbl
	end
end