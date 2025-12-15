local blindInfo = {
    name = "Felt Fortress",
    atlas = 'blinds',
    pos = {x = 0, y = 8},
    boss_colour = HEX('88e054'),
    dollars = 8,
    mult = 2,
    vars = {},
    debuff = {},
    boss = {min = 1, max = 10, showdown = true},
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'joel',
        },
        custom_color = 'joel'
    },
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    }
}

function blindInfo.defeat(self)
    check_for_unlock({ type = "defeat_feltfortress" })
end

blindInfo.press_play = function(self)
    if not G.GAME.blind.disabled then
        G.GAME.blind.activated = true
        G.GAME.blind.fortress_num_hands = (G.GAME.blind.fortress_num_hands or 0) + 1
    end
end

--Modified code from Math Blinds
blindInfo.drawn_to_hand = function(self)
    if not G.GAME.blind.disabled and G.GAME.blind.activated then
        G.GAME.blind.activated = false
        G.GAME.blind.chips = math.floor(G.GAME.blind.chips * 2)
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        G.GAME.blind:wiggle()
        play_area_status_text(localize('k_fort_doubled'))
        G.hand_text_area.blind_chips:juice_up()
    end
end

blindInfo.disable = function(self, silent)
    G.GAME.blind.chips = math.floor(G.GAME.blind.chips * (2 ^ (-1 * (G.GAME.blind.fortress_num_hands or 0))))
    G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    G.GAME.blind.fortress_num_hands = nil
end

--- this feels like it's going to get me killed
local ref_blind_save = Blind.save
function Blind:save()
	local ret = ref_blind_save(self)
    ret.fortress_num_hands = self.fortress_num_hands
	return ret
end

local ref_blind_load = Blind.load
function Blind:load(blindTable)
	local ret = ref_blind_load(self, blindTable)
    self.fortress_num_hands = blindTable.fortress_num_hands
    return ret
end

return blindInfo