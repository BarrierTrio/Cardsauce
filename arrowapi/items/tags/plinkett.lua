local tagInfo = {
    name = 'Plinkett Tag',
    atlas = 'tags',
    pos = {x = 4, y = 0},
    config = {type = 'new_blind_choice'},
    origin = {
        category = 'rlm',
        sub_origins = {
            'rlm_p',
        },
        custom_color = 'rlm',
    },
    artist = 'BarrierTrio/Gote',
    programmer = 'Kekulism',
    requires_type = 'VHS',
}

function tagInfo.in_pool(self, args)
    return ArrowAPI.loading.consumeable_has_items('VHS')
end

function tagInfo.apply(self, tag, context)
    if context.type == self.config.type then
        tag:yep('+', G.C.VHS,function()
            local key = 'p_arrow_analog4'
            local card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
                    G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[key], {bypass_discovery_center = true, bypass_discovery_ui = true})
            card.cost = 0
            card.from_tag = true
            G.FUNCS.use_card({config = {ref_table = card}})
            card:start_materialize()
            G.CONTROLLER.locks[tag.ID] = nil
            return true
        end)
        self.triggered = true
        return true
    end
end

return tagInfo