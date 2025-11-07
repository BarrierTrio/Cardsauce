local ref_set_ability = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
    local ret = ref_set_ability(self, center, initial, delay_sprites)

    if self.ability.set == 'Stand' then
        ArrowAPI.stands.set_stand_sprites(self)
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
        SMODS.calculate_context({removed_card = self})
        self.getting_sliced = was_getting_sliced
    end

    return ret
end
