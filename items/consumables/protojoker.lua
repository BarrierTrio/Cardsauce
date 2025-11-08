local consumInfo = {
    name = 'Protojoker',
    set = "Spectral",
    cost = 4,
    alerted = true,
    hidden = true,
    soul_rate = 0.003,
    soul_set = "Joker",
    streamer = 'vinny',
    csau_dependencies = {
        'enableVinnyContent',
    },
    artist = 'Lyman (JankJonklers)',
}

function consumInfo.use(self, card, area, copier)
    check_for_unlock({ type = "activate_protojoker" })
    for i = 1, #G.jokers.cards do
        if containsString(G.jokers.cards[i].ability.name, "Joker") and not G.jokers.cards[i].getting_sliced then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                G.FUNCS.csau_transform_card(G.jokers.cards[i], 'j_csau_chad')
                return true end
            }))
        end
    end
end

function consumInfo.draw(self,card,layer)
    if card.area and card.area.config.collection and not self.discovered then
        return
    end

    if not G.chadley_scarf then
        G.chadley_scarf = Sprite(0, 0, G.CARD_W, G.CARD_H, G.ASSET_ATLAS["csau_protojoker"], { x = 1, y = 0 })
    end
    local scale_mod = 0.05 + 0.05*math.sin(1.8*G.TIMERS.REAL) + 0.07*math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL))*math.pi*14)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^3
    local rotate_mod = 0.1*math.sin(1.219*G.TIMERS.REAL) + 0.07*math.sin((G.TIMERS.REAL)*math.pi*5)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^2

    G.chadley_scarf.role.draw_major = card
    G.chadley_scarf:draw_shader('dissolve',0, nil, nil, card.children.center,scale_mod, rotate_mod,nil, 0.1 + 0.03*math.sin(1.8*G.TIMERS.REAL),nil, 0.6)
    G.chadley_scarf:draw_shader('dissolve', nil, nil, nil, card.children.center, scale_mod, rotate_mod)
end

function consumInfo.can_use(self, card)
    for i = 1, #G.jokers.cards do
        if containsString(G.jokers.cards[i].ability.name, "Joker") then
            return true
        end
    end
end

return consumInfo