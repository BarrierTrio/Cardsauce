function G.UIDEF.vic_speech_bubble(text_key, loc_vars, extra)
    local text = {}
    local extra = extra or {}

    localize{type = 'quips', key = text_key, vars = loc_vars or {}, nodes = text}
    local row = {}
    for k, v in ipairs(text) do
        --v[1].config.colour = extra.text_colour or v[1].config.colour or G.C.JOKER_GREY
        row[#row+1] =  {n=G.UIT.R, config={align = extra.text_alignment or "cl"}, nodes=v}
    end
    local t = {n=G.UIT.ROOT, config = {align = "cm", minh = 1, r = 0.3, padding = 0.07, minw = 1, colour = extra.root_colour or G.C.JOKER_GREY, shadow = true}, nodes={
        {n=G.UIT.C, config={align = "cm", minh = 1, r = 0.2, padding = 0.1, minw = 1, colour = extra.bg_colour or G.C.WHITE}, nodes={
            {n=G.UIT.C, config={align = "cm", minh = 1, r = 0.2, padding = 0.03, minw = 1, colour = extra.bg_colour or G.C.WHITE}, nodes=row}}
        }
    }}
    return t
end

local G_FUNCS_can_buy_and_use_ref=G.FUNCS.can_buy_and_use
G.FUNCS.can_buy_and_use = function(e)
	G_FUNCS_can_buy_and_use_ref(e)
	if e.config.ref_table.ability.set=='VHS' then
		e.UIBox.states.visible = false
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

-- Modified Code from Malverk
local G_UIDEF_use_and_sell_buttons_ref = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
	if card.ability.set == "VHS" then
		if (card.area == G.pack_cards and G.pack_cards) and card.ability.consumeable then --Add a use button
			use = {n=G.UIT.R, config={align = 'cm'}, nodes={
				{n=G.UIT.C, config={align = "cm"}, nodes={
					{n=G.UIT.C, config={align = "bm", maxw = G.CARD_W * 0.65, shadow = true, padding = 0.1, r=0.08, minw = 0.5 * G.CARD_W, minh = 0.8, hover = true, colour = G.C.GREEN, button = "use_card", func = "can_select_card", ref_table = card}, nodes={
						{n=G.UIT.T, config={text = localize('b_select'), colour = G.C.UI.TEXT_LIGHT, scale = 0.45, shadow = true}}
					}}
				}}
			}}
			local t = {n=G.UIT.ROOT, config = {align = 'cm', padding = 0, colour = G.C.CLEAR}, nodes={
				{n=G.UIT.C, config={align = 'cm'}, nodes={
					use,
				}},
			}}
			return t
		end
	end

	if card.ability.set == "Stand" then
		local sell = {n=G.UIT.C, config={align = "cr"}, nodes={
			{n=G.UIT.C, config={ref_table = card, align = "cr",padding = 0.1, r=0.08, minw = 1.25, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'sell_card', func = 'can_sell_card'}, nodes={
				{n=G.UIT.B, config = {w=0.1,h=0.6}},
				{n=G.UIT.C, config={align = "tm"}, nodes={
					{n=G.UIT.R, config={align = "cm", maxw = 1.25}, nodes={
						{n=G.UIT.T, config={text = localize('b_sell'),colour = G.C.UI.TEXT_LIGHT, scale = 0.4, shadow = true}}
					}},
					{n=G.UIT.R, config={align = "cm"}, nodes={
						{n=G.UIT.T, config={text = localize('$'),colour = G.C.WHITE, scale = 0.4, shadow = true}},
						{n=G.UIT.T, config={ref_table = card, ref_value = 'sell_cost_label',colour = G.C.WHITE, scale = 0.55, shadow = true}}
					}}
				}}
			}},
		}}
		local t = {
			n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
				{n=G.UIT.C, config={padding = 0.15, align = 'cl'}, nodes={
					{n=G.UIT.R, config={align = 'cl'}, nodes={
						sell
					}},
				}},
			}}
		return t
	end
	return G_UIDEF_use_and_sell_buttons_ref(card)
end

function G.UIDEF.morshu_save(existing_morshu_area)
	-- keep the old one if it exists to maintain
	G.morshu_area = existing_morshu_area or CardArea(
		G.hand.T.x+0,
		G.hand.T.y+G.ROOM.T.y + 9,
		1.25*G.CARD_W,
		0.85*G.CARD_H,
		{card_limit = G.GAME.morshu_cards or 0, type = 'shop', highlight_limit = 1})

	local t = {n=G.UIT.ROOT, config = {align = 'cl', colour = G.C.CLEAR}, nodes={
		UIBox_dyn_container({{
			n=G.UIT.C, config={align = "cm", padding = 0.05, emboss = 0.05, r = 0.1, colour = G.C.BLACK}, nodes={
				{n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
					{n=G.UIT.C, config={align = "cm", padding = 0.15, r=0.2, colour = G.C.L_BLACK, emboss = 0.05}, nodes={
						{n=G.UIT.C, config={align = "cm", padding = 0.2, r=0.2, colour = G.C.BLACK, maxh = G.morshu_area.T.h+0.4}, nodes={
						{n=G.UIT.T, config={text = localize('k_morshu_ui'), scale = 0.45, colour = G.C.L_BLACK, vert = true}},
						{n=G.UIT.O, config={object = G.morshu_area}},
						}},
					}},
				}}
			}
		}}, false, G.C.CLEAR, G.C.CLEAR)
	}}
	t.nodes[1].config.colour = G.C.CLEAR
    return t
end

local function illegal_morshu_area(area, card)
	return not (area == G.shop_vouchers or area == G.shop_jokers or area == G.shop_booster or (area and area.config.type == 'shop' and not area == G.morshu_area))
end

--I wish i didnt have to overwrite this whole thing but it gives me no fuckin choice i hate working with UI -keku
local cscui_ref = create_shop_card_ui
function create_shop_card_ui(card, type, area)
	local morshu_exists = not not G.morshu_save
	if (G.morshu_area or morshu_exists) and not illegal_morshu_area(area, card) then
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.43,
			blocking = false,
			blockable = false,
			func = (function()
				if card.opening then return true end
				local t1 = {
					n=G.UIT.ROOT, config = {minw = 0.6, align = 'tm', colour = darken(G.C.BLACK, 0.2), shadow = true, r = 0.05, padding = 0.05, minh = 1}, nodes={
						{n=G.UIT.R, config={align = "cm", colour = lighten(G.C.BLACK, 0.1), r = 0.1, minw = 1, minh = 0.55, emboss = 0.05, padding = 0.03}, nodes={
							{n=G.UIT.O, config={object = DynaText({string = {{prefix = localize('$'), ref_table = card, ref_value = 'cost'}}, colours = {G.C.MONEY},shadow = true, silent = true, bump = true, pop_in = 0, scale = 0.5})}},
						}}
					}}

				local function get_t3(align, ghost, invisible)
					ghost = ghost or false
					local visible = true
					if ghost and invisible then
						visible = false
					end
					align = align or 'cr'
					return { n=ghost and G.UIT.R or G.UIT.ROOT, config = {id = 'buy_and_use'..(ghost and '_ghost' or ''), ref_table = card, minh = 1.1, padding = 0.1, align = align, colour = visible and G.C.RED or G.C.CLEAR, shadow = visible, r = 0.08, minw = 1.2, func = not ghost and 'can_buy_and_use', one_press = true, button = not ghost and 'buy_from_shop', hover = true, focus_args = {type = 'none'}}, nodes={
						--{n=G.UIT.B, config = {w=0.1,h=0.6}},
						{n=G.UIT.C, config = {align = 'cm'}, nodes={
							{n=G.UIT.R, config = {align = 'cm', maxw = 1}, nodes={
								{n=G.UIT.T, config={text = localize('b_buy'),colour = visible and G.C.WHITE or G.C.CLEAR, scale = 0.5}}
							}},
							{n=G.UIT.R, config = {align = 'cm', maxw = 1}, nodes={
								{n=G.UIT.T, config={text = localize('b_and_use'),colour = visible and G.C.WHITE or G.C.CLEAR, scale = 0.3}}
							}},
						}}
					}}
				end


				local buy = {n=G.UIT.C, config={align = 'bm'}, nodes= {
					card.ability.set == 'Voucher' and
							{n=G.UIT.R, config = {ref_table = card, minw = 0.85, maxw = 1, padding = 0.1, align = 'bm', colour = G.C.GREEN, shadow = true, r = 0.08, minh = 0.94, func = 'can_redeem', one_press = true, button = 'redeem_from_shop', hover = true}, nodes={
								{n=G.UIT.T, config={text = localize('b_redeem'),colour = G.C.WHITE, scale = 0.4}}
							}} or card.ability.set == 'Booster' and
							{n=G.UIT.R, config = {ref_table = card, minw = 1.1, maxw = 1.3, padding = 0.1, align = 'bm', colour = G.C.GREEN, shadow = true, r = 0.08, minh = 0.94, func = 'can_open', one_press = true, button = 'open_booster', hover = true}, nodes={
								{n=G.UIT.T, config={text = localize('b_open'),colour = G.C.WHITE, scale = 0.5}}
							}} or
							{n=G.UIT.R, config = {ref_table = card, minw = 1.1, maxw = 1.3, padding = 0.1, align = 'bm', colour = G.C.GOLD, shadow = true, r = 0.08, minh = 0.94, func = 'can_buy', one_press = true, button = 'buy_from_shop', hover = true}, nodes={
								{n=G.UIT.T, config={text = localize('b_buy'),colour = G.C.WHITE, scale = 0.5}}
							}}
				}}

				local scale = 1
				if card.children.center.scale and card.children.center.scale.y then
					scale = card.children.center.scale.y/95
				end

				local center_nodes = {}
				center_nodes[#center_nodes+1] = buy
				local center_column = {n=G.UIT.C, config={align = 'bm', minh=(((2.4*47/41)+0.3)+1.04+(card.ability.set == 'Booster' and 0.8 or 0))*scale}, nodes = center_nodes}

				local left_nodes = {}
				left_nodes[#left_nodes+1] = get_t3('cl', true, true)
				local left_column = {n=G.UIT.C, config={align = 'cm'}, nodes = left_nodes}

				local right_nodes = {}
				right_nodes[#right_nodes+1] = {n=G.UIT.R, config = {id = 'morshu_save', ref_table = card, minh = 0.8, padding = 0.1, align = 'cr', colour = G.C.PURPLE, shadow = true, r = 0.08, minw = 1.5, one_press = true, button = 'save_to_morshu', hover = true, focus_args = {type = 'none'}}, nodes={
					{n=G.UIT.C, config = {align = 'cm', maxw = 1}, nodes={
						{n=G.UIT.T, config={text = localize('b_save'),colour = G.C.WHITE, scale = 0.5}}
					}}
				}}
				if card.ability.consumeable and card:can_use_consumeable(true, true) then
					right_nodes[#right_nodes+1] = get_t3('cr', true, true)
				end
				local right_column = {n=G.UIT.C, config={align = 'cm', padding = 0.1}, nodes = right_nodes}

				local width = (2.4*35/41)

				local nodes = {
					{n=G.UIT.C, config={align = 'cr', minw = width}, nodes={left_column}},
					{n=G.UIT.C, config={align = 'cm'}, nodes={center_column}},
					{n=G.UIT.C, config={align = 'cl', minw = width}, nodes={right_column}}
				}

				local t2 =
				{n=G.UIT.ROOT, config = {align = 'cm', padding = 0, colour = G.C.CLEAR}, nodes={
					{n=G.UIT.R, config={align = 'cm'}, nodes=nodes},
				}}


				card.children.price = UIBox{
					definition = t1,
					config = {
						align="tm",
						offset = {x=0,y=1.5},
						major = card,
						bond = 'Weak',
						parent = card
					}
				}

				card.children.buy_button = UIBox{
					definition = t2,
					config = {
						align="cm",
						offset = {x=0,y=0},
						major = card,
						bond = 'Weak',
						parent = card
					}
				}

				card.children.buy_button.states.hover.can = false
				card.children.buy_button.states.click.can = false

				local t3 = {
					n=G.UIT.ROOT, config = {id = 'buy_and_use', ref_table = card, minh = 1.1, padding = 0.1, align = 'cr', colour = G.C.RED, shadow = true, r = 0.08, minw = 1.1, func = 'can_buy_and_use', one_press = true, button = 'buy_from_shop', hover = true, focus_args = {type = 'none'}}, nodes={
						{n=G.UIT.B, config = {w=0.1,h=0.6}},
						{n=G.UIT.C, config = {align = 'cm'}, nodes={
							{n=G.UIT.R, config = {align = 'cm', maxw = 1}, nodes={
								{n=G.UIT.T, config={text = localize('b_buy'),colour = G.C.WHITE, scale = 0.5}}
							}},
							{n=G.UIT.R, config = {align = 'cm', maxw = 1}, nodes={
								{n=G.UIT.T, config={text = localize('b_and_use'),colour = G.C.WHITE, scale = 0.3}}
							}},
						}}
					}}

				if card.ability.consumeable then --and card:can_use_consumeable(true, true)
					card.children.buy_and_use_button = UIBox{
						definition = t3,
						config = {
							align="cr",
							offset = {x=-0.3,y=0.48},
							major = card,
							bond = 'Weak',
							parent = card
						}
					}
				end

				card.children.price.alignment.offset.y = card.ability.set == 'Booster' and 0.5 or 0.38

				return true
			end)
		}))
	else
		cscui_ref(card, type, area)
	end
end

local cfb_ref = G.UIDEF.card_focus_button
function G.UIDEF.card_focus_button(args)
	if not args then return end
	if args.type == 'save' then
		local button_contents = {}
		button_contents = {n=G.UIT.T, config={text = localize('b_save'),colour = G.C.WHITE, scale = 0.4}}
		return UIBox{
			T = {args.card.VT.x,args.card.VT.y,0,0},
			definition =
			{n=G.UIT.ROOT, config = {align = 'bm', colour = G.C.CLEAR}, nodes={
				{n=G.UIT.R, config={id = args.type == 'morshu_save', ref_table = args.card, ref_parent = args.parent, align = 'bm', padding = 0.05, colour = G.C.PURPLE, shadow = true, r = 0.08, func = args.func, one_press = true, button = args.button, focus_args = {type = 'none'}, hover = true}, nodes={
					{n=G.UIT.R, config={align = 'bm', minw = 1, minh = 0.75, padding = 0.08,
										focus_args = {button = 'a', scale = 0.45, orientation = 'bli', offset = {x = 0.05, y = -0.05}, type = 'none'},
										func = 'set_button_pip'}, nodes={
						{n=G.UIT.R, config={align = "bm", minw = 1}, nodes={
							{n=G.UIT.R, config={align = "cl", minw = 1.25}, nodes={}},
							{n=G.UIT.R, config={align = "cr", padding = 0.04,}, nodes={
								button_contents
							}},
						}}
					}}
				}}
			}},
			config = {
				align = 'bm',
				offset = {x=0,y=(1)*((args.card_height or 0) - 0.17 - args.card.T.h/2)},
				parent = args.parent,
			}
		}
	else
		return cfb_ref(args)
	end
end

local cfui_ref = G.UIDEF.card_focus_ui
function G.UIDEF.card_focus_ui(card)
	local ret = cfui_ref(card)
	local base_attach = ret:get_UIE_by_ID('ATTACH_TO_ME')
	local card_width = card.T.w + (card.ability.consumeable and -0.1 or card.ability.set == 'Voucher' and -0.16 or 0)
	local card_height = card.T.h
	if G.shop and G.morshu_area then
		if card.area == G.morshu_area then
			if card.ability.set == "Booster" then
				base_attach.children.redeem = G.UIDEF.card_focus_button{
					card = card, parent = base_attach, type = 'buy',
					func = 'can_open', button = 'open_booster', card_width = card_width*0.85
				}
			elseif card.ability.set == "Voucher" then
				base_attach.children.redeem = G.UIDEF.card_focus_button{
					card = card, parent = base_attach, type = 'buy',
					func = 'can_open', button = 'open_booster', card_width = card_width*0.85
				}
			else
				local buy_and_use = nil
				if card.ability.consumeable then
					base_attach.children.buy_and_use = G.UIDEF.card_focus_button{
						card = card, parent = base_attach, type = 'buy_and_use',
						func = 'can_buy_and_use', button = 'buy_from_shop', card_width = card_width
					}
					buy_and_use = true
				end
				base_attach.children.buy = G.UIDEF.card_focus_button{
					card = card, parent = base_attach, type = 'buy',
					func = 'can_buy', button = 'buy_from_shop', card_width = card_width, buy_and_use = buy_and_use
				}
			end
		elseif not illegal_morshu_area(card.area, card) then
			base_attach.children.use = G.UIDEF.card_focus_button{
				card = card, parent = base_attach, type = 'save',
				func = nil, button = 'save_to_morshu', card_width = card_width, card_height = card_height
			}
		end
	end
	return ret
end

function G.FUNCS.csau_run_challenge_functions(challenge)
	if challenge.restrictions then
	 	if challenge.restrictions.banned_cards and type(challenge.restrictions.banned_cards) == 'function' then
			challenge.restrictions.banned_cards = challenge.restrictions.banned_cards()
		end
		if challenge.restrictions.banned_tags and type(challenge.restrictions.banned_tags) == 'function' then
			challenge.restrictions.banned_tags = challenge.restrictions.banned_tags()
		end
	end
end

local ref_cdt = G.UIDEF.challenge_description_tab
function G.UIDEF.challenge_description_tab(args)
	args = args or {}
	if args._tab == 'Restrictions' then
		local challenge = G.CHALLENGES[args._id]
		G.FUNCS.csau_run_challenge_functions(challenge)
	end
	return ref_cdt(args)
end


local ref_create_shop = create_card_for_shop
function create_card_for_shop(area)
	if area == G.shop_jokers and next(G.GAME.csau_saved_deathcards) and G.GAME.csau_rerolls_this_round == 0
	and not (G.SETTINGS.tutorial_progress and G.SETTINGS.tutorial_progress.forced_shop
	and G.SETTINGS.tutorial_progress.forced_shop[#G.SETTINGS.tutorial_progress.forced_shop]) then
		-- hate doing this
		local pop_deathcard = table.remove(G.GAME.csau_saved_deathcards, 1)
		local card = Card(
			area.T.x + area.T.w/2,
			area.T.y,
			G.CARD_W,
			G.CARD_H,
			nil,
			G.P_CENTERS[pop_deathcard.key]
		)

		card.ability.id = pop_deathcard.id
		card.ability.times_sold = pop_deathcard.times_sold
		card.cost = card.cost + (card.ability.extra.money_mod * card.ability.times_sold)
		card.ability.extra.mult = card.ability.extra.mult + (card.ability.extra.mult_mod * card.ability.times_sold)
		card:set_edition(pop_deathcard.edition)
		create_shop_card_ui(card)

		return card
	end

	return ref_create_shop(area)
end