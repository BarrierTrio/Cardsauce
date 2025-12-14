local voucherInfo = {
    name = 'Rope & Bombs',
    atlas = 'vouchers',
    pos = {x = 0, y = 1},
    cost = 10,
    requires = {'v_csau_lampoil'},
    config = {
        extra = {
            num_cards = 0,
            rounds = nil,
        }
    },
    unlock_condition = {type = 'csau_spent_in_shop', spent_money = 100},
    unlocked = false,
    artist = 'MightyKingWario'
}

function voucherInfo.locked_loc_vars(self, info_queue, card)
    return { vars = { self.unlock_condition.spent_money }}
end

function voucherInfo.check_for_unlock(self, args)
    if args.type ~= self.unlock_condition.type then return end
    return args.dollars >= self.unlock_condition.spent_money
end

function voucherInfo.redeem(self, card, area, copier)
    G.GAME.morshu_cards = G.GAME.morshu_cards + card.ability.extra.num_cards
    G.GAME.morshu_rounds = card.ability.extra.rounds

    if not G.morshu_save or not G.morshu_area then
        -- if the area already exists, set the card limit
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