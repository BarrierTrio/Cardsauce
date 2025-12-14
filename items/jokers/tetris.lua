Cardsauce.tetris = SMODS.load_file('items/jokers/Tetris/src/game.lua')()

local jokerInfo = {
    name = "YOU GOT THE TETRIS",
    atlas = 'jokers',
	pos = {x = 8, y = 14},
    config = {
        extra = {
            mult = 0
        }
    },
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
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
    },
    artist = {'Kekulism', 'GuffNFluff'}
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main and to_big(card.ability.extra.mult) > to_big(0) then
        return {
            mult = card.ability.extra.mult,
        }
    end
end

function jokerInfo.add_to_deck(self, card)
    Cardsauce.tetris.load()
    Cardsauce.tetris.isActive = true
end

function jokerInfo.remove_from_deck(self, card)
    Cardsauce.tetris.isActive = false
end

function jokerInfo.update(self, card, dt)
    if G.STAGE == G.STAGES.RUN and Cardsauce.tetris.isActive then
        card.ability.extra.mult = Cardsauce.tetris.linesCleared
        if Cardsauce.tetris.speedLevel >= 16 then
            check_for_unlock({ type = "high_tetris" })
        end
        if Cardsauce.tetris.queue and #Cardsauce.tetris.queue > 0 then
            local msg = Cardsauce.tetris.queue[1]
            if msg.type == 'line' then
                card_eval_status_text(card, 'extra', nil, nil, nil, {blockable = false, message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}})
            elseif msg.type == 'reset' then
                card_eval_status_text(card, 'extra', nil, nil, nil, {blockable = false, message = localize('k_reset'), colour = G.C.RED})
            end
            table.remove(Cardsauce.tetris.queue, 1)
        end
    else
        card.ability.extra.mult = 0
    end
end

function jokerInfo.load(self, card, card_table, other_card)
    Cardsauce.tetris.load()
    Cardsauce.tetris.isActive = true
end

function jokerInfo.draw(self,card,layer)
    --Without love.graphics.push, .pop, and .reset, it will attempt to use values from the rest of
    --the rendering code. We need a clean slate for rendering to canvases.
    if card.area ~= G.jokers then
        return
    end

    love.graphics.push('all')
    love.graphics.reset()
    Cardsauce.tetris.draw(6, 6)
    love.graphics.pop()
end

return jokerInfo