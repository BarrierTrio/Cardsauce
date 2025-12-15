SMODS.Atlas({key = 'banned_consumables', path = 'banned/banned_consumables.png', px = 169, py = 123})

local consumInfo = {
    name = "Banned Consumables",
    atlas = 'banned_consumables',
    set = "Tarot",
    config = {},
    no_doe = true,
    no_mod_badges = true,
    no_collection = true,
}

function consumInfo.set_card_type_badge(self, card, badges)
    badges = nil
end

function consumInfo.in_pool(self, args)
    return false
end

function consumInfo.set_sprites(self, card, front)
    card.T.w = card.T.w * (self.width/71) * 0.6
    card.T.h = card.T.h * (self.height/95) * 0.6

    card.children.center.sprite_pos = {x = 1, y = 0}
    local t = {x = card.T.x, y = card.T.y, w = card.T.w, h = card.T.h}
    local minor = {
		role_type = 'Minor',
		major = card,
		offset = { x = 0, y = 0 },
		xy_bond = 'Strong',
		wh_bond = 'Strong',
		r_bond = 'Strong',
		scale_bond = 'Strong',
		draw_major = card
	}
    local atlas = G.ASSET_ATLAS['csau_banned_consumables']

    -- second layer
    card.children.under_layer = Sprite(t.x, t.y, t.w, t.h, atlas, {x = 2, y = 0})
    card.children.under_layer:set_role(minor)
    card.children.under_layer.custom_draw = true

    -- first layer
    card.children.text_layer = Sprite(t.x, t.y, t.w, t.h, atlas, {x = 0, y = 0})
    card.children.text_layer:set_role(minor)
    card.children.text_layer.custom_draw = true
end

function consumInfo.draw(self, card, layer)
    if not (card.children.under_layer and card.children.text_layer) then
        return
    end

    card.children.under_layer:draw_shader('dissolve', card.shadow_height)
	card.children.under_layer:draw_shader('dissolve')
    card.children.text_layer:draw_shader('dissolve', card.shadow_height)
    card.children.text_layer:draw_shader('dissolve')
end

return consumInfo