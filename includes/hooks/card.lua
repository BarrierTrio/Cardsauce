function Card:vic_add_speech_bubble(text_key, align, loc_vars, extra)
    if self.children.speech_bubble then self.children.speech_bubble:remove() end
    self.config.speech_bubble_align = {align=align or 'bm', offset = {x=0,y=0},parent = self}
    self.children.speech_bubble =
    UIBox{
        definition = G.UIDEF.vic_speech_bubble(text_key, loc_vars, extra),
        config = self.config.speech_bubble_align
    }
    self.children.speech_bubble.states.hover.can = false
    self.children.speech_bubble.states.click.can = false
    self.children.speech_bubble:set_role{
        role_type = 'Minor',
        xy_bond = 'Weak',
        r_bond = 'Strong',
        major = self,
    }
    self.children.speech_bubble.states.visible = false
end

function Card:vic_remove_speech_bubble()
    if self.children.speech_bubble then self.children.speech_bubble:remove(); self.children.speech_bubble = nil end
end

function Card:vic_say_stuff(n, not_first, def_speed, voice, playVoice)
    voice = voice or nil
    playVoice = playVoice or 1
    local speed, delayMult = 1, 1
    if not def_speed then
        speed = G.SPEEDFACTOR
    else
        delayMult = G.SPEEDFACTOR
    end
    self.talking = true
    if not not_first then 
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1*delayMult,
            func = function()
                if self.children.speech_bubble then self.children.speech_bubble.states.visible = true end
                self:vic_say_stuff(n, true, def_speed, voice, playVoice)
              return true
            end
        }))
    else
        if n <= 0 then self.talking = false; return end
        local new_said = math.random(1, 11)
        while new_said == self.last_said do 
            new_said = math.random(1, 11)
        end
        self.last_said = new_said
        if voice == 'jimbo' then
            play_sound('voice'..math.random(1, 11), speed*(math.random()*0.2+1), 0.5)
        else
            if voice and playVoice == 1 then
                voice:play(1, (G.SETTINGS.SOUND.volume/100.0) * (G.SETTINGS.SOUND.game_sounds_volume/50.0),true);
                playVoice = 2
            end
        end

        self:juice_up()
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            blockable = false, blocking = false,
            delay = 0.13*delayMult,
            func = function()
                self:vic_say_stuff(n-1, true, def_speed, voice, playVoice)
            return true
            end
        }), 'tutorial')
    end
end

local function readSpeed(inputText)
    local wordsPerSecond = 3
    local wordCount = 0
    for _ in string.gmatch(inputText, "%S+") do wordCount = wordCount + 1 end
    local time = math.ceil(wordCount / wordsPerSecond)
    return time
end

function Card:jokerTalk(messages, index, delay, end_flag, fallback_card)
    local speed = G.SETTINGS.GAMESPEED
    local removed = false
    index = index or 1
    delay = delay or 0.1
    end_flag = end_flag or nil
    fallback_card = fallback_card or nil
    local card = self or fallback_card
    local speech_key = messages[index].speech_key or 'chad_greeting1'
    local bubble_side = messages[index].bubble_side or 'bm'
    local end_delay = messages[index].end_delay or nil
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = delay,
        blocking = false,
        func = function()
            local speech_key = speech_key
            local text = G.localization.misc.quips[speech_key]
            local current_mod = #text*2+1 or 5
            if current_mod < 5 then current_mod = 5 end
            local dynDelay
            if type(end_delay) == 'number' then
                dynDelay = end_delay
            elseif type(end_delay) == 'string' then
                dynDelay = tonumber(end_delay) + (readSpeed(tableToString(text)) + 2)
            else
                dynDelay = readSpeed(tableToString(text)) + 2
            end
            if card.ability.talking then
                local cancelling = false
                for k, v in pairs(card.ability.talking) do
                    if k ~= end_flag and v == true then
                        cancelling = true
                        if not card.ability.cancel then card.ability.cancel = {} end
                        card.ability.cancel[k] = true
                    end
                end
                if cancelling then
                    card:vic_remove_speech_bubble()
                end
            else
                card.ability.talking = {}
            end
            card:vic_add_speech_bubble(speech_key, bubble_side, nil, {text_alignment = "cm"})
            if card then
                card:vic_say_stuff(current_mod, nil, true)
            end
            if end_flag then card.ability.talking[end_flag] = true end
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = dynDelay*speed,
                blocking = false,
                blockable = true,
                func = function()
                    if end_flag then card.ability.talking[end_flag] = false end
                    card:vic_remove_speech_bubble()
                    if not card.ability.cancel then card.ability.cancel = {} end
                    if card.role.draw_major.removed == true or card.ARGS.get_major.removed == true then removed = true end
                    if card and not removed and messages[index+1] and ((end_flag and not card.ability.cancel[end_flag]) or (not end_flag)) then
                        card:jokerTalk(messages, index+1, 0, end_flag)
                    else
                        if end_flag and not card.ability.cancel[end_flag] then
                            if end_flag == 'chad_greeting_finished' or
                            end_flag == 'chad_explain_finished' or
                            end_flag == 'chad_showman_finished' then
                                card.ability.quips[end_flag] = true
                                G.SETTINGS.chad[end_flag] = true
                                G:save_settings()
                            else
                                card.ability.quips[end_flag] = true
                            end
                        end
                        if #card.ability.cancel > 0 then
                            for k, v in pairs(card.ability.talking) do
                                if v == true then
                                    card.ability.cancel[k] = false
                                end
                            end
                        end
                    end
                    return true
                end
            }))
            return true
        end
    }))
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
--------------------------- For tracking shop purchases for Morshu
---------------------------

local ref_redeem = Card.redeem
function Card:redeem()
    local ret = ref_redeem(self)
    if self.ability.set == "Voucher" then
        G.GAME.csau_shop_dollars_spent = G.GAME.csau_shop_dollars_spent + self.cost
        check_for_unlock({type = 'csau_spent_in_shop', dollars = G.GAME.csau_shop_dollars_spent})
    end
    return ret
end





---------------------------
--------------------------- For loading overlays and auras
---------------------------

local ref_set_ability = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
    local ret = ref_set_ability(self, center, initial, delay_sprites)

    if self.ability.set == 'csau_Stand' then
        G.FUNCS.csau_set_stand_sprites(self)
    end

    if self.ability.set == 'VHS' then
        if self.config.center.discovered and not (G.OVERLAY_MENU or G.STAGE == G.STAGES.MAIN_MENU) then
            local moodies = SMODS.find_card("c_csau_vento_moody")
            for _, v in ipairs(moodies) do
                self.ability.extra.runtime = self.ability.extra.runtime*2
            end
        end
        
        self.no_shadow = true
    end

    if self.playing_card and center ~= G.P_CENTERS.c_base and not initial then
        local bulks = SMODS.find_card('j_csau_bulk')
        for _, v in ipairs(bulks) do
            if not v.debuff then
                v.ability.extra.x_mult = v.ability.extra.x_mult + v.ability.extra.x_mult_mod
                card_eval_status_text(v, 'extra', nil, nil, nil, {
                    message = localize{type='variable',key='a_xmult',vars={v.ability.extra.x_mult}},
                })
            end
        end
    end

    return ret
end

local ref_card_base = Card.set_base
function Card:set_base(card, initial, delay_sprites)
    local old_id = self.base and self.base.id
    local ret = ref_card_base(self, card, initial, delay_sprites)

    if not initial and old_id and self.base.id > old_id then
        local bulks = SMODS.find_card('j_csau_bulk')
        for _, v in ipairs(bulks) do
            if not v.debuff then
                v.ability.extra.x_mult = v.ability.extra.x_mult + v.ability.extra.x_mult_mod
                card_eval_status_text(v, 'extra', nil, nil, nil, {
                    message = localize{type='variable',key='a_xmult',vars={v.ability.extra.x_mult}},
                })
            end
        end
    end

    return ret
end

local ref_card_load = Card.load
function Card:load(cardTable, other_card)
    local ret = ref_card_load(self, cardTable, other_card)

    if self.ability.set == 'csau_Stand' then
        G.FUNCS.csau_set_stand_sprites(self)
    end
    
    if self.ability.set == 'VHS' then
        self.no_shadow = true
    end

    return ret
end

local ref_card_ju = Card.juice_up
function Card:juice_up(scale, rot_amount)
    if self.seal_delay then self.seal_delay = false end
    ref_card_ju(self, scale, rot_amount)
end





---------------------------
--------------------------- For stand auras in the collection
---------------------------
local ref_card_hover = Card.hover
function Card:hover()

    if G.col_stand_hover and G.col_stand_hover ~= self then
        G.col_stand_hover.ability.aura_flare_queued = nil
        G.col_stand_hover.ability.stand_activated = nil
        G.col_stand_hover = nil
    end

    if self.ability.aura_hover or (self.area and self.area.config.collection and self.ability.set == 'csau_Stand') then
        G.col_stand_hover = self
        self.ability.aura_flare_queued = true
    end

    return ref_card_hover(self)
end

local ref_card_stop_hover = Card.stop_hover
function Card:stop_hover()
    if self.ability.aura_hover or (self.area and self.area.config.collection and self.ability.set == 'csau_Stand') then
        self.ability.aura_flare_queued = nil
        self.ability.stand_activated = nil
    end

    return ref_card_stop_hover(self)
end

function love.focus(f)
    if not f then return end

    if G.col_stand_hover then
        G.col_stand_hover.ability.aura_flare_queued = nil
        G.col_stand_hover.ability.stand_activated = nil
        G.col_stand_hover = nil
    end
end

local ref_cgid = Card.get_id
function Card:get_id(skip_pmk)
    skip_pmk = skip_pmk or false
    if not skip_pmk and (self.area == G.hand or self.area == G.play) and self:is_face() and next(SMODS.find_card("c_csau_lion_paper")) then
        return SMODS.Ranks[G.GAME.current_round.paper_rank or 'Jack'].id
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
        _suit = (G.GAME and G.GAME.wigsaw_suit and SMODS.Suits[G.GAME.wigsaw_suit]) or _suit
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