---------------------------
--------------------------- Loading/Debug Functions
---------------------------

SMODS.Gradient({
	key = 'ortalab_1',
	colours = {
		HEX('990000'),
		HEX('990000')
	}
})

SMODS.Gradient({
	key = 'ortalab_2',
	colours = {
		HEX('E28585'),
		HEX('E28585')
	}
})

function create_dummy_ortalab(file_key, item_type, info)
	if item_type == 'Joker' then
		SMODS.Joker({
			key = file_key..'_locked',
			pos = {x = 8, y = 9},
			loc_txt = {
				name = 'Locked',
				text = {'{s:1.1}Install {E:1,s:1.3,C:csau_ortalab_1}Ortalab'}
			},
			discovered = true,
			no_doe = true,
			rarity = (info and info.rarity) or nil,
			in_pool = function(self)
				return false
			end,
			set_badges = function(self, card, badges)
				if card.area and card.area == G.jokers or card.config.center.discovered then
					badges[#badges+1] = create_badge('Ortalab', HEX('990000'), HEX('E28585'), 0.9 )
				end
			end
		})
	end
end

-- TODO: replace loading with arrow loading functions

-- TODO: make this an arrow api function
math.randomseed(os.time())
--- External random function for on-load purposes
--- @param chance number Postive integer to compare using math.random()
--- @returns boolean # Result of the random roll
function externalPseudorandom(chance, total)
	if total <= 0 then return false end
	local randomNumber = math.random(1, total)
	return randomNumber <= chance
end





---------------------------
--------------------------- Csau Joker helper functions
---------------------------

-- TODO: make this an arrow API functiomn
--- Utility function to check if all cards in hand are of the same suit. DO NOT USE WHEN RETURNING QUANTUM ENHANCEMENTS
--- @param hand table Array table of Balatro card objects, representing a played hand
--- @param suit string Key of the suit to check
--- @return boolean # True if all cards in hand are the same suit
G.FUNCS.csau_all_suit = function(hand, suit)
	for k, v in ipairs(hand) do
		if not v:is_suit(suit, nil, true) then
			return false
		end
	end
	return true
end






---------------------------
--------------------------- VHS Helper Functios
---------------------------

-- TODO: replace all VHS helper functions with arrow equivalents




---------------------------
--------------------------- Stand Helper Functions
---------------------------

-- TODO: replace all stand helper functions with arrow equivalents





---------------------------
--------------------------- CSAU Discoveries
---------------------------

-- TODO: replace G.FUNCS.discovery_check with arrow equivalent





---------------------------
--------------------------- Loc Text Helper
---------------------------

-- TODO: replace csau_format_display_number with arrow equivalent




---------------------------
--------------------------- One-off Card Helpers
---------------------------

-- TODO: move this to arrow
function SMODS.food_expires()
    local bagels = G.FUNCS.find_activated_tape('c_csau_donbeveridge')
    if bagels and not bagels.ability.destroyed then
        bagels:juice_up()
        bagels.ability.extra.uses = bagels.ability.extra.uses+1
        if to_big(bagels.ability.extra.uses) >= to_big(bagels.ability.extra.runtime) then
            G.FUNCS.destroy_tape(bagels)
            bagels.ability.destroyed = true
        end
        return false
    end

    local bunjis = SMODS.find_card('j_csau_bunji')
	local expires = true
	for _, v in ipairs(bunjis) do
		if not v.debuff then
			expires = false
			break
		end
	end

	return expires
end

-- TODO: make this an arrow API function or context
function SMODS.return_to_hand(card, context)
	if not G.GAME.blind.disabled and G.GAME.blind.name == 'The Vod' then
        return true
    elseif G.GAME.fnwk_extra_blinds then
        for _, v in ipairs(G.GAME.fnwk_extra_blinds) do
            if not v.disabled and v.name == 'The Vod' then
                return true
            end
        end
    end

	if G.FUNCS.find_activated_tape('c_csau_yoyoman') and table.contains(context.scoring_hand, card) then return true end
	if context.scoring_name == "High Card" and next(SMODS.find_card("j_csau_besomeone")) and table.contains(context.scoring_hand, card) then return true end
	return false
end

-- TODO: make this an arrow API function
G.FUNCS.hand_contains_rank = function(hand, ranks, require_all)
	require_all = require_all or false
	local found = {}

	for _, card in ipairs(hand) do
		if card.ability.effect == "Base" then
			local rank = card:get_id()
			for _, target in ipairs(ranks) do
				if rank == target then
					found[target] = true
				end
			end
		end
	end
	if require_all then
		for _, target in ipairs(ranks) do
			if not found[target] then
				return false
			end
		end
		return true
	else
		return next(found) ~= nil
	end
end

-- TODO: replace all cards that modify draw with contexts where possible

-- TODO: replace deck preview with arrow equivalent (needs to be moved from Jojobal)

-- TODO: replace G.FUNCS.have_multiple_jokers with SMODS.find_card

-- TODO: this tag system might be useful for arrow
local tag_colors = {
    tag_uncommon = G.C.GREEN,
    tag_rare = G.C.RED,
    tag_negative = G.C.DARK_EDITION,
    tag_foil = G.C.DARK_EDITION,
    tag_holo = G.C.DARK_EDITION,
    tag_polychrome = G.C.DARK_EDITION,
    tag_investment = G.C.MONEY,
    tag_voucher = G.C.SECONDARY_SET.Voucher,
    tag_boss = G.C.IMPORTANT,
    tag_standard = G.C.IMPORTANT,
    tag_charm = G.C.SECONDARY_SET.Tarot,
    tag_meteor = G.C.SECONDARY_SET.Planet,
    tag_buffoon = G.C.RED,
    tag_handy = G.C.MONEY,
    tag_garbage = G.C.MONEY,
    tag_ethereal = G.C.SECONDARY_SET.Spectral,
    tag_coupon = G.C.MONEY,
    tag_double = G.C.IMPORTANT,
    tag_juggle = G.C.BLUE,
    tag_d_six = G.C.GREEN,
    tag_top_up = G.C.BLUE,
    tag_skip = G.C.MONEY,
    tag_orbital = G.C.SECONDARY_SET.Planet,
    tag_economy = G.C.MONEY,
}

G.FUNCS.csau_get_tag = function(type, seed)
	type = type or 'joker'
	seed = seed or 'freejokertag'
	local _pool, _ = get_current_pool('Tag', nil, nil, seed)
	local real_pool = {}
	for i, v in ipairs(_pool) do
		if v ~= "UNAVAILABLE" then
			if G.P_TAGS[v] then
				local tag = G.P_TAGS[v]
				if type == 'joker' and (tag.config.type and starts_with(tag.config.type, 'store_joker') and (not tag.min_ante or (G.GAME.round_resets.ante >= tag.min_ante)))
				or type == 'booster' and (tag.config.type == 'new_blind_choice' and (not tag.min_ante or (G.GAME.round_resets.ante >= tag.min_ante)) and v ~= 'tag_boss')
				or type == 'any' then
					real_pool[#real_pool+1] = v
				end
			end
		end
	end
	local key = pseudorandom_element(real_pool, pseudoseed(seed))
	return key, tag_colors[key] or G.C.IMPORTANT
end

-- TODO: replace G.FUNCS.nutbuster_active with SMODS.find_card

-- TODO: replace get_legendary_desc with arrow equivalent

-- TODO: replace G.FUNCS.cbt_can_delevel with arrow equivalent get_max_hand_level func