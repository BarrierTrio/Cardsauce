local consumInfo = {
    name = 'Killer Queen: Bites the Dust',
    set = 'Stand',
    config = {
        stand_mask = true,
        evolved = true,
        aura_colors = { '151590DC', '5f277dDC' },
    },
    cost = 10,
    rarity = 'EvolvedRarity',
    hasSoul = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'diamond',
        },
        custom_color = 'diamond'
    },
    blueprint_compat = false,
    artist = 'GuffNFluff',
    programmer = 'Eremel',
}

function consumInfo.in_pool(self, args)
    return (not G.GAME.used_jokers['c_jojobal_diamond_killer'])
end

local get_btd = function()
    if not G.consumeables then return false end
    for i, v in ipairs(G.consumeables.cards) do
        if v.config.center.key == 'c_jojobal_diamond_killer_btd' then
            return true
        end
    end
    return false
end

local get_card_areas = SMODS.get_card_areas
function SMODS.get_card_areas(_type, context)
    local t = get_card_areas(_type, context)
    if _type == 'playing_cards' then
        if get_btd() then
            local new_area = {cards = {}, reverse = true}
            for i= #G.play.cards - 1, 1, -1 do
                new_area.cards[#new_area.cards+1] = G.play.cards[i]
            end
            table.insert(t, 2, new_area)
        end
    end
    return t
end

local calc_main = SMODS.calculate_main_scoring
function SMODS.calculate_main_scoring(context, scoring_hand)
    if get_btd() and context.cardarea and context.cardarea.reverse then
        return calc_main(context, true)
    else
        return calc_main(context, scoring_hand)
    end
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if not context.blueprint and not context.retrigger_joker and context.before then
        card.ability.index = 0
    end

    if not context.retrigger_joker and not context.blueprint and context.individual and context.cardarea == G.play then
        card.ability.index = card.ability.index + 1
        if card.ability.index == #context.scoring_hand then
            return {
                no_retrigger = true,
                func = function()
                    ArrowAPI.stands.flare_aura(card, 0.50)
                end,
                message = localize('k_bites_the_dust'),
                colour = G.C.STAND,
                card = card
            }
        elseif card.ability.index > #context.scoring_hand then
            return {
                no_retrigger = true,
                func = function()
                    ArrowAPI.stands.flare_aura(card, 0.50)
                end,
            }
        end
    end

    if not context.retrigger_joker and not context.blueprint and context.end_of_round and context.main_eval then
        card.ability.index = 0
    end
end


return consumInfo