local jokerInfo = {
    name = "IT'S ME AUSTIN",
    atlas = 'jokers',
	pos = {x = 0, y = 15},
    config = {
        extra = {
            mult = 20,
        },
    },
    rarity = 1,
    cost = 6,
    unlocked = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pools = {
        ["Meme"] = true
    },
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'joel',
        },
        custom_color = 'joel'
    },
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },

    artist = 'ABBurlap'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
end

function jokerInfo.check_for_unlock(self, args)
    if args.type == "defeat_wall" then
        return true
    end
end

function jokerInfo.calculate(self, card, context)
    if context.blind_hidden and context.blind_obj.boss then
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_blind_hidden'), colour = G.P_BLINDS['bl_arrow_mystery'].boss_colour})
        return {
            blind_hidden = true
        }
    end

    if context.joker_main then
        return {
            mult = card.ability.extra.mult,
        }
    end
end

return jokerInfo