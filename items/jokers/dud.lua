local jokerInfo = {
    name = "The Dud",
    atlas = 'jokers',
	pos = {x = 6, y = 10},
    config = {},
    rarity = 1,
    cost = 5,
    unlocked = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    has_shiny = true,
    origin = 'vinny',
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'Swizik'
}

function jokerInfo.locked_loc_vars(self, info_queue, card)
    return { vars = { colours = {get_stake_col(4)} }}
end

function jokerInfo.in_pool(self, args)
    if G.GAME.modifiers.enable_eternals_in_shop then
        return true
    end
end

function jokerInfo.check_for_unlock(self, args)
    if args.type == "win_stake" then
        local highest_win = get_deck_win_stake(nil)
        if highest_win >= 4 then
            return true
        end
    end
end

local peeloff = SMODS.Sound({
    key = "peeloff",
    path = "peeloff.ogg"
})

function jokerInfo.calculate(self, card, context)
    if context.selling_card and context.card == card then
        local pool = {}
        for i, v in ipairs(G.jokers.cards) do
            if not v.debuff  and not v.csau_dud_flagged and card ~= v then
                for k, _ in pairs(SMODS.Stickers) do
                    if v.ability[k] then
                        v.csau_dud_flagged = true
                        pool[#pool+1] = v
                    end
                end
            end
        end

        if #pool > 0 then
            local chosen_joker = pseudorandom_element(pool, pseudoseed('dud_choice'))
            check_for_unlock({ type = "activate_dud" })
            for k, _ in pairs(SMODS.Stickers) do
                if chosen_joker.ability[k] then
                    chosen_joker:remove_sticker(k)
                end
            end

            play_sound('csau_peeloff')
            chosen_joker:juice_up()
        end
    end
end

return jokerInfo