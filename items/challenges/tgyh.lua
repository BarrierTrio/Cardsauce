local chalInfo = {
    rules = {
        custom = {
            {id = "csau_tgyh_tenbob", }
        }
    },
    unlocked = function(self)
        return true
    end
}

-- TODO: centralize this
local sc_ref = Card.set_cost
function Card:set_cost()
    sc_ref(self)
    if G.GAME and G.GAME.modifiers and G.GAME.modifiers.csau_tgyh_tenbob then
        self.base_cost = 10
        self.extra_cost = 0
        local voucher_discount = 0
        if self.ability.set == "Voucher" then
            voucher_discount = G.GAME.voucher_discount or 0
        end
        self.cost = math.max(1, math.floor((self.base_cost + self.extra_cost + 0.5)*(100-(G.GAME.discount_percent+voucher_discount))/100))
        if (self.ability.set == 'Planet' or (self.ability.set == 'Booster' and self.ability.name:find('Celestial'))) and #find_joker('Astronomer') > 0 then self.cost = 0 end
        self.sell_cost = math.max(1, math.floor(self.cost/2)) + (self.ability.extra_value or 0)
        if self.area and self.ability.couponed and (self.area == G.shop_jokers or self.area == G.shop_booster) then self.cost = 0 end
        self.sell_cost_label = self.facing == 'back' and '?' or self.sell_cost
    end
end


return chalInfo