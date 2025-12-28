local blindInfo = {
    name = "The Outlaw",
    atlas = 'blinds',
    pos = {x = 0, y = 3},
    boss_colour = HEX('a0a0cc'),
    dollars = 5,
    mult = 2,
    vars = {},
    boss = {min = 2, max = 10},
}

function blindInfo.defeat(self)
    check_for_unlock({ type = "defeat_outlaw" })
end

function blindInfo.set_blind(self)
    G.GAME.blind.played_ranks = {}
end

function blindInfo.drawn_to_hand(self)
    if G.GAME.current_round.hands_played < 1 or not G.GAME.blind.debuff_queued then
        return
    end

    for _, v in ipairs(G.playing_cards) do
        if not G.GAME.blind.fnwk_extra_blind or not v.debuffed_by_blind then
            G.GAME.blind:debuff_card(v, true)
        end
    end

    G.GAME.blind.debuff_queued = nil
    G.GAME.blind:alert_debuff(false)
end

function blindInfo.get_loc_debuff_text(self)
    if not G.GAME.blind.played_ranks or not (next(G.GAME.blind.played_ranks)) then
        return localize('k_outlaw_default')
    end


    local ordered_array = {}
    for k, v in pairs(G.GAME.blind.played_ranks) do table.insert(ordered_array, {rank = k, nominal = v}) end
    table.sort(ordered_array, function(a, b) return a.nominal < b.nominal end)

    local debuff_str = ''
    for i, v in ipairs(ordered_array) do
        if #ordered_array > 1 and i == #ordered_array then
            debuff_str = debuff_str..'and '
        end
        debuff_str = debuff_str..(v.rank)..'s'

        if #ordered_array > 2 and i < #ordered_array then
            debuff_str = debuff_str..','
        end

        if i < #ordered_array then
            debuff_str = debuff_str..' '
        end
    end

    return localize{type='variable',key='a_outlaw_debuffs',vars={debuff_str}}
end

function blindInfo.recalc_debuff(self, card, from_blind)
    if not G.GAME.blind.played_ranks then
        G.GAME.blind.played_ranks = {}
    end

    if card.area == G.jokers or G.GAME.blind.disabled or SMODS.has_no_rank(card) or not card.base.value then
        return false
    end

    return (G.GAME.blind.played_ranks[SMODS.Ranks[card.base.value].key] ~= nil)
end

function blindInfo.modify_hand(self, cards, poker_hands, text, mult, hand_chips)
    if G.GAME.blind.disabled then return end

    local scoring_hand = poker_hands[text][1]
    G.GAME.blind.played_ranks = {}
    for _, card in ipairs(scoring_hand) do
        local rank = SMODS.Ranks[card.base.value]
        if not G.GAME.blind.played_ranks[rank.key] or SMODS.has_no_rank(card) then
            G.GAME.blind.played_ranks[rank.key] = card:get_nominal()
        end
    end

    G.GAME.blind.debuff_queued = true

    return mult, hand_chips, false
end

return blindInfo