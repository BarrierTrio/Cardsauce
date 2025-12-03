local jokerInfo = {
    name = 'Dancing Joker',
    animation = {
        frames = 39,
        fps = 13,
    },
    config = {
        extra = {
            repetitions = 1,
        }
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    origin = 'joel',
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'elebant'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return {
        vars = {
            localize(G.GAME.current_round.duane_suit or 'Clubs', 'suits_singular'),
            colours = {
                G.C.SUITS[G.GAME.current_round.duane_suit or 'Clubs']
            }
        }
    }
end

function jokerInfo.calculate(self, card, context)
    if context.csau_duane_change then

        local y_off = (context.suit == 'Hearts' and 1) or (context.suit == 'Clubs' and 2)
        or (context.suit == 'Diamonds' and 3) or (context.suit == 'Spades' and 4) or 0
        G.E_MANAGER:add_event(Event({
            func = function()
                card.children.center:set_sprite_pos({x = self.pos.x, y = self.pos.y + y_off})
			    return true
            end
        }))

        return {
            message = localize{type = 'variable', key = 'a_duane', vars = {string.upper(localize(context.suit, 'suits_plural'))}}
        }
    end
    if context.cardarea == G.play and context.repetition and not context.repetition_only and not card.debuff then
        if context.other_card:is_suit(G.GAME.current_round.duane_suit) then
            return {
                message = 'Again!',
                repetitions = card.ability.extra.repetitions,
                card = card
            }
        end
    end
end

return jokerInfo
