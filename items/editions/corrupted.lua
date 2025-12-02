local function hashString(input)
    local hash = 5381  -- Seed value
    for i = 1, #input do
        local char = string.byte(input, i)
        hash = ((hash * 32) + hash + char) % 2^15  -- Wrap to 16-bit integer
    end
    return hash
end

SMODS.Shader {
    key = 'glitched',
    path = 'glitched.fs',
    send_vars = function (sprite, card)
        if card == nil then
            return {
                seed = hashString(card.config.center.key)
            }
        end
        return {
            seed = hashString(card.config.center.key..'_'..card.ID)
        }
    end,
}

local editionInfo = {
    shader = "csau_glitched",
    config = {
        values = {
            x_mult = 1.5,
            mult = 10,
            chips = 50,
        },
        weights = {
            x_mult = {weight = 3, display = 'X1.5', color = G.C.UI.TEXT_LIGHT},
            mult = {weight = 7, display = '+10', color = G.C.MULT },
            chips = {weight = 10, display = '+50', color = G.C.CHIPS},
        },
    },
    unlocked = true,
    in_shop = true,
    weight = 14,
    extra_cost = 4,
    apply_to_float = false,
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
}

G.FUNCS.csau_corrupted_func = function(e)
    local card = e.config.ref_table
    local dynatext_main = e.children[1].children[1].config.object
    card.csau_corrupted_text = dynatext_main.string == "+50" and "Chips" or "Mult"
    e.children[1].config.colour = dynatext_main.string == "X1.5" and G.C.MULT or G.C.CLEAR
end

local function weighted_random(weights, key)
    local total = 0

	for _, v in pairs(weights) do
		total = total + v.weight
	end

	local roll = pseudorandom(pseudoseed(key), 1, total)
	local iter = 0
	for k, v in pairs(weights) do
		iter = iter + v.weight
		if roll <= iter then
			return k
		end
	end
end

function editionInfo.loc_vars(self, info_queue, card)
    card.csau_corrupted_text = "Chips"
    local corru_strings = {}
    for k, v in pairs(self.config.weights) do
        for i=1, v.weight do
            corru_strings[#corru_strings+1] = { string = v.display, colour = v.color }
        end
    end

    local main_start = {
        {
            n = G.UIT.R,
            config = { ref_table = card, func = "csau_corrupted_func" },
            nodes = {{
                n = G.UIT.C,
                config = { colour = G.C.CLEAR, r = 0.05, padding = 0.03, res = 0.15 },
                nodes = {{
                    n = G.UIT.O,
                    config = {
                        object = DynaText({
                            string = corru_strings,
                            colours = { G.C.RED },
                            pop_in_rate = 9999999,
                            silent = true,
                            random_element = true,
                            pop_delay = 0.2,
                            scale = 0.32,
                            min_cycle_time = 0,
                        }),
                    },
                }}
            },
            {
                n = G.UIT.C,
                config = { colour = G.C.CLEAR, r = 0.05, padding = 0.03, res = 0.15 },
                nodes = {{
                    n = G.UIT.O,
                    config = {
                        object = DynaText({
                            string = {
                                { ref_table = card, ref_value = "csau_corrupted_text" } },
                            colours = { G.C.UI.TEXT_DARK },
                            pop_in_rate = 9999999,
                            silent = true,
                            pop_delay = 0.2,
                            scale = 0.32,
                            min_cycle_time = 0
                        })
                    }
                }}
            }},
        },
    }
    return { main_start = main_start }
end

-- Modified code from Cryptid
function editionInfo.calculate(self, card, context)
    if (context.edition and context.cardarea == G.jokers and card.config.trigger)
    or (context.main_scoring and context.cardarea == G.play) then
        local roll = weighted_random(self.config.weights, 'csau_corrupted')
        return {
            [roll] = self.config.values[roll]
        }
    end

    if context.joker_main then
        card.config.trigger = true -- context.edition triggers twice, this makes it only trigger once (only for jonklers)
    end

    if context.after then
        card.config.trigger = nil
    end
end


return editionInfo
