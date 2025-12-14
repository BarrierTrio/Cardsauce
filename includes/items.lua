SMODS.Atlas({ key = 'achievements', path = "achievements.png", px = 66, py = 66})
SMODS.Atlas({key = 'jokers', path = 'jokers.png', px = 71, py = 95})
SMODS.Atlas({key = 'planets', path = 'planets.png', px = 71, py = 95})
SMODS.Atlas({key = 'spectrals', path = 'spectrals.png', px = 71, py = 95})
SMODS.Atlas({key = 'vhs', path = 'vhs.png', px = 71, py = 95})
SMODS.Atlas({key = 'vouchers', path = 'vouchers.png', px = 71, py = 95})
SMODS.Atlas({key = 'blinds', atlas_table = "ANIMATION_ATLAS", path = 'blinds.png', px = 34, py = 34, frames = 21})
SMODS.Atlas({key = 'tags', path = 'tags.png', px = 34, py = 34})
SMODS.Atlas({key = 'soundpacks', path = 'soundpacks.png', px = 71, py = 71})

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
            'planet_lutetia',
            'planet_varuna',

            -- Spectral
            'spec_quixotic',
            'spec_protojoker',

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

    Achievement = {
        order = 14,
        items = {
            --- [[NEW ACHIEVEMENTS]]
			--- Bronze
			'win_fisheye',
			'activate_code',
			'high_kerosene',
			'high_supper',
			'three_pepsecret',
			'activate_red',
			'activate_claus',
			'early_reyn',
			'activate_watto',
			'high_muppet',
			'high_dontmind',
			'high_crack',
			'high_charity',
			'high_newjoker',
			'high_speen',
			'high_diaper',
			'activate_eman',
			'activate_wot',
			'high_joeyscastle',
			'activate_voice',
			'high_killjester',
			'high_rapture',
			'destroy_meteor',
			'activate_dud',
			'frich_cavendish',
			'preserve_gros',
			'expire_crudeoil',
			'expire_grannycream',
			'gamer_blowzo',
			'activate_drippy',
			'transform_sts',
			'high_passport',
			'destroy_killer',
			'high_sotw',
			'play_flushblackjack',
			'play_flushfib',
			'high_fren',
			'high_bonzi',
			'activate_proto',
			'high_superghostbusters',
			'high_facade',
			'high_bulk',
			'high_mrkill',
			'high_agga',
			'activate_mug',
			'hold_botw',
			'high_april',
			'high_feature',
			'high_triptoamerica',
			'high_hack',
			'high_junka',
			'high_pacman',
			'expire_fantabulous',
			'high_horse',
			'activate_supershow',
			'the_scot',
			'monkey_butt',
			'wheres_po',

			--- Silver
			'flip_sosad',
			'activate_roche',
			'activate_quixotic',
			'defeat_hog',
			'defeat_tray',
			'defeat_vod',
			'reno_colors',
			'fuckingkill_jimbo',
			'miracle_inherit',
			'skin_characters',
			'skin_vineshroom',
			'high_one',
			'supreme_ascend',
			'defeat_finger',
			'triple_seven',
			'dark_luigi',
			'get_sprunked',
			'grey_vomit',
			'evolve_echoes',
			'evolve_btd',
			'evolve_ger',
			'evolve_kingcrimson',
			'evolve_heaven',
			'evolve_tusk',
			'evolve_d4c',
			'evolve_soft',
			'defeat_darkest',
			'defeat_outlaw',
			'defeat_paint',
			'defeat_wasp',

			--- Gold
			'discover_vincenzo',
			'discover_quarterdumb',
			'purchase_dink',
			'five_deathcard',
			'final_odio',
			'chadley_power',
			'the_band',
			'win_vine',
			'ult_choomera',
			'sts_allforms',
			'discover_wigsaw',
			'fucking_idiot',
			'high_tetris',
			'defeat_mochamike',
			'defeat_feltfortress',
			'win_varg',
			'win_cbt',
			'win_wheel',
			'win_disc',

			--- Vine
			'big_meat',
			'all_discovered',
			'cardsauceplus',
			'cardsauceplusplus',
			'stand_master'
        }
    },

    SoundPack = {
        order = 15,
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