-- TODO: if possible, simplify this:

local function is_credited(key, card, palette)
    if G.csau_collab_credits[key][card.config.card.value].specific then
        if palette.pos_style[card.config.card.value] and palette.pos_style[card.config.card.value].atlas then
            if G.csau_collab_credits[key][card.config.card.value].specific[palette.pos_style[card.config.card.value].atlas] then
                return G.csau_collab_credits[key][card.config.card.value].specific[palette.pos_style[card.config.card.value].atlas]
            end
        else
            if G.csau_collab_credits[key][card.config.card.value].specific[palette.atlas] then
                return G.csau_collab_credits[key][card.config.card.value].specific[palette.atlas]
            end
        end
        return false
    else
        return true
    end
end


local upc_ref = G.FUNCS.update_collab_cards
G.FUNCS.update_collab_cards = function(key, suit, silent)
	upc_ref(key, suit, silent)
    if type(key) == "number" then
        key = G.COLLABS.options[suit][key]
    end
    local deckskin = SMODS.DeckSkins[key]
    local palette = deckskin.palette_map and deckskin.palette_map[G.SETTINGS.colour_palettes[suit] or ''] or (deckskin.palettes or {})[1]
    if type(key) == "number" then
		key = G.COLLABS.options[suit][key]
	end
	if G.csau_collab_credits[key] then
		for i, card in ipairs(G.cdds_cards.cards) do
			if G.csau_collab_credits[key][card.config.card.value] then
                local is = is_credited(key, card, palette)
                if is then
                    card.no_ui = false
                    card.csau_collab_credit = G.csau_collab_credits[key][card.config.card.value]
                    if type(is) == 'table' then
                        card.csau_collab_credit.vars = is
                    else
                        card.csau_collab_credit.vars = G.csau_collab_credits[key][card.config.card.value].vars
                    end
                end
			else
				card.no_ui = true
				card.csau_collab_credit = nil
			end
		end
	else
		for i, card in ipairs(G.cdds_cards.cards) do
			card.no_ui = true
			card.csau_collab_credit = nil
		end
	end
end


SMODS.Atlas{
	key = 'alt_color_jokers',
	path = "colorjokers.png",
	px = 71,
	py = 95,
	atlas_table = "ASSET_ATLAS",
}

SMODS.Atlas{
    key = "tarotreskins",
    path = "tarotreskins.png",
    px = 71,
    py = 95,
    atlas_table = "ASSET_ATLAS"
}





---------------------------
--------------------------- Malverk Functions
---------------------------

if AltTexture and TexturePack then
	AltTexture({
		key = 'jokers',
		set = 'Joker',
		path = 'colorjokers.png',
		loc_txt = {
			name = 'Jokers'
		},
		keys = {
			'j_gluttenous_joker',
			'j_greedy_joker',
			'j_lusty_joker',
			'j_wrathful_joker',
			'j_onyx_agate',
			'j_rough_gem'
		},
		original_sheet = true
	})

	AltTexture({
		key = 'tarot',
		set = 'Tarot',
		path = 'tarotreskins.png',
		loc_txt = {
			name = 'Tarot'
		},
		keys = {
			'c_hermit',
			'c_moon',
		},
		original_sheet = true
	})

	TexturePack{
		key = 'csau',
		textures = {
			'csau_jokers',
			'csau_tarot',
		},
		loc_txt = {
			name = 'Cardsauce Malverk Compatibility',
			text = {
				"Enables the Cardsauce reskins of the Suit Color",
				"Jokers + 2 Tarot cards to work with Malverk!",
			}
		}
	}
end





---------------------------
--------------------------- Tarot Reskins
---------------------------

if csau_enabled['enableTarotSkins'] then
    -- Tarot Atlas
	SMODS.Consumable:take_ownership('moon', {
		atlas = 'csau_tarotreskins'
	}, true)
	SMODS.Consumable:take_ownership('hermit', {
		atlas = 'csau_tarotreskins'
	}, true)
end






-- return for all the other skin related stuffto reduce total indent levels
if not csau_enabled['enableSkins'] then
    return
end

local full_ranks = {"Ace", "King", "Queen", "Jack", "10", "9", "8", "7", "6", "5", "4", "3", "2"}
local face_ace = {"Ace", "King", "Queen", "Jack"}
local face = {"King", "Queen", "Jack"}





---------------------------
--------------------------- Alt Joker Skins for suit-relevant jokers
---------------------------

SMODS.Joker:take_ownership('greedy_joker', {
    atlas = 'csau_alt_color_jokers'
}, true)
SMODS.Joker:take_ownership('lusty_joker', {
    atlas = 'csau_alt_color_jokers'
}, true)
SMODS.Joker:take_ownership('wrathful_joker', {
    atlas = 'csau_alt_color_jokers'
}, true)
SMODS.Joker:take_ownership('gluttenous_joker', {
    atlas = 'csau_alt_color_jokers'
}, true)

SMODS.Joker:take_ownership('onyx_agate', {
    atlas = 'csau_alt_color_jokers'
}, true)
SMODS.Joker:take_ownership('rough_gem', {
    atlas = 'csau_alt_color_jokers'
}, true)





---------------------------
--------------------------- Collab Deck SKins
---------------------------

-- Recolored Clubs Collabs
SMODS.Atlas{ key = 'csau_collab_VS', px = 71, py = 95, path = 'cards/recolored/csau_collab_VS.png', prefix_config = {key = false},}
SMODS.Atlas{ key = 'csau_collab_STS', px = 71, py = 95, path = 'cards/recolored/csau_collab_STS.png', prefix_config = {key = false},}
SMODS.Atlas{ key = 'csau_collab_PC', px = 71, py = 95, path = 'cards/recolored/csau_collab_PC.png', prefix_config = {key = false},}
SMODS.Atlas{ key = 'csau_collab_WF', px = 71, py = 95, path = 'cards/recolored/csau_collab_WF.png', prefix_config = {key = false},}
SMODS.Atlas{ key = 'csau_collab_FO', px = 71, py = 95, path = 'cards/recolored/csau_collab_FO.png', prefix_config = {key = false},}
SMODS.Atlas{ key = 'csau_collab_DBD', px = 71, py = 95, path = 'cards/recolored/csau_collab_DBD.png', prefix_config = {key = false},}
-- Recolored Diamonds Collabs
SMODS.Atlas{ key = 'csau_collab_DTD', px = 71, py = 95, path = 'cards/recolored/csau_collab_DTD.png', prefix_config = {key = false},}
SMODS.Atlas{ key = 'csau_collab_SV', px = 71, py = 95, path = 'cards/recolored/csau_collab_SV.png', prefix_config = {key = false},}
SMODS.Atlas{ key = 'csau_collab_EG', px = 71, py = 95, path = 'cards/recolored/csau_collab_EG.png', prefix_config = {key = false},}
SMODS.Atlas{ key = 'csau_collab_XR', px = 71, py = 95, path = 'cards/recolored/csau_collab_XR.png', prefix_config = {key = false},}
SMODS.Atlas{ key = 'csau_collab_C7', px = 71, py = 95, path = 'cards/recolored/csau_collab_C7.png', prefix_config = {key = false},}
SMODS.Atlas{ key = 'csau_collab_R', px = 71, py = 95, path = 'cards/recolored/csau_collab_R.png', prefix_config = {key = false},}
-- Recolored Hearts Collabs
SMODS.Atlas{ key = 'csau_collab_AU', px = 71, py = 95, path = 'cards/recolored/csau_collab_AU.png', prefix_config = {key = false},}
SMODS.Atlas{ key = 'csau_collab_TBoI', px = 71, py = 95, path = 'cards/recolored/csau_collab_TBoI.png', prefix_config = {key = false},}
SMODS.Atlas{ key = 'csau_collab_CL', px = 71, py = 95, path = 'cards/recolored/csau_collab_CL.png', prefix_config = {key = false},}
SMODS.Atlas{ key = 'csau_collab_D2', px = 71, py = 95, path = 'cards/recolored/csau_collab_D2.png', prefix_config = {key = false},}
SMODS.Atlas{ key = 'csau_collab_CR', px = 71, py = 95, path = 'cards/recolored/csau_collab_CR.png', prefix_config = {key = false},}
SMODS.Atlas{ key = 'csau_collab_BUG', px = 71, py = 95, path = 'cards/recolored/csau_collab_BUG.png', prefix_config = {key = false},}
-- Recolored Spades Collabs
SMODS.Atlas{ key = 'csau_collab_TW', px = 71, py = 95, path = 'cards/recolored/csau_collab_TW.png', prefix_config = {key = false}, }
SMODS.Atlas{ key = 'csau_collab_CYP', px = 71, py = 95, path = 'cards/recolored/csau_collab_CYP.png', prefix_config = {key = false}, }
SMODS.Atlas{ key = 'csau_collab_SK', px = 71, py = 95, path = 'cards/recolored/csau_collab_SK.png', prefix_config = {key = false}, }
SMODS.Atlas{ key = 'csau_collab_DS', px = 71, py = 95, path = 'cards/recolored/csau_collab_DS.png', prefix_config = {key = false}, }
SMODS.Atlas{ key = 'csau_collab_AC', px = 71, py = 95, path = 'cards/recolored/csau_collab_AC.png', prefix_config = {key = false}, }
SMODS.Atlas{ key = 'csau_collab_STP', px = 71, py = 95, path = 'cards/recolored/csau_collab_STP.png', prefix_config = {key = false}, }

local color = {
    Hearts = HEX("e14e62"),
    Diamonds = HEX("3c56a4"),
    Clubs = HEX("4dac84"),
    Spades = HEX("8d619a"),
}

local function assemble_vanilla_palettes(key, suit)
    local suit_y = 0; if suit == "Clubs" then suit_y = 1 elseif suit == "Diamonds" then suit_y = 2 elseif suit == "Spades" then suit_y = 3 end
    SMODS.DeckSkin.add_palette(SMODS.DeckSkins[key], {
        key = 'csau_'..key,
        ranks = full_ranks,
        display_ranks = face,
        atlas = 'csau_default',
        pos_style = {
            fallback_style = 'deck',
            Jack = { atlas = 'csau_'..key, pos = {x = 0, y = 0} },
            Queen = { atlas = 'csau_'..key, pos = {x = 1, y = 0} },
            King = { atlas = 'csau_'..key, pos = {x = 2, y = 0} },
            Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = suit_y} }
        },
        loc_txt = {
            ['en-us'] = "Cardsauce Colors"
        },
        colour = color[suit],
        suit_icon = {
            atlas = 'csau_suits'
        }
    })

    SMODS.DeckSkin.add_palette(SMODS.DeckSkins[key], {
        key = 'csau_'..key..'_darkshroom',
        ranks = full_ranks,
        display_ranks = face_ace,
        atlas = 'csau_default',
        pos_style = {
            fallback_style = 'deck',
            Jack = { atlas = 'csau_'..key, pos = {x = 0, y = 0} },
            Queen = { atlas = 'csau_'..key, pos = {x = 1, y = 0} },
            King = { atlas = 'csau_'..key, pos = {x = 2, y = 0} },
        },
        loc_txt = {
            ['en-us'] = "CSAU Colors & Darkshroom"
        },
        colour = color[suit],
        suit_icon = {
            atlas = 'csau_suits'
        }
    })

    SMODS.DeckSkin.add_palette(SMODS.DeckSkins[key], {
        key = 'csau_'..key..'_lightshroom',
        ranks = full_ranks,
        display_ranks = face_ace,
        atlas = 'csau_default',
        pos_style = {
            fallback_style = 'deck',
            Jack = { atlas = 'csau_'..key, pos = {x = 0, y = 0} },
            Queen = { atlas = 'csau_'..key, pos = {x = 1, y = 0} },
            King = { atlas = 'csau_'..key, pos = {x = 2, y = 0} },
            Ace = { atlas = 'csau_lightshrooms', pos = {x = 0, y = suit_y} }
        },
        loc_txt = {
            ['en-us'] = "CSAU Colors & Lightshroom"
        },
        colour = color[suit],
        suit_icon = {
            atlas = 'csau_suits'
        }
    })

    SMODS.DeckSkin.add_palette(SMODS.DeckSkins[key], {
        key = 'csau_'..key..'_vargshroom',
        ranks = full_ranks,
        display_ranks = face_ace,
        atlas = 'csau_default',
        pos_style = {
            fallback_style = 'deck',
            Jack = { atlas = 'csau_'..key, pos = {x = 0, y = 0} },
            Queen = { atlas = 'csau_'..key, pos = {x = 1, y = 0} },
            King = { atlas = 'csau_'..key, pos = {x = 2, y = 0} },
            Ace = { atlas = 'csau_varg_aces', pos = {x = 0, y = suit_y} }
        },
        loc_txt = {
            ['en-us'] = "CSAU Colors & Vargshroom"
        },
        colour = color[suit],
        suit_icon = {
            atlas = 'csau_suits'
        }
    })
    SMODS.DeckSkin.add_palette(SMODS.DeckSkins[key], {
        key = 'csau_'..key..'_jazz',
        ranks = full_ranks,
        display_ranks = face_ace,
        atlas = 'csau_default',
        pos_style = {
            fallback_style = 'deck',
            Jack = { atlas = 'csau_'..key, pos = {x = 0, y = 0} },
            Queen = { atlas = 'csau_'..key, pos = {x = 1, y = 0} },
            King = { atlas = 'csau_'..key, pos = {x = 2, y = 0} },
            Ace = { atlas = 'csau_jazz_aces', pos = {x = 0, y = suit_y} }
        },
        loc_txt = {
            ['en-us'] = "CSAU Colors & Jazz Mister"
        },
        colour = color[suit],
        suit_icon = {
            atlas = 'csau_suits'
        }
    })
end

for k, v in pairs(SMODS.DeckSkins) do
    if not v.mod and starts_with(k, 'collab_') then
        if SMODS.Atlases['csau_'..k] then
            assemble_vanilla_palettes(k, v.suit)
        else
            sendWarnMessage("[Cardsauce] Friends of Jimbo collab with key \'"..k.."\' has no texture for recolored cardsauce colors! Go bug Keku to add it.")
        end
    end
end





---------------------------
--------------------------- Suit Palettes
---------------------------

SMODS.Atlas{ key = 'balcolor_shrooms_lc', px = 71, py = 95, path = 'cards/balcolor_shrooms_lc.png' }
SMODS.Atlas{ key = 'balcolor_shrooms_hc', px = 71, py = 95, path = 'cards/balcolor_shrooms_hc.png' }
SMODS.Atlas{ key = 'varg_aces', px = 71, py = 95, path = 'cards/csau_varg_aces.png' }
SMODS.Atlas{ key = 'balcolor_varg_lc', px = 71, py = 95, path = 'cards/balcolor_varg_lc.png' }
SMODS.Atlas{ key = 'balcolor_varg_hc', px = 71, py = 95, path = 'cards/balcolor_varg_hc.png' }
SMODS.Atlas{ key = 'jazz_aces', px = 71, py = 95, path = 'cards/jazz_aces.png' }
SMODS.Atlas{ key = 'balcolor_jazz_lc', px = 71, py = 95, path = 'cards/balcolor_jazz_lc.png' }
SMODS.Atlas{ key = 'balcolor_jazz_hc', px = 71, py = 95, path = 'cards/balcolor_jazz_hc.png' }
SMODS.Atlas{ key = 'varg_willo', px = 71, py = 95, path = 'cards/csau_varg_willo.png' }
SMODS.Atlas{ key = 'color_aces', px = 71, py = 95, path = 'cards/csau_color_aces.png' }
SMODS.Atlas{ key = 'c_vineshroom', px = 71, py = 95, path = 'cards/c_vineshroom.png' } -- REMOVE THIS
SMODS.Atlas{ key = 'lightshrooms', px = 71, py = 95, path = 'cards/csau_lightshrooms.png' }
SMODS.Atlas{ key = 'csau_default', px = 71, py = 95, path = 'cards/csau_default.png', prefix_config = {key = false} }

SMODS.Atlas{ key = 'suits', px = 18, py = 18, path = 'cards/suits.png' }
SMODS.Atlas{ key = 'hearts_willo', px = 18, py = 18, path = 'cards/hearts_willo.png' }
local suits = {'hearts', 'diamonds', 'clubs', 'spades'}

local function set_first_deckskin(ds)
    G.SETTINGS.colourpalettes = {}
    if ds == 'vinny' then
        G.SETTINGS.CUSTOM_DECK.Collabs.Spades = "csau_confidants"
        G.SETTINGS.CUSTOM_DECK.Collabs.Hearts = "csau_wildcards"
        G.SETTINGS.CUSTOM_DECK.Collabs.Diamonds = "csau_classics"
        G.SETTINGS.CUSTOM_DECK.Collabs.Clubs = "csau_mascots"

        G.SETTINGS.colourpalettes.Spades = "csau_confidants"
        G.SETTINGS.colourpalettes.Hearts = "csau_wildcards"
        G.SETTINGS.colourpalettes.Diamonds = "csau_classics"
        G.SETTINGS.colourpalettes.Clubs = "csau_mascots"
    elseif ds == 'joel' then
        G.SETTINGS.CUSTOM_DECK.Collabs.Spades = "csau_powerful"
        G.SETTINGS.CUSTOM_DECK.Collabs.Hearts = "csau_americans"
        G.SETTINGS.CUSTOM_DECK.Collabs.Diamonds = "csau_duendes"
        G.SETTINGS.CUSTOM_DECK.Collabs.Clubs = "csau_voices"

        G.SETTINGS.colourpalettes.Spades = "csau_powerful"
        G.SETTINGS.colourpalettes.Hearts = "csau_americans"
        G.SETTINGS.colourpalettes.Diamonds = "csau_duendes"
        G.SETTINGS.colourpalettes.Clubs = "csau_voices"
    end
end

-- default color palettes if all suit colors are disabled
if not G.SETTINGS.initCSAUSkins then
    if SMODS.current_mod.DT.def_deckskin then
        if SMODS.current_mod.DT.def_deckskin == 'joel' then
            set_first_deckskin('joel')
        elseif SMODS.current_mod.DT.def_deckskin == 'vinny' then
            set_first_deckskin('vinny')
        end
    else
        set_first_deckskin('vinny')
    end
    G.SETTINGS.initCSAUSkins = true
    G.save_settings()
end

for _, suit in ipairs(suits) do
    local palettes = {}
    palettes[#palettes+1] = {
        key = 'csau_def_'..suit,
        ranks = full_ranks,
        display_ranks = face_ace,
        atlas = 'csau_default',
        pos_style = 'deck',
        loc_txt = {
            ['en-us'] = "Darkshroom"
        },
        colour = color[suit:gsub("^%l", string.upper)],
        suit_icon = {
            atlas = 'csau_suits'
        }
    }
    palettes[#palettes+1] = {
        key = 'csau_vineshroom',
        ranks = full_ranks,
        display_ranks = face_ace,
        atlas = 'csau_default',
        pos_style = {
            fallback_style = 'deck',
            Ace = {
                atlas = 'csau_lightshrooms',
                pos = {x = 0, y = (suit == 'hearts' and 0) or (suit == 'clubs' and 1) or (suit == 'diamonds' and 2) or (suit == 'spades' and 3)}
            }
        },
        loc_txt = {
            ['en-us'] = "Lightshroom"
        },
        colour = color[suit:gsub("^%l", string.upper)],
        suit_icon = {
            atlas = 'csau_suits'
        }
    }

    palettes[#palettes+1] = {
        key = 'csau_baldef_'..suit.."_lc",
        ranks = full_ranks,
        display_ranks = face_ace,
        atlas = 'cards_1',
        pos_style = {
            fallback_style = 'deck',
            Ace = {
                atlas = 'csau_balcolor_shrooms_lc',
                pos = {x = 0, y = (suit == 'hearts' and 0) or (suit == 'clubs' and 1) or (suit == 'diamonds' and 2) or (suit == 'spades' and 3)}
            }
        },
        loc_txt = {
            ['en-us'] = "Low Contrast Shrooms"
        },
        colour = G.C.SO_1[suit:gsub("^%l", string.upper)],
        suit_icon = {
            atlas = 'ui_1',
            pos = 1
        }
    }

    palettes[#palettes+1] = {
        key = 'csau_baldef_'..suit.."_hc",
        ranks = full_ranks,
        display_ranks = face_ace,
        atlas = 'cards_2',
        pos_style = {
            fallback_style = 'deck',
            Ace = {
                atlas = 'csau_balcolor_shrooms_hc',
                pos = {x = 0, y = (suit == 'hearts' and 0) or (suit == 'clubs' and 1) or (suit == 'diamonds' and 2) or (suit == 'spades' and 3)}
            }
        },
        loc_txt = {
            ['en-us'] = "High Contrast Shrooms"
        },
        colour = G.C.SO_2[suit:gsub("^%l", string.upper)],
        suit_icon = {
            atlas = 'ui_2',
            pos = 1
        }
    }

    SMODS.DeckSkin{
        key = "csau_default_"..suit,
        suit = suit:gsub("^%l", string.upper),
        palettes = palettes,
        loc_txt = {
            ['en-us'] = (suit == 'clubs' and "Main Channel") or (suit == 'hearts' and "Extrasauce") or (suit == 'diamonds' and "Fullsauce") or (suit == 'spades' and "Twitch Clips")
        },
        prefix_config = { key = false },
    }

    SMODS.DeckSkin.add_palette(SMODS.DeckSkins['default_'..suit:gsub("^%l", string.upper)], {
        key = 'csau_color_'..suit,
        ranks = full_ranks,
        display_ranks = face_ace,
        atlas = 'csau_default',
        pos_style = {
            fallback_style = 'deck',
            Ace = {
                atlas = 'csau_color_aces',
                pos = {x = 0, y = (suit == 'hearts' and 0) or (suit == 'clubs' and 1) or (suit == 'diamonds' and 2) or (suit == 'spades' and 3)}
            }
        },
        loc_txt = {
            ['en-us'] = "Cardsauce Colors"
        },
        colour = color[suit:gsub("^%l", string.upper)],
        suit_icon = {
            atlas = 'csau_suits'
        }
    })
end

for _, suit in ipairs(suits) do
    local palettes = {}
    palettes[#palettes+1] = {
        key = 'csau_def_varg_'..suit,
        ranks = full_ranks,
        display_ranks = face_ace,
        atlas = 'csau_default',
        pos_style = {
            fallback_style = 'deck',
            Ace = {
                atlas = 'csau_varg_aces',
                pos = {x = 0, y = (suit == 'hearts' and 0) or (suit == 'clubs' and 1) or (suit == 'diamonds' and 2) or (suit == 'spades' and 3)}
            }
        },
        loc_txt = {
            ['en-us'] = "Vargshroom"
        },
        colour = color[suit:gsub("^%l", string.upper)],
        suit_icon = {
            atlas = 'csau_suits'
        }
    }
    if suit == 'hearts' then
        palettes[#palettes+1] = {
            key = 'csau_varg_willo',
            ranks = full_ranks,
            display_ranks = face_ace,
            atlas = 'csau_varg_willo',
            pos_style = 'suit',
            loc_txt = {
                ['en-us'] = "Mini Highlights"
            },
            colour = HEX('b4665c'),
            suit_icon = {
                atlas = 'csau_hearts_willo'
            }
        }
    end
    palettes[#palettes+1] = {
        key = 'csau_baldef_varg_'..suit.."_lc",
        ranks = full_ranks,
        display_ranks = face_ace,
        atlas = 'cards_1',
        pos_style = {
            fallback_style = 'deck',
            Ace = {
                atlas = 'csau_balcolor_varg_lc',
                pos = {x = 0, y = (suit == 'hearts' and 0) or (suit == 'clubs' and 1) or (suit == 'diamonds' and 2) or (suit == 'spades' and 3)}
            }
        },
        loc_txt = {
            ['en-us'] = "Low Contrast Shrooms"
        },
        colour = G.C.SO_1[suit:gsub("^%l", string.upper)],
        suit_icon = {
            atlas = 'ui_1',
            pos = 1
        }
    }
    palettes[#palettes+1] = {
        key = 'csau_baldef_varg_'..suit.."_hc",
        ranks = full_ranks,
        display_ranks = face_ace,
        atlas = 'cards_2',
        pos_style = {
            fallback_style = 'deck',
            Ace = {
                atlas = 'csau_balcolor_varg_hc',
                pos = {x = 0, y = (suit == 'hearts' and 0) or (suit == 'clubs' and 1) or (suit == 'diamonds' and 2) or (suit == 'spades' and 3)}
            }
        },
        loc_txt = {
            ['en-us'] = "High Contrast Shrooms"
        },
        colour = G.C.SO_2[suit:gsub("^%l", string.upper)],
        suit_icon = {
            atlas = 'ui_2',
            pos = 1
        }
    }
    SMODS.DeckSkin{
        key = "default_varg_"..suit,
        suit = suit:gsub("^%l", string.upper),
        palettes = palettes,
        loc_txt = {
            ['en-us'] = (suit == 'clubs' and "Main Channel") or (suit == 'hearts' and "Extravarg?") or (suit == 'diamonds' and "Uncut") or (suit == 'spades' and "Twitch Clips")
        },
        prefix_config = { key = false },
    }
end





---------------------------
--------------------------- Character Skins
---------------------------

-- Vine Skins
SMODS.Atlas{ key = 'mascots', px = 71, py = 95, path = 'cards/csau/mascots.png',}
SMODS.Atlas{ key = 'mascots_1', px = 71, py = 95, path = 'cards/csau_recolored/mascots_1.png',}
SMODS.Atlas{ key = 'mascots_2', px = 71, py = 95, path = 'cards/csau_recolored/mascots_2.png',}
SMODS.Atlas{ key = 'classics', px = 71, py = 95, path = 'cards/csau/classics.png',}
SMODS.Atlas{ key = 'classics_1', px = 71, py = 95, path = 'cards/csau_recolored/classics_1.png',}
SMODS.Atlas{ key = 'classics_2', px = 71, py = 95, path = 'cards/csau_recolored/classics_2.png',}
SMODS.Atlas{ key = 'wildcards', px = 71, py = 95, path = 'cards/csau/wildcards.png',}
SMODS.Atlas{ key = 'wildcards_1', px = 71, py = 95, path = 'cards/csau_recolored/wildcards_1.png',}
SMODS.Atlas{ key = 'wildcards_2', px = 71, py = 95, path = 'cards/csau_recolored/wildcards_2.png',}
SMODS.Atlas{ key = 'confidants', px = 71, py = 95, path = 'cards/csau/confidants.png',}
SMODS.Atlas{ key = 'confidants_1', px = 71, py = 95, path = 'cards/csau_recolored/confidants_1.png',}
SMODS.Atlas{ key = 'confidants_2', px = 71, py = 95, path = 'cards/csau_recolored/confidants_2.png',}

-- Varg Skins
SMODS.Atlas{ key = 'voices', px = 71, py = 95, path = 'cards/csau/voices.png',}
SMODS.Atlas{ key = 'voices_1', px = 71, py = 95, path = 'cards/csau_recolored/voices_1.png',}
SMODS.Atlas{ key = 'voices_2', px = 71, py = 95, path = 'cards/csau_recolored/voices_2.png',}
SMODS.Atlas{ key = 'duendes', px = 71, py = 95, path = 'cards/csau/duendes.png',}
SMODS.Atlas{ key = 'duendes_1', px = 71, py = 95, path = 'cards/csau_recolored/duendes_1.png',}
SMODS.Atlas{ key = 'duendes_2', px = 71, py = 95, path = 'cards/csau_recolored/duendes_2.png',}
SMODS.Atlas{ key = 'americans', px = 71, py = 95, path = 'cards/csau/americans.png',}
SMODS.Atlas{ key = 'americans_1', px = 71, py = 95, path = 'cards/csau_recolored/americans_1.png',}
SMODS.Atlas{ key = 'americans_2', px = 71, py = 95, path = 'cards/csau_recolored/americans_2.png',}
SMODS.Atlas{ key = 'powerful', px = 71, py = 95, path = 'cards/csau/powerful.png',}
SMODS.Atlas{ key = 'powerful_1', px = 71, py = 95, path = 'cards/csau_recolored/powerful_1.png',}
SMODS.Atlas{ key = 'powerful_2', px = 71, py = 95, path = 'cards/csau_recolored/powerful_2.png',}

-- Mike Skins
SMODS.Atlas{ key = 'poops', px = 71, py = 95, path = 'cards/csau/poops.png',}
SMODS.Atlas{ key = 'poops_1', px = 71, py = 95, path = 'cards/csau_recolored/poops_1.png',}
SMODS.Atlas{ key = 'poops_2', px = 71, py = 95, path = 'cards/csau_recolored/poops_2.png',}
SMODS.Atlas{ key = 'ocs', px = 71, py = 95, path = 'cards/csau/ocs.png',}
SMODS.Atlas{ key = 'ocs_1', px = 71, py = 95, path = 'cards/csau_recolored/ocs_1.png',}
SMODS.Atlas{ key = 'ocs_2', px = 71, py = 95, path = 'cards/csau_recolored/ocs_2.png',}
SMODS.Atlas{ key = 'pets', px = 71, py = 95, path = 'cards/csau/pets.png',}
SMODS.Atlas{ key = 'pets_1', px = 71, py = 95, path = 'cards/csau_recolored/pets_1.png',}
SMODS.Atlas{ key = 'pets_2', px = 71, py = 95, path = 'cards/csau_recolored/pets_2.png',}
SMODS.Atlas{ key = 'fingies', px = 71, py = 95, path = 'cards/csau/fingies.png',}
SMODS.Atlas{ key = 'fingies_1', px = 71, py = 95, path = 'cards/csau_recolored/fingies_1.png',}
SMODS.Atlas{ key = 'fingies_2', px = 71, py = 95, path = 'cards/csau_recolored/fingies_2.png',}

local skins = {
    Spades = {
        {key = 'csau_confidants', type = 'vine',
         loc_txt = {
             ['en-us'] = "The Confidants"
         }},
        {key = 'csau_powerful', type = 'varg',
         loc_txt = {
            ['en-us'] = "The Powerful"
         }},
        {key = 'csau_ocs', type = 'mike',
         loc_txt = {
             ['en-us'] = "The OCs"
         }},
    },
    Hearts = {
        {key = 'csau_wildcards', type = 'vine',
         loc_txt = {
            ['en-us'] = "The Wildcards"
         }},
        {key = 'csau_americans', type = 'varg',
         loc_txt = {
            ['en-us'] = "The Americans"
         }},
        {key = 'csau_poops', type = 'mike',
         loc_txt = {
            ['en-us'] = "The Poops"
         }},
    },
    Clubs = {
        {key = 'csau_mascots', type = 'vine',
         loc_txt = {
            ['en-us'] = "The Mascots"
         }},
        {key = 'csau_voices', type = 'varg',
         loc_txt = {
            ['en-us'] = "The Voices"
         }},
        {key = 'csau_pets', type = 'mike',
         loc_txt = {
             ['en-us'] = "The Pets"
         }},
    },
    Diamonds = {
        {key = 'csau_classics', type = 'vine',
         loc_txt = {
            ['en-us'] = "The Classics"
         }},
        {key = 'csau_duendes', type = 'varg',
         loc_txt = {
            ['en-us'] = "The Duendes"
         }},
        {key = 'csau_fingies', type = 'mike',
         loc_txt = {
             ['en-us'] = "The Fingies"
         }},
    },
}

local function assemble_csau_vanilla_palettes(palettes, key, suit, type)
    local suit_y = 0; if suit == "Clubs" then suit_y = 1 elseif suit == "Diamonds" then suit_y = 2 elseif suit == "Spades" then suit_y = 3 end
    palettes[#palettes+1] = {
        key = 'csau_'..key.."_lc",
        ranks = full_ranks,
        display_ranks = face_ace,
        atlas = 'cards_1',
        pos_style = {
            fallback_style = 'deck',
            Jack = { atlas = key.."_1", pos = {x = 0, y = 0} },
            Queen = { atlas = key.."_1", pos = {x = 1, y = 0} },
            King = { atlas = key.."_1", pos = {x = 2, y = 0} },
            Ace = { atlas = (type == 'vine' and 'csau_balcolor_shrooms_lc') or (type == 'varg' and 'csau_balcolor_varg_lc') or (type == 'mike' and 'csau_balcolor_jazz_lc'), pos = {x = 0, y = suit_y} }
        },
        loc_txt = {
            ['en-us'] = "Low Contrast "..(type == 'mike' and "Jazz" or "Shrooms")
        },
        colour = G.C.SO_1[suit:gsub("^%l", string.upper)],
    }
    palettes[#palettes+1] = {
        key = 'csau_'..key.."_lc_ace",
        ranks = full_ranks,
        display_ranks = face_ace,
        atlas = 'cards_1',
        pos_style = {
            fallback_style = 'deck',
            Jack = { atlas = key.."_1", pos = {x = 0, y = 0} },
            Queen = { atlas = key.."_1", pos = {x = 1, y = 0} },
            King = { atlas = key.."_1", pos = {x = 2, y = 0} },
        },
        loc_txt = {
            ['en-us'] = "Low Contrast"
        },
        colour = G.C.SO_1[suit:gsub("^%l", string.upper)],
    }
    palettes[#palettes+1] = {
        key = 'csau_'..key.."_hc",
        ranks = full_ranks,
        display_ranks = face_ace,
        atlas = 'cards_2',
        pos_style = {
            fallback_style = 'deck',
            Jack = { atlas = key.."_2", pos = {x = 0, y = 0} },
            Queen = { atlas = key.."_2", pos = {x = 1, y = 0} },
            King = { atlas = key.."_2", pos = {x = 2, y = 0} },
            Ace = { atlas = (type == 'vine' and 'csau_balcolor_shrooms_hc') or (type == 'varg' and 'csau_balcolor_varg_hc') or (type == 'mike' and 'csau_balcolor_jazz_hc'), pos = {x = 0, y = suit_y} }
        },
        loc_txt = {
            ['en-us'] = "High Contrast "..(type == 'mike' and "Jazz" or "Shrooms")
        },
        colour = G.C.SO_2[suit:gsub("^%l", string.upper)],
    }
    palettes[#palettes+1] = {
        key = 'csau_'..key.."_hc_ace",
        ranks = full_ranks,
        display_ranks = face_ace,
        atlas = 'cards_2',
        pos_style = {
            fallback_style = 'deck',
            Jack = { atlas = key.."_2", pos = {x = 0, y = 0} },
            Queen = { atlas = key.."_2", pos = {x = 1, y = 0} },
            King = { atlas = key.."_2", pos = {x = 2, y = 0} },
        },
        loc_txt = {
            ['en-us'] = "High Contrast"
        },
        colour = G.C.SO_2[suit:gsub("^%l", string.upper)],
    }

    return palettes
end

local assemble_character_skins = function(key, suit, name, type)
    local suit_y = 0; if suit == "Clubs" then suit_y = 1 elseif suit == "Diamonds" then suit_y = 2 elseif suit == "Spades" then suit_y = 3 end
    local palettes = {
        {
            key = key, ranks = full_ranks,
            display_ranks = face_ace, atlas = 'csau_default',
            pos_style = {
                fallback_style = 'deck',
                Jack = { atlas = key, pos = {x = 0, y = 0} },
                Queen = { atlas = key, pos = {x = 1, y = 0} },
                King = { atlas = key, pos = {x = 2, y = 0} },
            },
            loc_txt = {
                ['en-us'] = "Darkshroom"
            },
            colour = color[suit],
            suit_icon = {
                atlas = 'csau_suits'
            }
        }
    }
    if type == 'vine' then
        palettes[#palettes+1] = {
            key = key..'_lightshroom', ranks = full_ranks,
            display_ranks = face_ace, atlas = 'csau_default',
            pos_style = {
                fallback_style = 'deck',
                Jack = { atlas = key, pos = {x = 0, y = 0} },
                Queen = { atlas = key, pos = {x = 1, y = 0} },
                King = { atlas = key, pos = {x = 2, y = 0} },
                Ace = { atlas = 'csau_lightshrooms', pos = {x = 0, y = suit_y} }
            },
            loc_txt = {
                ['en-us'] = "Lightshroom"
            },
            colour = color[suit],
            suit_icon = {
                atlas = 'csau_suits'
            }
        }
    elseif type == "varg" then
        palettes[1].pos_style.Ace = { atlas = 'csau_varg_aces', pos = {x = 0, y = suit_y} }
        palettes[1].loc_txt = {
            ['en-us'] = "Vargshroom"
        }
    elseif type == 'mike' then
        palettes[1].loc_txt = {
            ['en-us'] = "Cardsauce Colors"
        }
        palettes[1].pos_style.Ace = { atlas = 'csau_jazz_aces', pos = {x = 0, y = suit_y} }
    end
    palettes[#palettes+1] = {
        key = key..'_ace', ranks = full_ranks,
        display_ranks = face_ace, atlas = 'csau_default',
        pos_style = {
            fallback_style = 'deck',
            Jack = { atlas = key, pos = {x = 0, y = 0} },
            Queen = { atlas = key, pos = {x = 1, y = 0} },
            King = { atlas = key, pos = {x = 2, y = 0} },
            Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = suit_y} }
        },
        loc_txt = {
            ['en-us'] = "Vanilla Ace"
        },
        colour = color[suit],
        suit_icon = {
            atlas = 'csau_suits'
        }
    }

    if SMODS.Atlases[key.."_1"] and SMODS.Atlases[key.."_2"] then
        palettes = assemble_csau_vanilla_palettes(palettes, key, suit, type)
    end

    SMODS.DeckSkin{
        key = key,
        suit = suit,
        palettes = palettes,
        loc_txt = name
    }
end

for suit, v in pairs(skins) do
    for i, skin in ipairs(v) do
        if SMODS.Atlases[skin.key] then
            assemble_character_skins(skin.key, suit, skin.loc_txt, skin.type)
        end
    end
end