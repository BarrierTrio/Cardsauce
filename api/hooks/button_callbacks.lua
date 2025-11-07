local ref_use_card = G.FUNCS.use_card
G.FUNCS.use_card = function(e, mute, nosave)
    local card = e.config.ref_table
    if card.area == G.consumeables and (card.ability.activation or (card.config.center.activate and type(card.config.center.activate) == 'function')) then
        if card.config.center.activate and type(card.config.center.activate) == 'function' then
            card.config.center.activate(card.config.center, card, not card.ability.activated)
        end

        if card.ability.activation then
            G.FUNCS.tape_activate(card)
            if G.CONTROLLER.HID.controller then
                card.children.focused_ui = G.UIDEF.card_focus_ui(card)
                G.CONTROLLER.locks.use = false
            else
                card:highlight(true)
            end
        end

        return
    end

    return ref_use_card(e, mute, nosave)
end

local ref_buy_shop = G.FUNCS.buy_from_shop
G.FUNCS.buy_from_shop = function(e)
    ref_buy_shop(e)
    local c1 = e.config.ref_table
    if c1 and c1:is(Card) then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                if c1.ability.consumeable then
                    if c1.config.center.set == 'Stand' then
                        inc_career_stat('c_stands_bought', 1)
                    elseif c1.config.center.set == 'VHS' then
                        inc_career_stat('c_vhss_bought', 1)
                    end
                end
                return true
            end
        }))
    end
end





---------------------------
--------------------------- Stand buy space
---------------------------

local ref_check_buy_space = G.FUNCS.check_for_buy_space
G.FUNCS.check_for_buy_space = function(card)
    if card.ability.set == 'Stand' and not G.GAME.modifiers.unlimited_stands and ArrowAPI.stands.get_num_stands() >= G.GAME.modifiers.max_stands then
        alert_no_space(card, G.consumeables)
        return false
    end

    local ret = ref_check_buy_space(card)
    if not ret then
        return ret
    end


    return ret
end

local ref_select_booster = G.FUNCS.can_select_from_booster
G.FUNCS.can_select_from_booster = function(e)
    local ret = ref_select_booster(e)

    if e.config.button then
        local card = e.config.ref_table



        if card.ability.set == 'Stand' and not G.GAME.modifiers.unlimited_stands and ArrowAPI.stands.get_num_stands() >= G.GAME.modifiers.max_stands then
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        end
    end

    return ret
end





---------------------------
--------------------------- Management for gradient backgrounds and UIs
---------------------------

local ref_start_run = G.FUNCS.start_run
G.FUNCS.start_run = function(...)
    if G.GAME.blind then
        G.GAME.blind.in_blind = false
        G.GAME.blind.newrun_flag = true
    end
    
    if G.GAME.arrow_gradient_background then
        G.C.BACKGROUND.L = { G.C.BACKGROUND.L[1], G.C.BACKGROUND.L[2], G.C.BACKGROUND.L[3], G.C.BACKGROUND.L[4] }
        G.C.BACKGROUND.D = { G.C.BACKGROUND.D[1], G.C.BACKGROUND.D[2], G.C.BACKGROUND.D[3], G.C.BACKGROUND.D[4] }
        G.C.BACKGROUND.C = { G.C.BACKGROUND.C[1], G.C.BACKGROUND.C[2], G.C.BACKGROUND.C[3], G.C.BACKGROUND.C[4] }
        G.C.BACKGROUND.contrast = G.C.BACKGROUND.contrast
        G.GAME.arrow_gradient_background = nil
    end

    if G.GAME.arrow_gradient_ui then
        G.C.DYN_UI.MAIN = { G.C.DYN_UI.MAIN[1], G.C.DYN_UI.MAIN[2], G.C.DYN_UI.MAIN[3], G.C.DYN_UI.MAIN[4] }
        G.C.DYN_UI.DARK = { G.C.DYN_UI.DARK[1], G.C.DYN_UI.DARK[2], G.C.DYN_UI.DARK[3], G.C.DYN_UI.DARK[4] }
        G.C.DYN_UI.BOSS_MAIN = { G.C.DYN_UI.BOSS_MAIN[1], G.C.DYN_UI.BOSS_MAIN[2], G.C.DYN_UI.BOSS_MAIN[3], G.C.DYN_UI.BOSS_MAIN[4] }
        G.C.DYN_UI.BOSS_DARK = { G.C.DYN_UI.BOSS_DARK[1], G.C.DYN_UI.BOSS_DARK[2], G.C.DYN_UI.BOSS_DARK[3], G.C.DYN_UI.BOSS_DARK[4] }
        G.GAME.arrow_gradient_ui = nil
    end

    return ref_start_run(...)
end

local ref_go_menu = G.FUNCS.go_to_menu
G.FUNCS.go_to_menu = function(e)
    if G.GAME.arrow_gradient_background then
        G.C.BACKGROUND.L = { G.C.BACKGROUND.L[1], G.C.BACKGROUND.L[2], G.C.BACKGROUND.L[3], G.C.BACKGROUND.L[4] }
        G.C.BACKGROUND.D = { G.C.BACKGROUND.D[1], G.C.BACKGROUND.D[2], G.C.BACKGROUND.D[3], G.C.BACKGROUND.D[4] }
        G.C.BACKGROUND.C = { G.C.BACKGROUND.C[1], G.C.BACKGROUND.C[2], G.C.BACKGROUND.C[3], G.C.BACKGROUND.C[4] }
        G.C.BACKGROUND.contrast = G.C.BACKGROUND.contrast
        G.GAME.arrow_gradient_background = nil
    end

    if G.GAME.arrow_gradient_ui then
        G.C.DYN_UI.MAIN = { G.C.DYN_UI.MAIN[1], G.C.DYN_UI.MAIN[2], G.C.DYN_UI.MAIN[3], G.C.DYN_UI.MAIN[4] }
        G.C.DYN_UI.DARK = { G.C.DYN_UI.DARK[1], G.C.DYN_UI.DARK[2], G.C.DYN_UI.DARK[3], G.C.DYN_UI.DARK[4] }
        G.C.DYN_UI.BOSS_MAIN = { G.C.DYN_UI.BOSS_MAIN[1], G.C.DYN_UI.BOSS_MAIN[2], G.C.DYN_UI.BOSS_MAIN[3], G.C.DYN_UI.BOSS_MAIN[4] }
        G.C.DYN_UI.BOSS_DARK = { G.C.DYN_UI.BOSS_DARK[1], G.C.DYN_UI.BOSS_DARK[2], G.C.DYN_UI.BOSS_DARK[3], G.C.DYN_UI.BOSS_DARK[4] }
        G.GAME.arrow_gradient_ui = nil
    end

    return ref_go_menu(e)
end





---------------------------
--------------------------- Debuff text for blinds, including extra blinds
---------------------------

G.FUNCS.update_blind_debuff_text = function(e)
    if not e.config.object then return end

    local new_str = SMODS.debuff_text or G.GAME.blind:get_loc_debuff_text()
    if not new_str then return end
    
    if new_str ~= e.config.object.config.string[1].string then
        e.config.object.config.string[1].string = new_str
        e.config.object.start_pop_in = true
        e.config.object:update_text(true)
        e.UIBox:recalculate()
    end
end





---------------------------
--------------------------- Deck crediting
---------------------------

G.FUNCS.RUN_SETUP_check_artist = function(e)
    if G.GAME.viewed_back.name ~= e.config.id then
        --removes the UI from the previously selected back and adds the new one
        if G.GAME.viewed_back.effect.center.artist then
            if e.config.object then e.config.object:remove() end
            e.UIT = G.UIT.O
            e.config.object = UIBox{
                definition = G.UIDEF.deck_credit(G.GAME.viewed_back.effect.center),
                config = {offset = {x=0,y=0}, align = 'cm', parent = e}
            }

            e.config.minh = nil
            e.config.maxh = nil
            if e.parent.parent.children[1] then
                e.parent.parent.children[1].config.minh = 0.45
                e.parent.parent.children[2].config.minh = 0.9
            end
        else
            if e.config.object then e.config.object:remove() end
            e.UIT = G.UIT.R

            e.config.minh = 0
            e.config.maxh = 0
            if e.parent.parent.children[1] then
                e.parent.parent.children[1].config.minh = 0.6
                e.parent.parent.children[2].config.minh = 1.7
            end
        end
        e.config.id = G.GAME.viewed_back.name
        e.UIBox:recalculate()
    end
end