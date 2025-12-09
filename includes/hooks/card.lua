local ref_set_ability = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
    local ret = ref_set_ability(self, center, initial, delay_sprites)

    if self.config.center.key == 'm_glass' then
        ArrowAPI.stands.set_stand_sprites(self)
    end

    return ret
end

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

local ref_set_cost = Card.set_cost
function Card:set_cost()
    if self.config.center.key == 'j_csau_veryexpensivejoker' then
        self.base_cost = self.base_cost or 0
        self.cost = self.cost or 0
        self.sell_cost = self.sell_cost or 0
        self.sell_cost_label = self.sell_cost
        return
    end

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