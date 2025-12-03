SMODS.Sound({
    key = "mmmmmm",
    path = "mmmmmm.ogg",
})

SMODS.Sound({
    key = "sorry_link",
    path = "sorry_link.ogg",
})

local ref_check_buy_space = G.FUNCS.check_for_buy_space
G.FUNCS.check_for_buy_space = function(card)
    if card.config.center.key == 'j_csau_ufo' then
        if #G.jokers.cards < 1 then
            alert_no_space(card, G.jokers)
            return false
        end

        return true
    end

    return ref_check_buy_space(card)
end





---------------------------
--------------------------- Helper functions for Morshu Vouchers
---------------------------

local ref_toggle_shop = G.FUNCS.toggle_shop
G.FUNCS.toggle_shop = function(e)
    if G.shop and G.morshu_area and G.morshu_area.cards and G.GAME.morshu_rounds then
        local removed = 0
		for i, v in ipairs(G.morshu_area.cards) do
			v.ability.morshu_count = (v.ability.morshu_count or 0) + 1
			if v.ability.morshu_count > G.GAME.morshu_rounds then
                removed = removed + 1
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.3,
					func = function()
						-- clear the morshu_cards
						v:start_dissolve()
						return true
					end
				}))
			end
		end

        if removed > 0 then
            --play_sound('csau_sorry_link', 1, 0.38)
            delay(1.2)
        end
	end

    return ref_toggle_shop(e)
end

G.FUNCS.check_for_morshu_space = function(card)
    if #G.morshu_area.cards >= G.morshu_area.config.card_limit then
        --alert_no_space(card, G.morshu_area)
        for i, v in ipairs(G.morshu_area.cards) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                func = function()
                    v:start_dissolve()
                    return true
                end
            }))
        end
        return false
    end
    return true
end

G.FUNCS.save_to_morshu = function(e)
    local c1 = e.config.ref_table
    if c1 and c1:is(Card) then
        G.FUNCS.check_for_morshu_space(c1)
        local c2 = copy_card(c1)
        c2.states.visible = false
        if not c2.bypass_discovery_ui or not c2.bypass_discovery_center then
            c2.bypass_discovery_center = true
            c2.params.bypass_discovery_center = true
            c2.bypass_discovery_ui = true
            c2.params.bypass_discovery_ui = true
            c2:set_sprites(c2.config.center)
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()

            -- remove old stuff
            if c1.children.price then c1.children.price:remove() end
            c1.children.price = nil
            if c1.children.buy_button then c1.children.buy_button:remove() end
            c1.children.buy_button = nil
            if c1.children.buy_and_use_button then c1.children.buy_and_use_button:remove() end
            c1.children.buy_and_use_button = nil
            remove_nils(c1.children)

            c1:start_dissolve()

            --play_sound('csau_mmmmmm', 1, 0.38)
            return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.8,
            func = function()
            if c2.ability.set == "Voucher" then
                G.GAME.current_round.voucher.spawn[c2.config.center_key] = false
                G.GAME.used_vouchers[c2.config.center_key] = true
            end

            create_shop_card_ui(c2)
            G.morshu_area:emplace(c2)
            create_shop_card_ui(c2, c2.ability.set, G.morshu_area)
            c2:start_materialize()

            -- could add a context for this if you want
            return true
            end
        }))
    end
end





---------------------------
--------------------------- Shop dollars hook
---------------------------


local ref_buy_shop = G.FUNCS.buy_from_shop
G.FUNCS.buy_from_shop = function(e)
    local ret = ref_buy_shop(e)
    check_for_unlock({type = 'csau_spent_in_shop', dollars = G.GAME.shop_dollars_spent})
    return ret
end





---------------------------
--------------------------- Collab achievements
---------------------------

local ref_change_collab = G.FUNCS.change_collab
G.FUNCS.change_collab = function(args)
    local ret = ref_change_collab(args)

    if Cardsauce.config['enable_Skins'] then
        if G.SETTINGS.CUSTOM_DECK.Collabs.Spades == "collab_CYP" and
            G.SETTINGS.CUSTOM_DECK.Collabs.Hearts == "collab_TBoI" and
            G.SETTINGS.CUSTOM_DECK.Collabs.Diamonds == "collab_SV" and
            G.SETTINGS.CUSTOM_DECK.Collabs.Clubs == "collab_STS" then
            check_for_unlock({ type = "skin_characters" })
        end

        if ArrowAPI.string.ends_with(G.SETTINGS.CUSTOM_DECK.Collabs.Clubs, 'vineshroom')
        or G.SETTINGS.CUSTOM_DECK.Collabs.Clubs == "collab_PC"
        or G.SETTINGS.CUSTOM_DECK.Collabs.Clubs == "collab_WF" then
            check_for_unlock({ type = "skin_vineshroom" })
        end
    end

    return ret
end





---------------------------
--------------------------- Koffing behavior
---------------------------

local ref_reroll_shop = G.FUNCS.reroll_shop
G.FUNCS.reroll_shop = function(e)
    local koffings = SMODS.find_card('j_csau_coffing')
    if G.GAME.current_round.koffing_rerolls > 0 then
        local juice_cards = {koffings[G.GAME.current_round.koffing_rerolls]}
        for _, v in ipairs(juice_cards) do
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    v:juice_up()
                    return true
                end
            }))
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                for i = #G.shop_booster.cards, 1, -1 do
                    local c = G.shop_booster:remove_card(G.shop_booster.cards[i])
                    c:remove()
                    c = nil
                end

                G.GAME.current_round.koffing_rerolls = G.GAME.current_round.koffing_rerolls - 1
                if G.GAME.current_round.koffing_rerolls <= 0 then
                    G.GAME.current_round.koffing_rerolls = 0
                end

                G.GAME.current_round.used_packs = {}
                for i=1, G.GAME.starting_params.boosters_in_shop + (G.GAME.modifiers.extra_boosters or 0) do
                    G.GAME.current_round.used_packs[i] = get_pack('shop_pack').key

                    local new_booster = Card(G.shop_booster.T.x + G.shop_booster.T.w/2,
                    G.shop_booster.T.y, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[G.GAME.current_round.used_packs[i]], {bypass_discovery_center = true, bypass_discovery_ui = true})
                    create_shop_card_ui(new_booster, 'Booster', G.shop_booster)
                    new_booster.ability.booster_pos = i
                    new_booster:start_materialize()
                    G.shop_booster:emplace(new_booster)
                end

                return true
            end
        }))
    end

    return ref_reroll_shop(e)
end