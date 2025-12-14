local jokerInfo = {
    name = 'Let Fate Decide',
    atlas = 'jokers',
	pos = {x = 3, y = 4},
    config = {},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'vinny',
        },
        custom_color = 'vinny'
    },
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'FenixSeraph'
}

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.end_of_round and context.main_eval then
        local roll = pseudorandom('fate', 1, 6)
        if roll < 4 then
            check_for_unlock({ type = "activate_watto" })
        end

        local type = (roll == 1 and 'joker') or (roll == 2 and 'booster') or (roll == 3 and 'any') or nil
        if type then
            local key, color = ArrowAPI.game.get_tag_by_type(type, 'IMAWATTOOO_'..type)
            return {
                message = localize('k_plus_one')..' '..localize({type = 'name_text', set = 'Tag', key = key}),
                colour = color,
                extra = {
                    func = function()
                        add_tag(Tag(key))
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                    end
                }
            }
        end

        return {
            message = localize('k_nope_ex'),
            colour = G.C.SECONDARY_SET.Tarot
        }
    end
end

return jokerInfo