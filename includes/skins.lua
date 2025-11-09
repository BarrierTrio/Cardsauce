---------------------------
--------------------------- Card Skin Loading
---------------------------
if Cardsauce.current_config['enable_CardSkins'] then
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
    else
        ---------------------------
        --------------------------- Tarot Reskins
        ---------------------------
        SMODS.Consumable:take_ownership('moon', {
            atlas = 'csau_tarotreskins'
        }, true)
        SMODS.Consumable:take_ownership('hermit', {
            atlas = 'csau_tarotreskins'
        }, true)


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
    end
end





---------------------------
--------------------------- Deckskin Loading
---------------------------

if not Cardsauce.current_config['enable_DeckSkins'] then return end

-- helper tables for loading
local full_ranks = {"Ace", "King", "Queen", "Jack", "10", "9", "8", "7", "6", "5", "4", "3", "2"}
local face_ace = {"Ace", "King", "Queen", "Jack"}
local face = {"King", "Queen", "Jack"}





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

local color_map = {
    Hearts = HEX("e14e62"),
    Diamonds = HEX("3c56a4"),
    Clubs = HEX("4dac84"),
    Spades = HEX("8d619a"),
}

for k, v in pairs(SMODS.DeckSkins) do
    if not v.original_mod and ArrowAPI.string.starts_with(k, 'collab_') then
        if SMODS.Atlases['csau_'..k] then
            local suit_y = (v.suit == 'Hearts' and 0) or (v.suit == "Clubs" and 1)
            or (v.suit == "Diamonds" and 2) or (v.suit == "Spades" and 3) or 0



            --------------------------- Darkshroom palette
            SMODS.DeckSkin.add_palette(SMODS.DeckSkins[k], {
                key = 'csau_'..k,
                ranks = full_ranks,
                display_ranks = face,
                atlas = 'csau_default',
                pos_style = {
                    fallback_style = 'deck',
                    Jack = { atlas = 'csau_'..k, pos = {x = 0, y = 0} },
                    Queen = { atlas = 'csau_'..k, pos = {x = 1, y = 0} },
                    King = { atlas = 'csau_'..k, pos = {x = 2, y = 0} },
                    Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = suit_y} }
                },
                loc_txt = {
                    ['en-us'] = "Cardsauce Colors"
                },
                colour = color_map[v.suit],
                suit_icon = {
                    atlas = 'csau_suits'
                },
            })

            SMODS.DeckSkin.add_palette(SMODS.DeckSkins[k], {
                key = 'csau_'..k..'_darkshroom',
                ranks = full_ranks,
                display_ranks = face_ace,
                atlas = 'csau_default',
                pos_style = {
                    fallback_style = 'deck',
                    Jack = { atlas = 'csau_'..k, pos = {x = 0, y = 0} },
                    Queen = { atlas = 'csau_'..k, pos = {x = 1, y = 0} },
                    King = { atlas = 'csau_'..k, pos = {x = 2, y = 0} },
                },
                loc_txt = {
                    ['en-us'] = "CSAU Colors & Darkshroom"
                },
                colour = color_map[v.suit],
                suit_icon = {
                    atlas = 'csau_suits'
                },
            })

            SMODS.DeckSkin.add_palette(SMODS.DeckSkins[k], {
                key = 'csau_'..k..'_lightshroom',
                ranks = full_ranks,
                display_ranks = face_ace,
                atlas = 'csau_default',
                pos_style = {
                    fallback_style = 'deck',
                    Jack = { atlas = 'csau_'..k, pos = {x = 0, y = 0} },
                    Queen = { atlas = 'csau_'..k, pos = {x = 1, y = 0} },
                    King = { atlas = 'csau_'..k, pos = {x = 2, y = 0} },
                    Ace = { atlas = 'csau_lightshrooms', pos = {x = 0, y = suit_y} }
                },
                loc_txt = {
                    ['en-us'] = "CSAU Colors & Lightshroom"
                },
                colour = color_map[v.suit],
                suit_icon = {
                    atlas = 'csau_suits'
                },
            })

            SMODS.DeckSkin.add_palette(SMODS.DeckSkins[k], {
                key = 'csau_'..k..'_vargshroom',
                ranks = full_ranks,
                display_ranks = face_ace,
                atlas = 'csau_default',
                pos_style = {
                    fallback_style = 'deck',
                    Jack = { atlas = 'csau_'..k, pos = {x = 0, y = 0} },
                    Queen = { atlas = 'csau_'..k, pos = {x = 1, y = 0} },
                    King = { atlas = 'csau_'..k, pos = {x = 2, y = 0} },
                    Ace = { atlas = 'csau_varg_aces', pos = {x = 0, y = suit_y} }
                },
                loc_txt = {
                    ['en-us'] = "CSAU Colors & Vargshroom"
                },
                colour = color_map[v.suit],
                suit_icon = {
                    atlas = 'csau_suits'
                },
            })
            SMODS.DeckSkin.add_palette(SMODS.DeckSkins[k], {
                key = 'csau_'..k..'_jazz',
                ranks = full_ranks,
                display_ranks = face_ace,
                atlas = 'csau_default',
                pos_style = {
                    fallback_style = 'deck',
                    Jack = { atlas = 'csau_'..k, pos = {x = 0, y = 0} },
                    Queen = { atlas = 'csau_'..k, pos = {x = 1, y = 0} },
                    King = { atlas = 'csau_'..k, pos = {x = 2, y = 0} },
                    Ace = { atlas = 'csau_jazz_aces', pos = {x = 0, y = suit_y} }
                },
                loc_txt = {
                    ['en-us'] = "CSAU Colors & Jazz Mister"
                },
                colour = color_map[v.suit],
                suit_icon = {
                    atlas = 'csau_suits'
                },
            })
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

-- default color palettes if all suit colors are disabled
if not G.SETTINGS.csau_init_skins then
    if Cardsauce.default_ds == 'joel' then
        G.SETTINGS.CUSTOM_DECK.Collabs.Spades = "csau_powerful"
        G.SETTINGS.CUSTOM_DECK.Collabs.Hearts = "csau_americans"
        G.SETTINGS.CUSTOM_DECK.Collabs.Diamonds = "csau_duendes"
        G.SETTINGS.CUSTOM_DECK.Collabs.Clubs = "csau_voices"

        G.SETTINGS.colour_palettes.Spades = "csau_powerful"
        G.SETTINGS.colour_palettes.Hearts = "csau_americans"
        G.SETTINGS.colour_palettes.Diamonds = "csau_duendes"
        G.SETTINGS.colour_palettes.Clubs = "csau_voices"
    elseif Cardsauce.default_ds == 'vinny' then
        G.SETTINGS.CUSTOM_DECK.Collabs.Spades = "csau_confidants"
        G.SETTINGS.CUSTOM_DECK.Collabs.Hearts = "csau_wildcards"
        G.SETTINGS.CUSTOM_DECK.Collabs.Diamonds = "csau_classics"
        G.SETTINGS.CUSTOM_DECK.Collabs.Clubs = "csau_mascots"

        G.SETTINGS.colour_palettes.Spades = "csau_confidants"
        G.SETTINGS.colour_palettes.Hearts = "csau_wildcards"
        G.SETTINGS.colour_palettes.Diamonds = "csau_classics"
        G.SETTINGS.colour_palettes.Clubs = "csau_mascots"
    end

    G.SETTINGS.csau_init_skins = true
    G.save_settings()
end

for _, suit in ipairs({'Hearts', 'Diamonds', 'Clubs', 'Spades'}) do
    local suit_y = (suit == 'Hearts' and 0) or (suit == 'Clubs' and 1) or (suit == 'Diamonds' and 2) or (suit == 'Spades' and 3)



    --------------------------- Add vine skins
    ArrowAPI.loading.load_deckskin({
        key = "csau_default_"..suit:lower(),
        suit = suit,
        palettes = {{
            key = 'csau_def_'..suit:lower(),
            ranks = full_ranks,
            display_ranks = face_ace,
            atlas = 'csau_default',
            pos_style = 'deck',
            loc_txt = {
                ['en-us'] = "Darkshroom"
            },
            colour = color_map[suit],
            suit_icon = {
                atlas = 'csau_suits'
            },
            artist = 'Kekulism'
        },{
            key = 'csau_vineshroom',
            ranks = full_ranks,
            display_ranks = face_ace,
            atlas = 'csau_default',
            pos_style = {
                fallback_style = 'deck',
                Ace = {
                    atlas = 'csau_lightshrooms',
                    pos = {x = 0, y = suit_y}
                }
            },
            loc_txt = {
                ['en-us'] = "Lightshroom"
            },
            colour = color_map[suit:gsub("^%l", string.upper)],
            suit_icon = {
                atlas = 'csau_suits'
            },
            artist = 'Kekulism'
        },{
            key = 'csau_baldef_'..suit:lower().."_lc",
            ranks = full_ranks,
            display_ranks = face_ace,
            atlas = 'cards_1',
            pos_style = {
                fallback_style = 'deck',
                Ace = {
                    atlas = 'csau_balcolor_shrooms_lc',
                    pos = {x = 0, y = suit_y}
                }
            },
            loc_txt = {
                ['en-us'] = "Low Contrast Shrooms"
            },
            colour = G.C.SO_1[suit],
            suit_icon = {
                atlas = 'ui_1',
                pos = 1
            },
            artist = 'Kekulism'
        },{
            key = 'csau_baldef_'..suit.."_hc",
            ranks = full_ranks,
            display_ranks = face_ace,
            atlas = 'cards_2',
            pos_style = {
                fallback_style = 'deck',
                Ace = {
                    atlas = 'csau_balcolor_shrooms_hc',
                    pos = {x = 0, y = suit_y}
                }
            },
            loc_txt = {
                ['en-us'] = "High Contrast Shrooms"
            },
            colour = G.C.SO_2[suit:gsub("^%l", string.upper)],
            suit_icon = {
                atlas = 'ui_2',
                pos = 1
            },
            artist = 'Kekulism'
        }},
        loc_txt = {
            ['en-us'] = (suit == 'clubs' and "Main Channel") or (suit == 'hearts' and "Extrasauce") or (suit == 'diamonds' and "Fullsauce") or (suit == 'spades' and "Twitch Clips")
        },
        prefix_config = { key = false },
    })



    --------------------------- Add varg skins
    ArrowAPI.loading.load_deckskin({
        key = "default_varg_"..suit:lower(),
        suit = suit,
        palettes = {{
            key = 'csau_def_varg_'..suit:lower(),
            ranks = full_ranks,
            display_ranks = face_ace,
            atlas = 'csau_default',
            pos_style = {
                fallback_style = 'deck',
                Ace = {
                    atlas = 'csau_varg_aces',
                    pos = {x = 0, y = suit_y}
                }
            },
            loc_txt = {
                ['en-us'] = "Vargshroom"
            },
            colour = color_map[suit],
            suit_icon = {
                atlas = 'csau_suits'
            }
        }, suit == 'Hearts' and {
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
            },
            artist = 'Kekulism'
        } or nil, {
            key = 'csau_baldef_varg_'..suit:lower().."_lc",
            ranks = full_ranks,
            display_ranks = face_ace,
            atlas = 'cards_1',
            pos_style = {
                fallback_style = 'deck',
                Ace = {
                    atlas = 'csau_balcolor_varg_lc',
                    pos = {x = 0, y = suit_y}
                }
            },
            loc_txt = {
                ['en-us'] = "Low Contrast Shrooms"
            },
            colour = G.C.SO_1[suit],
            suit_icon = {
                atlas = 'ui_1',
                pos = 1
            },
            artist = 'Kekulism'
        }, {
            key = 'csau_baldef_varg_'..suit:lower().."_hc",
            ranks = full_ranks,
            display_ranks = face_ace,
            atlas = 'cards_2',
            pos_style = {
                fallback_style = 'deck',
                Ace = {
                    atlas = 'csau_balcolor_varg_hc',
                    pos = {x = 0, y = suit_y}
                }
            },
            loc_txt = {
                ['en-us'] = "High Contrast Shrooms"
            },
            colour = G.C.SO_2[suit],
            suit_icon = {
                atlas = 'ui_2',
                pos = 1
            },
            artist = 'Kekulism'
        }},
        loc_txt = {
            ['en-us'] = (suit == 'Clubs' and "Main Channel") or (suit == 'Hearts' and "Extravarg?") or (suit == 'Diamonds' and "Uncut") or (suit == 'Spades' and "Twitch Clips")
        },
        prefix_config = { key = false },
    })



    --------------------------- Add palette variants for non-collab cards
    SMODS.DeckSkin.add_palette(SMODS.DeckSkins['default_'..suit], {
        key = 'csau_color_'..suit:lower(),
        ranks = full_ranks,
        display_ranks = face_ace,
        atlas = 'csau_default',
        pos_style = {
            fallback_style = 'deck',
            Ace = {
                atlas = 'csau_color_aces',
                pos = {x = 0, y = suit_y}
            }
        },
        loc_txt = {
            ['en-us'] = "Cardsauce Colors"
        },
        colour = color_map[suit],
        suit_icon = {
            atlas = 'csau_suits'
        }
    })
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

-- full map of skins and credits
local skins = {
    ['vine'] = {
        Spades = {
            key = 'csau_confidants',
            loc_txt = {['en-us'] = "The Confidants"},
            artist = {
                Ace = 'Kekulism',
                Jack = 'Jazz_Jen',
                Queen = 'Jazz_Jen',
                King = 'Jazz_Jen'
            }
        },
        Hearts = {
            key = 'csau_wildcards',
            loc_txt = {['en-us'] = "The Wildcards"},
            artist = {
                Ace = 'Kekulism',
                Jack = 'CheesyDraws',
                Queen = 'CheesyDraws',
                King = 'fradavovan'
            }
        },
        Clubs = {
            key = 'csau_mascots',
            loc_txt = {['en-us'] = "The Mascots"},
            artist = {
                Ace = 'Kekulism',
                Jack = 'WhimsyCherry',
                Queen = 'Greeeg',
                King = 'CheesyDraws'
            }
        },
        Diamonds = {
            key = 'csau_classics',
            loc_txt = {['en-us'] = "The Classics"},
            artist = {
                Ace = 'Kekulism',
                Jack = 'Winter Grimwell',
                Queen = 'Winter Grimwell',
                King = 'Winter Grimwell'
            }
        },
    },
    ['varg'] = {
        Spades = {
            key = 'csau_powerful',
            loc_txt = {['en-us'] = "The Powerful"},
            artist = {
                Ace = 'Kekulism',
                Jack = 'Retrotype',
                Queen = 'chvsau',
                King = 'BarrierTrio/Gote'
            }
        },
        Hearts = {
            key = 'csau_americans',
            loc_txt = {['en-us'] = "The Americans"},
            artist = {
                Ace = 'Kekulism',
                Jack = 'plunch',
                Queen = 'GuffNFluff',
                King = 'Burdrehnar'
            }
        },
        Clubs = {
            key = 'csau_voices',
            loc_txt = {['en-us'] = "The Voices"},
            artist = {
                Ace = 'Kekulism',
                Jack = 'Lyzerus',
                Queen = 'Crisppyboat',
                King = 'Lyzerus'
            }
        },
        Diamonds = {
            key = 'csau_duendes',
            loc_txt = {['en-us'] = "The Duendes"},
            artist = {
                Ace = 'Kekulism',
                Jack = 'GuffNFluff',
                Queen = 'SagaciousCejai',
                King = 'Winter Grimwell'
            }
        },
    },
    ['mike'] = {
        Spades = {
            key = 'csau_ocs',
            loc_txt = {['en-us'] = "The OCs"},
            artist = {
                Ace = 'MightyKingWario',
                Jack = 'BarrierTrio/Gote',
                Queen = 'GuffNFluff',
                King = 'eldritchminds'
            }
        },
        Hearts = {
            key = 'csau_poops',
            loc_txt = {['en-us'] = "The Poops"},
            artist = {
                Ace = 'MightyKingWario',
                Jack = 'SagaciousCejai',
                Queen = 'BarrierTrio/Gote',
                King = {'BarrierTrio/Gote', 'SagaciousCejai'}
            }
        },
        Clubs = {
            key = 'csau_pets',
            loc_txt = {['en-us'] = "The Pets"},
            artist = {
                Ace = 'MightyKingWario',
                Jack = 'Winter Grimwell',
                Queen = 'Winter Grimwell',
                King = 'FenixSeraph'
            }
        },
        Diamonds = {
            key = 'csau_fingies',
            loc_txt = {['en-us'] = "The Fingies"},
            artist = {
                Ace = 'MightyKingWario',
                Jack = 'BarrierTrio/Gote',
                Queen = 'LolWutBurger',
                King = 'Winter Grimwell'
            }
        },
    },
}

for type, v in pairs(skins) do
    for suit, tbl in pairs(v) do
        local suit_y = (suit == 'Hearts' and 0) or (suit == 'Clubs' and 1) or (suit == 'Diamonds' and 2) or (suit == 'Spades' and 3)
        local key = tbl.key

        ArrowAPI.loading.load_deckskin({
            key = key,
            suit = suit:lower(),
            palettes = {{
                key = key, ranks = full_ranks,
                display_ranks = face_ace, atlas = 'csau_default',
                pos_style = {
                    fallback_style = 'deck',
                    Ace = (type == 'mike' and { atlas = 'csau_jazz_aces', pos = {x = 0, y = suit_y} })
                    or (type == 'varg' and { atlas = 'csau_varg_aces', pos = {x = 0, y = suit_y} })
                    or nil,
                    Jack = { atlas = key, pos = {x = 0, y = 0} },
                    Queen = { atlas = key, pos = {x = 1, y = 0} },
                    King = { atlas = key, pos = {x = 2, y = 0} },
                },
                loc_txt = {
                    ['en-us'] = (type == 'mike' and 'Cardsauce Colors') or (type == 'varg' and 'Lightshroom') or "Darkshroom"
                },
                colour = color_map[suit],
                suit_icon = {
                    atlas = 'csau_suits'
                },
                artist = tbl.artist
            }, type == 'vine' and {
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
                colour = color_map[suit],
                suit_icon = {
                    atlas = 'csau_suits'
                },
                artist = tbl.artist
            } or nil, {
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
                colour = G.C.SO_1[suit],
                artist = tbl.artist
            }, {
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
                colour = G.C.SO_1[suit],
                artist = tbl.artist
            }, {
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
                colour = G.C.SO_2[suit],
                artist = tbl.artist
            }, {
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
                colour = G.C.SO_2[suit],
                artist = tbl.artist
            }, {
                key = key..'_ace',
                ranks = full_ranks,
                display_ranks = face_ace,
                atlas = 'csau_default',
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
                colour = color_map[suit],
                suit_icon = {
                    atlas = 'csau_suits'
                },
                artist = tbl.artist
            }},
            loc_txt = tbl.loc_txt
        })
    end
end