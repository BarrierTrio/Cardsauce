local consumInfo = {
    name = 'Moody Blues',
    set = 'Stand',
    config = {
        aura_colors = { 'a3f2d7DC', '4fedd0DC' },
        stand_mask = true,
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'vento',
        },
        custom_color = 'vento'
    },
    artist = 'Dolos',
    programmer = 'Kekulism'
}

function consumInfo.add_to_deck(self, card)
    for _, v in ipairs(G.I.CARD) do
        if v.ability and v.ability.set == "VHS" and (v.ability.extra and v.ability.extra.runtime) then
            v.ability.extra.runtime = v.ability.extra.runtime * 2
            ArrowAPI.stands.flare_aura(card, 0.38)
        end
    end
end

function consumInfo.remove_from_deck(self, card)
    for _, v in ipairs(G.I.CARD) do
        if v.ability and v.ability.set == "VHS" and (v.ability.extra and v.ability.extra.runtime) then
            v.ability.extra.runtime = v.ability.extra.runtime / 2
        end
    end
end


return consumInfo