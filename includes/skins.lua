local upc_ref = G.FUNCS.update_collab_cards
G.FUNCS.update_collab_cards = function(key, suit, silent)
	upc_ref(key, suit, silent)
	if type(key) == "number" then
		key = G.COLLABS.options[suit][key]
	end
	if G.csau_collab_credits[key] then
		for i, card in ipairs(G.cdds_cards.cards) do
			if G.csau_collab_credits[key][card.config.card.value] then
				card.no_ui = false
				card.csau_collab_credit = G.csau_collab_credits[key][card.config.card.value]
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
SMODS.Atlas{ key = 'csau_c_collab_VS', px = 71, py = 95, path = 'cards/recolored/csau_c_collab_VS.png', prefix_config = {key = false},}
SMODS.Atlas{ key = 'csau_c_collab_STS', px = 71, py = 95, path = 'cards/recolored/csau_c_collab_STS.png', prefix_config = {key = false},}
SMODS.Atlas{ key = 'csau_c_collab_PC', px = 71, py = 95, path = 'cards/recolored/csau_c_collab_PC.png', prefix_config = {key = false},}
SMODS.Atlas{ key = 'csau_c_collab_WF', px = 71, py = 95, path = 'cards/recolored/csau_c_collab_WF.png', prefix_config = {key = false},}
-- Recolored Diamonds Collabs
SMODS.Atlas{ key = 'csau_d_collab_DTD', px = 71, py = 95, path = 'cards/recolored/csau_d_collab_DTD.png', prefix_config = {key = false},}
SMODS.Atlas{ key = 'csau_d_collab_SV', px = 71, py = 95, path = 'cards/recolored/csau_d_collab_SV.png', prefix_config = {key = false},}
SMODS.Atlas{ key = 'csau_d_collab_EG', px = 71, py = 95, path = 'cards/recolored/csau_d_collab_EG.png', prefix_config = {key = false},}
SMODS.Atlas{ key = 'csau_d_collab_XR', px = 71, py = 95, path = 'cards/recolored/csau_d_collab_XR.png', prefix_config = {key = false},}
-- Recolored Hearts Collabs
SMODS.Atlas{ key = 'csau_h_collab_AU', px = 71, py = 95, path = 'cards/recolored/csau_h_collab_AU.png', prefix_config = {key = false},}
SMODS.Atlas{ key = 'csau_h_collab_TBoI', px = 71, py = 95, path = 'cards/recolored/csau_h_collab_TBoI.png', prefix_config = {key = false},}
SMODS.Atlas{ key = 'csau_h_collab_CL', px = 71, py = 95, path = 'cards/recolored/csau_h_collab_CL.png', prefix_config = {key = false},}
SMODS.Atlas{ key = 'csau_h_collab_D2', px = 71, py = 95, path = 'cards/recolored/csau_h_collab_D2.png', prefix_config = {key = false},}
-- Recolored Spades Collabs
SMODS.Atlas{ key = 'csau_s_collab_TW', px = 71, py = 95, path = 'cards/recolored/csau_s_collab_TW.png', prefix_config = {key = false}, }
SMODS.Atlas{ key = 'csau_s_collab_CYP', px = 71, py = 95, path = 'cards/recolored/csau_s_collab_CYP.png', prefix_config = {key = false}, }
SMODS.Atlas{ key = 'csau_s_collab_SK', px = 71, py = 95, path = 'cards/recolored/csau_s_collab_SK.png', prefix_config = {key = false}, }
SMODS.Atlas{ key = 'csau_s_collab_DS', px = 71, py = 95, path = 'cards/recolored/csau_s_collab_DS.png', prefix_config = {key = false}, }

local color = {
    Hearts = HEX("e14e62"),
    Diamonds = HEX("3c56a4"),
    Clubs = HEX("4dac84"),
    Spades = HEX("8d619a"),
}

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_VS'], {
    key = 'csau_collab_VS',
    ranks = full_ranks,
    display_ranks = face,
    atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_c_collab_VS', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_c_collab_VS', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_c_collab_VS', pos = {x = 2, y = 0} },
        Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = 0} }
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors"
    },
    colour = color.Clubs,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_VS'], {
    key = 'csau_collab_VS_shroom',
    ranks = full_ranks,
    display_ranks = face_ace,
    atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_c_collab_VS', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_c_collab_VS', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_c_collab_VS', pos = {x = 2, y = 0} },
    },
    loc_txt = {
        ['en-us'] = "CSAU Colors & Darkshroom"
    },
    colour = color.Clubs,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_VS'], {
    key = 'csau_collab_VS_vineshroom',
    ranks = full_ranks,
    display_ranks = face_ace,
    atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_c_collab_VS', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_c_collab_VS', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_c_collab_VS', pos = {x = 2, y = 0} },
        Ace = { atlas = 'csau_c_vineshroom', pos = {x = 0, y = 0} }
    },
    loc_txt = {
        ['en-us'] = "CSAU Colors & Vineshroom"
    },
    colour = color.Clubs,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_STS'], {
    key = 'csau_collab_STS',
    ranks = full_ranks,
    display_ranks = face,
    atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_c_collab_STS', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_c_collab_STS', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_c_collab_STS', pos = {x = 2, y = 0} },
        Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = 0} }
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors"
    },
    colour = color.Clubs,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_STS'], {
    key = 'csau_collab_STS_shroom',
    ranks = full_ranks,
    display_ranks = face_ace,
    atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_c_collab_STS', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_c_collab_STS', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_c_collab_STS', pos = {x = 2, y = 0} },
    },
    loc_txt = {
        ['en-us'] = "CSAU Colors & Darkshroom"
    },
    colour = color.Clubs,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_STS'], {
    key = 'csau_collab_STS_vineshroom',
    ranks = full_ranks,
    display_ranks = face_ace,
    atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_c_collab_STS', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_c_collab_STS', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_c_collab_STS', pos = {x = 2, y = 0} },
        Ace = { atlas = 'csau_c_vineshroom', pos = {x = 0, y = 0} }
    },
    loc_txt = {
        ['en-us'] = "CSAU Colors & Vineshroom"
    },
    colour = color.Clubs,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_PC'], {
    key = 'csau_collab_PC',
    ranks = full_ranks,
    display_ranks = face,
    atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_c_collab_PC', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_c_collab_PC', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_c_collab_PC', pos = {x = 2, y = 0} },
        Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = 0} }
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors"
    },
    colour = color.Clubs,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_PC'], {
    key = 'csau_collab_PC_shroom',
    ranks = full_ranks,
    display_ranks = face_ace,
    atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_c_collab_PC', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_c_collab_PC', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_c_collab_PC', pos = {x = 2, y = 0} },
    },
    loc_txt = {
        ['en-us'] = "CSAU Colors & Darkshroom"
    },
    colour = color.Clubs,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_PC'], {
    key = 'csau_collab_PC_vineshroom',
    ranks = full_ranks,
    display_ranks = face_ace,
    atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_c_collab_PC', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_c_collab_PC', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_c_collab_PC', pos = {x = 2, y = 0} },
        Ace = { atlas = 'csau_c_vineshroom', pos = {x = 0, y = 0} }
    },
    loc_txt = {
        ['en-us'] = "CSAU Colors & Vineshroom"
    },
    colour = color.Clubs,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_WF'], {
    key = 'csau_collab_WF',
    ranks = full_ranks,
    display_ranks = face,
    atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_c_collab_WF', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_c_collab_WF', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_c_collab_WF', pos = {x = 2, y = 0} },
        Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = 0} }
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors"
    },
    colour = color.Clubs,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_WF'], {
    key = 'csau_collab_WF_shroom',
    ranks = full_ranks,
    display_ranks = face_ace, atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_c_collab_WF', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_c_collab_WF', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_c_collab_WF', pos = {x = 2, y = 0} },
    },
    loc_txt = {
        ['en-us'] = "CSAU Colors & Darkshroom"
    },
    colour = color.Clubs,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_WF'], {
    key = 'csau_collab_WF_vineshroom',
    ranks = full_ranks,
    display_ranks = face_ace,
    atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_c_collab_WF', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_c_collab_WF', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_c_collab_WF', pos = {x = 2, y = 0} },
        Ace = { atlas = 'csau_c_vineshroom', pos = {x = 0, y = 0} }
    },
    loc_txt = {
        ['en-us'] = "CSAU Colors & Vineshroom"
    },
    colour = color.Clubs,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_DTD'], {
    key = 'csau_collab_DTD',
    ranks = full_ranks,
    display_ranks = face,
    atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_d_collab_DTD', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_d_collab_DTD', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_d_collab_DTD', pos = {x = 2, y = 0} },
        Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = 2} }
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors"
    },
    colour = color.Diamonds,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_DTD'], {
    key = 'csau_collab_DTD_shroom',
    ranks = full_ranks,
    display_ranks = face_ace,
    atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_d_collab_DTD', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_d_collab_DTD', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_d_collab_DTD', pos = {x = 2, y = 0} },
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors & Shroom"
    },
    colour = color.Diamonds,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_SV'], {
    key = 'csau_collab_SV',
    ranks = full_ranks,
    display_ranks = face, atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_d_collab_SV', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_d_collab_SV', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_d_collab_SV', pos = {x = 2, y = 0} },
        Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = 2} }
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors"
    },
    colour = color.Diamonds,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_SV'], {
    key = 'csau_collab_SV_shroom',
    ranks = full_ranks,
    display_ranks = face_ace, atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_d_collab_SV', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_d_collab_SV', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_d_collab_SV', pos = {x = 2, y = 0} },
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors & Shroom"
    },
    colour = color.Diamonds,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_EG'], {
    key = 'csau_collab_EG',
    ranks = full_ranks,
    display_ranks = face, atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_d_collab_EG', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_d_collab_EG', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_d_collab_EG', pos = {x = 2, y = 0} },
        Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = 2} }
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors"
    },
    colour = color.Diamonds,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_EG'], {
    key = 'csau_collab_EG_shroom',
    ranks = full_ranks,
    display_ranks = face_ace, atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_d_collab_EG', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_d_collab_EG', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_d_collab_EG', pos = {x = 2, y = 0} },
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors & Shroom"
    },
    colour = color.Diamonds,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_XR'], {
    key = 'csau_collab_XR',
    ranks = full_ranks,
    display_ranks = face, atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_d_collab_XR', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_d_collab_XR', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_d_collab_XR', pos = {x = 2, y = 0} },
        Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = 2} }
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors"
    },
    colour = color.Diamonds,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_XR'], {
    key = 'csau_collab_XR_shroom',
    ranks = full_ranks,
    display_ranks = face_ace, atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_d_collab_XR', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_d_collab_XR', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_d_collab_XR', pos = {x = 2, y = 0} },
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors & Shroom"
    },
    colour = color.Diamonds,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_AU'], {
    key = 'csau_collab_AU',
    ranks = full_ranks,
    display_ranks = face, atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_h_collab_AU', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_h_collab_AU', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_h_collab_AU', pos = {x = 2, y = 0} },
        Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = 0} }
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors"
    },
    colour = color.Hearts,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_AU'], {
    key = 'csau_collab_AU_shroom',
    ranks = full_ranks,
    display_ranks = face_ace, atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_h_collab_AU', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_h_collab_AU', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_h_collab_AU', pos = {x = 2, y = 0} },
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors & Shroom"
    },
    colour = color.Hearts,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_TBoI'], {
    key = 'csau_collab_TBoI',
    ranks = full_ranks,
        display_ranks = face, atlas = 'csau_default',
        pos_style = {
            fallback_style = 'deck',
            Jack = { atlas = 'csau_h_collab_TBoI', pos = {x = 0, y = 0} },
            Queen = { atlas = 'csau_h_collab_TBoI', pos = {x = 1, y = 0} },
            King = { atlas = 'csau_h_collab_TBoI', pos = {x = 2, y = 0} },
            Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = 0} }
        },
        loc_txt = {
            ['en-us'] = "Cardsauce Colors"
        },
        colour = color.Hearts,
        suit_icon = {
            atlas = 'csau_suits'
        }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_TBoI'], {
    key = 'csau_collab_TBoI_shroom',
    ranks = full_ranks,
    display_ranks = face_ace, atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_h_collab_TBoI', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_h_collab_TBoI', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_h_collab_TBoI', pos = {x = 2, y = 0} },
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors & Shroom"
    },
    colour = color.Hearts,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_CL'], {
    key = 'csau_collab_CL',
    ranks = full_ranks,
    display_ranks = face, atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_h_collab_CL', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_h_collab_CL', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_h_collab_CL', pos = {x = 2, y = 0} },
        Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = 0} }
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors"
    },
    colour = color.Hearts,
    suit_icon = {
        atlas = 'csau_suits'
    }
})
SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_CL'], {
    key = 'csau_collab_CL_shroom',
    ranks = full_ranks,
    display_ranks = face_ace, atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_h_collab_CL', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_h_collab_CL', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_h_collab_CL', pos = {x = 2, y = 0} },
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors & Shroom"
    },
    colour = color.Hearts,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_D2'], {
    key = 'csau_collab_D2',
    ranks = full_ranks,
    display_ranks = face, atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_h_collab_D2', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_h_collab_D2', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_h_collab_D2', pos = {x = 2, y = 0} },
        Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = 0} }
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors"
    },
    colour = color.Hearts,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_D2'], {
    key = 'csau_collab_D2_shroom',
    ranks = full_ranks,
    display_ranks = face_ace, atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_h_collab_D2', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_h_collab_D2', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_h_collab_D2', pos = {x = 2, y = 0} },
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors & Shroom"
    },
    colour = color.Hearts,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_TW'], {
    key = 'csau_collab_TW',
    ranks = full_ranks,
    display_ranks = face, atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_s_collab_TW', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_s_collab_TW', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_s_collab_TW', pos = {x = 2, y = 0} },
        Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = 3} }
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors"
    },
    colour = color.Spades,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_TW'], { key = 'csau_collab_TW_shroom', ranks = full_ranks,
    display_ranks = face_ace, atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_s_collab_TW', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_s_collab_TW', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_s_collab_TW', pos = {x = 2, y = 0} },
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors & Shroom"
    },
    colour = color.Spades,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_CYP'], {
    key = 'csau_collab_CYP',
    ranks = full_ranks,
    display_ranks = face, atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_s_collab_CYP', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_s_collab_CYP', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_s_collab_CYP', pos = {x = 2, y = 0} },
        Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = 3} }
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors"
    },
    colour = color.Spades,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_CYP'], {
    key = 'csau_collab_CYP_shroom',
    ranks = full_ranks,
    display_ranks = face_ace, atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_s_collab_CYP', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_s_collab_CYP', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_s_collab_CYP', pos = {x = 2, y = 0} },
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors & Shroom"
    },
    colour = color.Spades,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_SK'], {
    key = 'csau_collab_SK',
    ranks = full_ranks,
    display_ranks = face, atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_s_collab_SK', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_s_collab_SK', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_s_collab_SK', pos = {x = 2, y = 0} },
        Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = 3} }
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors"
    },
    colour = color.Spades,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_SK'], {
    key = 'csau_collab_SK_shroom',
    ranks = full_ranks,
    display_ranks = face_ace, atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_s_collab_SK', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_s_collab_SK', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_s_collab_SK', pos = {x = 2, y = 0} },
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors & Shroom"
    },
    colour = color.Spades,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_DS'], {
    key = 'csau_collab_DS',
    ranks = full_ranks,
    display_ranks = face, atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_s_collab_DS', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_s_collab_DS', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_s_collab_DS', pos = {x = 2, y = 0} },
        Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = 3} }
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors"
    },
    colour = color.Spades,
    suit_icon = {
        atlas = 'csau_suits'
    }
})

SMODS.DeckSkin.add_palette(SMODS.DeckSkins['collab_DS'], {
    key = 'csau_collab_DS_shroom',
    ranks = full_ranks,
    display_ranks = face_ace, atlas = 'csau_default',
    pos_style = {
        fallback_style = 'deck',
        Jack = { atlas = 'csau_s_collab_DS', pos = {x = 0, y = 0} },
        Queen = { atlas = 'csau_s_collab_DS', pos = {x = 1, y = 0} },
        King = { atlas = 'csau_s_collab_DS', pos = {x = 2, y = 0} },
    },
    loc_txt = {
        ['en-us'] = "Cardsauce Colors & Shroom"
    },
    colour = color.Spades,
    suit_icon = {
        atlas = 'csau_suits'
    }
})





---------------------------
--------------------------- Vine Character Skins
---------------------------

SMODS.Atlas{ key = 'c_mascots', px = 71, py = 95, path = 'cards/csau/c_mascots.png',}
SMODS.Atlas{ key = 'd_classics', px = 71, py = 95, path = 'cards/csau/d_classics.png',}
SMODS.Atlas{ key = 'h_wildcards', px = 71, py = 95, path = 'cards/csau/h_wildcards.png',}
SMODS.Atlas{ key = 's_confidants', px = 71, py = 95, path = 'cards/csau/s_confidants.png',}
SMODS.DeckSkin{
    key = "csau_mascots",
    suit = "Clubs",
    palettes = {
        {
            key = 'csau_mascots', ranks = full_ranks,
            display_ranks = face_ace, atlas = 'csau_default',
            pos_style = {
                fallback_style = 'deck',
                Jack = { atlas = 'csau_c_mascots', pos = {x = 0, y = 0} },
                Queen = { atlas = 'csau_c_mascots', pos = {x = 1, y = 0} },
                King = { atlas = 'csau_c_mascots', pos = {x = 2, y = 0} },
            },
            loc_txt = {
                ['en-us'] = "Cardsauce Colors"
            },
            colour = color.Clubs,
            suit_icon = {
                atlas = 'csau_suits'
            }
        },
        {
            key = 'csau_mascots_vineshroom', ranks = full_ranks,
            display_ranks = face_ace, atlas = 'csau_default',
            pos_style = {
                fallback_style = 'deck',
                Jack = { atlas = 'csau_c_mascots', pos = {x = 0, y = 0} },
                Queen = { atlas = 'csau_c_mascots', pos = {x = 1, y = 0} },
                King = { atlas = 'csau_c_mascots', pos = {x = 2, y = 0} },
                Ace = { atlas = 'csau_c_vineshroom', pos = {x = 0, y = 0} }
            },
            loc_txt = {
                ['en-us'] = "Vineshroom"
            },
            colour = color.Clubs,
            suit_icon = {
                atlas = 'csau_suits'
            }
        },
        {
            key = 'csau_mascots_ace', ranks = full_ranks,
            display_ranks = face_ace, atlas = 'csau_default',
            pos_style = {
                fallback_style = 'deck',
                Jack = { atlas = 'csau_c_mascots', pos = {x = 0, y = 0} },
                Queen = { atlas = 'csau_c_mascots', pos = {x = 1, y = 0} },
                King = { atlas = 'csau_c_mascots', pos = {x = 2, y = 0} },
                Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = 1} }
            },
            loc_txt = {
                ['en-us'] = "Vanilla Ace"
            },
            colour = color.Clubs,
            suit_icon = {
                atlas = 'csau_suits'
            }
        },
    },
    loc_txt = {
        ['en-us'] = "The Mascots"
    }
}

SMODS.DeckSkin{
    key = "csau_classics",
    suit = "Diamonds",
    palettes = {
        {
            key = 'csau_classics', ranks = full_ranks,
            display_ranks = face_ace, atlas = 'csau_default',
            pos_style = {
                fallback_style = 'deck',
                Jack = { atlas = 'csau_d_classics', pos = {x = 0, y = 0} },
                Queen = { atlas = 'csau_d_classics', pos = {x = 1, y = 0} },
                King = { atlas = 'csau_d_classics', pos = {x = 2, y = 0} },
            },
            loc_txt = {
                ['en-us'] = "Cardsauce Colors"
            },
            colour = color.Diamonds,
            suit_icon = {
                atlas = 'csau_suits'
            }
        },
        {
            key = 'csau_classics_ace', ranks = full_ranks,
            display_ranks = face_ace, atlas = 'csau_default',
            pos_style = {
                fallback_style = 'deck',
                Jack = { atlas = 'csau_d_classics', pos = {x = 0, y = 0} },
                Queen = { atlas = 'csau_d_classics', pos = {x = 1, y = 0} },
                King = { atlas = 'csau_d_classics', pos = {x = 2, y = 0} },
                Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = 2} }
            },
            loc_txt = {
                ['en-us'] = "Vanilla Ace"
            },
            colour = color.Diamonds,
            suit_icon = {
                atlas = 'csau_suits'
            }
        },
    },
    loc_txt = {
        ['en-us'] = "The Classics"
    }
}

SMODS.DeckSkin{
    key = "csau_wildcards",
    suit = "Hearts",
    palettes = {
        {
            key = 'csau_wildcards', ranks = full_ranks,
            display_ranks = face_ace, atlas = 'csau_default',
            pos_style = {
                fallback_style = 'deck',
                Jack = { atlas = 'csau_h_wildcards', pos = {x = 0, y = 0} },
                Queen = { atlas = 'csau_h_wildcards', pos = {x = 1, y = 0} },
                King = { atlas = 'csau_h_wildcards', pos = {x = 2, y = 0} },
            },
            loc_txt = {
                ['en-us'] = "Cardsauce Colors"
            },
            colour = color.Hearts,
            suit_icon = {
                atlas = 'csau_suits'
            }
        },
        {
            key = 'csau_wildcards_ace', ranks = full_ranks,
            display_ranks = face_ace, atlas = 'csau_default',
            pos_style = {
                fallback_style = 'deck',
                Jack = { atlas = 'csau_h_wildcards', pos = {x = 0, y = 0} },
                Queen = { atlas = 'csau_h_wildcards', pos = {x = 1, y = 0} },
                King = { atlas = 'csau_h_wildcards', pos = {x = 2, y = 0} },
                Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = 0} }
            },
            loc_txt = {
                ['en-us'] = "Vanilla Ace"
            },
            colour = color.Hearts,
            suit_icon = {
                atlas = 'csau_suits'
            }
        },
    },
    loc_txt = {
        ['en-us'] = "The Wildcards"
    }
}

SMODS.DeckSkin{
    key = "csau_confidants",
    suit = "Spades",
    palettes = {
        {
            key = 'csau_confidants', ranks = full_ranks,
            display_ranks = face_ace, atlas = 'csau_default',
            pos_style = {
                fallback_style = 'deck',
                Jack = { atlas = 'csau_s_confidants', pos = {x = 0, y = 0} },
                Queen = { atlas = 'csau_s_confidants', pos = {x = 1, y = 0} },
                King = { atlas = 'csau_s_confidants', pos = {x = 2, y = 0} },
            },
            loc_txt = {
                ['en-us'] = "Cardsauce Colors"
            },
            colour = color.Spades,
            suit_icon = {
                atlas = 'csau_suits'
            }
        },
        {
            key = 'csau_confidants_ace', ranks = full_ranks,
            display_ranks = face_ace, atlas = 'csau_default',
            pos_style = {
                fallback_style = 'deck',
                Jack = { atlas = 'csau_s_confidants', pos = {x = 0, y = 0} },
                Queen = { atlas = 'csau_s_confidants', pos = {x = 1, y = 0} },
                King = { atlas = 'csau_s_confidants', pos = {x = 2, y = 0} },
                Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = 3} }
            },
            loc_txt = {
                ['en-us'] = "Vanilla Ace"
            },
            colour = color.Spades,
            suit_icon = {
                atlas = 'csau_suits'
            }
        },
    },
    loc_txt = {
        ['en-us'] = "The Confidants"
    }
}





---------------------------
--------------------------- Varg Character Skins
---------------------------

if twoPointO then
    -- Varg Characters
    SMODS.Atlas{ key = 'c_voices', px = 71, py = 95, path = 'cards/csau/c_voices.png',}
    SMODS.Atlas{ key = 'd_duendes', px = 71, py = 95, path = 'cards/csau/d_duendes.png',}
    SMODS.Atlas{ key = 'h_americans', px = 71, py = 95, path = 'cards/csau/h_americans.png',}
    SMODS.Atlas{ key = 's_powerful', px = 71, py = 95, path = 'cards/csau/s_powerful.png',}

    SMODS.DeckSkin{
        key = "csau_voices",
        suit = "Clubs",
        palettes = {
            {
                key = 'csau_voices', ranks = full_ranks,
                display_ranks = face_ace, atlas = 'csau_default',
                pos_style = {
                    fallback_style = 'deck',
                    Jack = { atlas = 'csau_c_voices', pos = {x = 0, y = 0} },
                    Queen = { atlas = 'csau_c_voices', pos = {x = 1, y = 0} },
                    King = { atlas = 'csau_c_voices', pos = {x = 2, y = 0} },
                    Ace = { atlas = 'csau_varg_aces', pos = {x = 0, y = 1} }
                },
                loc_txt = {
                    ['en-us'] = "Cardsauce Colors"
                },
                colour = color.Clubs,
                suit_icon = {
                    atlas = 'csau_suits'
                }
            },
            {
                key = 'csau_voices_ace', ranks = full_ranks,
                display_ranks = face_ace, atlas = 'csau_default',
                pos_style = {
                    fallback_style = 'deck',
                    Jack = { atlas = 'csau_c_voices', pos = {x = 0, y = 0} },
                    Queen = { atlas = 'csau_c_voices', pos = {x = 1, y = 0} },
                    King = { atlas = 'csau_c_voices', pos = {x = 2, y = 0} },
                    Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = 1} }
                },
                loc_txt = {
                    ['en-us'] = "Vanilla Ace"
                },
                colour = color.Clubs,
                suit_icon = {
                    atlas = 'csau_suits'
                }
            },
        },
        loc_txt = {
            ['en-us'] = "The Voices"
        }
    }
    SMODS.DeckSkin{
        key = "csau_duendes",
        suit = "Diamonds",
        palettes = {
            {
                key = 'csau_duendes', ranks = full_ranks,
                display_ranks = face_ace, atlas = 'csau_default',
                pos_style = {
                    fallback_style = 'deck',
                    Jack = { atlas = 'csau_d_duendes', pos = {x = 0, y = 0} },
                    Queen = { atlas = 'csau_d_duendes', pos = {x = 1, y = 0} },
                    King = { atlas = 'csau_d_duendes', pos = {x = 2, y = 0} },
                    Ace = { atlas = 'csau_varg_aces', pos = {x = 0, y = 2} }
                },
                loc_txt = {
                    ['en-us'] = "Cardsauce Colors"
                },
                colour = color.Diamonds,
                suit_icon = {
                    atlas = 'csau_suits'
                }
            },
            {
                key = 'csau_duendes_ace', ranks = full_ranks,
                display_ranks = face_ace, atlas = 'csau_default',
                pos_style = {
                    fallback_style = 'deck',
                    Jack = { atlas = 'csau_d_duendes', pos = {x = 0, y = 0} },
                    Queen = { atlas = 'csau_d_duendes', pos = {x = 1, y = 0} },
                    King = { atlas = 'csau_d_duendes', pos = {x = 2, y = 0} },
                    Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = 2} }
                },
                loc_txt = {
                    ['en-us'] = "Vanilla Ace"
                },
                colour = color.Diamonds,
                suit_icon = {
                    atlas = 'csau_suits'
                }
            },
        },
        loc_txt = {
            ['en-us'] = "The Duendes"
        }
    }
    SMODS.DeckSkin{
        key = "csau_americans",
        suit = "Hearts",
        palettes = {
            {
                key = 'csau_americans', ranks = full_ranks,
                display_ranks = face_ace, atlas = 'csau_default',
                pos_style = {
                    fallback_style = 'deck',
                    Jack = { atlas = 'csau_h_americans', pos = {x = 0, y = 0} },
                    Queen = { atlas = 'csau_h_americans', pos = {x = 1, y = 0} },
                    King = { atlas = 'csau_h_americans', pos = {x = 2, y = 0} },
                    Ace = { atlas = 'csau_varg_aces', pos = {x = 0, y = 0} }
                },
                loc_txt = {
                    ['en-us'] = "Cardsauce Colors"
                },
                colour = color.Hearts,
                suit_icon = {
                    atlas = 'csau_suits'
                }
            },
            {
                key = 'csau_americans_ace', ranks = full_ranks,
                display_ranks = face_ace, atlas = 'csau_default',
                pos_style = {
                    fallback_style = 'deck',
                    Jack = { atlas = 'csau_h_americans', pos = {x = 0, y = 0} },
                    Queen = { atlas = 'csau_h_americans', pos = {x = 1, y = 0} },
                    King = { atlas = 'csau_h_americans', pos = {x = 2, y = 0} },
                    Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = 0} }
                },
                loc_txt = {
                    ['en-us'] = "Vanilla Ace"
                },
                colour = color.Hearts,
                suit_icon = {
                    atlas = 'csau_suits'
                }
            },
        },
        loc_txt = {
            ['en-us'] = "The Americans"
        }
    }
    SMODS.DeckSkin{
        key = "csau_powerful",
        suit = "Spades",
        palettes = {
            {
                key = 'csau_powerful', ranks = full_ranks,
                display_ranks = face_ace, atlas = 'csau_default',
                pos_style = {
                    fallback_style = 'deck',
                    Jack = { atlas = 'csau_s_powerful', pos = {x = 0, y = 0} },
                    Queen = { atlas = 'csau_s_powerful', pos = {x = 1, y = 0} },
                    King = { atlas = 'csau_s_powerful', pos = {x = 2, y = 0} },
                    Ace = { atlas = 'csau_varg_aces', pos = {x = 0, y = 3} }
                },
                loc_txt = {
                    ['en-us'] = "Cardsauce Colors"
                },
                colour = color.Spades,
                suit_icon = {
                    atlas = 'csau_suits'
                }
            },
            {
                key = 'csau_confidants_ace', ranks = full_ranks,
                display_ranks = face_ace, atlas = 'csau_default',
                pos_style = {
                    fallback_style = 'deck',
                    Jack = { atlas = 'csau_s_powerful', pos = {x = 0, y = 0} },
                    Queen = { atlas = 'csau_s_powerful', pos = {x = 1, y = 0} },
                    King = { atlas = 'csau_s_powerful', pos = {x = 2, y = 0} },
                    Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = 3} }
                },
                loc_txt = {
                    ['en-us'] = "Vanilla Ace"
                },
                colour = color.Spades,
                suit_icon = {
                    atlas = 'csau_suits'
                }
            },
        },
        loc_txt = {
            ['en-us'] = "The Powerful"
        }
    }
end





---------------------------
--------------------------- Mike Character skins
---------------------------

SMODS.Atlas{ key = 'h_poops', px = 71, py = 95, path = 'cards/csau/h_poops.png',}
SMODS.Atlas{ key = 's_ocs', px = 71, py = 95, path = 'cards/csau/s_ocs.png',}

SMODS.DeckSkin{
    key = "csau_poops",
    suit = "Hearts",
    palettes = {
        {
            key = 'csau_poops', ranks = full_ranks,
            display_ranks = face_ace, atlas = 'csau_default',
            pos_style = {
                fallback_style = 'deck',
                Jack = { atlas = 'csau_h_poops', pos = {x = 0, y = 0} },
                Queen = { atlas = 'csau_h_poops', pos = {x = 1, y = 0} },
                King = { atlas = 'csau_h_poops', pos = {x = 2, y = 0} },
            },
            loc_txt = {
                ['en-us'] = "Cardsauce Colors"
            },
            colour = color.Hearts,
            suit_icon = {
                atlas = 'csau_suits'
            }
        },
        {
            key = 'csau_poops_ace', ranks = full_ranks,
            display_ranks = face_ace, atlas = 'csau_default',
            pos_style = {
                fallback_style = 'deck',
                Jack = { atlas = 'csau_h_poops', pos = {x = 0, y = 0} },
                Queen = { atlas = 'csau_h_poops', pos = {x = 1, y = 0} },
                King = { atlas = 'csau_h_poops', pos = {x = 2, y = 0} },
                Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = 0} }
            },
            loc_txt = {
                ['en-us'] = "Vanilla Ace"
            },
            colour = color.Hearts,
            suit_icon = {
                atlas = 'csau_suits'
            }
        },
    },
    loc_txt = {
        ['en-us'] = "The Poops"
    }
}
if twoPointO then
    SMODS.DeckSkin{
        key = "csau_ocs",
        suit = "Spades",
        palettes = {
            {
                key = 'csau_ocs', ranks = full_ranks,
                display_ranks = face_ace, atlas = 'csau_default',
                pos_style = {
                    fallback_style = 'deck',
                    Jack = { atlas = 'csau_s_ocs', pos = {x = 0, y = 0} },
                    Queen = { atlas = 'csau_s_ocs', pos = {x = 1, y = 0} },
                    King = { atlas = 'csau_s_ocs', pos = {x = 2, y = 0} },
                },
                loc_txt = {
                    ['en-us'] = "Cardsauce Colors"
                },
                colour = color.Spades,
                suit_icon = {
                    atlas = 'csau_suits'
                }
            },
            {
                key = 'csau_ocs_ace', ranks = full_ranks,
                display_ranks = face_ace, atlas = 'csau_default',
                pos_style = {
                    fallback_style = 'deck',
                    Jack = { atlas = 'csau_s_ocs', pos = {x = 0, y = 0} },
                    Queen = { atlas = 'csau_s_ocs', pos = {x = 1, y = 0} },
                    King = { atlas = 'csau_s_ocs', pos = {x = 2, y = 0} },
                    Ace = { atlas = 'csau_color_aces', pos = {x = 0, y = 0} }
                },
                loc_txt = {
                    ['en-us'] = "Vanilla Ace"
                },
                colour = color.Hearts,
                suit_icon = {
                    atlas = 'csau_suits'
                }
            },
        },
        loc_txt = {
            ['en-us'] = "The OCs"
        }
    }
end





---------------------------
--------------------------- Suit Palettes
---------------------------

SMODS.Atlas{ key = 'balcolor_shrooms_lc', px = 71, py = 95, path = 'cards/balcolor_shrooms_lc.png' }
SMODS.Atlas{ key = 'balcolor_shrooms_hc', px = 71, py = 95, path = 'cards/balcolor_shrooms_hc.png' }
SMODS.Atlas{ key = 'varg_aces', px = 71, py = 95, path = 'cards/csau_varg_aces.png' }
SMODS.Atlas{ key = 'balcolor_varg_lc', px = 71, py = 95, path = 'cards/balcolor_varg_lc.png' }
SMODS.Atlas{ key = 'balcolor_varg_hc', px = 71, py = 95, path = 'cards/balcolor_varg_hc.png' }
SMODS.Atlas{ key = 'varg_willo', px = 71, py = 95, path = 'cards/csau_varg_willo.png' }
SMODS.Atlas{ key = 'color_aces', px = 71, py = 95, path = 'cards/csau_color_aces.png' }
SMODS.Atlas{ key = 'c_vineshroom', px = 71, py = 95, path = 'cards/c_vineshroom.png' }
SMODS.Atlas{ key = 'csau_default', px = 71, py = 95, path = 'cards/csau_default.png', prefix_config = {key = false} }

SMODS.Atlas{ key = 'suits', px = 18, py = 18, path = 'cards/suits.png' }
SMODS.Atlas{ key = 'hearts_willo', px = 18, py = 18, path = 'cards/hearts_willo.png' }
local suits = {'hearts', 'diamonds', 'clubs', 'spades'}

-- default color palettes if all suit colors are disabled
if not G.SETTINGS.initCSAUColors then
    G.SETTINGS.CUSTOM_DECK.Collabs.Spades = "csau_default_spades"
    G.SETTINGS.CUSTOM_DECK.Collabs.Hearts = "csau_default_hearts"
    G.SETTINGS.CUSTOM_DECK.Collabs.Diamonds = "csau_default_diamonds"
    G.SETTINGS.CUSTOM_DECK.Collabs.Clubs = "csau_default_clubs"
    if not G.SETTINGS.colourpalettes then
        G.SETTINGS.colourpalettes = {}
    end
    G.SETTINGS.colourpalettes.Spades = "csau_def_spades"
    G.SETTINGS.colourpalettes.Hearts = "csau_def_hearts"
    G.SETTINGS.colourpalettes.Diamonds = "csau_def_diamonds"
    G.SETTINGS.colourpalettes.Clubs = "csau_def_clubs"
    G.SETTINGS.initCSAUColors = true
    G.save_settings()
end

-- setting base suit
for suit, color in pairs(G.C.SUITS) do
    local c
    if suit == "Hearts" then c = HEX("e14e62")
    elseif suit == "Diamonds" then c = HEX("3c56a4")
    elseif suit == "Clubs" then c = HEX("4dac84")
    elseif suit == "Spades" then c = HEX("8d619a")
    end
    SMODS.Suits[suit].keep_base_colours = false
    SMODS.Suits[suit].lc_colour = c
    SMODS.Suits[suit].hc_colour = c
    if G.VANILLA_COLLABS then
        G.VANILLA_COLLABS.lc_colours[suit] = c
        G.VANILLA_COLLABS.hc_colours[suit] = c
    end
    G.C.SO_1[suit] = c
    G.C.SO_2[suit] = c
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
            ['en-us'] = "Cardsauce Colors"
        },
        colour = color[suit:gsub("^%l", string.upper)],
        suit_icon = {
            atlas = 'csau_suits'
        }
    }

    if suit == 'clubs' then
        palettes[#palettes+1] = {
            key = 'csau_vineshroom',
            ranks = full_ranks,
            display_ranks = face_ace,
            atlas = 'csau_default',
            pos_style = {
                fallback_style = 'deck',
                Ace = {
                    atlas = 'csau_c_vineshroom',
                    pos = {x = 0, y = 0}
                }
            },
            loc_txt = {
                ['en-us'] = "Vineshroom Ace"
            },
            colour = color[suit:gsub("^%l", string.upper)],
            suit_icon = {
                atlas = 'csau_suits'
            }
        }
    end

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

if twoPointO then
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
                ['en-us'] = "Cardsauce Colors"
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
end