local tagInfo = {
    name = 'Spirit Tag',
    config = {type = 'immediate'},
    alerted = true,
    csau_dependencies = {
        'enableStands',
    }
}

tagInfo.loc_vars = function(self, info_queue, card)
    if G.GAME.modifiers.csau_unlimited_stands then
        info_queue[#info_queue+1] = {key = "stand_info_unlimited", set = "Other"}
    else
        info_queue[#info_queue+1] = {key = "stand_info", set = "Other", vars = { G.GAME.modifiers.max_stands or 1, ((G.GAME.modifiers.max_stands and G.GAME.modifiers.max_stands > 1) and localize('b_stand_cards') or localize('k_stand')) }}
    end
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.keku } }
end

tagInfo.apply = function(self, tag, context)
    if context.type == self.config.type then
        if G.consumeables.config.card_limit <= #G.consumeables.cards or (not G.GAME.modifiers.csau_unlimited_stands and G.FUNCS.csau_get_num_stands() >= G.GAME.modifiers.max_stands) then
            tag:nope()
        else
            tag:yep('+', G.C.STAND,function()
                G.FUNCS.csau_new_stand(false)
                return true
            end)
        end

        tag.triggered = true
        return true
    end
end

return tagInfo