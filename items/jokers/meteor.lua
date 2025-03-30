local jokerInfo = {
    name = "Meteor",
    config = {
        id = 7,
        extra = {
            x_mult = 2
        }
    },
    rarity = 1,
    cost = 5,
    unlocked = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.trance } }
end

function jokerInfo.add_to_deck(self, card)
    check_for_unlock({ type = "discover_meteor" })
    ach_jokercheck(self, ach_checklists.ff7)
end

function jokerInfo.check_for_unlock(self, args)
    if args.type == "roche_destroyed" then
        return true
    end
end

function jokerInfo.calculate(self, card, context)
    if context.check_enhancement and context.cardarea == G.jokers then
		if context.other_card.ability.effect ~= "Glass Card" and context.other_card.ability.effect ~= "Stone Card" and
		context.other_card.base.id == 7 then	
            return {
                ['m_glass'] = true,
            }
        end
	end 
    --[[if context.destroying_card then
        if context.destroying_card:get_id() == 7 and context.destroying_card.ability.effect ~= "Glass Card" and not context.blueprint then
            if pseudorandom('meteor') < G.GAME.probabilities.normal / 4 then
                return true
            end
        end
    end]]--
end

return jokerInfo