local consumInfo = {
    name = 'Moody Blues',
    set = 'csau_Stand',
    config = {
        aura_colors = { 'a3f2d7DC', '4fedd0DC' },
        stand_mask = true,
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    part = 'vento',
    in_progress = true,
    csau_dependencies = {
        'enableVHSs'
    }
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.dolos } }
end

function consumInfo.add_to_deck(self, card)
    for i, v in ipairs(G.consumeables.cards) do
        if v.ability.set == "VHS" and (v.ability.extra and v.ability.extra.runtime) then
            v.ability.extra.runtime = v.ability.extra.runtime * 2
        end
    end
end

function consumInfo.remove_from_deck(self, card)
    for i, v in ipairs(G.consumeables.cards) do
        if v.ability.set == "VHS" and (v.ability.extra and v.ability.extra.runtime) then
            v.ability.extra.runtime = v.ability.extra.runtime / 2
        end
    end
end

function consumInfo.can_use(self, card)
    return false
end

return consumInfo