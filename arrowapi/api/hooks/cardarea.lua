---------------------------
--------------------------- Hook for extra blinds
---------------------------

local ref_cardarea_highlighted = CardArea.parse_highlighted
function CardArea:parse_highlighted(...)
    for k, v in pairs(G.GAME.arrow_extra_blinds) do
        v.arrow_extra_boss_throw_hand = nil
    end

    return ref_cardarea_highlighted(self, ...)
end





---------------------------
--------------------------- Tonsmith cardarea behaviors
---------------------------

local ref_cardarea_canhighlight = CardArea.can_highlight
function CardArea:can_highlight(card)
    -- the default balatro object cant be highlighted or rearranged
    return (self.config.type == 'soundpack' and card.params.tnsmi_soundpack ~= 'sp_balatro') or ref_cardarea_canhighlight(self, card)
end

local ref_cardarea_align = CardArea.align_cards
function CardArea:align_cards()
    if self.config.type ~= 'soundpack' then
        return ref_cardarea_align(self)
    end

    -- the entire purpose of this is so cards on the soundpack menu immediately
    -- snap into place when something changes
    -- EXCEPT when dragging in the priority area
    local smooth_align = false
    for k, card in ipairs(self.cards) do
        if G.CONTROLLER.dragging.target == card then
            smooth_align = true
        end

        if not card.states.drag.is then
            card.T.r = 0.1*(-#self.cards/2 - 0.5 + k)/(#self.cards)+ (G.SETTINGS.reduced_motion and 0 or 1)*0.02*math.sin(2*G.TIMERS.REAL+card.T.x)
            local max_cards = math.max(#self.cards, self.config.temp_limit)
            card.T.x = self.T.x + (self.T.w-self.card_w)*((k-1)/math.max(max_cards-1, 1) - 0.5*(#self.cards-max_cards)/math.max(max_cards-1, 1)) + 0.5*(self.card_w - card.T.w)

            if #self.cards > 1 then
                card.T.x = self.T.x + (self.T.w-self.card_w)*((k-1)/(#self.cards-1)) + 0.5*(self.card_w - card.T.w)
            else
                card.T.x = self.T.x + self.T.w/2 - self.card_w/2 + 0.5*(self.card_w - card.T.w)
            end

            card.T.y = self.T.y + self.T.h/2 - card.T.h/2 - (card.highlighted and G.HIGHLIGHT_H/2 or 0) + (G.SETTINGS.reduced_motion and 0 or 1)*0.03*math.sin(0.666*G.TIMERS.REAL+card.T.x)
            card.T.x = card.T.x + card.shadow_parrallax.x/30
        end
    end

    if not smooth_align then
        for k, card in ipairs(self.cards) do
            if not card.states.drag.is then
                card.VT.x = card.T.x
            end
        end
    end

    -- this sort essentially pins the default balatro card always to the left, since if you want something lower priority than
    -- default balatro sound, it should just be unloaded
    table.sort(self.cards, function (a, b)
        if a.params.tnsmi_soundpack == 'sp_balatro' and b.params.tnsmi_soundpack ~= 'sp_balatro' then return true
        elseif b.params.tnsmi_soundpack == 'sp_balatro' and a.params.tnsmi_soundpack ~= 'sp_balatro' then return false
        else return a.T.x + a.T.w/2 < b.T.x + b.T.w/2 end
    end)
end

local ref_cardarea_ranks = CardArea.set_ranks
function CardArea:set_ranks()
    if self.config.type ~= 'soundpack' then
        return ref_cardarea_ranks(self)
    end

    -- prevents the default balatro object from being dragged
    for k, card in ipairs(self.cards) do
        card.rank = k
        card.states.collide.can = true
        card.states.drag.can = card.params.tnsmi_soundpack ~= 'sp_balatro'
    end
end

-- this hook is needed because the drawing code for cardareas doesn't
-- allow drawing for unspecified types
-- so this is the drawing definition for cards of the new soundpack type
local ref_cardarea_draw = CardArea.draw
function CardArea:draw()
    if self.config.type ~= 'soundpack' then
        return ref_cardarea_draw(self)
    end

    self:draw_boundingrect()
    add_to_drawhash(self)

    for k, v in ipairs({'shadow', 'card'}) do
        local defer = {}
        for i = 1, #self.cards do
            if self.cards[i] ~= G.CONTROLLER.focused.target and self.cards[i] ~= G.CONTROLLER.dragging.target then
                if self.cards[i].highlighted then
                    defer[#defer+1] = i
                else
                    self.cards[i]:draw(v)
                end
            end
        end

        for i = 1, #defer do
            self.cards[defer[i]]:draw(v)
        end
    end
end