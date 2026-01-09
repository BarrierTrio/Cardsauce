local jokerInfo = {
    name = 'Kill Jester',
    atlas = 'jokers',
	pos = {x = 9, y = 8},
    config = {
        extra = {
            x_mult = 1,
            x_mult_mod = 0.25,
        }
    },
    rarity = 3,
    cost = 8,
    unlocked = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
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
    artist = 'Swizik'
}

local lang_table = {
    ['de'] = 'Joker',
    ['en-us'] = 'Joker',
    ['es_419'] = 'Comodín',
    ['es_ES'] = 'Comodín',
    ['fr'] = 'Joker',
    ['id'] = 'Joker',
    ['it'] = 'Jolly',
    ['ja'] = 'ジョーカー',
    ['ko'] = '조커',
    ['nl'] = 'Joker',
    ['pl'] = 'Joker',
    ['pt_BR'] = 'Curinga',
    ['ru'] = 'Джокер',
    ['zh_CN'] = '小丑',
    ['zh_TW'] = '小丑',
}

function jokerInfo.check_for_unlock(self, args)
    return  args.type == "unlock_killjester"
end

function jokerInfo.loc_vars(self, info_queue, card)
    local loc_str = lang_table[G.LANG.key]
    return {
        vars = {
            loc_str,
            card.ability.extra.x_mult_mod,
            card.ability.extra.x_mult
        }
    }
end


function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.setting_blind and not context.blueprint then
        local trigger = false
        local num_destroyed = 0
        for i = 1, #G.jokers.cards do
            local joker = G.jokers.cards[i]
            if joker ~= card and not joker.getting_sliced then
                local name = localize({type = 'name_text', set = 'Joker', key = joker.config.center.key})
                sendDebugMessage('checking name '..name)
                local loc_str = lang_table[G.LANG.key]
                if (ArrowAPI.string.contains(name, loc_str) or ArrowAPI.string.contains(name, 'Joker')) and not SMODS.is_eternal(joker, card) then
                    num_destroyed = num_destroyed + 1
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "x_mult",
                        scalar_value = "x_mult_mod",
                        no_message = true
                    })
                    check_for_unlock({type = 'scale_card', card = card, value = card.ability.extra.x_mult})
                    joker.getting_sliced = true
                    trigger = true

                    if num_destroyed == 1 then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                play_sound('slice1', 0.96+math.random()*0.08)
                                return true
                            end
                        }))
                    end

                    G.E_MANAGER:add_event(Event({
                        func = function()
                            joker:start_dissolve({G.C.RED}, num_destroyed ~= 1, 1.6)
                            return true
                        end
                    }))
                end
            end
        end

        if trigger then
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.x_mult}}
            }
        end
    end

    if context.joker_main and card.ability.extra.x_mult > 1 then
        return {
            x_mult = card.ability.extra.x_mult,
        }
    end
end

return jokerInfo