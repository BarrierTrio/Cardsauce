---------------------------
--------------------------- Setting wigsaw suit
---------------------------

local ref_check_unlock = check_for_unlock
function check_for_unlock(args)
    local ret = ref_check_unlock(args)

    if args.type == 'modify_deck' then
        G.GAME.wigsaw_suit = nil
        local wigsaw_suit = nil
        if next(SMODS.find_card('j_csau_wigsaw')) then
            local suit_tallies = {}
            local highest_suit = nil
            local highest_num = 0
            for _, v in ipairs(G.playing_cards) do
                if not SMODS.has_no_suit(v) then
                    suIit_tallies[v.base.suit] = (suit_tallies[v.base.suit] or 0) + 1
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

        if wigsaw_suit then
            -- unsure about his, but we'll see
            for _, v in ipairs(SMODS.Suit.obj_buffer) do
                G.ARGS.LOC_COLOURS[v:lower()] = G.C.SUITS[G.GAME.wigsaw_suits]
            end
        end

        G.GAME.wigsaw_suit = wigsaw_suit
    end

    return ret
end

