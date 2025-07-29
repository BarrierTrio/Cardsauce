local tagInfo = {
    name = 'Plinkett Tag',
    config = {type = 'new_blind_choice'},
    csau_dependencies = {
        'enableVHSs',
    }
}

function tagInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } }
end

function tagInfo.apply(self, tag, context)
    if context.type == self.config.type then
        sendDebugMessage('state: '..tostring(G.STATE))
        local lock = tag.ID
        G.CONTROLLER.locks[tag.ID] = true
        tag:yep('+', G.C.VHS, function()
            local booster = SMODS.create_card { key = 'p_csau_analog4', area = G.play }
            booster.T.x = G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2
            booster.T.y = G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2
            booster.T.w = G.CARD_W * 1.27
            booster.T.h = G.CARD_H * 1.27
            booster.cost = 0
            booster.from_tag = true
            G.FUNCS.use_card({config = {ref_table = booster}})
            booster:start_materialize()
            G.CONTROLLER.locks[lock] = nil
            return true
        end)
        tag.triggered = true
        return true
    end
end

return tagInfo