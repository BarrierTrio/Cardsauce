local jokerInfo = {
    name = 'Jerma',
    config = {
        dt = 0,
        jerma_dt = 0,
        mode = 'stare',
        modes = {
            stare = {
                last_x = 1,
                y = 1,
            },
            lootget = {
                last_x = 1,
                y = 2,
            },
            blood = {
                last_x = 1,
                y = 3,
            },
            perfect = {
                last_x = 1,
                y = 4,
            }
        }
    },
    rarity = 1,
    cost = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    width = 142,
    height = 190,
    origin = 'cardsauce',
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { } }
end

local lootget = SMODS.Sound({
    key = "lootget",
    path = "lootget.ogg"
})

local lootget_blood = SMODS.Sound({
    key = "blood",
    path = "blood.ogg"
})

local perfect = SMODS.Sound({
    key = "perfect",
    path = "perfect.ogg"
})

local godgamer = SMODS.Sound({
    key = "godgamer",
    path = "godgamer.ogg"
})

function jokerInfo.calculate(self, card, context)
    if context.open_booster then
        G.E_MANAGER:add_event(Event({ func = function()
            local blood = false
            for i, v in ipairs(G.pack_cards.cards) do
                if v.config.center_key == 'j_bloodstone' then blood = true end
            end
            local dialogue = {
                message = 'jerma_lootget',
                sound = lootget,
                shake = 2,
                top = false,
                start_func = function(card)
                    card.ability.mode = 'lootget'
                end,
                end_func = function(card)
                    card.ability.mode = 'stare'
                end
            }
            local blood_dialogue = {
                message = 'jerma_blood',
                sound = lootget_blood,
                shake = 2,
                top = false,
                start_func = function(card)
                    card.ability.mode = 'blood'
                end,
                end_func = function(card)
                    card.ability.mode = 'stare'
                end
            }
            G.FUNCS.talking_card(card, blood and blood_dialogue or dialogue)
            return true
        end }))
    end
    if context.end_of_round and not card.debuff and not context.individual and not context.repetition and not context.blueprint then
        if G.ARGS.score_intensity.earned_score >= G.ARGS.score_intensity.required_score and G.ARGS.score_intensity.required_score > 0 then
            local lines = {
                [1] = "jerma_perfect",
                [2] = "jerma_godgamer",
            }
            local line = lines[pseudorandom('flames', 1, 2)]
            local dialogue = {
                message = line,
                sound = line == "jerma_perfect" and perfect or line == "jerma_godgamer" and godgamer,
                shake = 2,
                top = false,
                start_func = function(card)
                    card.ability.mode = 'perfect'
                end,
                end_func = function(card)
                    card.ability.mode = 'stare'
                end
            }
            G.FUNCS.talking_card(card, dialogue)
        end
    end
end

function jokerInfo.update(self, card, dt)
    card.ability.jerma_dt = card.ability.jerma_dt + card.ability.dt
    if G.P_CENTERS and G.P_CENTERS.j_csau_jerma and card.ability.jerma_dt > 0.075 then
        card.ability.jerma_dt = 0
        local obj = G.P_CENTERS.j_csau_jerma
        obj.pos.y = card.ability.modes[card.ability.mode].y
        if obj.pos.x == card.ability.modes[card.ability.mode].last_x then
            obj.pos.x = 0
        else
            obj.pos.x = obj.pos.x + 1
        end
    end
end

local upd = Game.update
function Game:update(dt)
    upd(self,dt)
    for k, v in pairs(G.I.CARD) do
        if v.config and v.config.center and v.config.center.key == 'j_csau_jerma' then
            v.ability.dt = dt
        end
    end
end

return jokerInfo