local consumInfo = {
    name = 'Black Spine',
    set = "VHS",
    cost = 3,
    nosleeve = true,
    config = {
        use_activate = true,
        extra = {
            runtime = 1
        }
    },
    origin = {
        'rlm',
        'rlm_bs',
        color = 'rlm'
    }
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } }
end

function consumInfo.activate(self, card, on)
    G.GAME.banned_keys[card.config.center.key] = true
    local key = pseudorandom_element(get_current_pool('VHS', nil, nil, 'blackspine'), pseudoseed('blackspine'))
    local it = 1
    while key == 'UNAVAILABLE' do
        it = it + 1
        key = pseudorandom_element(get_current_pool('VHS', nil, nil, 'blackspine'), pseudoseed('blackspine_resample'..it))
    end
    G.GAME.banned_keys[card.config.center.key] = nil
    G.FUNCS.csau_transform_card(card, key)
end

function consumInfo.can_use(self, card)
    if to_big(#G.consumeables.cards) < to_big(G.consumeables.config.card_limit) or card.area == G.consumeables then return true end
end

return consumInfo