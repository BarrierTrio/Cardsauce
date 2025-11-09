local has_jojobal = next(SMODS.find_mod('jojobal'))
ArrowAPI.loading.batch_load({
    Joker = {
        items = {
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
        not has_jojobal and 'gravity' or nil,
        not has_jojobal and 'jokerdrive' or nil,
        not has_jojobal and 'photodad' or nil,
        not has_jojobal and 'no2joker' or nil,
        not has_jojobal and 'sotw' or nil, -- Page 8 End

        -- challenge dummy items
        'banned_cards',
        'banned_jokers',
        }
    },

    Partner = {
        items = {
            'partner_roche',
        }
    },

    VHS = {
        items = {
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
        }
    },

    Stand = not has_jojobal and {
        items = {
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
        }
    } or nil,

    Tag = {
        items = {
            'corrupted',
            'plinkett',
            not has_jojobal and 'spirit' or nil,
            'banned_tags'
        }
    },

    Voucher = {
        items = {
            'scavenger',
            'raffle',
            'foo',
            'plant',
            'lampoil',
            'ropebombs',
            'banned_vouchers',
        }
    },

    Consumable = {
        items = {
            -- Planet
            'lutetia',
            'varuna',
            'planet_whirlpool',
            'planet_lost',

            -- Spectral
            'quixotic',
            'protojoker',
             not has_jojobal and 'spec_stone' or nil,

            -- Tarot
            'banned_consumables',
        }
    },

    Deck = {
        items = {
            'vine',
            'varg',
            'cbt',
            'wheel',
            'disc'
        }
    },

    Sleeve = {
        items = {
            'sleeve_vine',
            'sleeve_varg',
            'sleeve_cbt',
            'sleeve_wheel',
            'sleeve_disc'
        }
    },

    Booster = {
        items = {
            'banned_boosters'
        }
    },

    Challenge = {
        load_priority = -1,
        items = {
            'tucker',
            'tgyh',
            'nmbb',
            'kriskross',
            'marathon'
        }
    },

    Blind = {
        items = {
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
        }
    },

    Edition = {
        items = {
            'corrupted'
        }
    }
})

if Cardsauce.ortalab_dlc then
    local init, error = SMODS.load_file("includes/ortalab_dlc.lua")
    if error then sendErrorMessage("[Cardsauce] Failed to load ortalab_dlc with error "..error) else
        local data = init()
        sendDebugMessage("[Cardsauce] Loaded hook: ortalab_dlc")
    end
end