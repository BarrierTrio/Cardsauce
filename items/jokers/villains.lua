local jokerInfo = {
    name = 'Jokers of Circumstance',
    config = {
        extra = {
            chips = 50,
            mult = 5
        }
    },
    rarity = 1,
    cost = 4,
    unlocked = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    origin = 'vinny',
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'BarrierTrio/Gote'
}

function jokerInfo.check_for_unlock(self, args)
    if args.type == "unlock_villains" then
        return true
    end
end

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.chips, card.ability.extra.mult}}
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main then
        local play_more_than = 0
        local most_played = {}
        for k, v in pairs(G.GAME.hands) do
            if v.visible and v.played > 0 then
                if v.played > play_more_than then
                    most_played = {[k] = true}
                    play_more_than = v.played
                elseif v.played == play_more_than then
                    most_played[k] = true
                end
            end
        end

        if most_played[context.scoring_name] then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        end
    end
end

return jokerInfo