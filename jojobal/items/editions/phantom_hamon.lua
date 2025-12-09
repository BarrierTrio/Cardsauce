SMODS.Atlas({key = 'depths_blue', path = 'depths_blue.png', px = 80, py = 64})
SMODS.Atlas({key = 'depths_darker', path = 'depths_darker.png', px = 80, py = 64})

SMODS.Shader {
    key = 'hamon',
    path = 'hamon.fs',
    send_vars = function (sprite, card)
        return {
            textureFront = G.ASSET_ATLAS['jojobal_depths_blue'].image,
            --textureBack = G.ASSET_ATLAS['jojobal_depths_darker'].image,
        }
    end,
}

local editionInfo = {
    shader = "jojobal_hamon",
    config = {},
    unlocked = true,
    in_shop = true,
    badge_colour = G.C.EDITION,
    weight = 14,
    extra_cost = 4,
    apply_to_float = true,
}

function editionInfo.loc_vars(self, info_queue, card)

end

-- Modified code from Cryptid
function editionInfo.calculate(self, card, context)

end

return editionInfo