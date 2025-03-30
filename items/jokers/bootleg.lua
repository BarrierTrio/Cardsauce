local mod = SMODS.current_mod

SMODS.Shader {
    key = 'bootleg',
    path = 'bootleg.fs',
}

local jokerInfo = {
    name = 'Bootleg Joker',
    config = {},
    bootlegged_center = nil,
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "joel",
}

local function get_joker_center(key)
    for k, v in pairs(SMODS.Centers) do
        if k == key then
            return v
        end
    end
    for k, v in pairs(G.P_CENTERS) do
        if k == key then
            return v
        end
    end
    return nil
end

local function get_joker_pool()
    local jokers = {}
    for k, v in pairs(G.P_CENTERS) do
        if starts_with(k, "j_") and v.discovered and not table.contains(jokers, k) then
            jokers[#jokers+1] = k
        end
    end
    for k, v in pairs(SMODS.Centers) do
        if starts_with(k, "j_") and v.discovered and not table.contains(jokers, k) then
            jokers[#jokers+1] = k
        end
    end
    return jokers
end

local function get_random_joker_key()
    local key
    repeat
        if G.playing_cards then
            key = pseudorandom_element(get_current_pool('Joker', nil, nil, 'bootleg'), pseudoseed('assdrugbagfuck'))
        else
            local jokers = get_joker_pool()
            key = pseudorandom_element(jokers, pseudoseed('assdrugbagfuck'))
        end
    until key and key:sub(1, 2) == "j_"
    return key
end

local function get_all_in_one_joker(card)
    local key = get_random_joker_key(card, true)
    local center = get_joker_center(key)
    local order = center.order
    return order.." . "..G.localization.descriptions.Joker[key].name
end

local function updateSprite(card)
    if card.ability.bootlegged_center then
        if card.config.center.atlas ~= card.ability.bootlegged_center.atlas then
            card.config.center.atlas = card.ability.bootlegged_center.atlas
            card.config.center.pos = card.ability.bootlegged_center.pos
            card:set_sprites(card.config.center)
        end
    else
        if card.config.center.atlas ~= "csau_bootleg" then
            card.config.center.atlas = "csau_bootleg"
            card.config.center.pos = { x = 0, y = 0 }
            card:set_sprites(card.config.center)
        end
    end
end

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
    return { vars = {  } }
end

function jokerInfo.load(self, card, card_table, other_card)
    if (card.ability.bootlegged_center and card.ability.bootlegged_key) or G.GAME.bootleg_joker_key then
        local key = (card.ability.bootlegged_center and card.ability.bootlegged_key) or G.GAME.bootleg_joker_key
        if type(card.ability.bootlegged_center) ~= "table" then
            local center = get_joker_center(key)
            card.ability.bootlegged_center = center
            card.ability.bootlegged_key = center.key
            G.GAME.bootleg_joker_key = center.key
            card.ability.name = center.name or center.key
            updateSprite(card)
        end
    end
end

function jokerInfo.calc_dollar_bonus(self, card)
    if card.ability.bootlegged_center then
        if card.ability.bootlegged_center.calc_dollar_bonus then
            local ret = card.ability.bootlegged_center.calc_dollar_bonus(self, card)
            if ret then
                return ret
            end
        end
        if self.ability.name == 'Golden Joker' then
            return self.ability.extra
        end
        if self.ability.name == 'Cloud 9' and self.ability.nine_tally and self.ability.nine_tally > 0 then
            return self.ability.extra*(self.ability.nine_tally)
        end
        if self.ability.name == 'Rocket' then
            return self.ability.extra.dollars
        end
        if self.ability.name == 'Satellite' then
            local planets_used = 0
            for k, v in pairs(G.GAME.consumeable_usage) do
                if v.set == 'Planet' then planets_used = planets_used + 1 end
            end
            if planets_used == 0 then return end
            return self.ability.extra*planets_used
        end
        if self.ability.name == 'Delayed Gratification' and G.GAME.current_round.discards_used == 0 and G.GAME.current_round.discards_left > 0 then
            return G.GAME.current_round.discards_left*self.ability.extra
        end
    end
end

function jokerInfo.calculate(self, card, context)
    if context.setting_blind and not card.getting_sliced and not card.debuff and not context.blueprint then
        local center = get_joker_center(get_random_joker_key(card))
        for k, v in pairs(center.config) do
            card.ability[k] = v
        end
        card.ability.bootlegged_center = center
        card.ability.bootlegged_key = center.key
        G.GAME.bootleg_joker_key = center.key
        card.ability.name = center.name or center.key
        updateSprite(card)
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = G.localization.descriptions.Joker[card.ability.bootlegged_center.key].name, colour = G.C.IMPORTANT})
    end
    if card.ability.bootlegged_center and card.ability.bootlegged_center.calculate then
        local ret = card.ability.bootlegged_center.calculate(card.ability.bootlegged_center, card, context)
        if ret then return ret end
    end
    if context.end_of_round then
        card.ability.bootlegged_center = nil
        card.ability.bootlegged_key = nil
        card.ability.name = nil
        G.GAME.bootleg_joker_key = nil
        updateSprite(card)
        card:juice_up()
    end
end

local function fuck_you_generate_ui_box_ability_table(self)
    local loc_vars, main_start, main_end = nil, nil, nil
    if self.ability.name == 'Joker' then loc_vars = {self.ability.mult}
    elseif self.ability.name == 'Jolly Joker' or self.ability.name == 'Zany Joker' or
            self.ability.name == 'Mad Joker' or self.ability.name == 'Crazy Joker'  or
            self.ability.name == 'Droll Joker' then
        loc_vars = {self.ability.t_mult, localize(self.ability.type, 'poker_hands')}
    elseif self.ability.name == 'Sly Joker' or self.ability.name == 'Wily Joker' or
            self.ability.name == 'Clever Joker' or self.ability.name == 'Devious Joker'  or
            self.ability.name == 'Crafty Joker' then
        loc_vars = {self.ability.t_chips, localize(self.ability.type, 'poker_hands')}
    elseif self.ability.name == 'Half Joker' then loc_vars = {self.ability.extra.mult, self.ability.extra.size}
    elseif self.ability.name == 'Fortune Teller' then loc_vars = {self.ability.extra, (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot or 0)}
    elseif self.ability.name == 'Steel Joker' then loc_vars = {self.ability.extra, 1 + self.ability.extra*(self.ability.steel_tally or 0)}
    elseif self.ability.name == 'Chaos the Clown' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Space Joker' then loc_vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), self.ability.extra}
    elseif self.ability.name == 'Stone Joker' then loc_vars = {self.ability.extra, self.ability.extra*(self.ability.stone_tally or 0)}
    elseif self.ability.name == 'Drunkard' then loc_vars = {self.ability.d_size}
    elseif self.ability.name == 'Green Joker' then loc_vars = {self.ability.extra.hand_add, self.ability.extra.discard_sub, self.ability.mult}
    elseif self.ability.name == 'Credit Card' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Greedy Joker' or self.ability.name == 'Lusty Joker' or
            self.ability.name == 'Wrathful Joker' or self.ability.name == 'Gluttonous Joker' then loc_vars = {self.ability.extra.s_mult, localize(self.ability.extra.suit, 'suits_singular')}
    elseif self.ability.name == 'Blue Joker' then loc_vars = {self.ability.extra, self.ability.extra*((G.deck and G.deck.cards) and #G.deck.cards or 52)}
    elseif self.ability.name == 'Sixth Sense' then loc_vars = {}
    elseif self.ability.name == 'Mime' then
    elseif self.ability.name == 'Hack' then loc_vars = {self.ability.extra+1}
    elseif self.ability.name == 'Pareidolia' then
    elseif self.ability.name == 'Faceless Joker' then loc_vars = {self.ability.extra.dollars, self.ability.extra.faces}
    elseif self.ability.name == 'Oops! All 6s' then
    elseif self.ability.name == 'Juggler' then loc_vars = {self.ability.h_size}
    elseif self.ability.name == 'Golden Joker' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Joker Stencil' then loc_vars = {self.ability.x_mult}
    elseif self.ability.name == 'Four Fingers' then
    elseif self.ability.name == 'Ceremonial Dagger' then loc_vars = {self.ability.mult}
    elseif self.ability.name == 'Banner' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Misprint' then
        local r_mults = {}
        for i = self.ability.extra.min, self.ability.extra.max do
            r_mults[#r_mults+1] = tostring(i)
        end
        local loc_mult = ' '..(localize('k_mult'))..' '
        main_start = {
            {n=G.UIT.T, config={text = '  +',colour = G.C.MULT, scale = 0.32}},
            {n=G.UIT.O, config={object = DynaText({string = r_mults, colours = {G.C.RED},pop_in_rate = 9999999, silent = true, random_element = true, pop_delay = 0.5, scale = 0.32, min_cycle_time = 0})}},
            {n=G.UIT.O, config={object = DynaText({string = {
                {string = 'rand()', colour = G.C.JOKER_GREY},{string = "#@"..(G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.id or 11)..(G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.suit:sub(1,1) or 'D'), colour = G.C.RED},
                loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult},
                                                   colours = {G.C.UI.TEXT_DARK},pop_in_rate = 9999999, silent = true, random_element = true, pop_delay = 0.2011, scale = 0.32, min_cycle_time = 0})}},
        }
    elseif self.ability.name == 'Mystic Summit' then loc_vars = {self.ability.extra.mult, self.ability.extra.d_remaining}
    elseif self.ability.name == 'Marble Joker' then
    elseif self.ability.name == 'Loyalty Card' then loc_vars = {self.ability.extra.Xmult, self.ability.extra.every + 1, localize{type = 'variable', key = (self.ability.loyalty_remaining == 0 and 'loyalty_active' or 'loyalty_inactive'), vars = {self.ability.loyalty_remaining}}}
    elseif self.ability.name == '8 Ball' then loc_vars = {''..(G.GAME and G.GAME.probabilities.normal or 1),self.ability.extra}
    elseif self.ability.name == 'Dusk' then loc_vars = {self.ability.extra+1}
    elseif self.ability.name == 'Raised Fist' then
    elseif self.ability.name == 'Fibonacci' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Scary Face' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Abstract Joker' then loc_vars = {self.ability.extra, (G.jokers and G.jokers.cards and #G.jokers.cards or 0)*self.ability.extra}
    elseif self.ability.name == 'Delayed Gratification' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Gros Michel' then loc_vars = {self.ability.extra.mult, ''..(G.GAME and G.GAME.probabilities.normal or 1), self.ability.extra.odds}
    elseif self.ability.name == 'Even Steven' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Odd Todd' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Scholar' then loc_vars = {self.ability.extra.mult, self.ability.extra.chips}
    elseif self.ability.name == 'Business Card' then loc_vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), self.ability.extra}
    elseif self.ability.name == 'Supernova' then
    elseif self.ability.name == 'Spare Trousers' then loc_vars = {self.ability.extra, localize('Two Pair', 'poker_hands'), self.ability.mult}
    elseif self.ability.name == 'Superposition' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Ride the Bus' then loc_vars = {self.ability.extra, self.ability.mult}
    elseif self.ability.name == 'Egg' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Burglar' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Blackboard' then loc_vars = {self.ability.extra, localize('Spades', 'suits_plural'), localize('Clubs', 'suits_plural')}
    elseif self.ability.name == 'Runner' then loc_vars = {self.ability.extra.chips, self.ability.extra.chip_mod}
    elseif self.ability.name == 'Ice Cream' then loc_vars = {self.ability.extra.chips, self.ability.extra.chip_mod}
    elseif self.ability.name == 'DNA' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Splash' then
    elseif self.ability.name == 'Constellation' then loc_vars = {self.ability.extra, self.ability.x_mult}
    elseif self.ability.name == 'Hiker' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'To Do List' then loc_vars = {self.ability.extra.dollars, localize(self.ability.to_do_poker_hand, 'poker_hands')}
    elseif self.ability.name == 'Smeared Joker' then
    elseif self.ability.name == 'Blueprint' then
        self.ability.blueprint_compat_ui = self.ability.blueprint_compat_ui or ''; self.ability.blueprint_compat_check = nil
        main_end = (self.area and self.area == G.jokers) and {
            {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
                {n=G.UIT.C, config={ref_table = self, align = "m", colour = G.C.JOKER_GREY, r = 0.05, padding = 0.06, func = 'blueprint_compat'}, nodes={
                    {n=G.UIT.T, config={ref_table = self.ability, ref_value = 'blueprint_compat_ui',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.8}},
                }}
            }}
        } or nil
    elseif self.ability.name == 'Cartomancer' then
    elseif self.ability.name == 'Astronomer' then loc_vars = {self.ability.extra}

    elseif self.ability.name == 'Golden Ticket' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Mr. Bones' then
    elseif self.ability.name == 'Acrobat' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Sock and Buskin' then loc_vars = {self.ability.extra+1}
    elseif self.ability.name == 'Swashbuckler' then loc_vars = {self.ability.mult}
    elseif self.ability.name == 'Troubadour' then loc_vars = {self.ability.extra.h_size, -self.ability.extra.h_plays}
    elseif self.ability.name == 'Certificate' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Throwback' then loc_vars = {self.ability.extra, self.ability.x_mult}
    elseif self.ability.name == 'Hanging Chad' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Rough Gem' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Bloodstone' then loc_vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), self.ability.extra.odds, self.ability.extra.Xmult}
    elseif self.ability.name == 'Arrowhead' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Onyx Agate' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Glass Joker' then loc_vars = {self.ability.extra, self.ability.x_mult}
    elseif self.ability.name == 'Showman' then
    elseif self.ability.name == 'Flower Pot' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Wee Joker' then loc_vars = {self.ability.extra.chips, self.ability.extra.chip_mod}
    elseif self.ability.name == 'Merry Andy' then loc_vars = {self.ability.d_size, self.ability.h_size}
    elseif self.ability.name == 'The Idol' then loc_vars = {self.ability.extra, localize(G.GAME.current_round.idol_card.rank, 'ranks'), localize(G.GAME.current_round.idol_card.suit, 'suits_plural'), colours = {G.C.SUITS[G.GAME.current_round.idol_card.suit]}}
    elseif self.ability.name == 'Seeing Double' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Matador' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Hit the Road' then loc_vars = {self.ability.extra, self.ability.x_mult}
    elseif self.ability.name == 'The Duo' or self.ability.name == 'The Trio'
            or self.ability.name == 'The Family' or self.ability.name == 'The Order' or self.ability.name == 'The Tribe' then loc_vars = {self.ability.x_mult, localize(self.ability.type, 'poker_hands')}

    elseif self.ability.name == 'Cavendish' then loc_vars = {self.ability.extra.Xmult, ''..(G.GAME and G.GAME.probabilities.normal or 1), self.ability.extra.odds}
    elseif self.ability.name == 'Card Sharp' then loc_vars = {self.ability.extra.Xmult}
    elseif self.ability.name == 'Red Card' then loc_vars = {self.ability.extra, self.ability.mult}
    elseif self.ability.name == 'Madness' then loc_vars = {self.ability.extra, self.ability.x_mult}
    elseif self.ability.name == 'Square Joker' then loc_vars = {self.ability.extra.chips, self.ability.extra.chip_mod}
    elseif self.ability.name == 'Seance' then loc_vars = {localize(self.ability.extra.poker_hand, 'poker_hands')}
    elseif self.ability.name == 'Riff-raff' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Vampire' then loc_vars = {self.ability.extra, self.ability.x_mult}
    elseif self.ability.name == 'Shortcut' then
    elseif self.ability.name == 'Hologram' then loc_vars = {self.ability.extra, self.ability.x_mult}
    elseif self.ability.name == 'Vagabond' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Baron' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Cloud 9' then loc_vars = {self.ability.extra, self.ability.extra*(self.ability.nine_tally or 0)}
    elseif self.ability.name == 'Rocket' then loc_vars = {self.ability.extra.dollars, self.ability.extra.increase}
    elseif self.ability.name == 'Obelisk' then loc_vars = {self.ability.extra, self.ability.x_mult}
    elseif self.ability.name == 'Midas Mask' then
    elseif self.ability.name == 'Luchador' then
        local has_message= (G.GAME and self.area and (self.area == G.jokers))
        if has_message then
            local disableable = G.GAME.blind and ((not G.GAME.blind.disabled) and (G.GAME.blind:get_type() == 'Boss'))
            main_end = {
                {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
                    {n=G.UIT.C, config={ref_table = self, align = "m", colour = disableable and G.C.GREEN or G.C.RED, r = 0.05, padding = 0.06}, nodes={
                        {n=G.UIT.T, config={text = ' '..localize(disableable and 'k_active' or 'ph_no_boss_active')..' ',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.9}},
                    }}
                }}
            }
        end
    elseif self.ability.name == 'Photograph' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Gift Card' then  loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Turtle Bean' then loc_vars = {self.ability.extra.h_size, self.ability.extra.h_mod}
    elseif self.ability.name == 'Erosion' then loc_vars = {self.ability.extra, math.max(0,self.ability.extra*(G.playing_cards and (G.GAME.starting_deck_size - #G.playing_cards) or 0)), G.GAME.starting_deck_size}
    elseif self.ability.name == 'Reserved Parking' then loc_vars = {self.ability.extra.dollars, ''..(G.GAME and G.GAME.probabilities.normal or 1), self.ability.extra.odds}
    elseif self.ability.name == 'Mail-In Rebate' then loc_vars = {self.ability.extra, localize(G.GAME.current_round.mail_card.rank, 'ranks')}
    elseif self.ability.name == 'To the Moon' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Hallucination' then loc_vars = {G.GAME.probabilities.normal, self.ability.extra}
    elseif self.ability.name == 'Lucky Cat' then loc_vars = {self.ability.extra, self.ability.x_mult}
    elseif self.ability.name == 'Baseball Card' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Bull' then loc_vars = {self.ability.extra, self.ability.extra*math.max(0,G.GAME.dollars) or 0}
    elseif self.ability.name == 'Diet Cola' then loc_vars = {localize{type = 'name_text', set = 'Tag', key = 'tag_double', nodes = {}}}
    elseif self.ability.name == 'Trading Card' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Flash Card' then loc_vars = {self.ability.extra, self.ability.mult}
    elseif self.ability.name == 'Popcorn' then loc_vars = {self.ability.mult, self.ability.extra}
    elseif self.ability.name == 'Ramen' then loc_vars = {self.ability.x_mult, self.ability.extra}
    elseif self.ability.name == 'Ancient Joker' then loc_vars = {self.ability.extra, localize(G.GAME.current_round.ancient_card.suit, 'suits_singular'), colours = {G.C.SUITS[G.GAME.current_round.ancient_card.suit]}}
    elseif self.ability.name == 'Walkie Talkie' then loc_vars = {self.ability.extra.chips, self.ability.extra.mult}
    elseif self.ability.name == 'Seltzer' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Castle' then loc_vars = {self.ability.extra.chip_mod, localize(G.GAME.current_round.castle_card.suit, 'suits_singular'), self.ability.extra.chips, colours = {G.C.SUITS[G.GAME.current_round.castle_card.suit]}}
    elseif self.ability.name == 'Smiley Face' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Campfire' then loc_vars = {self.ability.extra, self.ability.x_mult}
    elseif self.ability.name == 'Stuntman' then loc_vars = {self.ability.extra.chip_mod, self.ability.extra.h_size}
    elseif self.ability.name == 'Invisible Joker' then loc_vars = {self.ability.extra, self.ability.invis_rounds}
    elseif self.ability.name == 'Brainstorm' then
        self.ability.blueprint_compat_ui = self.ability.blueprint_compat_ui or ''; self.ability.blueprint_compat_check = nil
        main_end = (self.area and self.area == G.jokers) and {
            {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
                {n=G.UIT.C, config={ref_table = self, align = "m", colour = G.C.JOKER_GREY, r = 0.05, padding = 0.06, func = 'blueprint_compat'}, nodes={
                    {n=G.UIT.T, config={ref_table = self.ability, ref_value = 'blueprint_compat_ui',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.8}},
                }}
            }}
        } or nil
    elseif self.ability.name == 'Satellite' then
        local planets_used = 0
        for k, v in pairs(G.GAME.consumeable_usage) do if v.set == 'Planet' then planets_used = planets_used + 1 end end
        loc_vars = {self.ability.extra, planets_used*self.ability.extra}
    elseif self.ability.name == 'Shoot the Moon' then loc_vars = {self.ability.extra}
    elseif self.ability.name == "Driver's License" then loc_vars = {self.ability.extra, self.ability.driver_tally or '0'}
    elseif self.ability.name == 'Burnt Joker' then
    elseif self.ability.name == 'Bootstraps' then loc_vars = {self.ability.extra.mult, self.ability.extra.dollars, self.ability.extra.mult*math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/self.ability.extra.dollars)}
    elseif self.ability.name == 'Caino' then loc_vars = {self.ability.extra, self.ability.caino_xmult}
    elseif self.ability.name == 'Triboulet' then loc_vars = {self.ability.extra}
    elseif self.ability.name == 'Yorick' then loc_vars = {self.ability.extra.xmult, self.ability.extra.discards, self.ability.yorick_discards, self.ability.x_mult}
    elseif self.ability.name == 'Chicot' then
    elseif self.ability.name == 'Perkeo' then loc_vars = {self.ability.extra}
    end
    return loc_vars, main_start, main_end
end

local function get_loc_vars(self, card, info_queue)
    if card.ability.bootlegged_center.loc_vars then
        return card.ability.bootlegged_center.loc_vars(card.ability.bootlegged_center, info_queue, card).vars or {}, nil, nil
    elseif card.ability.bootlegged_center then
        local loc_vars, main_start, main_end = nil, nil, nil
        loc_vars, main_start, main_end = fuck_you_generate_ui_box_ability_table(card)
        return loc_vars, main_start, main_end
    end
    if self.loc_vars then
        return self.loc_vars(self, info_queue, card).vars, nil, nil
    end
    return {}, nil, nil
end

function jokerInfo.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local key = card.config.center.key
    if card.config.center.discovered then
        -- If statement makes it so that this function doesnt activate in the "Joker Unlocked" UI and cause 'Not Discovered' to be stuck in the corner
        full_UI_table.name = localize{type = 'name', key = key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    end
    if card.ability.bootlegged_center then
        local loc_vars, main_start, main_end = get_loc_vars(self, card, info_queue)
        localize{type = 'descriptions', key = card.ability.bootlegged_center.key, set = self.set, nodes = desc_nodes, vars = loc_vars}
        if main_start then
            desc_nodes[#desc_nodes+1] = main_start
        end
        if main_end then
            desc_nodes[#desc_nodes+1] = main_end
        end
    else
        if mod.config['detailedDescs'] then
            G.FUNCS.csau_generate_detail_desc(self, info_queue, card, desc_nodes, specific_vars, full_UI_table, nil, true)
        else
            info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
            set_discover_tallies()
            local tally = G.DISCOVER_TALLIES.jokers.of
            local main_start = {
                {n=G.UIT.T, config={text = tally..localize('a_in_one'), colour = G.C.DARK_EDITION, scale = 0.4}},
            }
            local main_end = {
                {n=G.UIT.O, config={object = DynaText(
                        {string = {
                            {string = '0 . rand()', colour = G.C.JOKER_GREY},
                            get_all_in_one_joker(card),
                            get_all_in_one_joker(card),
                            get_all_in_one_joker(card),
                            get_all_in_one_joker(card),
                            get_all_in_one_joker(card),
                            get_all_in_one_joker(card),
                            get_all_in_one_joker(card),
                            get_all_in_one_joker(card),
                            get_all_in_one_joker(card),
                            get_all_in_one_joker(card),
                            get_all_in_one_joker(card),
                            get_all_in_one_joker(card),
                            get_all_in_one_joker(card)
                        },
                         colours = {G.C.UI.TEXT_DARK},
                         pop_in_rate = 9999999,
                         silent = true,
                         random_element = true,
                         pop_delay = 0.2011,
                         scale = 0.32,
                         min_cycle_time = 0
                        }
                )}},
            }
            desc_nodes[#desc_nodes+1] = main_start
            desc_nodes[#desc_nodes+1] = main_end
        end
    end
end

function jokerInfo.draw(self, card, layer)
    if card.config.center.atlas ~= "csau_bootleg" then
        card.children.center:draw_shader('csau_bootleg', nil, card.ARGS.send_to_shader)
    end
end

return jokerInfo
	