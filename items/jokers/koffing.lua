local jokerInfo = {
    name = "That Fucking Koffing Again",
    atlas = 'jokers',
	pos = {x = 1, y = 9},
    config = {extra = {rerolled = false}},
    rarity = 1,
    cost = 5,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
origin = {
        category = 'cardsauce',
        sub_origins = {
            'vinny',
        },
        custom_color = 'vinny'
    },
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'BarrierTrio/Gote',
    programmer = 'Mysthaps'
}

function jokerInfo.add_to_deck(self, card, from_debuff)
    if from_debuff then return end

    G.GAME.current_round.koffing_rerolls = G.GAME.current_round.koffing_rerolls + 1
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    if from_debuff then return end

    G.GAME.current_round.koffing_rerolls = G.GAME.current_round.koffing_rerolls - 1
end

function jokerInfo.update(self, card, dt)
	if not self.discovered and not card.bypass_discovery_center then
        return
    end

	if card.area and card.area.config.collection then
		return
	end

    card.koffing_can_juice = not not G.shop and card.area and card.area == G.jokers
    if not card.koffing_can_juice then card.koffing_juiced = nil end
    if card.koffing_can_juice then update_juice_positions(card) end
end

function update_juice_positions(card)
    local koffing_idx = 1
    if not card.current_koffings then card.current_koffings = {} end
    local order_changed = false

    local koffing_count = 0
    for i, v in ipairs(card.area.cards) do
        if v.config.center.key == 'j_csau_koffing' then
            koffing_count = koffing_count + 1
            if v == card then
                koffing_idx = koffing_count
            end

            if not order_changed and v.ID ~= card.current_koffings[i] then
                order_changed = true
            end
        end
    end

    local size_changed = koffing_count ~= #card.current_koffings
    if not size_changed and not order_changed and koffing_idx == card.koffing_last_index then
        return
    end

    if G.GAME.current_round.koffing_rerolls < koffing_idx then
        card.koffing_juiced = nil
    elseif not card.koffing_juiced then
        card.koffing_juiced = true
        local eval = function(koffing)
            return koffing.koffing_juiced and koffing.koffing_can_juice
        end
        juice_card_until(card, eval, true)
    end

    card.current_koffings = {}
    for _, v in ipairs(card.area.cards) do
        card.current_koffings[#card.current_koffings] = v.ID
    end

    card.koffing_last_index = koffing_idx
end

return jokerInfo