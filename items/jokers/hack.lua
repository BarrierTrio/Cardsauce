local jokerInfo = {
    name = "Hack Fraud",
    atlas = 'jokers',
	pos = {x = 3, y = 14},
    config = {
        extra = {
            chip_mod = 15,
            chips = 0,
        },
    },
    rarity = 1,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    has_shiny = true,
    dependencies = {
        config = {
            ['VHSs'] = true,
        }
    },
    origin = {
        category = 'rlm',
        sub_origins = {'rlm_botw'},
        custom_color = 'rlm'
    },
    artist = 'yunkie101'
}

local function get_chips(card)
    local mod = 1
    if G.GAME.used_vouchers.v_directors_cut then mod = 2 end
    local vhs_obtained = 0
    for k, v in pairs(G.GAME.consumeable_usage) do if v.set == 'VHS' then vhs_obtained = vhs_obtained + 1 end end
    return (card.ability.extra.chip_mod * vhs_obtained) * mod
end

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.chip_mod, get_chips(card) } }
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main and get_chips(card) > 0 then
        return {
            chips = get_chips(card)
        }
    end
end

return jokerInfo
