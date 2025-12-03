local consumInfo = {
    name = 'Black Spine',
    set = "VHS",
    runtime = 1,
    cost = 3,
    nosleeve = true,
    config = {},
    origin = {
        category = 'rlm',
        sub_origins = {
            'rlm_bs',
        },
        custom_color = 'rlm'
    },
    artist = 'BarrierTrio/Gote'
}

function consumInfo.activate(self, card, on)
    G.GAME.banned_keys[card.config.center.key] = true
    local key = pseudorandom_element(get_current_pool('VHS', nil, nil, 'blackspine'), pseudoseed('blackspine'))
    local it = 1
    while key == 'UNAVAILABLE' do
        it = it + 1
        key = pseudorandom_element(get_current_pool('VHS', nil, nil, 'blackspine'), pseudoseed('blackspine_resample'..it))
    end
    G.GAME.banned_keys[card.config.center.key] = nil
    ArrowAPI.game.transform_card(card, key)
end

return consumInfo