local consumInfo = {
    name = 'Alien Private Eye',
    atlas = 'vhs',
	pos = {x = 4, y = 4},
    set = "VHS",
    runtime = 100,
    cost = 6,
    config = {
        extra = {
            chance_mod = 1,
            chance = 0,
            rate = 100,
            x_mult = 1.5,
        },
    },
    origin = {
        category = 'rlm',
        sub_origins = {
            'rlm_botw',
        },
        custom_color = 'rlm'
    },
    artist = 'Gongalicious'
}

function consumInfo.loc_vars(self, info_queue, card)
    local num, dom = SMODS.get_probability_vars(card, card.ability.extra.chance, card.ability.extra.rate, 'csau_alienpi')
    return { vars = { card.ability.extra.x_mult, card.ability.extra.chance_mod, num, dom } }
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if card.ability.activated and not card.ability.destroyed and context.before then
        local scale_table = {chance_mod = #context.scoring_hand * card.ability.extra.chance_mod}
        SMODS.scale_card(card, {
            ref_table = card.ability.extra,
            ref_value = "chance",
            scalar_table = scale_table,
            scalar_value = "chance_mod",
            no_message = true,
        })
        ArrowAPI.vhs.run_tape(card, nil, #context.scoring_hand)
    end

    if card.ability.activated and not card.ability.destroyed and context.individual and context.cardarea == G.play then
        return {
            x_mult = card.ability.extra.x_mult,
            card = context.blueprint_card or card
        }
    end

    if context.after and card.ability.destroyed then
        ArrowAPI.game.game_over(false)
    end

    if context.selling_self and SMODS.pseudorandom_probability(card, 'csau_alienpi', card.ability.extra.chance, card.ability.extra.rate) then
       ArrowAPI.game.game_over(false)
    end
end

return consumInfo