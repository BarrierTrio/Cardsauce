local jokers = {
    'j_csau_roche',
    'j_csau_chad',
    'j_csau_meteor',
}

local achInfo = {
    rarity = 2,
    unlock_condition = function(self, args)
        if G.jokers and #G.jokers.cards > 0 then
            return ArrowAPI.game.have_multiple_jokers(jokers)
        end
    end,
}

function achInfo.loc_vars(self)
    return { vars = { #jokers }}
end

return achInfo