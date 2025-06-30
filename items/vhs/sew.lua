local consumInfo = {
    name = 'Surviving Edged Weapons',
    key = 'sew',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        activated = false,
        destroyed = false,
        extra = {
            runtime = 4,
            uses = 0
        },
    },
    origin = {
        'rlm',
        'rlm_wotw',
        color = 'rlm'
    }
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.yunkie } }
    return { 
        vars = {
            card.ability.extra.runtime-card.ability.extra.uses,
            (card.ability.extra.runtime-card.ability.extra.uses) > 1 and 's' or ''
        }
    }
end

function consumInfo.can_use(self, card)
    if to_big(#G.consumeables.cards) < to_big(G.consumeables.config.card_limit) or card.area == G.consumeables then return true end
end

return consumInfo

--[[

THINGS AFFECTED BY SURVIVING EDGED WEAPONS MANUALLY (FUCK):

Vanilla:
- Ceremonial Dagger ✔️
- Madness ✔️
- Ankh ✔️
- Hex ✔️
Cardsauce:
- Kill Jester ✔️

]]--