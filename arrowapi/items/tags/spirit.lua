local tagInfo = {
    name = 'Spirit Tag',
    atlas = 'tags',
    pos = {x = 3, y = 0},
    config = {type = 'immediate'},
    origin = 'jojo',
    artist = 'BarrierTrio/Gote',
    programmer = 'Kekulism',
    requires_type = 'Stand',
}

function tagInfo.in_pool(self, args)
    return ArrowAPI.loading.consumeable_has_items('Stand')
end

function tagInfo.loc_vars(self, info_queue, card)
    if G.GAME.modifiers.unlimited_stands then
        info_queue[#info_queue+1] = {key = "stand_info_unlimited", set = "Other"}
    else
        info_queue[#info_queue+1] = {key = "stand_info", set = "Other", vars = { G.GAME.modifiers.max_stands or 1, ((G.GAME.modifiers.max_stands and G.GAME.modifiers.max_stands > 1) and localize('b_stand_cards') or localize('k_stand')) }}
    end
end

function tagInfo.apply(self, tag, context)
    if context.type == self.config.type then
        tag:yep('+', G.C.STAND,function()
            if (G.GAME.modifiers.unlimited_stands and G.consumeables.config.card_limit > #G.consumeables.cards) or (ArrowAPI.stands.get_num_stands() < G.GAME.modifiers.max_stands) then
                ArrowAPI.stands.new_stand(false)
            end
            return true
        end)
        tag.triggered = true
        return true
    end
end

return tagInfo