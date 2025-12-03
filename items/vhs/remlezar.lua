local consumInfo = {
    name = 'Creating Rem Lezar',
    key = 'remlezar',
    set = "VHS",
    runtime = 1,
    cost = 3,
    blueprint_compat = false,
    config = {},
    origin = 'vinny',
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'greek_shmeek'
}

function consumInfo.calculate(self, card, context)
    if card.debuff or context.blueprint then return end

    if card.ability.activated and not card.ability.destroyed and context.spectral_downside and context.downside then

        ArrowAPI.vhs.run_tape(card)

        if not card.ability.destroyed then
            G.E_MANAGER:add_event(Event({
                func = function()
                    card:juice_up()
                end
            }))
        end

        return {
            prevent_downside = true
        }
    end
end

return consumInfo