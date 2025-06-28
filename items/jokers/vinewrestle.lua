local jokerInfo = {
    name = 'Vinewrestle',
    config = {},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "joel",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.cejai } }
end

function jokerInfo.calculate(self, card, context)
    local bad_context = context.repetition or context.individual or context.blueprint
    if context.end_of_round and G.GAME.blind.boss and not card.debuff and not bad_context then
        local key, color = G.FUNCS.csau_get_tag('joker', 'ITSSOMOAJOE')
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_one')..G.localization.descriptions["Tag"][key].name, colour = color})
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            blocking = false,
            func = (function()
                add_tag(Tag(key))
                play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                return true
            end)
        }))
    end
end

return jokerInfo
	