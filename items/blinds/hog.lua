local blindInfo = {
    name = "The Hog",
    color = HEX('a11f1f'),
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    vars = {},
    debuff = {},
    boss = {min = 3, max = 10},
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
}

function blindInfo.set_blind(self)
    for _, v in ipairs(G.playing_cards) do
        v.csau_hogstruck = nil
        v.csau_hog_checked = nil
        if v:is_face(true) then
            if SMODS.pseudorandom_probability(G.GAME.blind, pseudoseed('csau_hog'), 1, 2) then
                v.csau_hogstruck = true
            end
            v.csau_hog_checked = true
        end

    end
end

function blindInfo.recalc_debuff(self, card, from_blind)
    if card.area == G.jokers or G.GAME.blind.disabled then
        return false
    end

    if card.csau_hogstruck then
        if card:is_face(true) then
            return true
        end

        card.csau_hogstruck = nil
        card.csau_hog_checked = nil
        return false
    elseif card:is_face(true) and not card.csau_hog_checked then
        card.csau_hog_checked = true
        if SMODS.pseudorandom_probability(G.GAME.blind, 'csau_hog', 1, 2) then
            card.csau_hogstruck = true
            return true
        end
    end

    return false
end

function blindInfo.loc_vars(self)
    return {vars = {SMODS.get_probability_vars(self, 1, 2, 'csau_hog')} }
end
function blindInfo.collection_loc_vars(self)
    return {vars = {SMODS.get_probability_vars(self, 1, 2, 'csau_hog')} }
end

function blindInfo.defeat(self)
    check_for_unlock({ type = "defeat_hog" })

    for _, v in ipairs(G.playing_cards) do
        v.csau_hogstruck = nil
        v.csau_hog_checked = nil
    end
end

function blindInfo.press_play(self)
    local destroy = false
    G.E_MANAGER:add_event(Event({
        func = function()
            for i, v in ipairs(G.play.cards) do
                if v.csau_hogstruck and SMODS.pseudorandom_probability(G.GAME.blind, 'csau_hog', 1, 2) then
                    destroy = true
                    if v.ability.name == 'Glass Card' then
                        v:shatter()
                    else
                        v:start_dissolve(nil, i == #G.play.cards)
                    end
                end
            end
            return true
        end
    }))

    if destroy then
        G.GAME.blind:wiggle()
    end

    return destroy
end

return blindInfo