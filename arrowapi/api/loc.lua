local suit_text = {
	singular = {
		"Converts {C:attention}#1#{}",
        "selected card",
        "to {V:1}#2#{}"
	},
	multi = {
		"Converts up to",
        "{C:attention}#1#{} selected cards",
        "to {V:1}#2#{}"
	}
}

local enhance_text = {
	singular = {
		"Enhances {C:attention}#1#{} selected",
		"card into a {C:attention}#2#{}"
	},
	multi = {
		"Enhances up to {C:attention}#1#{}",
		"selected cards into",
		"{C:attention}#2#s{}"
	}
}

local seal_text = {
	singular = {
		"Add a {C:attention}#1#{} to",
		"{C:attention}#2#{} selected card",
		"in your hand"
	},
	multi = {
		"Add {C:attention}#1#s{} to up",
		"to {C:attention}#2#{} selected cards",
		"in your hand"
	}
}

ArrowAPI.process_loc_text = function()
    ---------------------------
    --------------------------- Labels
    ---------------------------
    SMODS.process_loc_text(G.localization.misc.labels, 'vhs', {['en-us'] = 'VHS Tape'})
    SMODS.process_loc_text(G.localization.misc.labels, 'stand', {['en-us'] = 'Stand'})



    ---------------------------
    --------------------------- Dictionary
    ---------------------------
    --- credits loc
    SMODS.process_loc_text(G.localization.misc.dictionary, 'arrow_credits_direction', {['en-us'] = 'Direction'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'arrow_credits_concept', {['en-us'] = 'Concept'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'arrow_credits_artist', {['en-us'] = 'Artists'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'arrow_credits_programmer', {['en-us'] = 'Programming'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'arrow_credits_graphics', {['en-us'] = 'Graphics'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'arrow_credits_special', {['en-us'] = 'Special Thanks'})

    --- config loc
    SMODS.process_loc_text(G.localization.misc.dictionary, 'arrow_options_enable_DetailedDescs', {['en-us'] = 'Detailed Descriptions'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'arrow_options_enable_Jokers', {['en-us'] = 'Jokers'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'arrow_options_enable_Consumables', {['en-us'] = 'Consumeables'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'arrow_options_enable_Decks', {['en-us'] = 'Decks'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'arrow_options_enable_Blinds', {['en-us'] = 'Blinds'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'arrow_options_enable_DeckSkins', {['en-us'] = 'Deck Skins'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'arrow_options_enable_Challenges', {['en-us'] = 'Challenges'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'arrow_options_enable_Achievements', {['en-us'] = 'Achievements'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'arrow_options_enable_VHSs', {['en-us'] = 'VHS Tapes'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'arrow_options_enable_Stands', {['en-us'] = 'Stands'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'arrow_options_enable_Tags', {['en-us'] = 'Tags'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'arrow_options_enable_Boosters', {['en-us'] = 'Booster Packs'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'arrow_options_enable_Vouchers', {['en-us'] = 'Vouchers'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'arrow_options_enable_Editions', {['en-us'] = 'Editions'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'arrow_options_enable_Sleeves', {['en-us'] = 'Sleeves'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'arrow_options_enable_Partners', {['en-us'] = 'Partners'})

    --- palette loc
    SMODS.process_loc_text(G.localization.misc.dictionary, 'b_set_palettes', {['en-us'] = 'Palettes'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'b_pal_tarot', {['en-us'] = 'Tarot'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'b_pal_planet', {['en-us'] = 'Planet'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'b_pal_spectral', {['en-us'] = 'Spectral'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'b_pal_background', {['en-us'] = 'Background'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'b_apply_palette', {['en-us'] = 'Apply'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'b_save_palette', {['en-us'] = 'Save'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'b_delete_palette', {['en-us'] = 'Delete'})

    --- tonsmth loc
    SMODS.process_loc_text(G.localization.misc.dictionary, 'k_soundpack', {['en-us'] = 'Sound Pack'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'b_remove', {['en-us'] = 'Remove'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'tnsmi_cfg_rows', {['en-us'] = 'Rows to display'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'tnsmi_cfg_cols', {['en-us'] = 'Packs per row'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'tnsmi_manager_pause', {['en-us'] = 'Packs per row'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'tnsmi_manager_loaded', {['en-us'] = 'DRAG FOR PRIORITY'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'tnsmi_filter_label', {['en-us'] = 'FILTER'})

    --- stand loc
    SMODS.process_loc_text(G.localization.misc.dictionary, 'b_stand_cards', {['en-us'] = "Stands"})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'b_evolved_stand_cards', {['en-us'] = "Evolved Stands"})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'k_stand', {['en-us'] = "Stand"})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'k_evolved_stand', {['en-us'] = "Evolved Stand"})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'k_stand_stickers', {['en-us'] = "Stand Stickers"})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'k_stand_evolved', {['en-us'] = 'Evolved!'})

    --- stand badges
    SMODS.process_loc_text(G.localization.misc.dictionary, 'ba_jojo', {['en-us'] = "Jojo's Bizarre Adventure"})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'ba_diamond', {['en-us'] = 'Diamond is Unbreakable'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'ba_stone', {['en-us'] = 'Stone Ocean'})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'ba_lion', {['en-us'] = 'JoJolion'})

    --- vhs loc
    SMODS.process_loc_text(G.localization.misc.dictionary, 'b_vhs_cards', {['en-us'] = "VHS Tapes"})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'k_vhs', {['en-us'] = "VHS Tape"})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'k_vhs_destroyed', {['en-us'] = "Fin!"})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'b_activate', {['en-us'] = "PLAY"})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'b_deactivate', {['en-us'] = "PAUSE"})

    --- vhs badges
    SMODS.process_loc_text(G.localization.misc.dictionary, 'ba_rlm', {['en-us'] = "RedLetterMedia"})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'ba_rlm_botw', {['en-us'] = "Best of the Worst"})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'ba_rlm_p', {['en-us'] = "Plinketto"})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'ba_rlm_wotw', {['en-us'] = "Wheel of the Worst"})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'ba_rlm_hitb', {['en-us'] = "Half in the Bag"})
    SMODS.process_loc_text(G.localization.misc.dictionary, 'ba_rlm_r', {['en-us'] = "Re:View"})



    ---------------------------
    --------------------------- Variable Dictionary
    ---------------------------
    SMODS.process_loc_text(G.localization.misc.v_dictionary, 'arrow_options_reset_achievements', {['en-us'] = "Reset #1# Achievements"})
    SMODS.process_loc_text(G.localization.misc.v_dictionary, 'tnsmi_search_text', {['en-us'] = "#1#-#2# of #3# results"})



    ---------------------------
    --------------------------- Variable Text
    ---------------------------
    SMODS.process_loc_text(G.localization.misc.v_text, 'banned_except', {['en-us'] = {"{C:attention}All Jokers{} and {C:stand}all Stands{} {C:attention}banned{} except:"}})
    SMODS.process_loc_text(G.localization.misc.v_text, 'blinds_except', {['en-us'] = {"{C:attention}All Blinds banned{} except:"}})
    SMODS.process_loc_text(G.localization.misc.v_text, 'ch_c_scaling', {['en-us'] = {"{C:attention}#1#X{} Blind scaling"}})
    SMODS.process_loc_text(G.localization.misc.v_text, 'ch_c_max_stands', {['en-us'] = {"You may have up to {C:attention}#1#{} {C:stand}Stands{}"}})
    SMODS.process_loc_text(G.localization.misc.v_text, 'ch_c_all_bosses', {['en-us'] = {"{C:attention}Small{} and {C:attention}Big Blinds{} are {C:attention}Boss Blinds{}"}})
    SMODS.process_loc_text(G.localization.misc.v_text, 'ch_c_all_showdown', {['en-us'] = {"{C:attention}Boss Blinds{} are {C:attention}Final Boss Blinds{}"}})
    SMODS.process_loc_text(G.localization.misc.v_text, 'ch_c_all_scores_hidden', {['en-us'] = {"{C:attention}Blind requirements{} are {C:dark_edition}hidden{}"}})
    SMODS.process_loc_text(G.localization.misc.v_text, 'ch_c_extra_blind_active', {['en-us'] = {"{B:1,C:white}#1#{} is {C:attention}always active{}"}})



    ---------------------------
    --------------------------- Soundpacks
    ---------------------------
    G.localization.descriptions.SoundPack = {}
    SMODS.process_loc_text(G.localization.descriptions.SoundPack, 'sp_balatro', {['en-us'] = {
        name = "Balatro OST",
        text = {
            "{C:blue,E:1}Luis Clemente{}",
            "{C:blue,E:1}(LouisF){}"
        }
    }})



    ---------------------------
    --------------------------- Other Descriptions
    ---------------------------
    --- consumable types
    SMODS.process_loc_text(G.localization.descriptions.Other, 'vhs_activation', {['en-us'] = {
        name = "VHS Playing",
        text = {
            "{C:vhs}VHS Tapes{} can have",
            "their passive abilities",
            "{C:attention}toggled{} on/off",
        },
    }})
    SMODS.process_loc_text(G.localization.descriptions.Other, 'stand_info', {['en-us'] = {
        name = "Stand Limit",
        text = {
            "You can only",
            "have {C:attention}#1#{} {C:stand}#2#{}",
            "at a time",
        },
    }})
    SMODS.process_loc_text(G.localization.descriptions.Other, 'stand_info_unlimited', {['en-us'] = {
        name = "Stand Limit",
        text = {
            "You can have",
            "as many {C:stand}Stands{}",
            "as you have",
            "consumable slots"
        },
    }})
    SMODS.process_loc_text(G.localization.descriptions.Other, 'undiscovered_vhs', {['en-us'] = {
        name = "Not Discovered",
        text = {
            "Purchase this card in",
            "an unseeded run to",
            "learn what it does",
        },
    }})
    SMODS.process_loc_text(G.localization.descriptions.Other, 'undiscovered_stand', {['en-us'] = {
        name = "Not Discovered",
        text = {
            "Purchase this card in",
            "an unseeded run to",
            "learn what it does",
        },
    }})

    --- stand stickers
    SMODS.process_loc_text(G.localization.descriptions.Other, 'white_sticker', {['en-us'] = {
        name = "White Sticker",
        text = {
            "Used this #1#",
            "to win on {C:attention}White",
            "{C:attention}Stake{} difficulty",
        },
    }})
    SMODS.process_loc_text(G.localization.descriptions.Other, 'red_sticker', {['en-us'] = {
        name = "Red Sticker",
        text = {
            "Used this #1#",
            "to win on {C:attention}Red",
            "{C:attention}Stake{} difficulty",
        },
    }})
    SMODS.process_loc_text(G.localization.descriptions.Other, 'green_sticker', {['en-us'] = {
        name = "Green Sticker",
        text = {
            "Used this #1#",
            "to win on {C:attention}Green",
            "{C:attention}Stake{} difficulty",
        },
    }})
    SMODS.process_loc_text(G.localization.descriptions.Other, 'black_sticker', {['en-us'] = {
        name = "Black Sticker",
        text = {
            "Used this #1#",
            "to win on {C:attention}Black",
            "{C:attention}Stake{} difficulty",
        },
    }})
    SMODS.process_loc_text(G.localization.descriptions.Other, 'blue_sticker', {['en-us'] = {
        name = "Blue Sticker",
        text = {
            "Used this #1#",
            "to win on {C:attention}Blue",
            "{C:attention}Stake{} difficulty",
        },
    }})
    SMODS.process_loc_text(G.localization.descriptions.Other, 'purple_sticker', {['en-us'] = {
        name = "Purple Sticker",
        text = {
            "Used this #1#",
            "to win on {C:attention}Purple",
            "{C:attention}Stake{} difficulty",
        },
    }})
    SMODS.process_loc_text(G.localization.descriptions.Other, 'orange_sticker', {['en-us'] = {
        name = "Orange Sticker",
        text = {
            "Used this #1#",
            "to win on {C:attention}Orange",
            "{C:attention}Stake{} difficulty",
        },
    }})
    SMODS.process_loc_text(G.localization.descriptions.Other, 'gold_sticker', {['en-us'] = {
        name = "Gold Sticker",
        text = {
            "Used this #1#",
            "to win on {C:attention}Gold",
            "{C:attention}Stake{} difficulty",
        },
    }})

    --- credits
    SMODS.process_loc_text(G.localization.descriptions.Other, 'artistcredit_1', {['en-us'] = {
        name = "Artists",
        text = {
            "{E:1}#1#{}",
        },
    }})
    SMODS.process_loc_text(G.localization.descriptions.Other, 'artistcredit_2', {['en-us'] = {
        name = "Artists",
        text = {
            "{E:1}#1#{}",
            "{E:1}#2#{}",
        },
    }})
    SMODS.process_loc_text(G.localization.descriptions.Other, 'artistcredit_3', {['en-us'] = {
        name = "Artists",
        text = {
            "{E:1}#1#{}",
            "{E:1}#2#{}",
            "{E:1}#2#{}"
        },
    }})

    --- booster packs
    SMODS.process_loc_text(G.localization.descriptions.Other, 'p_arrow_analog1', {['en-us'] = {
        name = 'Analog Pack',
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:vhs} VHS Tapes{}",
        },
    }})
    SMODS.process_loc_text(G.localization.descriptions.Other, 'p_arrow_analog2', {['en-us'] = {
        name = 'Analog Pack',
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:vhs} VHS Tapes{}",
        },
    }})
    SMODS.process_loc_text(G.localization.descriptions.Other, 'p_arrow_analog3', {['en-us'] = {
        name = 'Jumbo Analog Pack',
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:vhs} VHS Tapes{}",
        },
    }})
    SMODS.process_loc_text(G.localization.descriptions.Other, 'p_arrow_analog4', {['en-us'] = {
        name = 'Mega Analog Pack',
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:vhs} VHS Tapes{}",
        },
    }})
    SMODS.process_loc_text(G.localization.descriptions.Other, 'p_arrow_spirit_reg', {['en-us'] = {
        name = 'Spirit Pack',
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:vhs} Stands{}",
        },
    }})



    ---------------------------
    --------------------------- Tarot Descriptions
    ---------------------------
    --- general multi selection editing
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_strength', {['en-us'] = {
        name = "Strength",
        text = {
            "Increases rank",
            "of {C:attention}#1#{} selected",
            "card by {C:attention}#2#{}"
        }
    }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_strength_multi', {['en-us'] = {
        name = "Strength",
        text = {
            "Increases rank of",
            "up to {C:attention}#1#{} selected",
            "cards by {C:attention}#2#{}"
        }
    }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_death', {['en-us'] = {
        name = "Death",
        text = {
            "Select {C:attention}#1#{} cards,",
            "convert the {C:attention}left{} card",
            "into the {C:attention}right{} card",
            "{C:inactive}(Drag to rearrange)"
        }
    }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_death_multi', {['en-us'] = {
        name = "Death",
        text = {
            "Select {C:attention}#1#{} cards,",
            "convert the {C:attention}left{} cards",
            "into the {C:attention}rightmost{} card",
            "{C:inactive}(Drag to rearrange)"
        }
    }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_hanged_man', {['en-us'] = {
        name = "The Hanged Man",
        text = {
            "Destroys {C:attention}#1#{} selected card",
        }
    }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_hanged_man_multi', {['en-us'] = {
        name = "The Hanged Man",
        text = {
            "Destroys up to",
            "{C:attention}#1#{} selected cards",
        }
    }})

    --- enhancement multi selection
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_devil', {['en-us'] = { name = "The Devil", text = enhance_text.singular }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_devil_multi', {['en-us'] = { name = "The Devil", text = enhance_text.multi }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_tower', {['en-us'] = { name = "The Tower", text = enhance_text.singular }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_tower_multi', {['en-us'] = { name = "The Tower", text = enhance_text.multi }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_magician', {['en-us'] = { name = "The Magician", text = enhance_text.singular }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_magician_multi', {['en-us'] = { name = "The Magician", text = enhance_text.multi }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_empress', {['en-us'] = { name = "The Empress", text = enhance_text.singular }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_empress_multi', {['en-us'] = { name = "The Empress", text = enhance_text.multi }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_heirophant', {['en-us'] = { name = "The Hierophant", text = enhance_text.singular }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_heirophant_multi', {['en-us'] = { name = "The Hierophant", text = enhance_text.multi }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_lovers', {['en-us'] = { name = "The Lovers", text = enhance_text.singular }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_lovers_multi', {['en-us'] = { name = "The Lovers", text = enhance_text.multi }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_chariot', {['en-us'] = { name = "The Chariot", text = enhance_text.singular }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_chariot_multi', {['en-us'] = { name = "The Chariot", text = enhance_text.multi }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_justice', {['en-us'] = { name = "Justice", text = enhance_text.singular }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_justice_multi', {['en-us'] = { name = "Justice", text = enhance_text.multi }})

    --- suit multi selection
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_star', {['en-us'] = { name = "The Star", text = suit_text.singular }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_star_multi', {['en-us'] = { name = "The Star", text = suit_text.multi }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_world', {['en-us'] = { name = "The World", text = suit_text.singular }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_world_multi', {['en-us'] = { name = "The World", text = suit_text.multi }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_sun', {['en-us'] = { name = "The Sun", text = suit_text.singular }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_sun_multi', {['en-us'] = { name = "The Sun", text = suit_text.multi }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_moon', {['en-us'] = { name = "The Moon", text = suit_text.singular }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_moon_multi', {['en-us'] = { name = "The Moon", text = suit_text.multi }})

    --- custom
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_arrow_tarot_arrow', {['en-us'] = {
        name = "The Arrow",
        text = {
            "Create a random {C:stand}Stand{}",
            "{C:inactive}(Must have room){}",
        }
    }})



    ---------------------------
    --------------------------- Spectral Descriptions
    ---------------------------
    --- general multi selection
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_cryptid', {['en-us'] = {
        name = 'Cryptid',
        text = {
            "Create {C:attention}#1#{} copies of",
            "{C:attention}#2#{} selected card",
            "in your hand"
        },
    }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_cryptid_multi', {['en-us'] = {
        name = 'Cryptid',
        text = {
            "Create {C:attention}#1#{} copies of",
            "up to {C:attention}#2#{} selected cards",
            "in your hand"
        },
    }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_aura', {['en-us'] = {
        name = 'Aura',
        text = {
            "Add {C:dark_edition}Foil{}, {C:dark_edition}Holographic{}, or",
            "{C:dark_edition}#2#{} edition to",
            "{C:attention}#1#{} selected card in hand"
        },
    }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_aura_multi', {['en-us'] = {
        name = 'Aura',
        text = {
            "Add {C:dark_edition}Foil{}, {C:dark_edition}Holographic{}, or",
            "{C:dark_edition}#2#{} edition to up to",
            "{C:attention}#1#{} selected cards in hand"
        },
    }})

    --- seal multi selection
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_talisman', {['en-us'] = { name = "Talisman", text = seal_text.singular }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_talisman_multi', {['en-us'] = { name = "Talisman", text = seal_text.multi }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_deja_vu', {['en-us'] = { name = "Deja Vu", text = seal_text.singular }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_deja_vu_multi', {['en-us'] = { name = "Deja Vu", text = seal_text.multi }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_medium', {['en-us'] = { name = "Medium", text = seal_text.singular }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_medium_multi', {['en-us'] = { name = "Medium", text = seal_text.multi }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_trance', {['en-us'] = { name = "Trance", text = seal_text.singular }})
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_trance_multi', {['en-us'] = { name = "Trance", text = seal_text.multi }})

    --- custom
    SMODS.process_loc_text(G.localization.descriptions.Tarot, 'c_arrow_spec_diary', {['en-us'] = {
        name = "The Diary",
        text = {
            "Create a random",
            "{C:stand}Evolved Stand{}",
            "{C:inactive}(Must have room){}",
        }
    }})



    ---------------------------
    --------------------------- Tag Descriptions
    ---------------------------
    SMODS.process_loc_text(G.localization.descriptions.Tag, 'tag_arrow_plinkett', {['en-us'] = {
        name = "Plinkett Tag",
        text = {
            "Gives a free",
            "{C:vhs}Mega Analog Pack{}",
        },
    }})
    SMODS.process_loc_text(G.localization.descriptions.Tag, 'tag_arrow_spirit', {['en-us'] = {
        name = "Spirit Tag",
        text = {
            "Create a random {C:stand}Stand",
            "{C:inactive}(Must have room)",
        },
    }})



    ---------------------------
    --------------------------- Tag Descriptions
    ---------------------------
    SMODS.process_loc_text(G.localization.descriptions.Voucher, 'v_arrow_scavenger', {['en-us'] = {
        name = "Scavenger Hunt",
        text = {
            "{C:vhs}VHS Tapes{} can be purchased",
            "from the {C:attention}shop{}"
        }
    }})
    SMODS.process_loc_text(G.localization.descriptions.Voucher, 'v_arrow_raffle', {['en-us'] = {
        name = "Raffle",
        text = {
            "{C:vhs}VHS Tapes{} appear {C:attention}2X{} more",
            "frequently in the {C:attention}shop{}"
        },
        unlock = {
            "Buy a total of ",
            "{C:attention}#1#{} {C:vhs}VHS Tapes",
            "from the shop",
            "{C:inactive}(#2#)",
        },
    }})
    SMODS.process_loc_text(G.localization.descriptions.Voucher, 'v_arrow_foo', {['en-us'] = {
        name = 'Foo Fighter',
        text = {
            "{C:stand}Stands{} can be purchased",
            "from the {C:attention}shop{}"
        }
    }})
    SMODS.process_loc_text(G.localization.descriptions.Voucher, 'v_arrow_plant', {['en-us'] = {
        name = 'Plant Appraiser',
        text = {
            "{C:stand}Evolved Stands{} can be",
            "purchased from the {C:attention}shop{}"
        },
        unlock = {
            "Buy a total of",
            "{C:attention}#1#{} {C:stand}Stands",
            "from the shop",
            "{C:inactive}(#2#)",
        },
    }})
end