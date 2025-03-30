local mod = SMODS.current_mod





---------------------------
--------------------------- Loading/Debug Functions
---------------------------

--- Load an item definition using SMODS
--- @param file_key string file name to load within the "Items" directory, excluding file extension
--- @param item_type string SMODS item type (such as Joker, Consumable, Deck, etc)
--- @param no_badges boolean | nil Whether or not to display mod badges on this item
function load_cardsauce_item(file_key, item_type, no_badges)
	local key = string.lower(item_type)..(item_type == 'VHS' and '' or 's')
	local info = assert(SMODS.load_file("items/" .. key .. "/" .. file_key .. ".lua"))()

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
	elseif info.part then
		info.no_mod_badges = true
		info.set_badges = function(self, card, badges)
			local title = localize('ba_'..info.part)
			local color = HEX(localize('co_'..info.part))
			local text = G.localization.misc.dictionary['te_'..info.part] and HEX(localize('te_'..info.part)) or G.C.WHITE
			badges[#badges+1] = create_badge(title, color, text, 1)
		end
	end

	if item_type == 'Joker' then        
        -- need streamer information to load
        if not info.streamer then
            return
        end

        -- load based on streamer type
        if ((info.streamer == 'vinny' or info.streamer == 'othervinny') and not csau_enabled['enableVinkers'])
                or ((info.streamer == 'joel' or info.streamer == 'otherjoel') and not csau_enabled['enableJoelkers'])
                or ((info.streamer == 'other' or info.streamer == 'othervinny') and not csau_enabled['enableOtherJokers']) then
            return
        end
	end

	if item_type == 'Blind' and info.color then
		info.boss_colour = info.color
		info.color = nil
	end

	local smods_item = item_type
	if item_type == 'Stand' or item_type == 'VHS' then smods_item = 'Consumable' end
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

    if item_type == 'Blind' then
        -- separation for animated spritess
        SMODS.Atlas({ key = file_key, atlas_table = "ANIMATION_ATLAS", path = "blinds/" .. file_key .. ".png", px = 34, py = 34, frames = 21, })
    else 
        SMODS.Atlas({ key = file_key, path = key .. "/" .. file_key .. ".png", px = new_item.width or 71, py = new_item.height or  95 })
    end
end

math.randomseed(os.time())
--- External random function for on-load purposes
--- @param chance number Postive integer to compare using math.random()
--- @returns boolean # Result of the random roll
function externalPsuedorandom(chance, total)
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
	if level == 'debug' then
		if type(message) == 'table' then
			sendDebugMessage(tprint(message))
		else
			sendDebugMessage(message)
		end
	elseif level == 'info' then
		if type(message) == 'table' then
			sendInfoMessage(tprint(message))
		else
			sendInfoMessage(message)
		end
	elseif level == 'error' then
		if type(message) == 'table' then
			sendErrorMessage(tprint(message))
		else
			sendErrorMessage(message)
		end
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

--- Contextually swaps descriptions for cards based on the "detailedDescs" settings in mod config, params identical to center.generate_ui
G.FUNCS.csau_generate_detail_desc = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table, key, no_title)
	no_title = no_title or false
	key = key or card.config.center.key
	if card.config.center.discovered and not no_title then
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
G.FUNCS.transform_card = function(card, to_key)
	local new_card = G.P_CENTERS[to_key]
	card.children.center = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS[new_card.atlas], new_card.pos)
	card.children.center.states.hover = card.states.hover
	card.children.center.states.click = card.states.click
	card.children.center.states.drag = card.states.drag
	card.children.center.states.collide.can = false
	card.children.center:set_role({major = card, role_type = 'Glued', draw_major = card})
	card:set_ability(new_card)
	card:set_cost()
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
        local t = {w = card.T.w, h = card.T.h}
        local vt = {w = card.VT.w, h = card.VT.h}
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
    if not card.config.center.activation then return end
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
G.FUNCS.get_leftmost_stand = function()
    if not G.consumeables then return nil end

    local stand = nil
    for i, card in ipairs(G.consumeables.cards) do
        if card.ability.set == "Stand" then
            stand = card
            break
        end
    end

    return stand
end

--- Gets the number of stands in your consumable slots
--- @return integer
G.FUNCS.get_num_stands = function()
    if not G.consumeables then return 0 end

    local count = 0
    for i, v in ipairs(G.consumeables.cards) do
        if v.ability.set == "Stand" then
            count = count+1
        end
    end

   return count
end

--- Evolves a Stand. A Stand must have an 'evolve_key' field to evolve
--- @param stand Card Balatro card table representing a Stand consumable
G.FUNCS.evolve_stand = function(stand)
	G.E_MANAGER:add_event(Event({
        func = function()
			G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
			local evolved_stand = create_card('EvolvedPool', G.consumables, nil, nil, true, nil, stand.ability.evolve_key, 'standevolve')
			evolved_stand:hard_set_T(stand.T.x, stand.T.y, stand.T.w, stand.T.h)
		
			evolved_stand:set_edition(stand.edition)
			evolved_stand:set_seal(stand.ability.seal)
			if evolved_stand.on_evolve and type(evolved_stand.on_evolve) == 'function' then
				evolved_stand:on_evolve(evolved_stand, stand)
			end
		
			evolved_stand:add_to_deck()		
			G.consumeables:emplace(evolved_stand, nil, nil, true, nil, stand.rank)   
			stand:remove()
			G.GAME.consumeable_buffer = 0
	

			attention_text({
                text = localize('k_stand_evolved'),
                scale = 0.7, 
                hold = 0.55,
                backdrop_colour = G.C.STAND,
                align = 'bm',
                major = evolved_stand,
                offset = {x = 0, y = 0.05*evolved_stand.T.h}
            })

			if not evolved_stand.edition then 
				play_sound('polychrome1')
			end
			evolved_stand:juice_up(0.3, 0.5)

			return true
		end
    }))
end

--- Creates a new stand in the consumables card area, on the side of Stands
--- @param evolved boolean Whether or not to use the Evolved Stand pool
G.FUNCS.new_stand = function(evolved)
	local pool_key = evolved and 'EvolvedPool' or 'StandPool'
    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
	local stand = create_card(pool_key, G.consumeables, nil, nil, nil, nil, nil, 'arrow')
	stand:add_to_deck()
	G.consumeables:emplace(stand, nil, nil, nil, nil, get_num_stands() + 1)
	stand:juice_up(0.3, 0.5)
	G.GAME.consumeable_buffer = 0
end

--- Queues a stand aura to flare for delay_time if a Stand has an aura attached
--- @param stand Card Balatro card table representing a stand
--- @param delay_time delay_time length of flare in seconds
G.FUNCS.flare_stand_aura = function(stand, delay_time)
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
G.FUNCS.set_stand_sprites = function(stand)
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
		local rand = math.random(-10, 10)
		stand.ability.aura_offset = math.max(0, rand + G.TIMERS.REAL)
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