local consumInfo = {
    name = 'Metallica',
    set = 'Stand',
    config = {
        aura_colors = { 'F97C87DA', 'CE3749DA' }, 
        stand_overlay = true,
    },
    cost = 4,
    rarity = 'StandRarity',
    alerted = true,
    hasSoul = true,
    in_progress = true,
    part = 'vento',
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
end

function consumInfo.add_to_deck(self, card)
    set_consumeable_usage(card)
end

function consumInfo.calculate(self, card, context)

end

function consumInfo.can_use(self, card)
    return false
end

function consumInfo.draw(self,card,layer)

end


return consumInfo