local jokerInfo = {
    name = 'Black Spine Junka',
    atlas = 'jokers',
	pos = {x = 7, y = 14},
    config = {
        unlock = 10,
        extra = {
            x_mult_mod = 0.2,
            x_mult = 1,
            prob_mod = 1,
            prob_extra = 0,
            prob = 50,
            destroyed = false,
        }
    },
    rarity = 3,
    cost = 8,
    unlocked = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    dependencies = {
        config = {
            ['VHSs'] = true,
        }
    },
    origin = {
        category = 'rlm',
        sub_origins = {'rlm_j'},
        custom_color = 'rlm'
    },
    artist = 'yunkie101'
}

function jokerInfo.loc_vars(self, info_queue, card)
    local num, dom = SMODS.get_probability_vars(card, card.ability.extra.prob_extra, card.ability.extra.prob, 'csau_junka')
    return { vars = {card.ability.extra.x_mult_mod, card.ability.extra.prob_mod, num, dom, card.ability.extra.x_mult } }
end

function jokerInfo.locked_loc_vars(self, info_queue, card)
    return { vars = { card.ability.unlock, G.DISCOVER_TALLIES.vhss.tally } }
end

function jokerInfo.check_for_unlock(self, args)
    if args.type == 'discover_amount' then
        if G.DISCOVER_TALLIES.vhss.tally >= self.config.unlock then
            return true
        end
    end
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.vhs_death and not context.blueprint and not card.ability.extra.destroyed then
        if SMODS.pseudorandom_probability(card, 'csau_junka', card.ability.extra.prob_extra, card.ability.extra.prob) then
            card.ability.extra.destroyed = true
            ArrowAPI.game.card_expire(card, 'k_junka_lose')
        else
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "x_mult",
                scalar_value = "x_mult_mod",
                no_message = true
            })
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "prob_extra",
                scalar_value = "prob_mod",
                no_message = true
            })

            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.x_mult}}
            }
        end
    end

    if context.joker_main and to_big(card.ability.extra.x_mult) > to_big(1) then
        return {
            x_mult = card.ability.extra.x_mult,
        }
    end
end

return jokerInfo