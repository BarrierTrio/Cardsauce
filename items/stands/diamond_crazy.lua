local consumInfo = {
    name = 'Crazy Diamond',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'e099e8DC' , 'f5ccf4DC' },
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'diamond',
        },
        custom_color = 'diamond'
    },
    blueprint_compat = false,
    artist = 'cejai',
}

function consumInfo.calculate(self, card, context)
    if context.before and not card.debuff and not context.blueprint and not context.retrigger_joker then
         local activated = false
         for i, v in ipairs(context.full_hand) do
             if v.debuff then
                  v.debuff = false
                  v.cured_debuff = true
                  G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function ()
                      v.cured_debuff = false
                      v:juice_up()
                      return true
                  end}))
                 activated = true
             end
         end
         if activated then
             return {
                 func = function()
                    ArrowAPI.stands.flare_aura(card, 0.50)
                 end,
                 extra = {
                    card = card,
                    message = localize('k_cd_healed'),
                    colour = G.C.STAND
                 }
             }
         end
    end
end


return consumInfo