local tagInfo = {
    name = 'Corrupted Tag',
    atlas = 'tags',
    config = {type = 'store_joker_modify', edition = 'csau_corrupted', odds = 3},
    alerted = true,
    csau_dependencies = {
        'enableVinnyContent',
        'enableEditions',
    },
    artist = 'BarrierTrio/Gote'
}

tagInfo.apply = function(self, tag, context)
    if context.type == self.config.type then
        local applied = nil
        if context.card and not context.card.edition and not context.card.temp_edition and context.card.ability.set == 'Joker' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true

            context.card.temp_edition = true
            tag:yep('+', G.C.DARK_EDITION, function()
                context.card:set_edition({csau_corrupted = true}, true)
                context.card.ability.couponed = true
                context.card:set_cost()
                context.card.temp_edition = nil
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            applied = true

            tag.triggered = true
        end
        return applied
    end
end

return tagInfo