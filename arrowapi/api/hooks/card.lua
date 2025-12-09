---------------------------
--------------------------- Maggie Quips
---------------------------

function Card:add_quip(text_key, align, loc_vars, extra)
    if self.children.quip then
        self.children.quip:remove()
    end

    self.children.quip = UIBox{
        definition = G.UIDEF.jok_speech_bubble(text_key, loc_vars, extra),
        config = { align = align or 'bm', offset = { x=0, y=0 }, parent = self}
    }
    self.children.quip:set_role{
        major = self,
        role_type = 'Minor',
        xy_bond = 'Weak',
        r_bond = 'Weak',
    }
    self.children.quip.states.visible = false
end

function Card:remove_quip()
    if self.children.quip then
        self.children.quip:remove()
        self.children.quip = nil
    end
end

function Card:say_quip(iter, not_first, def_speed, voice)
    -- cancel this quip once the iteration ends
    if iter <= 0 then
        self.talking = false
        return
    end

    local speed = (not def_speed and G.SPEEDFACTOR) or 1
    local delay_mult = def_speed and G.SPEEDFACTOR or 1
    self.talking = true

    if not not_first then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1 * delay_mult,
            func = function()
                if self.children.quip then
                    self.children.quip.states.visible = true
                end
                self:say_quip(iter, true, def_speed)
            return true
        end}))
        return
    end

    local new_said = math.random(1, 10)
    if self.last_said and new_said >= self.last_said then
        new_said = new_said + 1
    end
    self.last_said = new_said

    if voice and SMODS.Sound[voice] then
        SMODS.Sound[voice]:play(1, (G.SETTINGS.SOUND.volume/100.0) * (G.SETTINGS.SOUND.game_sounds_volume/50.0), true);
    else
        play_sound('voice'..new_said, speed * (math.random() * 0.2 + 1), 0.5)
    end

    self:juice_up()
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        blockable = false,
        blocking = false,
        delay = 0.13 * delay_mult,
        func = function()
            self:say_quip(iter-1, true, def_speed)
        return true
    end}), 'tutorial')
end





---------------------------
--------------------------- General ability stuff
---------------------------

local ref_set_ability = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
    local ret = ref_set_ability(self, center, initial, delay_sprites)

    if self.ability.set == 'Stand' then
        ArrowAPI.stands.set_stand_sprites(self)
    end

    if self.ability.set == 'VHS' then
        self.ability.activation = true
        self.ability.activated = false
        self.ability.destroyed = false
        self.ability.runtime = center.runtime or 3
        self.ability.uses = 0
    end

    return ret
end





---------------------------
--------------------------- Stand visual loading
---------------------------

local ref_card_load = Card.load
function Card:load(cardTable, other_card)
    local ret = ref_card_load(self, cardTable, other_card)

    if self.ability.set == 'Stand' then
        ArrowAPI.stands.set_stand_sprites(self)
    end

    return ret
end





---------------------------
--------------------------- For stand auras in the collection
---------------------------

local ref_card_hover = Card.hover
function Card:hover(...)
    if ArrowAPI.col_stand_hover and ArrowAPI.col_stand_hover ~= self then
        ArrowAPI.col_stand_hover.ability.aura_flare_queued = nil
        ArrowAPI.col_stand_hover.ability.stand_activated = nil
        ArrowAPI.col_stand_hover = nil
    end

    if self.ability.aura_hover or (self.area and (self.area.config.collection or self.area == G.pack_cards) and self.ability.set == 'Stand') then
        ArrowAPI.col_stand_hover = self
        self.ability.aura_flare_queued = true
    end

    local ret = ref_card_hover(self, ...)
    if self.facing == 'back' and self.area and self.area == G.deck and (not self.states.drag.is or G.CONTROLLER.HID.touch)
    and not self.no_ui and not G.debug_tooltip_toggle and G.GAME.selected_back.effect.center.artist then
        self.config.h_popup = G.UIDEF.deck_artist_popup(G.GAME.selected_back.effect.center)
        self.config.h_popup_config = {align = 'cl', offset = {x=-0.1, y=0}, parent = self}
        Node.hover(self)
    end

    return ret
end

local ref_card_stop_hover = Card.stop_hover
function Card:stop_hover()
    if self.ability.aura_hover or (self.area and (self.area.config.collection or self.area == G.pack_cards) and self.ability.set == 'Stand') then
        self.ability.aura_flare_queued = nil
        self.ability.stand_activated = nil
    end

    return ref_card_stop_hover(self)
end

function love.focus(f)
    if not f then return end

    if ArrowAPI.col_stand_hover then
        ArrowAPI.col_stand_hover.ability.aura_flare_queued = nil
        ArrowAPI.col_stand_hover.ability.stand_activated = nil
        ArrowAPI.col_stand_hover = nil
    end
end





---------------------------
--------------------------- Card destruction calc context
---------------------------

local ref_card_dissolve = Card.start_dissolve
function Card:start_dissolve(...)
    local ret = ref_card_dissolve(self, ...)

    if self.area then
        local was_getting_sliced = self.getting_sliced
        self.getting_sliced = nil
        SMODS.calculate_context({removed_card = self, getting_sliced = was_getting_sliced})
        self.getting_sliced = was_getting_sliced
    end

    return ret
end





---------------------------
--------------------------- Add deck crediting
---------------------------

local ref_card_sprites = Card.set_sprites
function Card:set_sprites(center, front)
    local ret = ref_card_sprites(self, center, front)

    if front and G.SETTINGS.CUSTOM_DECK.Collabs[front.suit]
    and SMODS.DeckSkins[G.SETTINGS.CUSTOM_DECK.Collabs[front.suit]] then
        local deckSkin = SMODS.DeckSkins[G.SETTINGS.CUSTOM_DECK.Collabs[front.suit]]
        if deckSkin.outdated then return ret end
        local palette = deckSkin.palette_map and deckSkin.palette_map[G.SETTINGS.colour_palettes[front.suit] or ''] or (deckSkin.palettes or {})[1]
        self.artist = type(palette.artist) == 'table' and palette.artist[front.value] or palette.artist
    end
end





---------------------------
--------------------------- Eternal bypass
---------------------------

local ref_card_eternal = Card.set_eternal
function Card:set_eternal(_eternal)
    if not ArrowAPI.eternal_compat_bypass then
        return ref_card_eternal(self, _eternal)
    end

    self.ability.eternal = nil
    if not self.ability.perishable then
        self.ability.eternal = _eternal
    end
end





---------------------------
--------------------------- Tonsmith highlight behavior
---------------------------

local ref_card_highlight = Card.highlight
function Card:highlight(is_higlighted)
    if not self.params or not self.params.tnsmi_soundpack then
        return ref_card_highlight(self, is_higlighted)
    end

    self.highlighted = is_higlighted
    if self.highlighted and self.area then
        -- unhighlight all other cards even in different cardareas
        -- so you can only highlight one "available" card at once
        for _, pack_area in ipairs(TNSMI.cardareas) do
            for _, v in ipairs(pack_area.highlighted) do
                if v ~= self then
                    pack_area:remove_from_highlighted(v)
                end
            end
        end

        self.children.use_button = UIBox{
            definition = G.UIDEF.tnsmi_soundpack_button(self),
            config = {align = "bmi", offset = {x=0,y=0.5}, parent = self}
        }
    elseif self.children.use_button then
        self.children.use_button:remove()
        self.children.use_button = nil
    end
end
