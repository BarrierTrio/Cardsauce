local consumInfo = {
    name = 'Killer Queen',
    set = 'Stand',
    config = {
        stand_mask = true,
        evolve_key = 'c_jojobal_diamond_killer_btd',
        aura_colors = { 'de7cf9DC', 'e059e9DC' },
        extra = {
            evolve_cards = 0,
            evolve_num = 8,
            hand_mod = 1,
            hands = 0,
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'diamond',
        },
        custom_color = 'diamond'
    },
    blueprint_compat = true,
    artist = 'GuffNFluff',
    programmer = 'Kekulism'
}

function consumInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.hand_mod, card.ability.extra.hands, card.ability.extra.evolve_num, card.ability.extra.evolve_cards } }
end

function consumInfo.in_pool(self, args)
    return (not G.GAME.used_jokers['c_jojobal_diamond_killer_btd'])
end

function consumInfo.calculate(self, card, context)
    if not context.blueprint and context.remove_playing_cards then
        local hands = 0
        for i, _ in ipairs(context.removed) do
            check_for_unlock({ type = "destroy_killer" })
            hands = hands + card.ability.extra.hand_mod
        end
        card.ability.extra.hands = card.ability.extra.hands + hands
        card.ability.extra.evolve_cards = card.ability.extra.evolve_cards + hands
        if to_big(card.ability.extra.evolve_cards) >= to_big(card.ability.extra.evolve_num) then
            check_for_unlock({ type = "evolve_btd" })
            ArrowAPI.stands.evolve_stand(card)
            return
        end

        ArrowAPI.stands.flare_aura(card, 0.50)
        G.E_MANAGER:add_event(Event({func = function()
            play_sound('generic1')
            card:juice_up()
            return true
        end }))
        delay(0.65)
    end

    if context.setting_blind and card.ability.extra.hands > 0 then
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                ArrowAPI.stands.flare_aura(flare_card, 0.50)
                ease_hands_played(card.ability.extra.hands)
            end,
            extra = {
                message = localize{type = 'variable', key = 'a_hands', vars = {card.ability.extra.hands}},
                card = flare_card
            }
        }
    end

    if not context.blueprint and not context.retrigger_joker and context.end_of_round
    and context.main_eval and G.GAME.blind:get_type() == 'Boss' and card.ability.extra.hands > 0 then
        card.ability.extra.hands = 0
        return {
            no_retrigger = true,
            message = localize('k_reset'),
        }
    end
end

return consumInfo