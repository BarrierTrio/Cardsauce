local jokerInfo = {
    name = 'Murder the Monolith',
    rarity = 3,
    cost = 8,
    config = {
        extra = {
            form = 'Base',
            Hearts = {
                repetitions = 1
            },
            Diamonds = {
                mult_mod = 4,
                mult = 0
            },
            Spades = {
                x_mult = 3,
                extra_cards = 3,
                hands = 1,
                discards = 0,
                repetitions = 2
            },
            Clubs = {},
            changed_forms = {
                ['Base'] = true
            }
        }
    },
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "other",
    artist = 'BarrierTrio/Gote'
}

local forms = {
        ["Base"] = { pos = {x=0,y=0}, color = G.C.PURPLE },
        ["Hearts"] = { pos = {x=1,y=0}, color = G.C.SUITS.Hearts },
        ["Clubs"] = { pos = {x=2,y=0}, color = G.C.SUITS.Clubs },
        ["Diamonds"] = { pos = {x=3,y=0}, color = G.C.SUITS.Diamonds },
        ["Spades"] = { pos = {x=4,y=0}, color = G.C.SUITS.Spades },
        ["Wild"] = { pos = {x=5,y=0, color = G.C.GOLD },
    }
}

local change_form = function(card, form)
    check_for_unlock({ type = "transform_sts" })
    card.ability.extra.form = form
    card.ability.extra.changed_forms[form] = true

    local all_forms = true
    for k, _ in pairs(forms) do
        if not card.ability.extra.changed_forms[k] then
            all_forms = false
        end
    end

    if all_forms then
        check_for_unlock({ type = "sts_allforms" })
    end

    card.config.center.pos = forms[form].pos
    return form
end

function jokerInfo.loc_vars(self, info_queue, card)
    return {
        vars = {
            card.ability.extra.Diamonds.mult_mod,
            card.ability.extra.Diamonds.mult,
            card.ability.extra.Spades.x_mult,
            card.ability.extra.Spades.extra_cards,
            card.ability.extra.Spades.hands,
            card.ability.extra.Spades.discards
        },
        key = "j_csau_sts_"..card.ability.extra.form
    }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.cardarea == G.jokers and context.before then
        if card.ability.extra.form == "Base" and not context.blueprint then
            local first = nil
            for i=1, #context.scoring_hand do
                if first == nil and not (context.scoring_hand[i].debuff or SMODS.has_enhancement(context.scoring_hand[i], 'm_stone')) then
                    first = context.scoring_hand[i]
                end
            end

            if first then
                local form = change_form(card, first.config.center.key == 'm_wild' and 'Wild' or first.base.suit)

                -- resetting collection sprites
                G.E_MANAGER:add_event(Event({ func = function()
                    card:juice_up(0.7, 0.7)
                    card:set_sprites(card.config.center)
                    card.config.center.pos = forms.Base.pos
                    return true end
                }))

                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = localize('k_sts_'..card.ability.extra.form),
                    colour = forms[form].color,
                    no_juice = true,
                })

                if form == "Spades" then
                    if to_big(G.GAME.current_round.hands_left) > to_big(0) then
                        ease_discard(-G.GAME.current_round.discards_left, nil, true)
                    end

                    if to_big(G.GAME.current_round.hands_left) > to_big(1) then
                        ease_hands_played(-G.GAME.current_round.hands_left + 1, nil, true)
                    end
                end
            end
        end

        if card.ability.extra.form == "Diamonds" and not context.blueprint then
            card.ability.extra.Diamonds.mult = card.ability.extra.Diamonds.mult + card.ability.extra.Diamonds.mult_mod * #context.scoring_hand
            return {
                message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.Diamonds.mult}},
                colour = G.C.MULT
            }
        elseif card.ability.extra.form == "Wild" then
            for _, v in ipairs(context.scoring_hand) do
                if v.config.center.key == 'c_base' then
                    v:set_ability(pseudorandom_element(G.P_CENTER_POOLS.Enhanced, pseudoseed('csau_sts_wild')), nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card:juice_up()
                            return true
                        end
                    }))

                    card_eval_status_text(v, 'extra', nil, nil, nil, {
                        message = localize('k_enhanced'),
                    })
                end
            end
        end

        card.ability.csau_sts_handplayed = true
    end

    if context.drawing_cards and card.ability.csau_sts_handplayed and card.ability.extra.form == "Spades" then
		card.ability.csau_sts_handplayed = nil
        return {
			cards_to_draw = context.amount + card.ability.extra.Spades.extra_cards
		}
	end

    if context.cardarea == G.play and context.repetition
    and (card.ability.extra.form == 'Hearts' or card.ability.extra.form == 'Spades') then
        return {
            message = localize('k_again_ex'),
            repetitions = card.ability.extra[card.ability.extra.form].repetitions,
            card = context.blueprint_card or card
        }
    end

    if context.joker_main and (card.ability.extra.form == 'Diamonds' or card.ability.extra.form == 'Spades') then
        local form = card.ability.extra.form
        return {
            x_mult = card.ability.extra[form].x_mult and to_big(card.ability.extra[form].x_mult) > to_big(0) and card.ability.extra[form].x_mult,
            mult = card.ability.extra[form].mult and to_big(card.ability.extra[form].mult) > to_big(0) and card.ability.extra[form].mult,
        }
    end


    if context.after and card.ability.extra.form == "Clubs" then
        G.E_MANAGER:add_event(Event({
            func = function()
                local new_card = SMODS.add_card({
                    set = 'Enhanced',
                    enhancement = 'm_stone',
                    key = 'm_stone',
                    skip_materialize = true,
                })
                G.deck.config.card_limit = G.deck.config.card_limit + 1

                new_card.states.visible = nil
                new_card:start_materialize()
                playing_card_joker_effects({new_card})
                return true
            end
        }))
    end

    if context.end_of_round and context.main_eval then
        if card.ability.extra.form ~= "Base" then
            change_form(card, "Base")
            G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
                play_sound('generic1')
                card:juice_up(0.7, 0.7)
                card:set_sprites(card.config.center)
                return true end
            }))
        end

        card.ability.extra.Diamonds.mult = 0
    end
end

-- TODO: reimplement sts always_scores ref with modern SMODS add_to_hand contexts

return jokerInfo