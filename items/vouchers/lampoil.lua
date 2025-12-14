local voucherInfo = {
    name = 'Lamp Oil',
    atlas = 'vouchers',
    pos = {x = 0, y = 0},
    cost = 10,
    config = {
        extra = {
            num_cards = 1,
            rounds = 1
        }
    },
    artist = 'MightyKingWario'
}

function voucherInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.num_cards, card.ability.extra.num_cards ~= 1 and 's' or ''}}
end

function voucherInfo.redeem(self, card, area, copier)
    G.GAME.morshu_cards = G.GAME.morshu_cards + card.ability.extra.num_cards
    G.GAME.morshu_rounds = (G.GAME.morshu_rounds or 0) + card.ability.extra.rounds

    if not G.morshu_save or not G.morshu_area then
    -- set the morshu area to appear
        if G.morshu_area then G.morshu_area.config.card_limit = G.GAME.morshu_cards end

        -- set the morshu area to appear
        G.morshu_save = G.morshu_save or UIBox{
            definition = G.UIDEF.morshu_save(G.morshu_area),
            config = {align='tmi', instance_type = 'NODE', offset = {x=7.6,y=G.ROOM.T.y+29}, major = G.hand, bond = 'Weak'}
        }

        -- recreate shop card UIs for existing cards
        for k, v in pairs(G.I.CARD) do
            if v.area and v.area.config.type == 'shop' then
                if v.children.price then v.children.price:remove(); v.children.price = nil end
                if v.children.buy_button then v.children.buy_button:remove(); v.children.buy_button = nil end
                if v.children.buy_and_use_button then v.children.buy_and_use_button:remove(); v.children.buy_and_use_button = nil end
                remove_nils(v.children)

                create_shop_card_ui(v, nil, v.area)
            end
        end
    end

    G.morshu_save.alignment.offset.py = -5.3
    G.morshu_save.alignment.offset.y = G.ROOM.T.y + 29
end

return voucherInfo