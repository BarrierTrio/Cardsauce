local jokerInfo = {
	name = 'Meat',
	atlas = 'jokers',
	pos = {x = 8, y = 0},
	config = {
		extra = {
			remain = 3,
			remain_mod = 1
		}
	},
	rarity = 2,
	cost = 8,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	pools = { ["Food"] = true },
	origin = 'vinny',
	dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
	artist = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
	return {vars = { card.ability.extra.remain } }
end

function jokerInfo.calculate(self, card, context)
	if card.debuff or context.blueprint then return end

	if context.before and context.scoring_name == "High Card" then
		local activate = false
		for k, v in ipairs(context.scoring_hand) do
			if not v.seal and not v.debuff then
				activate = true
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					func = function()
						local new_seal = pseudorandom_element(SMODS.Seal.obj_buffer, 'csau_meat')
						v:set_seal(new_seal, true, nil)
						v:juice_up()
						local sound = G.P_SEALS[new_seal].sound or {sound = 'gold_seal', per = 1.2, vol = 0.4}
						play_sound(sound.sound, sound.per, sound.vol)
						return true
					end
				}))
			end
		end

		if activate then
			if SMODS.food_expires(card) then
				SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "remain",
                    scalar_value = "remain_mod",
                    operation = '-',
                    no_message = true
                })
			end

			return {
				message = localize('k_meat_seal'),
				colour = G.C.MONEY
			}
		end
	end

	if context.after and to_big(card.ability.extra.remain) <= to_big(0) then
		ArrowAPI.game.card_expire(card, 'k_meat_destroy', G.C.MONEY)
		check_for_unlock({ type = "meat_beaten" })
	end
end



return jokerInfo

