---------------------------
--------------------------- Setting wigsaw suit
---------------------------

local ref_check_unlock = check_for_unlock
function check_for_unlock(args)
    local ret = ref_check_unlock(args)

    if args.type == 'modify_deck' or args.type == 'wigsaw_added' then
        G.GAME.wigsaw_suit = nil
        local wigsaw_suit = nil
        if args.type == 'wigsaw_added' or next(SMODS.find_card('j_csau_wigsaw')) then
            local suit_tallies = {}
            local highest_suit = nil
            local highest_num = 0
            for _, v in ipairs(G.playing_cards) do
                if not SMODS.has_no_suit(v) then
                    suit_tallies[v.base.suit] = (suit_tallies[v.base.suit] or 0) + 1
                    if suit_tallies[v.base.suit] == highest_num and highest_suit ~= v.base.suit then
                        highest_suit = nil
                    elseif suit_tallies[v.base.suit] > highest_num then
                        highest_suit = v.base.suit
                        highest_num = suit_tallies[v.base.suit]
                    end
                end
            end

            wigsaw_suit = highest_suit
        end

        G.GAME.wigsaw_suit = wigsaw_suit
    end

    return ret
end

--------------------------- Force clear main_start and main_end
---------------------------
local ref_card_ui = generate_card_ui
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card, ...)
    if specific_vars and G.GAME.wigsaw_suit and specific_vars.colours then
        -- anything that isn't a playing card has its loc vars colours adjusted to the wigsaw suit
        for i, v in ipairs(specific_vars.colours) do
            for _, col in pairs(G.C.SUITS) do
                if v == col then
                    specific_vars.colours[i] = G.C.SUITS[G.GAME.wigsaw_suit]
                end
            end
        end
    end

    return ref_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card, ...)
end