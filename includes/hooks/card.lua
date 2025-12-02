function Card:gunshot_func()
    if G.OVERLAY_MENU and G.OVERLAY_MENU:get_UIE_by_ID('jimbo_spot') then
        play_sound("csau_gunshot", 1, 1)
        self.children.center.atlas = G.ASSET_ATLAS["csau_jimbo_shot"]
        self.children.center:set_sprite_pos({x = 0, y = 0})
        self:juice_up()

        if not G.GAME.shot_jimbo then
            for k, v in pairs(G.I.CARD) do
                if getmetatable(v) == Card_Character then
                    v.children.particles = Particles(0, 0, 0,0, {
                        timer = 0.01,
                        scale = 0.3,
                        speed = 2,
                        lifespan = 4,
                        attach = v,
                        colours = {G.C.RED, G.C.RED, G.C.RED},
                        fill = true
                    })
                    v:remove_speech_bubble()
                    v.talking = false
                end
            end
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 2,
            func = (function()
                check_for_unlock({ type = "fuckingkill_jimbo" })
                return true
            end)}))

        G.GAME.shot_jimbo = true
    end
end





---------------------------
--------------------------- For loading overlays and auras
---------------------------

local ref_card_ju = Card.juice_up
function Card:juice_up(scale, rot_amount)
    if self.seal_delay then self.seal_delay = false end
    ref_card_ju(self, scale, rot_amount)
end


local ref_cgid = Card.get_id
function Card:get_id(skip_pmk)
    skip_pmk = skip_pmk or false
    if not skip_pmk and (self.area == G.hand or self.area == G.play) and self:is_face() and next(SMODS.find_card("c_csau_lion_paper")) then
        return SMODS.Ranks[G.GAME.current_round.jojobal_paper_rank or 'Jack'].id
    end
    return ref_cgid(self)
end

-- why is this function not a global, i had to steal it from smods code
function juice_flip(used_tarot)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.4,
        func = function()
            play_sound('tarot1')
            used_tarot:juice_up(0.3, 0.5)
            return true
        end
    }))
    for i = 1, #G.hand.cards do
        local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,
            func = function()
                G.hand.cards[i]:flip(); play_sound('card1', percent); G.hand.cards[i]:juice_up(0.3, 0.3); return true
            end
        }))
    end
end

SMODS.Consumable:take_ownership('sigil', {
    use = function(self, card, area, copier)
        local used_tarot = copier or card
        juice_flip(used_tarot)
        local _suit = pseudorandom_element(SMODS.Suits, pseudoseed('sigil'))
        for i = 1, #G.hand.cards do
            G.E_MANAGER:add_event(Event({
                func = function()
                    local _card = G.hand.cards[i]
                    assert(SMODS.change_base(_card, _suit.key))
                    return true
                end
            }))
        end
        for i = 1, #G.hand.cards do
            local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.cards[i]:flip(); play_sound('tarot2', percent, 0.6); G.hand.cards[i]:juice_up(0.3, 0.3); return true
                end
            }))
        end
        delay(0.5)
    end,
})

local ref_set_cost = Card.set_cost
function Card:set_cost()
    if G.GAME and G.GAME.modifiers and G.GAME.modifiers.csau_tgyh_tenbob then
        self.base_cost = 10
        self.extra_cost = 0
    end

    local ret = ref_set_cost(self)

    if (self.ability.set == 'VHS' or (self.ability.set == 'Booster' and self.ability.name:find('Analog'))) then
        if #SMODS.find_card('j_csau_weretrulyfrauds') > 0 then
            self.cost = 0
        end
    end

    self.sell_cost = self.sell_cost + (self.ability.csau_extra_value or 0)

    return ret
end





---------------------------
--------------------------- Wigsaw hooks
---------------------------

local ref_card_suit = Card.is_suit
function Card:is_suit(suit, bypass_debuff, flush_calc)
    suit = G.GAME.wigsaw_suit or suit
    return ref_card_suit(self, suit, bypass_debuff, flush_calc)
end

function Card:get_suit()
    return G.GAME.wigsaw_suit or self.base.suit
end

local ref_card_change = Card.change_suit
function Card:change_suit(new_suit)
    new_suit = G.GAME.wigsaw_suit or new_suit
    return ref_card_change(self, new_suit)
end