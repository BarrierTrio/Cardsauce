local jokerInfo = {
    name = "The Dud",
    config = {},
    rarity = 1,
    cost = 5,
    unlocked = false,
    blueprint_compat = false,
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
        local highest_win, lowest_win = get_deck_win_stake(nil)
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
    if context.selling_self then
        local pool = {}
        for k, v in pairs(G.jokers.cards) do
            if (v.ability.eternal or v.ability.perishable or v.ability.rental) and card ~= v then
                pool[#pool+1] = v
            end
        end
        if #pool > 0 then
            local chosen_joker = pseudorandom_element(pool, pseudoseed('dud_choice'))
            for k, v in pairs(G.jokers.cards) do
                if v == chosen_joker then
                    check_for_unlock({ type = "activate_dud" })
                    if v.ability.eternal then
                        v.ability.eternal = false
                    end
                    if v.ability.perishable then
                        v.ability.perishable = false
                    end
                    if v.ability.rental then
                        v.ability.rental = false
                    end
                    peeloff:play(1, (G.SETTINGS.SOUND.volume/100.0) * (G.SETTINGS.SOUND.game_sounds_volume/70.0),true)
                    v:juice_up()
                end
            end
        end
    end
end

return jokerInfo