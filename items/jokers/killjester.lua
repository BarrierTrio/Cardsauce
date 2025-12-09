local jokerInfo = {
    name = 'Kill Jester',
    atlas = 'jokers',
	pos = {x = 9, y = 8},
    config = {
        extra = {
            x_mult = 1,
            x_mult_mod = 0.25,
        }
    },
    rarity = 3,
    cost = 8,
    unlocked = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    origin = 'vinny',
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'Swizik'
}

function jokerInfo.check_for_unlock(self, args)
    return  args.type == "unlock_killjester"
end

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.x_mult_mod, card.ability.extra.x_mult} }
end


function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.setting_blind and not context.blueprint then
        local trigger = false
        for i = 1, #G.jokers.cards do
            local joker = G.jokers.cards[i]
            if joker ~= card and not joker.getting_sliced and (ArrowAPI.string.contains(joker.config.center.name, "Joker")
            or ArrowAPI.string.contains(joker.config.center.name, "Jester")) and not SMODS.is_eternal(joker, self) then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "x_mult",
                    scalar_value = "x_mult_mod",
                    no_message = true
                })
                joker.getting_sliced = true
                trigger = true

                G.E_MANAGER:add_event(Event({
                    func = function()
                        joker:start_dissolve({G.C.RED}, nil, 1.6)
                        return true
                    end
                }))
            end
        end

        if trigger then
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.x_mult}}
            }
        end
    end

    if context.joker_main and card.ability.extra.x_mult > 1 then
        return {
            x_mult = card.ability.extra.x_mult,
        }
    end
end

return jokerInfo