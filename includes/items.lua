local itemsToLoad = {
    Joker = {
        --- [[[VINNY]]]
        -- [[Common]]
        -- 1.0
        'newjoker', -- Page 1 Start
        'twoface',
        'pivot',
        'disguy',
        'gnorts',
        'diaper',
        'speen',
        'pacman',
        'besomeone',
        'roche',
        'reyn',
        'emmanuel',
        'fisheye',
        'chad',
        'garbagehand', -- Page 1 End


        'purple',-- Page 2 Start
        'businesstrading',
        'fantabulous',
        -- Update 1.2
        'ten',
        -- Update 1.3
        'koffing',
        'crudeoil',
        'grannycream',
        -- [[Uncommon]]
        -- 1.0
        'depressedbrother',
        'meat',
        'greyjoker',
        'veryexpensivejoker',
        'roger',
        'cousinsclub',
        'anotherlight',
        'sohappy', -- Page 2 End


        'code', -- Page 3 Start
        'deathcard',
        'maskedjoker',
        'dontmind',
        'kerosene',
        'red',
        'fate',
        'miracle',
        'chromedup',
        -- Update 1.2
        'beginners',
        'voice',
        'rotten',
        -- Update 1.3
        'bjbros',
        'drippy',
        -- [[Rare]]
        'thisiscrack', -- Page 3 End


        'werewolves', -- Page 4 Start
        'hell',
        'odio',
        -- Update 1.3
        'sts',
        -- [[Common]] (LOCKED)
        -- Update 1.3
        'meteor',
        'dud',
        -- Update 1.2
        'rapture',
        'villains',
        -- 1.0
        'speedjoker',
        'disturbedjoker',
        -- [[Uncommon]] (LOCKED)
        -- 1.0
        'charity',
        'shrimp',
        'muppet',
        -- Update 1.3
        'frich',
        'bunji',
        -- [[Rare]] (LOCKED)
         -- Page 4 End


        'supper', -- Page 5 Start
        'pepsecret',
        'greenneedle',
        'wingsoftime',
        'killjester',
        --- [[[JOEL]]]
        -- [[Common]]
        'grand',
        'frens',
        'memehouse',
        'bonzi',
        'bbq',
        'protogent',
        'lidl',
        'superghostbusters',
        'chips',
        'toeofsatan', -- Page 5 End


        'bald', -- Page 6 Start
        'bootleg',
        'facade',
        -- [[Uncommon]]
        'joeycastle',
        'flusher',
        'bulk',
        'mrkill',
        'plaguewalker',
        'skeletor',
        'agga',
        'duane',
        'bsi',
        'mug',
        'fireworks',
        'scam', -- Page 6 End


        'april', -- Page 7 Start
        'sprunk',
        'itsafeature',
        'passport',
        'vinewrestle',
        -- [[Rare]]
        'skeletonmetal',
        'ufo',
        'tetris',
        -- [[Common]] (LOCKED)
        'itsmeaustin',
        'vomitblast',
        'nutbuster',
        -- [[Uncommon]] (LOCKED)
        'powers',
        'triptoamerica',
        'monkey',
        'blackjack', -- Page 7 End


        -- [[Rare]] (LOCKED)
        'kings', -- Page 8 Start
        'byebye',
        --- [[LEGENDARY]]
        'vincenzo',
        'quarterdumb',
        'wigsaw',
        --- [[REDLETTERMEDIA]]
        'hack',
        'endlesstrash',
        'genres',
        'weretrulyfrauds',
        'junka',
        --- [[JOJO'S BIZARRE ADVENTURE]]
        'gravity',
        'jokerdrive',
        'photodad',
        'no2joker',
        'sotw', -- Page 8 End

        -- challenge dummy items
        'banned_cards',
        'banned_jokers',
    },

    Partner = {
        'partner_roche',
    },

    VHS = {
        'blackspine',
        'remlezar',
        'sew',
        'shakma',
        'troll2',
        'swhs',
        'exploding',
        'choppingmall',
        'roar',
        'calibighunks',
        'ishtar',
        'nukie',
        'sataniccults',
        'blooddebts',
        'topslots',
        'doubledown',
        'twistedpair',
        'fatefulfindings',
        'streetsmarts',
        'devilstory',
        'rentafriend',
        'tbone',
        'wwvcr',
        'sos',
        'macandme',
        'osteo',
        'miami',
        'lowblow',
        'kidsand',
        'spacecop',
        'theroom',
        'ryansbabe',
        'ritf',
        'suburbansasquatch',
        'rawtime',
        'donbeveridge',
        'alienpi',
        'supershow',
        'yoyoman',
    },

    Stand = {
        -- stardust crusaders
        'stardust_star',
        'stardust_world',
        'stardust_tohth',

        -- diamond is unbreakable
        'diamond_crazy',
        'diamond_hand',
        'diamond_echoes_1',
        'diamond_echoes_2',
        'diamond_echoes_3',
        'diamond_killer',
        'diamond_killer_btd',

        -- vento aureo
        'vento_gold',
        'vento_gold_requiem',
        'vento_moody',
        'vento_metallica',
        'vento_epitaph',
        'vento_epitaph_king',
        'vento_watchtower',

        -- stone ocean
        'stone_stone',
        'stone_marilyn',
        'stone_white',
        'stone_white_moon',
        'stone_white_heaven',

        -- steel ball run
        'steel_d4c',
        'steel_d4c_love',
        'steel_tusk_1',
        'steel_tusk_2',
        'steel_tusk_3',
        'steel_tusk_4',
        'steel_civil',

        -- jojolion
        'lion_soft',
        'lion_soft_beyond',
        'lion_paper',
        'lion_rock',
        'lion_wonder',

        -- jojolands
        'lands_november',
        'lands_smooth',
        'lands_bigmouth',
    },

    Tag = {
        'corrupted',
        'plinkett',
        'spirit',
        'banned_tags'
    },

    Voucher = {
        'scavenger',
        'raffle',
        'foo',
        'plant',
        'lampoil',
        'ropebombs',
        'banned_vouchers',
    },

    Consumable = {
        -- Planet
        'lutetia',
        'varuna',
        'planet_whirlpool',
        'planet_lost',

        -- Spectral
        'quixotic',
        'protojoker',
        'spec_stone',
        'spec_diary',

        -- Tarot
        'tarot_arrow',
        'banned_consumables',
    },

    Deck = {
        'vine',
        'varg',
        'cbt',
        'wheel',
        'disc'
    },

    Sleeve = {
        'sleeve_vine',
        'sleeve_varg',
        'sleeve_cbt',
        'sleeve_wheel',
        'sleeve_disc'
    },

    Booster = {
        'analog1',
        'analog2',
        'analog3',
        'analog4',
        'banned_boosters'
    },

    Challenge = {
        'tucker',
        'tgyh',
        'nmbb',
        'kriskross',
        'marathon'
    },

    Blind = {
        'hog',
        'tray',
        'darkest',
        'finger',
        'mochamike',
        'vod',
        'outlaw',
        'paint',
        'wasp',
        'feltfortress',
    },
    Edition = {
        'corrupted'
    }
}

for k, v in pairs(itemsToLoad) do
    if next(itemsToLoad[k]) then
        if csau_filter_loading('set', {key = k}) then
            for i = 1, #v do
                load_cardsauce_item(v[i], k)
            end
        end
    end
end

SMODS.Atlas({ key = 'undiscovered', path = "undiscovered.png", px = 71, py = 95 })
--------------------------- VHS Consumable Type
if csau_enabled['enableVHSs'] then
    SMODS.Sound({ key = "vhsopen", path = "vhsopen.ogg"})
    SMODS.Sound({ key = "vhsclose", path = "vhsclose.ogg"})

    SMODS.UndiscoveredSprite{ key = "VHS", atlas = "csau_undiscovered", pos = { x = 0, y = 0 }}

    SMODS.ConsumableType{
        key = "VHS",
        primary_colour = G.C.VHS,
        secondary_colour = G.C.VHS,
        collection_rows = { 7, 6 },
        shop_rate = 0,
        loc_txt = {},
        default = "c_csau_blackspine",
        can_stack = false,
        can_divide = false,
    }
end

--------------------------- Stands consumable type
if csau_enabled['enableStands'] then
    SMODS.ObjectType { default = 'c_csau_stardust_star', key = 'StandPool', prefix_config = false }
    SMODS.ObjectType { default = 'c_csau_stardust_star', key = 'csau_EvolvedPool', prefix_config = false}


    SMODS.Rarity {
        key = 'StandRarity',
        prefix_config = false,
        default_weight = 1,
        no_mod_badges = true,
        badge_colour = 'FFFFFF'
    }

    SMODS.Rarity {
        key = 'csau_EvolvedRarity',
        prefix_config = false,
        default_weight = 0,
        no_mod_badges = true,
        badge_colour = 'FFFFFF',
    }

    -- Stand Consumable
    SMODS.Atlas({ key = 'stickers', path = "stickers.png", px = 71, py = 95 })
    SMODS.UndiscoveredSprite { key = "Stand", atlas = "csau_undiscovered", pos = { x = 1, y = 0 }, overlay_pos = { x = 2, y = 0 }, prefix_config = false }
    SMODS.ConsumableType {
        key = 'Stand',
        prefix_config = false,
        primary_colour = G.C.STAND,
        secondary_colour = G.C.STAND,
        collection_rows = { 8, 8 },
        shop_rate = 0,
        default = "c_csau_diamond_star",
        rarities = {
            {key = 'StandRarity'},
            {key = 'csau_EvolvedRarity'},
        },
        inject_card = function(self, center)
            if center.set ~= self.key then SMODS.insert_pool(G.P_CENTER_POOLS[self.key], center) end
            local pool_key = center.config.evolved and 'csau_EvolvedPool' or 'StandPool'
            SMODS.insert_pool(G.P_CENTER_POOLS[pool_key], center)
            if center.rarity and self.rarity_pools[center.rarity] then
                SMODS.insert_pool(self.rarity_pools[center.rarity], center)
            end
        end,
        delete_card = function(self, center)
            if center.set ~= self.key then SMODS.remove_pool(G.P_CENTER_POOLS[self.key], center.key) end
            local pool_key = center.config.evolved and 'csau_EvolvedPool' or 'StandPool'
            SMODS.remove_pool(G.P_CENTER_POOLS[pool_key], center)
            if center.rarity and self.rarity_pools[center.rarity] then
                SMODS.remove_pool(self.rarity_pools[center.rarity], center.key)
            end
        end,
    }

    SMODS.Shader {
        key = 'stand_mask',
        path = 'stand_mask.fs',
    }
end

if Cardsauce.ortalab_dlc then
    local init, error = SMODS.load_file("includes/ortalab_dlc.lua")
    if error then sendErrorMessage("[Cardsauce] Failed to load ortalab_dlc with error "..error) else
        local data = init()
        sendDebugMessage("[Cardsauce] Loaded hook: ortalab_dlc")
    end
end