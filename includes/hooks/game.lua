-- TODO: move color change behavior to arrow

local ref_update_shop = Game.update_shop
function Game:update_shop(dt)
	if not G.STATE_COMPLETE and (next(SMODS.find_card('v_csau_lampoil')) or next(SMODS.find_card('v_csau_ropebombs'))) then
		local morshu_exists = not not G.morshu_save

		-- this is the result of stupid UI layerin bullshit
		if G.morshu_save and G.morshu_save.config.instance_type then
			for k, v in pairs(G.I[G.morshu_save.config.instance_type]) do
				if v == G.morshu_save then
					table.remove(G.I[G.morshu_save.config.instance_type], k)
					break;
				end
			end
			-- move it to regular UI boxes now if it's not already
			G.morshu_save.config.instance_type = nil
			table.insert(G.I.UIBOX, G.morshu_save)
		end

		G.morshu_save = G.morshu_save or UIBox{
			definition = G.UIDEF.morshu_save(G.morshu_area),
			config = {align='tmi', offset = {x=7.6,y=G.ROOM.T.y+29}, major = G.hand, bond = 'Weak'}
		}

		G.E_MANAGER:add_event(Event({
			func = function()
				G.morshu_save.alignment.offset.y = -5.3
				G.morshu_save.alignment.offset.x = 7.6
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					blockable = false,
					func = function()
						if math.abs(G.morshu_save.T.y - G.morshu_save.VT.y) < 3 then
							if not morshu_exists then
								if G.load_morshu_area then
									G.morshu_area:load(G.load_morshu_area)
									for k, v in ipairs(G.morshu_area.cards) do
										create_shop_card_ui(v)
										if v.ability.consumeable then v:start_materialize() end
									end
									G.load_morshu_area = nil
								elseif not G.morshu_area.cards then
									G.morshu_area.cards = {}
								end
							end
							return true
						end
					end
				}))
				return true
			end
		}))
	end

	return ref_update_shop(self, dt)
end

-- TODO: update *all* cardsauce animated centers using new SMODS behavior for wide support of AnimatedSprite
local ref_update = Game.update
function Game:update(dt)
	local ret = ref_update(self, dt)
	if G.P_CENTERS then
		for k, v in pairs(G.csau_animated_centers) do
			if G.P_CENTERS[k] then
				local speed = v.speed or 0.1
				v.dt = v.dt + dt
				if v.dt > speed then
					v.dt = 0
					local obj = G.P_CENTERS[k]
					if v.tiles.x and v.tiles.y then
						local last_tile = { x = ((v.tiles.last_tile and v.tiles.last_tile.x or v.tiles.x)-1), y = ((v.tiles.last_tile and v.tiles.last_tile.y or v.tiles.y)-1) }
						local width = v.tiles.x-1
						local height = v.tiles.y-1
						if (obj.pos.x == last_tile.x and obj.pos.y == last_tile.y) then
							obj.pos.x = 0
							obj.pos.y = 0
						elseif (obj.pos.x < width) then obj.pos.x = obj.pos.x + 1
						elseif (obj.pos.y < height) then
							obj.pos.x = 0
							obj.pos.y = obj.pos.y + 1
						end
					elseif v.tiles.x and not v.tiles.y then
						local width = v.tiles.x-1
						if (obj.pos.x < width) then obj.pos.x = obj.pos.x + 1
						else obj.pos.x = 0 end
					end
				end
			end
		end
	end
	return ret
end