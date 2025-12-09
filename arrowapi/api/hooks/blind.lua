local function set_blind_score_visible(bool)
	local blind_score = G.hand_text_area.blind_chips
    local chip_total = G.hand_text_area.game_chips
    if not bool then
        blind_score.UIT = G.UIT.O
        blind_score.config.object = DynaText({
            string = '?????',
            colours = {G.C.DARK_EDITION},
            bump = true,
            pop_in_rate = 99999999,
            scale = 0.65,
        })
        blind_score.config.ref_table = nil
        blind_score.config.ref_value = nil

        chip_total.UIT = G.UIT.O
        chip_total.config.object = DynaText({
            string = '?????',
            colours = {G.C.DARK_EDITION},
            bump = true,
            pop_in_rate = 99999999,
            scale = 0.65,
        })
        chip_total.config.ref_table = nil
        chip_total.config.ref_value = nil
        chip_total.UIBox:recalculate()

        return
    end

    blind_score.UIT = G.UIT.T
    blind_score.config.ref_table = G.GAME.blind
    blind_score.config.ref_value = 'chip_text'
    if blind_score.config.object then blind_score.config.object:remove() end

    chip_total.UIT = G.UIT.T
    chip_total.config.ref_table = G.GAME
    chip_total.config.ref_value = 'chips_text'
    if chip_total.config.object then chip_total.config.object:remove() end

    blind_score:juice_up()
    chip_total:juice_up()
end

local ref_blind_debuff = G.FUNCS.HUD_blind_debuff
G.FUNCS.HUD_blind_debuff = function(e)
	if e.UIBox == G.HUD_blind then return ref_blind_debuff(e) end
end


---------------------------
--------------------------- Initialization blind functions
---------------------------

function arrow_init_extra_blind(X, Y, W, H, extra_source)
	local extra_blind = Blind(X, Y, W, H)
	Moveable.init(extra_blind, X, Y, W, H)
	extra_blind.arrow_extra_blind = extra_source

	extra_blind.children = {}
	extra_blind.config = {}
	extra_blind.states.visible = false
	extra_blind.states.collide.can = false
	extra_blind.states.drag.can = false
	extra_blind.loc_debuff_lines = {'',''}

	if getmetatable(extra_blind) == Blind then
		table.insert(G.I.CARD, extra_blind)
	end

	return extra_blind
end

function Blind:extra_set_blind(blind, reset)
	if not reset then
		self.config.blind = blind
		self.name = blind.name
		self.debuff = blind.debuff
		self.dollars = G.GAME.blind.dollars
		if self.config.blind.score_invisible or G.GAME.modifiers.all_scores_hidden then
			if not G.GAME.modifiers.hide_blind_score then
				G.GAME.modifiers.hide_blind_score = true
				set_blind_score_visible(false)
			end
			if self.config.blind.score_invisible then self.triggered = true end
		else
			self.mult = blind.mult / 2
		end

		self.disabled = false
		self.discards_sub = nil
		self.hands_sub = nil
		self.boss = not not blind.boss
		self.blind_set = false
		self.triggered = nil
		self.prepped = true
		self:set_text()

		-- applying any relative mults
		G.GAME.blind.chips = G.GAME.blind.chips * self.mult
		G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
		if not G.GAME.blind.boss then
			G.GAME.blind.boss = self.boss
		end

		self.chips = G.GAME.blind.chips
		self.chip_text = G.GAME.blind.chip_text
	end

	if blind then
        self.in_blind = true
    end

	local old_main_blind = G.GAME.blind
	G.GAME.blind = self
	local obj = self.config.blind
	if not reset and obj.set_blind and type(obj.set_blind) == 'function' then
		obj:set_blind()
	elseif self.name == 'The Eye' and not reset then
		self.hands = {
			["Flush Five"] = false,
			["Flush House"] = false,
			["Five of a Kind"] = false,
			["Straight Flush"] = false,
			["Four of a Kind"] = false,
			["Full House"] = false,
			["Flush"] = false,
			["Straight"] = false,
			["Three of a Kind"] = false,
			["Two Pair"] = false,
			["Pair"] = false,
			["High Card"] = false,
		}
	elseif self.name == 'The Mouth' and not reset then
		self.only_hand = false
	elseif self.name == 'The Fish' and not reset then
		self.prepped = nil
	elseif self.name == 'The Water' and not reset then
		self.discards_sub = G.GAME.current_round.discards_left
		ease_discard(-self.discards_sub)
	elseif self.name == 'The Needle' and not reset then
		self.hands_sub = G.GAME.round_resets.hands - 1
		ease_hands_played(-self.hands_sub)
	elseif self.name == 'The Manacle' and not reset then
		G.hand:change_size(-1)
	elseif self.name == 'Amber Acorn' and not reset and #G.jokers.cards > 0 then
		G.jokers:unhighlight_all()
		for k, v in ipairs(G.jokers.cards) do
			v:flip()
		end
		if #G.jokers.cards > 1 then
			G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function()
				G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 0.85);return true end }))
				delay(0.15)
				G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 1.15);return true end }))
				delay(0.15)
				G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 1);return true end }))
				delay(0.5)
			return true end }))
		end
	end

	--add new debuffs
	for _, v in ipairs(G.playing_cards) do
		if not v.debuffed_by_blind then
			self:debuff_card(v)
		end
	end

	for _, v in ipairs(G.jokers.cards) do
		if not reset and not v.debuffed_by_blind then self:debuff_card(v, true) end
	end

	for _, v in ipairs(G.consumeables.cards) do
        if not reset and v.ability.set == 'Stand' then self:debuff_card(v, true) end
    end

	G.GAME.blind = old_main_blind
	G.GAME.blind.chips = self.chips
	G.GAME.blind.chip_text = self.chip_text
	G.GAME.blind.dollars = self.dollars
end

local ref_blind_set = Blind.set_blind
function Blind:set_blind(...)
	SMODS.hide_blind = nil
	local args = {...}
	local blind, reset = args[1], args[2]
	if self.arrow_extra_blind then
		if blind or reset then
			return self:extra_set_blind(self.config.blind, reset)
		end

		return
	end

	G.GAME.modifiers.hide_blind_score = nil
	self.newrun_flag = nil

	if blind and (blind.score_invisible or G.GAME.modifiers.all_scores_hidden) then
		G.GAME.modifiers.hide_blind_score = true
		set_blind_score_visible(false)

		if blind.score_invisible then self.triggered = true end
	end

	local ret = ref_blind_set(self, ...)
	for _, v in ipairs(G.consumeables.cards) do
        if not reset and v.ability.set == 'Stand' then self:debuff_card(v, true) end
    end

	if not reset then
		self.main_blind_disabled = nil
	end

	if not (blind or reset) then return ret end

	for _, v in ipairs(G.GAME.arrow_extra_blinds) do
		if self.config.blind ~= v.config.blind then
			v:extra_set_blind(v.config.blind, reset)
		end
	end

	return ret
end

--- reimplementation because the original has a lot of visuals for "defeat"
--- You can't "defeat" extra blinds except by selling the joker
local ref_blind_defeat = Blind.defeat
function Blind:defeat(...)
	if not self.arrow_extra_blind then self.disabled = self.main_blind_disabled end
	local ret = ref_blind_defeat(self, ...)

	if (self.config.blind.score_invisible or G.GAME.modifiers.all_scores_hidden) and G.GAME.modifiers.hide_blind_score then
		G.GAME.modifiers.hide_blind_score = nil
		set_blind_score_visible(true)
	end

	-- although this is not recursive, this check still exists for if
	-- defeat gets called by, say, the joker controlling the extra blind when sold
	if not self.arrow_extra_blind then
		self.disabled = false
		for _, v in ipairs(G.GAME.arrow_extra_blinds) do
			if self.config.blind ~= v.config.blind then
				v.chips = self.chips
				v.chip_text = number_format(self.chips)
				v.dollars = self.dollars
				G.GAME.blind = v

				for _, val in ipairs(G.jokers.cards) do
					if val.facing == 'back' then val:flip() end
				end
				local obj = v.config.blind
				if obj.defeat and type(obj.defeat) == 'function' then
					obj:defeat()
				elseif v.name == 'Crimson Heart' then
					for _, val in ipairs(G.jokers.cards) do
						val.ability.crimson_heart_chosen = nil
					end
				elseif v.name == 'The Manacle' and not v.disabled then
					G.hand:change_size(1)
				end

				self.chips = v.chips
				self.chip_text = number_format(v.chips)
				self.dollars = v.dollars
				G.GAME.blind = self
			end
		end
	end

	return ret
end

local ref_blind_disable = Blind.disable
function Blind:disable(...)
	if not self.arrow_extra_blind then
		local ret = nil
		if not self.main_blind_disabled then
			self.main_blind_disabled = not self.disabled
			ret = ref_blind_disable(self, ...)
			if (self.config.blind.score_invisible or G.GAME.modifiers.all_scores_hidden) and G.GAME.modifiers.hide_blind_score then
				G.GAME.modifiers.hide_blind_score = nil
				set_blind_score_visible(true)
			end
		end

		if self.main_blind_disabled then self.boss = false end
		self.disabled = false

		for _, v in ipairs(G.GAME.arrow_extra_blinds) do
			if self.config.blind ~= v.config.blind and not v.disabled then
				v.chips = self.chips
				v.chip_text = number_format(self.chips)
				v.dollars = self.dollars
				G.GAME.blind = v

				ref_blind_disable(v, ...)

				self.chips = v.chips
				self.chip_text = number_format(v.chips)
				self.dollars = v.dollars
				G.GAME.blind = self
			end
		end

		return ret
	end

	self.chips = G.GAME.blind.chips
	self.chip_text = number_format(G.GAME.blind.chips)
	self.dollars = G.GAME.blind.dollars
	G.GAME.blind = self

	local ret = ref_blind_disable(self, ...)

	if (self.config.blind.score_invisible or G.GAME.modifiers.all_scores_hidden) and G.GAME.modifiers.hide_blind_score then
		G.GAME.modifiers.hide_blind_score = nil
		set_blind_score_visible(true)
	end

	G.GAME.blind.chips = self.chips
	G.GAME.blind.chip_text = number_format(self.chips)
	G.GAME.blind.dollars = self.dollars
	G.GAME.blind = G.GAME.blind

	return ret
end

-- override behavior to properly manage blind types
function Blind:get_type()
	return self.arrow_extra_blind and 'Extra' or G.GAME.round_resets.effective_blind
end





---------------------------
--------------------------- Visual Blind Functions
---------------------------

local ref_blind_colour = Blind.change_colour
function Blind:change_colour(...)
	if self.arrow_extra_blind then return end

	local args = {...}
	local blind_col = args[1]

	-- redeclare these to reset table references
	if not self.newrun_flag and next(self.config.blind) and not blind_col and G.STATE ~= G.STATES.ROUND_EVAL then
		local blind = self.config.blind
		local col_primary = blind.boss_colour and blind.boss_colour.colours and blind.boss_colour or nil
        local col_special = blind.special_colour and blind.special_colour.colours and blind.special_colour or nil
        local col_tertiary = blind.tertiary_colour and blind.tertiary_colour.colours and blind.tertiary_colour or nil

		if col_primary or col_special or col_tertiary then
			G.GAME.arrow_gradient_ui = true

			if col_primary then
				local predict_primary = ArrowAPI.misc.predict_gradient(col_primary, 0.3)
				ease_colour(G.C.DYN_UI.MAIN, predict_primary)
				ease_colour(G.C.DYN_UI.BOSS_MAIN, predict_primary)
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					blockable = false,
					blocking = false,
					delay =  0.35,
					func = function()
						G.C.DYN_UI.MAIN = col_primary
						G.C.DYN_UI.BOSS_MAIN = col_primary
						return true
					end
				}))
			else
				ease_colour(G.C.DYN_UI.MAIN, blind.boss_colour)
				ease_colour(G.C.DYN_UI.BOSS_MAIN, blind.boss_colour)
			end

			if col_special then
				local predict_special = ArrowAPI.misc.predict_gradient(col_special, 0.3)
				ease_colour(G.C.DYN_UI.DARK, predict_special)
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					blockable = false,
					blocking = false,
					delay =  0.35,
					func = function()
						G.C.DYN_UI.DARK = col_special
						return true
					end
				}))
			else
				ease_colour(G.C.DYN_UI.DARK, blind.special_colour or mix_colours(col_primary, G.C.BLACK, 0.4))
			end

			if col_tertiary then
				local predict_tertiary = ArrowAPI.misc.predict_gradient(col_tertiary, 0.3)
				ease_colour(G.C.DYN_UI.DARK, predict_tertiary)
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					blockable = false,
					blocking = false,
					delay =  0.35,
					func = function()
						G.C.DYN_UI.BOSS_DARK = col_tertiary
						return true
					end
				}))
			else
				ease_colour(G.C.DYN_UI.BOSS_DARK, blind.tertiary_colour or mix_colours(col_primary, G.C.BLACK, 0.2))
			end

			-- manual recreation of UI because for some reason I have to
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				blockable = false,
				blocking = false,
				delay =  0.8,
				func = function()
					ArrowAPI.ui.manual_ui_reload(0)
					return true
				end
			}))
			return
		end
	end

	return ref_blind_colour(self, ...)
end

local ref_alert_debuff = Blind.alert_debuff
function Blind:alert_debuff(...)
	if not self.arrow_extra_blind and self.main_blind_disabled then
		self.block_play = nil
		return
	end

	return ref_alert_debuff(self, ...)
end

local ref_debuff_text = Blind.get_loc_debuff_text
function Blind:get_loc_debuff_text(...)
	if self.arrow_extra_blind then
		local old_main_blind = G.GAME.blind
		G.GAME.blind = self
		local ret = ref_debuff_text(self, ...)
		G.GAME.blind = old_main_blind
		return ret
	end

	return ref_debuff_text(self, ...)
end

local ref_blind_wiggle = Blind.wiggle
function Blind:wiggle(...)
	if self.arrow_extra_blind then
		if next(self.arrow_extra_blind) then
			card_eval_status_text(
				self.arrow_extra_blind,
				'extra',
				nil, nil, nil,
				{
					message = self.disabled and localize('k_disabled_ex') or self.loc_name,
					colour = self.disabled and G.C.FILTER or get_blind_main_colour(self.config.blind.key),
					delay = 0.8,
					volume = 0,
				}
			)
		end

		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.06*G.SETTINGS.GAMESPEED,
			blockable = false,
			blocking = false,
			func = function()
				play_sound('tarot2', 0.76, 0.4);
				return true
				end
			}))
		play_sound('tarot2', 1, 0.4)
		return
	end

	return ref_blind_wiggle(self, ...)
end

local ref_blind_juice = Blind.juice_up
function Blind:juice_up(...)
	if self.arrow_extra_blind and next(self.arrow_extra_blind) then
		card_eval_status_text(
			self.arrow_extra_blind,
			'extra',
			nil, nil, nil,
			{
				message = self.disabled and localize('k_disabled_ex') or self.loc_name,
				colour = self.disabled and G.C.FILTER or get_blind_main_colour(self.config.blind.key),
				delay = 0.8,
				volume = 0,
			}
		)
		return
	end

	return ref_blind_juice(self, ...)
end

local ref_blind_hover = Blind.hover
function Blind:hover(...)
	if self.arrow_extra_blind then return end
	return ref_blind_hover(self, ...)
end

local ref_blind_stop_hover = Blind.stop_hover
function Blind:stop_hover(...)
    if self.arrow_extra_blind then return end
	return ref_blind_stop_hover(self, ...)
end

local ref_blind_draw = Blind.draw
function Blind:draw(...)
	if self.arrow_extra_blind then return end
	return ref_blind_draw(self, ...)
end

local ref_blind_move = Blind.move
function Blind:move(...)
	if self.arrow_extra_blind then return end
	return ref_blind_move(self, ...)
end

local ref_blind_dims = Blind.change_dim
function Blind:change_dim(...)
	if self.arrow_extra_blind then return end
	return ref_blind_dims(self, ...)
end




---------------------------
--------------------------- Debuff functions
---------------------------

--- press_play() main functionality is handled with a lovely patch
local ref_blind_play = Blind.press_play
function Blind:press_play(...)
	if not self.arrow_extra_blind then
		self.disabled = self.main_blind_disabled
		self.main_play_loop = true
		return ref_blind_play(self, ...)
	end

	local old_main_blind = G.GAME.blind
	self.chips = old_main_blind.chips
	self.chip_text = number_format(old_main_blind.chips)
	self.dollars = old_main_blind.dollars
	G.GAME.blind = self

	local ret = ref_blind_play(self, ...)

	old_main_blind.chips = self.chips
	old_main_blind.chip_text = number_format(self.chips)
	old_main_blind.dollars = self.dollars
	G.GAME.blind = old_main_blind

	if ret and next(self.arrow_extra_blind) then
		local juice_obj = self.arrow_extra_blind
		G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			func = function()
				attention_text({
					text = self.disabled and localize('k_disabled_ex') or self.loc_name,
					scale = 1,
					hold = 0.45,
					backdrop_colour = self.disabled and G.C.FILTER or get_blind_main_colour(self.config.blind.key),
					align = 'bm',
					major = juice_obj,
					offset = { x = 0, y = 0.05*juice_obj.T.h}
				})
				if juice_obj.juice_up then juice_obj:juice_up() end
				play_sound('generic1', (0.9 + 0.2*math.random())*0.2 + 0.8, 1)
				return true
			end
		}))
	end

	return ret
end

--- modify_hand() main functionality is taken care of within a lovely patch
local ref_blind_modify = Blind.modify_hand
function Blind:modify_hand(...)
	if not self.arrow_extra_blind then
		self.disabled = self.main_blind_disabled
		local mult, chips, hand_chips = ref_blind_modify(self, ...)
		if not self.main_play_loop then
			self.disabled = false
		end
		return mult, chips, hand_chips
	end

	local old_main_blind = G.GAME.blind
	self.chips = old_main_blind.chips
	self.chip_text = number_format(old_main_blind.chips)
	self.dollars = old_main_blind.dollars
	G.GAME.blind = self

	local mult, chips, hand_chips = ref_blind_modify(self, ...)

	old_main_blind.chips = self.chips
	old_main_blind.chip_text = number_format(self.chips)
	old_main_blind.dollars = self.dollars
	G.GAME.blind = old_main_blind

	if ((self.config.blind.modify_hand and type(self.config.blind.modify_hand) == 'function')
	or self.config.blind.name == 'The Flint') and next(self.arrow_extra_blind) then
		local juice_obj = self.arrow_extra_blind
		G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			func = function()
				attention_text({
					text = self.disabled and localize('k_disabled_ex') or self.loc_name,
					scale = 1,
					hold = 0.45,
					backdrop_colour = self.disabled and G.C.FILTER or get_blind_main_colour(self.config.blind.key),
					align = 'bm',
					major = juice_obj,
					offset = { x = 0, y = 0.05*juice_obj.T.h}
				})
				if juice_obj.juice_up then juice_obj:juice_up() end
				play_sound('generic1', (0.9 + 0.2*math.random())*0.2 + 0.8, 1)
				return true
			end
		}))
	end

	return mult, chips, hand_chips
end

local ref_blind_hand = Blind.debuff_hand
function Blind:debuff_hand(...)
	if not self.arrow_extra_blind then self.disabled = self.main_blind_disabled end
	local ret = ref_blind_hand(self, ...)
	local extra_ret = nil

	if not self.arrow_extra_blind then
		if not self.main_play_loop then
			self.disabled = false
		end

		local old_text = SMODS.debuff_text
		local old_source = SMODS.hand_debuff_source
		for _, v in ipairs(G.GAME.arrow_extra_blinds) do
			if self.config.blind ~= v.config.blind then
				v.chips = self.chips
				v.chip_text = number_format(self.chips)
				v.dollars = self.dollars
				G.GAME.blind = v

				local v_ret = ref_blind_hand(v, ...)

				if v_ret then
					v.arrow_extra_boss_throw_hand = true
				end

				if not extra_ret and v_ret then
					extra_ret = v_ret
				end

				self.chips = v.chips
				self.chip_text = number_format(v.chips)
				self.dollars = v.dollars
				G.GAME.blind = self
			end
		end

		-- these are reset to always prioritize a debuff from the main blind
		if old_text then SMODS.debuff_text = old_text end
		if old_source then SMODS.hand_debuff_source = old_source end
	end

	return (ret or extra_ret), (extra_ret and not ret)
end


local ref_blind_drawn = Blind.drawn_to_hand
function Blind:drawn_to_hand(...)
	if not self.arrow_extra_blind then self.disabled = self.main_blind_disabled end
	local ret = ref_blind_drawn(self, ...)


	if not self.arrow_extra_blind then
		self.disabled = false
		self.main_play_loop = nil
		for _, v in ipairs(G.GAME.arrow_extra_blinds) do
			if self.config.blind ~= v.config.blind then
				v.chips = self.chips
				v.chip_text = number_format(self.chips)
				v.dollars = self.dollars
				G.GAME.blind = v

				ref_blind_drawn(v, ...)

				self.chips = v.chips
				self.chip_text = number_format(v.chips)
				self.dollars = v.dollars
				G.GAME.blind = self
			end
		end
		G.GAME.blind = self
	end

	return ret
end

local ref_blind_flipped = Blind.stay_flipped
function Blind:stay_flipped(...)
	if not self.arrow_extra_blind then self.disabled = self.main_blind_disabled end
	local ret = ref_blind_flipped(self, ...)

	if not self.arrow_extra_blind then
		if not self.main_play_loop then
			self.disabled = false
		end

		for _, v in ipairs(G.GAME.arrow_extra_blinds) do
			if self.config.blind ~= v.config.blind then
				v.chips = self.chips
				v.chip_text = number_format(self.chips)
				v.dollars = self.dollars
				G.GAME.blind = v

				local extra_ret = ref_blind_flipped(v, ...)

				if not ret and extra_ret and extra_ret == true then
					ret = extra_ret
				end

				self.chips = v.chips
				self.chip_text = number_format(v.chips)
				self.dollars = v.dollars
				G.GAME.blind = self
			end
		end
	end

	return ret
end

local ref_blind_debuff = Blind.debuff_card
function Blind:debuff_card(...)
	if not self.arrow_extra_blind then self.disabled = self.main_blind_disabled end
	local ret = ref_blind_debuff(self, ...)

	if not self.arrow_extra_blind then
		self.disabled = false
		local args = {...}
		local card = args[1]
		if not card.debuffed_by_blind then
			for _, v in ipairs(G.GAME.arrow_extra_blinds) do
				if self.config.blind ~= v.config.blind then
					v.chips = self.chips
					v.chip_text = number_format(self.chips)
					v.dollars = self.dollars
					G.GAME.blind = v

					ref_blind_debuff(v, ...)

					self.chips = v.chips
					self.chip_text = number_format(v.chips)
					self.dollars = v.dollars
					G.GAME.blind = self

					if card.debuffed_by_blind then
						break
					end
				end
			end
		end
	end

	return ret
end





---------------------------
--------------------------- Saving and Loading Functions
---------------------------

--- this feels like it's going to get me killed
local ref_blind_save = Blind.save
function Blind:save(...)
	local ret = ref_blind_save(self, ...)

	ret.main_blind_disabled = self.main_blind_disabled

	if self.arrow_extra_blind then
		ret.arrow_extra_blind = (self.arrow_extra_blind.is and self.arrow_extra_blind:is(Blind) and self.arrow_extra_blind.config.blind.key) or self.arrow_extra_blind.unique_val or true
		ret.dollars = nil
	end

	local obj = self.config.blind
	if obj.save and type(obj.save) == 'function' then
		obj:save(ret)
	end

	return ret
end

local ref_blind_load = Blind.load
function Blind:load(blindTable)
	if not self.arrow_extra_blind then
		local ret = ref_blind_load(self, blindTable)

		if (self.config.blind.score_invisible or G.GAME.modifiers.all_scores_hidden) and G.GAME.modifiers.hide_blind_score then
			set_blind_score_visible(false)
			if self.config.blind.score_invisible then self.triggered = true end
		end

		local obj = self.config.blind
		if self.in_blind and obj.load and type(obj.load) == 'function' then
			obj:load(blindTable)
		end

		return ret
	end

	self.in_blind = blindTable.in_blind
	self.config.blind = G.P_BLINDS[blindTable.config_blind] or {}

	self.effect = blindTable.effect
    self.name = blindTable.name
    self.debuff = blindTable.debuff
    self.mult = blindTable.mult
    self.disabled = blindTable.disabled
	self.main_blind_disabled = blindTable.main_blind_disabled
    self.discards_sub = blindTable.discards_sub
    self.hands_sub = blindTable.hands_sub
    self.boss = blindTable.boss
    self.hands = blindTable.hands
    self.only_hand = blindTable.only_hand
    self.triggered = blindTable.triggered
	self:set_text()

	if (self.config.blind.score_invisible or G.GAME.modifiers.all_scores_hidden) and G.GAME.modifiers.hide_blind_score then
		set_blind_score_visible(false)
		if self.config.blind.score_invisible then self.triggered = true end
	end

	local obj = self.config.blind
	if self.in_blind and obj.load and type(obj.load) == 'function' then
		obj:load(blindTable)
	end
end


---------------------------
--------------------------- Check for card added behavior
---------------------------

function Blind:card_added(card)
	local obj = self.config.blind
	if obj.card_added and type(obj.card_added) == 'function' then
        obj:card_added(card)
	end
end


---------------------------
--------------------------- Ensure blinds are removed from G.I.CARD to prevent memor leak/weirdness
--------------------------- Vanilla only ever creates one blind object
---------------------------

function Blind:remove()
	for k, v in pairs(G.I.CARD) do
        if v == self then
            table.remove(G.I.CARD, k)
        end
    end
    Moveable.remove(self)
end