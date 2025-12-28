local jokerInfo = {
    name = 'Protegent Antivirus',
    atlas = 'jokers',
	pos = {x = 6, y = 11},
    config = {
        extra = {
            boss_prob = 4,
            save_prob = 8,
        }
    },
    rarity = 1,
    cost = 6,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    has_shiny = true,
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'joel',
        },
        custom_color = 'joel'
    },
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'HunnyByte'
}

function jokerInfo.loc_vars(self, info_queue, card)
    local num, dom1 = SMODS.get_probability_vars(card, 1, card.ability.extra.boss_prob, 'csau_proto_boss')
    local _, dom2 = SMODS.get_probability_vars(card, 1, card.ability.extra.save_prob, 'csau_proto_save')
    return { vars = { num, dom1, dom2 } }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff or context.blueprint then return end

    if context.setting_blind and G.GAME.blind:get_type() == 'Boss'
    and SMODS.pseudorandom_probability(card, 'csau_proto_boss', 1, card.ability.extra.boss_prob) then
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.blind:disable()
                return true
            end
        }))

        ArrowAPI.game.card_expire(card, 'ph_boss_disabled')
    end

    if context.game_over and SMODS.pseudorandom_probability(card, 'csau_proto_save', 1, card.ability.extra.save_prob) then
        G.E_MANAGER:add_event(Event({
            func = function()
                G.hand_text_area.blind_chips:juice_up()
                G.hand_text_area.game_chips:juice_up()
                play_sound('tarot1')
                card:start_dissolve()
                return true
            end
        }))

        check_for_unlock({ type = "activate_proto" })
        return {
            saved = 'ph_saved_proto',
            colour = G.C.RED
        }
    end
end

return jokerInfo