local consumInfo = {
    name = "DIO's World",
    set = 'csau_Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'ce9c36DC' , 'ffd575DC' },
        extra = {
            hand_mod = 1,
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    part = 'stardust',
    in_progress = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } }
    return { vars = { card.ability.extra.hand_mod } }
end

function consumInfo.calculate(self, card, context)
    if context.before and not card.debuff and G.GAME.current_round.hands_played == 0 then
        local all = true
        for _, v in ipairs(context.full_hand) do
            if not v:is_suit('Spades', nil, true) then
                all = false
                break
            end
        end
        if all then
            ease_hands_played(card.ability.extra.hand_mod)
            return {
                func = function()
                    G.FUNCS.csau_flare_stand_aura(card, 0.38)
                end,
                card = card,
                message = localize{type = 'variable', key = 'a_hands', vars = {card.ability.extra.hand_mod}},
                colour = G.C.BLUE
            }
        end
    end
end

function consumInfo.can_use(self, card)
    return false
end

return consumInfo