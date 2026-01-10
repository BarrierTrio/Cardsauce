

---------------------------
--------------------------- Card Skin Loading
---------------------------
if Cardsauce.config['enable_CardSkins'] then
    SMODS.Atlas{
        key = "tarotreskins",
        path = "tarotreskins.png",
        px = 71,
        py = 95,
        atlas_table = "ASSET_ATLAS"
    }

    if AltTexture and TexturePack then

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
                'csau_tarot',
            },
            loc_txt = {
                name = 'Cardsauce Malverk Compatibility',
                text = {
                    "Enables the Cardsauce reskins of",
                    "2 Tarot cards to work with Malverk!",
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
    end
end





---------------------------
--------------------------- Deckskin Loading
---------------------------

-- helper tables for loading

SMODS.Atlas{ key = 'hearts_vineshroom_ace', px = 71, py = 95, path = 'cards/hearts_vineshroom_ace.png'}
SMODS.Atlas{ key = 'hearts_vargshroom_ace', px = 71, py = 95, path = 'cards/hearts_vargshroom_ace.png'}
SMODS.Atlas{ key = 'hearts_jazz_ace', px = 71, py = 95, path = 'cards/hearts_jazz_ace.png'}

SMODS.Atlas{ key = 'clubs_vineshroom_ace', px = 71, py = 95, path = 'cards/clubs_vineshroom_ace.png'}
SMODS.Atlas{ key = 'clubs_vargshroom_ace', px = 71, py = 95, path = 'cards/clubs_vargshroom_ace.png'}
SMODS.Atlas{ key = 'clubs_jazz_ace', px = 71, py = 95, path = 'cards/clubs_jazz_ace.png'}

SMODS.Atlas{ key = 'diamonds_vineshroom_ace', px = 71, py = 95, path = 'cards/diamonds_vineshroom_ace.png'}
SMODS.Atlas{ key = 'diamonds_vargshroom_ace', px = 71, py = 95, path = 'cards/diamonds_vargshroom_ace.png'}
SMODS.Atlas{ key = 'diamonds_jazz_ace', px = 71, py = 95, path = 'cards/diamonds_jazz_ace.png'}

SMODS.Atlas{ key = 'spades_vineshroom_ace', px = 71, py = 95, path = 'cards/spades_vineshroom_ace.png'}
SMODS.Atlas{ key = 'spades_vargshroom_ace', px = 71, py = 95, path = 'cards/spades_vargshroom_ace.png'}
SMODS.Atlas{ key = 'spades_jazz_ace', px = 71, py = 95, path = 'cards/spades_jazz_ace.png'}



---------------------------
--------------------------- Suit Palettes
---------------------------

for _, suit in ipairs({'Hearts', 'Diamonds', 'Clubs', 'Spades'}) do
    local suit_lower = suit:lower()

    --------------------------- Add vine skins
    ArrowAPI.loading.load_deckskin({
        key = "csau_default_"..suit_lower,
        suit = suit,
        palettes = {{
            key = 'lc',
            ranks = {'Ace'},
            display_ranks = {'Ace'},
            atlas = 'csau_'..(suit_lower)..'_vineshroom_ace',
            pos_style = 'ranks',
            loc_txt = {
                ['en-us'] = "Vineshroom"
            },
            colour = G.C[suit:upper()],
            suit_icon = {
                atlas = 'suits'
            },
            artist = 'Kekulism'
        }},

        prefix_config = { key = false },
    })



    --------------------------- Add varg skins
    ArrowAPI.loading.load_deckskin({
        key = "csau_varg_"..suit_lower,
        suit = suit,
        palettes = {{
            key = 'lc',
            ranks = {'Ace'},
            display_ranks = {'Ace'},
            atlas = 'csau_'..(suit_lower)..'_vargshroom_ace',
            pos_style = 'ranks',
            loc_txt = {
                ['en-us'] = "Vineshroom"
            },
            colour = G.C[suit:upper()],
            suit_icon = {
                atlas = 'suits'
            },
            artist = 'Kekulism'
        }},

        prefix_config = { key = false },
    })

    --------------------------- Add varg skins
    ArrowAPI.loading.load_deckskin({
        key = "csau_jazz_"..suit_lower,
        suit = suit,
        palettes = {{
            key = 'lc',
            ranks = {'Ace'},
            display_ranks = {'Ace'},
            atlas = 'csau_'..(suit_lower)..'_jazz_ace',
            pos_style = 'ranks',
            loc_txt = {
                ['en-us'] = "Vineshroom"
            },
            colour = G.C[suit:upper()],
            suit_icon = {
                atlas = 'suits'
            },
            artist = 'Kekulism'
        }},

        prefix_config = { key = false },
    })
end



--[[

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
--]]