local jokerInfo = {
    name = "No. 2 Joker",
    config = {
        extra = 1,
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    origin = 'jojo',
    dependencies = {
        config = {
            ['Stands'] = true,
        }
    },
    artist = 'SagaciousCejai',
    programmer = 'Kekulism'
}

function jokerInfo.calculate(self, card, context)
    if context.retrigger_joker_check and not context.retrigger_joker
    and context.other_card.config.center.set == "Stand" then
        return {
            no_retrigger_juice = true,
            message = localize('k_again_ex'),
            repetitions = card.ability.extra,
        }
    end
end

return jokerInfo
