local jokerInfo = {
    name = "That Fucking Koffing Again",
    config = {extra = {rerolled = false}},
    rarity = 2,
    cost = 5,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
    info_queue[#info_queue+1] = {key = "codercredit", set = "Other", vars = { csau_team.myst } }
end

function jokerInfo.add_to_deck(self, card)
    check_for_unlock({ type = "discover_koffing" })
end

function jokerInfo.calculate(self, card, context)
    if context.ending_shop and not context.blueprint then
        card.ability.extra.rerolled = false
    end
end

local reroll_shopref = G.FUNCS.reroll_shop
function G.FUNCS.reroll_shop(e)
    reroll_shopref(e)
    for _, v in ipairs(SMODS.find_card('j_csau_koffing')) do
        if not v.ability.extra.rerolled then
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    for i = #G.shop_booster.cards, 1, -1 do
                        local c = G.shop_booster:remove_card(G.shop_booster.cards[i])
                        c:remove()
                        c = nil
                    end

                    G.GAME.current_round.used_packs = G.GAME.current_round.used_packs or {}
                    for i = #G.GAME.current_round.used_packs+1, #G.GAME.current_round.used_packs+2 do
                        if not G.GAME.current_round.used_packs[i] then
                            G.GAME.current_round.used_packs[i] = get_pack('shop_pack').key
                        end

                        if G.GAME.current_round.used_packs[i] ~= 'USED' then 
                            local card = Card(G.shop_booster.T.x + G.shop_booster.T.w/2,
                            G.shop_booster.T.y, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[G.GAME.current_round.used_packs[i]], {bypass_discovery_center = true, bypass_discovery_ui = true})
                            create_shop_card_ui(card, 'Booster', G.shop_booster)
                            card.ability.booster_pos = i
                            card:start_materialize()
                            G.shop_booster:emplace(card)
                        end
                    end

                    v:juice_up()
                return true
                end
            }))
            G.E_MANAGER:add_event(Event({ func = function() save_run(); return true end}))
            v.ability.extra.rerolled = true
            break
        end
    end
end

return jokerInfo