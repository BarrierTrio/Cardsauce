local jokerInfo = {
    name = '2 Kings 2:23-24',
    atlas = 'jokers',
	pos = {x = 3, y = 5},
    config = {
        extra = {
            king_cards = {},
            max_cards = 42
        },
    },
    rarity = 3,
    cost = 8,
    unlocked = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    origin = 'joel',
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'Winter Grimwell',
}

local function create_kings_area(card, max_cards)
    local card_num = math.min(#G.deck.cards, max_cards)
    G['csau_kings_remove_'..card.ID] = CardArea(card.T.x, card.T.y, G.CARD_W, G.CARD_H, {
        card_limit = card_num,
        type = 'kings_deck',
    })

	G['csau_kings_remove_'..card.ID].states.collide.can = false
	G['csau_kings_remove_'..card.ID].states.drag.can = false
    G['csau_kings_remove_'..card.ID].ARGS.invisible_area_types = {
        discard = 1,
        voucher = 1,
        play = 1,
        consumeable = 1,
        title = 1,
        title_2 = 1,
        kings_deck = 1,
    }

    local new_uibox = UIBox{
        definition =
            {n=G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR}, nodes={
                {n=G.UIT.R, config={minw = G['csau_kings_remove_'..card.ID].T.w, minh = G['csau_kings_remove_'..card.ID].T.h, align = "cm", padding = 0.1, mid = true, r = 0.1, ref_table = G['csau_kings_remove_'..card.ID]}},
                {n=G.UIT.R, config={align = 'cr', padding = 0.03, no_fill = true}, nodes={
                    {n=G.UIT.B, config={w = 0.1,h=0.1}},
                    {n=G.UIT.T, config={ref_table = G['csau_kings_remove_'..card.ID].config, ref_value = 'card_count', scale = 0.4, colour = G.C.WHITE}},
                    {n=G.UIT.B, config={w = 0.1,h=0.1}}
                }}
            }},
        config = { align = 'cm', offset = {x=0,y=0}, major = G['csau_kings_remove_'..card.ID], parent = G['csau_kings_remove_'..card.ID]}
    }
    new_uibox.states.visible = true
    G['csau_kings_remove_'..card.ID].children.area_uibox = new_uibox

    return G['csau_kings_remove_'..card.ID]
end

function jokerInfo.check_for_unlock(self, args)
    if args.type == "unlock_kings" then
        return true
    end
end

function jokerInfo.load(self, card, card_table, other_card)
    if #card_table.ability.extra.king_cards > 0 then
        local kings_area = create_kings_area(card, card_table.ability.extra.max_cards)

        for _, v in ipairs(card_table.ability.extra.king_cards) do
            local new_card = Card(
                kings_area.T.x,
                kings_area.T.y,
                G.CARD_W,
                G.CARD_H,
                G.P_CARDS[v.card_key],
                G.P_CENTERS[v.center_key],
                {
                    bypass_discovery_center = true,
                    bypass_discovery_ui = true
                })
            new_card:set_edition(v.edition, true, true)
            new_card:set_seal(v.seal, true, true)
            kings_area:emplace(new_card, 'front', true)
        end
    end
end

function jokerInfo.add_to_deck(self, card, from_debuff)
    if from_debuff or not G.playing_cards or #G.deck.cards <= 0 then return end

    if G.GAME.buttons then
        G.GAME.buttons:remove();
        G.GAME.buttons = nil
    end

    G.CONTROLLER.locks.csau_2kings = true
    if G.shop and not G.shop.REMOVED then
        G.shop.alignment.offset.y = G.ROOM.T.y+11
    end

    local kings_area = create_kings_area(card, card.ability.extra.max_cards)

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            for i=1, kings_area.config.card_limit do
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.06,
                    func = function()
                        local drawn_card = G.deck:remove_card()
                        drawn_card:remove_from_deck()
                        G.deck.config.card_limit =  G.deck.config.card_limit - 1
                        kings_area:emplace(drawn_card,'front', true)

                        -- reassign playing cards
                        for k, v in ipairs(G.playing_cards) do
                            if v == drawn_card then
                                table.remove(G.playing_cards, k)
                                break
                            end
                        end

                        for k, v in ipairs(G.playing_cards) do
                            v.playing_card = k
                        end

                        G.playing_card = #G.playing_cards

                        table.insert(card.ability.extra.king_cards, {
                            card_key = drawn_card.config.card_key,
                            center_key = drawn_card.config.center.key,
                            seal = drawn_card.seal,
                            edition = drawn_card.edition and drawn_card.edition.type or nil
                        })
                        drawn_card.children.back.states.visible = true
                        drawn_card.states.collide.can = false
                        drawn_card.states.drag.can = false

                        G.VIBRATION = G.VIBRATION + 0.35
                        card:juice_up()
                        play_sound('card1', 0.85 + (i*100/kings_area.config.card_limit)*0.2/100, 0.6)
                        return true
                    end
                }))
            end

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 1,
                func = function()
                    if G.shop and not G.shop.REMOVED then G.shop.alignment.offset.y = -5.3 end
                    G.CONTROLLER.locks.csau_2kings = nil
                    return true
                end
            }))

            return true
        end
    }))
end

function jokerInfo.update(self, card, dt)
    if G['csau_kings_remove_'..card.ID] then
        local kings_area = G['csau_kings_remove_'..card.ID]
        kings_area.T.x = card.T.x
        kings_area.T.y = card.T.y + 0.092
        kings_area.VT.x = card.VT.x
        kings_area.VT.y = card.VT.y + 0.092

        local deck_height = 0.15/52
        for i, removed_card in ipairs(kings_area.cards) do
            removed_card.T.x = kings_area.T.x + 0.5*(kings_area.T.w - removed_card.T.w) + kings_area.shadow_parrallax.x*deck_height*(#kings_area.cards - i) + 0.9*kings_area.shuffle_amt*(1 - i*0.01)*(i%2 == 1 and 1 or -0)
            removed_card.T.y = kings_area.T.y + 0.5*(kings_area.T.h - removed_card.T.h) + kings_area.shadow_parrallax.y*deck_height*(#kings_area.cards - i)
            removed_card.T.r = 0 + 0.3*kings_area.shuffle_amt*(1 + i*0.05)*(i%2 == 1 and 1 or -0)
            removed_card.T.x = removed_card.T.x + removed_card.shadow_parrallax.x/30
        end
    end
end

function jokerInfo.draw(self, card, layer)
    if G['csau_kings_remove_'..card.ID] then
        local kings_area = G['csau_kings_remove_'..card.ID]
        kings_area.children.area_uibox:draw()
        for i = #kings_area.cards, 1, -1 do
            local kings_card = kings_area.cards[i]
            if i == 1 or i%9 == 0 or i == #kings_area.cards or math.abs(kings_card.VT.x - kings_area.T.x) > 1 or math.abs(kings_card.VT.y - kings_area.T.y) > 1 then
                local overlay = G.C.WHITE
                if kings_card.rank > 3 then
                    kings_card.back_overlay = kings_card.back_overlay or {}
                    kings_card.back_overlay[1] = 0.5 + ((#kings_area.cards - kings_card.rank)%7)/50
                    kings_card.back_overlay[2] = 0.5 + ((#kings_area.cards - kings_card.rank)%7)/50
                    kings_card.back_overlay[3] = 0.5 + ((#kings_area.cards - kings_card.rank)%7)/50
                    kings_card.back_overlay[4] = 1
                    overlay = kings_card.back_overlay
                end

                kings_card.children.back:draw(overlay)
            end
        end

        card.children.center:draw_shader('dissolve')
    end
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    if from_debuff or not G.playing_cards then return end

    if G['csau_kings_remove_'..card.ID] then
        local kings_area = G['csau_kings_remove_'..card.ID]
        if G.GAME.buttons then
            G.GAME.buttons:remove();
            G.GAME.buttons = nil
        end

        G.CONTROLLER.locks.csau_2kings = true

        if G.shop and not G.shop.REMOVED then
            G.shop.alignment.offset.y = G.ROOM.T.y+11
        end

        local remove_cards = {}
        local total_kings_cards = #kings_area.cards
        for i=1, total_kings_cards do
            local drawn_card = kings_area:remove_card()
            drawn_card.no_shadow = true
            table.insert(remove_cards, 1, drawn_card)
            drawn_card.csau_2kings_rank = #kings_area.cards + 1
            drawn_card.csau_2kings_total = total_kings_cards
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                for i=1, #remove_cards do
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.06,
                        func = function()
                            local drawn_card = table.remove(remove_cards, 1)
                            drawn_card.no_shadow = false
                            drawn_card.csau_2kings_rank = nil
                            drawn_card.csau_2kings_total = nil
                            G.deck:emplace(drawn_card, nil, true)
                            G.deck:sort()

                            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                            drawn_card.playing_card = G.playing_card
                            table.insert(G.playing_cards, drawn_card)
                            G.deck.config.card_limit = G.deck.config.card_limit + 1

                            G.VIBRATION = G.VIBRATION + 0.35
                            card:juice_up()
                            play_sound('card1', 0.85 + (1-(i*100/kings_area.config.card_limit))*0.2/100, 0.6)
                            return true
                        end
                    }))
                end

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 1,
                    func = function()
                        if G.shop and not G.shop.REMOVED then G.shop.alignment.offset.y = -5.3 end
                        card.ability.extra.king_cards = {}
                        kings_area:remove()
                        G.CONTROLLER.locks.csau_2kings = nil
                        return true
                    end
                }))

                return true
            end
        }))
    end
end

return jokerInfo


