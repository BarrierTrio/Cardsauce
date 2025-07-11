local jokerInfo = {
	name = 'Green Needle',
	config = {},
	rarity = 3,
	cost = 10,
	unlocked = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	has_shiny = true,
	unlock_condition = {type = 'win_deck', deck = 'b_green'},
	streamer = "other",
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } }

	local compat = 'incompatible'
    if G.jokers and #G.jokers.cards > 1 and card.rank < #G.jokers.cards and G.jokers.cards[#G.jokers.cards].ability.set == 'Joker' then
        compat = G.jokers.cards[#G.jokers.cards].config.center.blueprint_compat and 'compatible' or 'incompatible'
    end

    card.ability.blueprint_compat = compat
    card.ability.blueprint_compat_ui = card.ability.blueprint_compat_ui or ''
    card.ability.blueprint_compat_check = nil

    local main_end = (card.area and card.area == G.jokers) and {
        {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
            {n=G.UIT.C, config={ref_table = card, align = "m", colour = G.C.JOKER_GREY, r = 0.05, padding = 0.06, func = 'blueprint_compat'}, nodes={
                {n=G.UIT.T, config={ref_table = card.ability, ref_value = 'blueprint_compat_ui',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.8}},
            }}
        }}
    } or nil

    return {
        vars = {},
        main_end = main_end
    }
end

function jokerInfo.check_for_unlock(self, args)
	if (args.type == "win_deck" and get_deck_win_stake(self.unlock_condition.deck)) or G.FUNCS.discovery_check({ mode = 'key', key = 'b_green' }) then
		return true
	end
end

function jokerInfo.calculate(self, card, context)
	local rightmost_joker = G.jokers.cards[#G.jokers.cards]
	local ret = SMODS.blueprint_effect(card, rightmost_joker, context)
	if ret then return ret end
end

return jokerInfo
	