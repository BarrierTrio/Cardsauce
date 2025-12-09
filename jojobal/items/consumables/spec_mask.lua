local consumInfo = {
    name = 'Stone Mask',
    set = "Spectral",
    cost = 4,
    alerted = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'phantom',
        },
        custom_color = 'phantom'
    },
    artist = 'Vivian Giacobbi',
    programmer = 'Vivian Giacobbi'
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.e_holo
    info_queue[#info_queue+1] = {key = 'eternal', set = 'Other'}
end

function consumInfo.use(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
        func = (function()
            local randomcard = pseudorandom_element(G.jokers.cards, pseudoseed('stonemask'))
            card.ability.perishable = false
            randomcard:set_eternal(true)
            randomcard:set_edition({holo = true}, true)
            card:juice_up(0.3, 0.5)
            play_sound('gold_seal')
            return true
        end)
    }))
    delay(0.6)
end

function consumInfo.can_use(self, card)
    if not G.jokers then
       return false
    end

    return #G.jokers.cards > 0
end

return consumInfo