local jokerInfo = {
    name = 'Murder the Monolith',
    rarity = 3,
    cost = 8,
    config = {
        form = 'base',
        hearts = {
            repetitions = 1
        },
        diamonds = {
            mult_mod = 4,
            mult = 0
        },
        spades = {
            x_mult = 3,
            extra_cards = 3,
            hands = 1,
            discards = 0,
            repetitions = 2
        },
        changed_forms = {
            hearts = false,
            clubs = false,
            diamonds = false,
            spades = false,
            wild = false,
        }
    },
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "other",
}

local forms = {
        ["Base"] = {'base', {x=0,y=0} },
        ["Hearts"] = {'hearts', {x=1,y=0} },
        ["Clubs"] = {'clubs', {x=2,y=0} },
        ["Diamonds"] = {'diamonds', {x=3,y=0} },
        ["Spades"] = {'spades', {x=4,y=0} },
        ["Wild Card"] = {'wild', {x=5,y=0} },
    }

local change_form = function(card, form)
    if forms[form] then
        card.ability.form = forms[form][1]
        card.config.center.pos = forms[form][2]
    else
        for k, v in pairs(forms) do
            if v[1] == form then
                card.ability.form = v[1]
                card.config.center.pos = v[2]
            end
        end
    end
    return card.ability.form
end

local form_color = function(form)
    if form == 'wild' then
        return G.C.GOLD
    elseif form == 'hearts' then
        return G.C.SUITS.Hearts
    elseif form == 'clubs' then
        return G.C.SUITS.Clubs
    elseif form == 'diamonds' then
        return G.C.SUITS.Diamonds
    elseif form == 'spades' then
        return G.C.SUITS.Spades
    else
        return G.C.PURPLE
    end
end

local sts_allforms = function(card)
    if card.ability.changed_forms.hearts and card.ability.changed_forms.clubs and card.ability.changed_forms.diamonds and card.ability.changed_forms.spades and card.ability.changed_forms.wild then
        check_for_unlock({ type = "sts_allforms" })
    end
end

function G.FUNCS.find_sts_form(form)
    if next(SMODS.find_card("j_csau_sts")) then
        for i, v in ipairs(SMODS.find_card("j_csau_sts")) do
            if v.Mid.ability.form == form then
                return true
            end
        end
    end
    return false
end

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
    return { vars = {card.ability.diamonds.mult_mod, card.ability.diamonds.mult, card.ability.spades.x_mult, card.ability.spades.extra_cards, card.ability.spades.hands, card.ability.spades.discards } }
end

function jokerInfo.add_to_deck(self, card)
    check_for_unlock({ type = "discover_sts" })
end

function jokerInfo.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    if card.config.center.discovered then
        -- If statement makes it so that this function doesnt activate in the "Joker Unlocked" UI and cause 'Not Discovered' to be stuck in the corner
        full_UI_table.name = localize{type = 'name', key = "j_csau_sts_"..card.ability.form, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    end
    localize{type = 'descriptions', key = "j_csau_sts_"..card.ability.form, set = self.set, nodes = desc_nodes, vars = self.loc_vars(self, info_queue, card).vars}
end

function jokerInfo.set_sprites(self, card, _front)
    if card.config.center.discovered or card.bypass_discovery_center then
        card.children.center:reset()
    end
end

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.jokers and context.before and not card.debuff then
        if card.ability.form == "base" and not context.blueprint then
            local first = nil
            for i=1, #context.scoring_hand do
                if first == nil and not (context.scoring_hand[i].debuff or SMODS.has_enhancement(context.scoring_hand[i], 'm_stone')) then
                    first = context.scoring_hand[i]
                end
            end
            if first then
                if first.ability.effect == 'Wild Card' then
                    local form = change_form(card, "Wild Card")
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_sts_'..card.ability.form), colour = form_color(form), update_sprites = true, juice_num1 = 0.7, juice_num2 = 0.7})
                else
                    local form = change_form(card, first.base.suit)
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_sts_'..card.ability.form), colour = form_color(form), update_sprites = true, juice_num1 = 0.7, juice_num2 = 0.7})
                end
                if card.ability.form == "spades" then
                    ease_discard(-G.GAME.current_round.discards_left, nil, true)
                    ease_hands_played(-G.GAME.current_round.hands_left + 1, nil, true)
                end
                card.ability.changed_forms[card.ability.form] = true
                sts_allforms(card)
            end
        end
        if card.ability.form == "clubs" then
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            local front = pseudorandom_element(G.P_CARDS, pseudoseed('marb_fr'))
            local _card = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS.m_stone, {playing_card = G.playing_card})
            _card:add_to_deck()
            G.deck.config.card_limit = G.deck.config.card_limit + 1
            table.insert(G.playing_cards, _card)
            G.hand:emplace(_card)
            _card.states.visible = nil
            G.E_MANAGER:add_event(Event({
                func = function()
                    _card:start_materialize()
                    return true
                end
            }))
        elseif card.ability.form == "spades" then
            if G.GAME.csau_stss_drawthreeextra == nil then
                G.GAME.csau_stss_drawthreeextra = 1
            else
                G.GAME.csau_stss_drawthreeextra = G.GAME.csau_stss_drawthreeextra + 1
            end
        end
        if G.GAME.current_round.hands_played > 0 then
            if card.ability.form == "diamonds" and not context.blueprint then
                card.ability.diamonds.mult = to_big(card.ability.diamonds.mult) + (to_big(card.ability.diamonds.mult_mod) * to_big(#context.scoring_hand))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_mult', vars = {to_big(card.ability.diamonds.mult)}}, colour = G.C.MULT})
            elseif card.ability.form == "wild" then
                local enhancements = {
                    [1] = G.P_CENTERS.m_bonus,
                    [2] = G.P_CENTERS.m_mult,
                    [3] = G.P_CENTERS.m_wild,
                    [4] = G.P_CENTERS.m_glass,
                    [5] = G.P_CENTERS.m_steel,
                    [6] = G.P_CENTERS.m_stone,
                    [7] = G.P_CENTERS.m_gold,
                    [8] = G.P_CENTERS.m_lucky,
                }
                for i, v in ipairs(context.scoring_hand) do
                    if v.ability.effect == "Base" then
                        v:set_ability(enhancements[pseudorandom('deification', 1, 8)], nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v:juice_up()
                                return true
                            end
                        }))
                    end
                end
            end
        end
    end
    if context.cardarea == G.play and context.repetition and not context.repetition_only and not card.debuff and G.GAME.current_round.hands_played > 0 then
        if card.ability.form == "hearts" then
            return {
                message = 'Again!',
                repetitions = card.ability.hearts.repetitions,
                card = card
            }
        elseif card.ability.form == "spades" then
            return {
                message = 'Again!',
                repetitions = card.ability.spades.repetitions,
                card = card
            }
        end
    end
    if context.final_scoring_step and G.GAME.current_round.hands_played > 0 then
        if card.ability.form == "diamonds" and to_big(card.ability.diamonds.mult) > to_big(0) then
            return {
                message = localize{type='variable',key='a_mult',vars={to_big(card.ability.diamonds.mult)}},
                mult_mod = card.ability.diamonds.mult
            }
        elseif card.ability.form == "spades" then
            return {
                message = localize{type='variable',key='a_xmult',vars={to_big(card.ability.spades.x_mult)}},
                Xmult_mod = card.ability.spades.x_mult,
            }
        end
    end
    if context.end_of_round and not context.other_card then
        if card.ability.form ~= "base" then
            change_form(card, "Base")
            card:juice_up(1, 1)
            card:set_sprites(card.config.center)
        end
        if card.ability.diamonds.mult > 0 then
            card.ability.diamonds.mult = 0
        end
        if G.GAME.csau_stss_drawthreeextra and G.GAME.csau_stss_drawthreeextra > 0 then
            G.GAME.csau_stss_drawthreeextra = 0
        end
    end
end

function jokerInfo.update(self, card)
    if G.screenwipe then
        change_form(card, card.ability.form)
        card:set_sprites(card.config.center)
    end
end

return jokerInfo