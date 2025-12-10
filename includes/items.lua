SMODS.Atlas({key = 'jokers', path = 'jokers/jokers.png', px = 71, py = 95})

ArrowAPI.loading.batch_load({
    Joker = {
        order = 1,
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

        -- challenge dummy items
        'banned_cards',
        'banned_jokers',
        }
    },

    Partner = {
        order = 2,
        items = {
            'partner_roche',
        }
    },

    VHS = {
        order = 3,
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

    Consumable = {
        order = 5,
        items = {
            -- Planet
            'lutetia',
            'varuna',

            -- Spectral
            'quixotic',
            'protojoker',

            -- Tarot
            'banned_consumables',
        }
    },

    Voucher = {
        order = 6,
        items = {
            'lampoil',
            'ropebombs',
            'banned_vouchers',
        }
    },


    Booster = {
        order = 7,
        items = {
            'banned_boosters'
        }
    },


    Tag = {
        order = 8,
        items = {
            'corrupted',
            'banned_tags'
        }
    },


    Edition = {
        order = 9,
        items = {
            'corrupted'
        }
    },


    Blind = {
        order = 10,
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

    Deck = {
        order = 11,
        items = {
            'vine',
            'varg',
            'cbt',
            'wheel',
        }
    },

    Sleeve = {
        order = 12,
        items = {
            'sleeve_vine',
            'sleeve_varg',
            'sleeve_cbt',
            'sleeve_wheel',
        }
    },


    Challenge = {
        order = 13,
        items = {
            'tucker',
            'tgyh',
            'nmbb',
            'marathon'
        }
    },

    SoundPack = {
        order = 14,
        items = {
            'cardsauce',
        }
    }
})

if SMODS.JimboQuip then
    for i=1, 9 do
        SMODS.JimboQuip{
            key = 'wq_vinny_'..tostring(i),
            type = 'win',
            csau_streamer = 'vinny',
        }

        SMODS.JimboQuip{
            key = 'lq_vinny_'..tostring(i),
            type = 'loss',
            csau_streamer = 'vinny',
        }
        SMODS.JimboQuip{
            key = 'lq_joel_'..tostring(i),
            type = 'loss',
            csau_streamer = 'joel',
        }
    end

    for i=1, 10 do
        SMODS.JimboQuip{
            key = 'wq_joel_'..tostring(i),
            type = 'win',
            csau_streamer = 'joel',
        }
    end

    SMODS.JimboQuip{
        key = 'lq_1',
        type = 'loss',
    }
    SMODS.JimboQuip{
        key = 'lq_2',
        type = 'loss',
    }
    SMODS.JimboQuip{
        key = 'wq_1',
        type = 'win',
    }
end