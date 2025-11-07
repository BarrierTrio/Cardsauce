-- TODO replace achievment loading with arrow achievement loading
-- enumerate all achievements in the achievements directory instead of loading it directly
SMODS.Atlas({ key = 'csau_achievements', path = "csau_achievements.png", px = 66, py = 66})
local achievementsToLoad = {}
for s in recursiveEnumerate(UsableModPath .. "/items/achievements"):gmatch("[^\r\n]+") do
    achievementsToLoad[#achievementsToLoad + 1] = s:gsub(PathPatternReplace .. "/items/achievements/", "")
end

if csau_enabled['enableAchievements'] then
	-- I retained the individual achievement loading because it's so different from the centralized
	-- load_cardsauce_item function that it didn't matter much
	for i, v in ipairs(achievementsToLoad) do
		local trophyInfo = assert(SMODS.load_file("items/achievements/" .. v))()

		if trophyInfo.csau_dependencies then
			if not csau_filter_loading('item', { dependencies = trophyInfo.csau_dependencies }) then return end
		end

		trophyInfo.key = v:sub(1, -5)
		trophyInfo.atlas = 'csau_achievements'
		if trophyInfo.rarity then
			if trophyInfo.rarity == 1 then
				trophyInfo.pos = { x = 1, y = 0 }
			elseif trophyInfo.rarity == 2 then
				trophyInfo.pos = { x = 2, y = 0 }
			elseif trophyInfo.rarity == 3 then
				trophyInfo.pos = { x = 3, y = 0 }
			elseif trophyInfo.rarity == 4 then
				trophyInfo.pos = { x = 4, y = 0 }
			end
		end

		SMODS.Achievement(trophyInfo)
	end
end


function ach_jokercheck(card, table)
	local counter = 0
	for i, name in ipairs(table[3]) do
		if next(find_joker(name)) or card.name == name then
			counter = counter + 1
		end
	end
	if counter >= table[1] then
		check_for_unlock({ type = table[2] })
	end
end

function G.FUNCS.ach_pepsecretunlock(text)
	for k, v in pairs(SMODS.PokerHands) do
		if k == text then
			if v.visible == false then
				check_for_unlock({ type = "unlock_pep" })
			end
		end
	end
end

function G.FUNCS.ach_characters_check()
	if G.SETTINGS.CUSTOM_DECK.Collabs.Spades == "collab_CYP" and
	   G.SETTINGS.CUSTOM_DECK.Collabs.Hearts == "collab_TBoI" and
	   G.SETTINGS.CUSTOM_DECK.Collabs.Diamonds == "collab_SV" and
	   G.SETTINGS.CUSTOM_DECK.Collabs.Clubs == "collab_STS" then
		check_for_unlock({ type = "skin_characters" })
	end
end

function G.FUNCS.ach_vineshroom_check()
	if ends_with(G.SETTINGS.CUSTOM_DECK.Collabs.Clubs, 'vineshroom') or G.SETTINGS.CUSTOM_DECK.Collabs.Clubs == "collab_PC" or G.SETTINGS.CUSTOM_DECK.Collabs.Clubs == "collab_WF" then
		check_for_unlock({ type = "skin_vineshroom" })
	end
end

G.FUNCS.reset_trophies = function(e)
	local warning_text = e.UIBox:get_UIE_by_ID('warn')
	if warning_text.config.colour ~= G.C.WHITE then
		warning_text:juice_up()
		warning_text.config.colour = G.C.WHITE
		warning_text.config.shadow = true
		e.config.disable_button = true
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06, blockable = false, blocking = false, func = function()
			play_sound('tarot2', 0.76, 0.4);return true end}))
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.35, blockable = false, blocking = false, func = function()
			e.config.disable_button = nil;return true end}))
		play_sound('tarot2', 1, 0.4)
	else
		G.FUNCS.wipe_on()
		for k, v in pairs(SMODS.Achievements) do
			if starts_with(k, 'ach_csau_') then
				G.SETTINGS.ACHIEVEMENTS_EARNED[k] = nil
				G.ACHIEVEMENTS[k].earned = nil
			end
		end
		G:save_settings()
		G.E_MANAGER:add_event(Event({
			delay = 1,
			func = function()
				G.FUNCS.wipe_off()
				return true
			end
		}))
	end
end