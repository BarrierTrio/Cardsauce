local consumInfo = {
    name = 'Paper Moon King',
    set = 'Stand',
    config = {
        aura_colors = { 'afb5b1DC', '4a7e38DC' },
        aura_hover = true,
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'lion',
        },
        custom_color = 'lion'
    },
    blueprint_compat = false,
    artist = 'gote',
}

function consumInfo.loc_vars(self, info_queue, card)
    return {vars = {(G.GAME and G.GAME.current_round and G.GAME.current_round.jojobal_paper_rank) or 'Jack'}}
end

return consumInfo