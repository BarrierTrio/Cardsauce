local consumInfo = {
    name = 'Troll 2',
    key = 'troll2',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        activated = false,
        destroyed = false,
        extra = {
            runtime = 3,
            uses = 0
        }
    },
    origin = 'vinny',
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'yunkie101'
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_stone
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    return { vars = { card.ability.extra.runtime-card.ability.extra.uses } }
end

function consumInfo.calculate(self, card, context)
    if card.ability.activated and context.before and not card.debuff and not context.blueprint then
        local eligable_cards = {}
        for i, v in ipairs(G.hand.cards) do
            if v.ability.effect == "Base" then
                table.insert(eligable_cards, v)
            end
        end
        if #eligable_cards > 0 then
            local rand_card = pseudorandom_element(eligable_cards, pseudoseed('youcantpissonhospitality'))
            rand_card:set_ability(G.P_CENTERS.m_stone, nil, true)
            G.E_MANAGER:add_event(Event({
                func = function()
                    rand_card:juice_up()
                    return true
                end
            }))
            card.ability.extra.uses = card.ability.extra.uses+1
            if to_big(card.ability.extra.uses) >= to_big(card.ability.extra.runtime) then
                ArrowAPi.vhs.destroy_tape(card)
                card.ability.destroyed = true
            end
            return {
                message = localize('k_troll2'),
                card = card
            }
        end
    end
end

function consumInfo.can_use(self, card)
    if to_big(#G.consumeables.cards) < to_big(G.consumeables.config.card_limit) or card.area == G.consumeables then return true end
end

return consumInfo