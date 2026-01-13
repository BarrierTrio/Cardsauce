

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

SMODS.Atlas{ key = 'hearts_vineshroom', px = 71, py = 95, path = 'cards/hearts_vineshroom.png'}
SMODS.Atlas{ key = 'hearts_vargshroom', px = 71, py = 95, path = 'cards/hearts_vargshroom.png'}
SMODS.Atlas{ key = 'hearts_jazz', px = 71, py = 95, path = 'cards/hearts_jazz.png'}

SMODS.Atlas{ key = 'clubs_vineshroom', px = 71, py = 95, path = 'cards/clubs_vineshroom.png'}
SMODS.Atlas{ key = 'clubs_vargshroom', px = 71, py = 95, path = 'cards/clubs_vargshroom.png'}
SMODS.Atlas{ key = 'clubs_jazz', px = 71, py = 95, path = 'cards/clubs_jazz.png'}

SMODS.Atlas{ key = 'diamonds_vineshroom', px = 71, py = 95, path = 'cards/diamonds_vineshroom.png'}
SMODS.Atlas{ key = 'diamonds_vargshroom', px = 71, py = 95, path = 'cards/diamonds_vargshroom.png'}
SMODS.Atlas{ key = 'diamonds_jazz', px = 71, py = 95, path = 'cards/diamonds_jazz.png'}

SMODS.Atlas{ key = 'spades_vineshroom', px = 71, py = 95, path = 'cards/spades_vineshroom.png'}
SMODS.Atlas{ key = 'spades_vargshroom', px = 71, py = 95, path = 'cards/spades_vargshroom.png'}
SMODS.Atlas{ key = 'spades_jazz', px = 71, py = 95, path = 'cards/spades_jazz.png'}

--- Table representing the credits for collab artwork. Properties are tables containing localizaiton info for each face card
local collab_credits = {
	-- Vine
    -- spades
	csau_default_spades = {
        Ace = "Kekulism",
        King = "Jazz_Jen",
        Queen = "Jazz_Jen",
        Jack = "Jazz_Jen",
	},
    -- hearts
	csau_default_hearts = {
        Ace = "Kekulism",
		King = "fradavovan",
		Queen = "CheesyDraws",
		Jack = "CheesyDraws",
	},
    -- clubs
	csau_default_clubs = {
        Ace = "Kekulism",
		King = "CheesyDraws",
		Queen = "Greeeg",
		Jack = "CheesyDraws",
	},
    -- diamonds
	csau_default_diamonds = {
        Ace = "Kekulism",
		King = "Winter Grimwell",
		Queen = "Winter Grimwell",
		Jack = "Winter Grimwell",
	},
	-- Varg
    -- spades
	csau_varg_spades = {
        Ace = "Kekulism",
		King = "BarrierTrio/Gote",
		Queen = "chvsau",
		Jack = "Retrotype",
	},
    -- hearts
	csau_varg_hearts = {
        Ace = "Kekulism",
		King = "Burdrehnar",
		Queen = "GuffNFluff",
		Jack = "plunch",
	},
    -- clubs
	csau_varg_clubs = {
        Ace = "Kekulism",
		King = "Lyzerus",
		Queen = "Crisppyboat",
		Jack = "Lyzerus",
	},
    -- diamonds
	csau_varg_diamonds = {
        Ace = "Kekulism",
		King = "Winter Grimwell",
		Queen = "SagaciousCejai",
		Jack = "GuffNFluff",
	},
	-- Mike
    -- spades
	csau_jazz_spades = {
		Ace = "MightyKingWario",
		King = "eldritchminds",
		Queen = "GuffNFluff",
		Jack = "BarrierTrio/Gote",
	},
    -- hearts
	csau_jazz_hearts = {
		Ace = "MightyKingWario",
		King = "SagaciousCejai", "BarrierTrio/Gote",
		Queen = "BarrierTrio/Gote",
		Jack = "SagaciousCejai",
	},
    -- clubs
	csau_jazz_clubs = {
		Ace = "MightyKingWario",
		King = "FenixSeraph",
		Queen = "Winter Grimwell",
		Jack = "Winter Grimwell",
	},
    -- diamonds
	csau_jazz_diamonds = {
		Ace = "MightyKingWario",
		King = "Winter Grimwell",
		Queen = "LolWutBurger",
		Jack = "BarrierTrio/Gote",
	},
}

---------------------------
--------------------------- Suit Palettes
---------------------------

for _, suit in ipairs({'Hearts', 'Diamonds', 'Clubs', 'Spades'}) do
    local suit_lower = suit:lower()

    --------------------------- Add vine skins
    local vine_key = "csau_default_"..suit_lower
    ArrowAPI.loading.load_deckskin({
        key = vine_key,
        suit = suit,
        palettes = {{
            key = "csau_default_"..suit_lower..'_nocharacters',
            ranks = {'Ace'},
            display_ranks = {'Jack', 'Queen', 'King', 'Ace'},
            atlas = 'csau_'..(suit_lower)..'_vineshroom',
            pos_style = {
                ['Ace'] = {atlas = 'csau_'..(suit_lower)..'_vineshroom', pos = {x = 3, y = 0}}
            },
            loc_txt = {
                ['en-us'] = "Vineshroom"
            },
            artist = collab_credits[vine_key],
            colour = G.C[suit:upper()],
        },{
            key = "csau_default_"..suit_lower..'_characters',
            ranks = {'Jack', 'Queen', 'King', 'Ace'},
            display_ranks = {'Jack', 'Queen', 'King', 'Ace'},
            atlas = 'csau_'..(suit_lower)..'_vineshroom',
            pos_style = 'ranks',
            loc_txt = {
                ['en-us'] = "Vineshroom (Characters)"
            },
            artist = collab_credits[vine_key],
            colour = G.C[suit:upper()],
        }},
        loc_txt = {
            ['en-us'] = "Vineshroom"
        },
        generate_ds_card_ui = function(card, deckskin, palette, info_queue, desc_nodes, specific_vars, full_UI_table)
            if card.artist then
                local vars = (type(card.artist) == 'function' and card:artist()) or (type(card.artist) == 'table' and card.artist) or {card.artist}
                localize{type = 'other', nodes = desc_nodes, key = "artistcredit_"..#vars, set = "Other", vars = vars }
            end
        end,
        has_ds_card_ui = function(card, deckskin, palette)
            return card.artist
        end,
        prefix_config = { key = false },
    })



    --------------------------- Add varg skins
    local varg_key = "csau_varg_"..suit_lower
    ArrowAPI.loading.load_deckskin({
        key = varg_key,
        suit = suit,
        palettes = {{
            key = "csau_varg_"..suit_lower..'_nocharacters',
            ranks = {'Ace'},
            display_ranks = {'Jack', 'Queen', 'King', 'Ace'},
            atlas = 'csau_'..(suit_lower)..'_vargshroom',
            pos_style = {
                ['Ace'] = {atlas = 'csau_'..(suit_lower)..'_vargshroom', pos = {x = 3, y = 0}}
            },
            loc_txt = {
                ['en-us'] = "Vargshroom"
            },
            artist = collab_credits[varg_key],
            colour = G.C[suit:upper()],
        },{
            key = "csau_varg_"..suit_lower..'_characters',
            ranks = {'Jack', 'Queen', 'King', 'Ace'},
            display_ranks = {'Jack', 'Queen', 'King', 'Ace'},
            atlas = 'csau_'..(suit_lower)..'_vargshroom',
            pos_style = 'ranks',
            loc_txt = {
                ['en-us'] = "Vargshroom (Characters)"
            },
            artist = collab_credits[varg_key],
            colour = G.C[suit:upper()],
        }},
        loc_txt = {
            ['en-us'] = "Vargshroom"
        },
        generate_ds_card_ui = function(card, deckskin, palette, info_queue, desc_nodes, specific_vars, full_UI_table)
            if card.artist then
                local vars = (type(card.artist) == 'function' and card:artist()) or (type(card.artist) == 'table' and card.artist) or {card.artist}
                localize{type = 'other', nodes = desc_nodes, key = "artistcredit_"..#vars, set = "Other", vars = vars }
            end
        end,
        has_ds_card_ui = function(card, deckskin, palette)
            return card.artist
        end,
        prefix_config = { key = false },
    })

    --------------------------- Add varg skins
    local jazz_key = "csau_jazz_"..suit_lower
    ArrowAPI.loading.load_deckskin({
        key = jazz_key,
        suit = suit,
        palettes = {{
            key = 'csau_jazz_'..suit_lower..'_characters',
            ranks = {'Ace'},
            display_ranks = {'Jack', 'Queen', 'King', 'Ace'},
            atlas = 'csau_'..(suit_lower)..'_jazz',
            pos_style = {
                ['Ace'] = {atlas = 'csau_'..(suit_lower)..'_jazz', pos = {x = 3, y = 0}}
            },
            loc_txt = {
                ['en-us'] = "Jazz Mister"
            },
            colour = G.C[suit:upper()],
            artist = collab_credits[jazz_key],
        },{
            key = 'csau_jazz_'..suit_lower..'_characters',
            ranks = {'Jack', 'Queen', 'King', 'Ace'},
            display_ranks = {'Jack', 'Queen', 'King', 'Ace'},
            atlas = 'csau_'..(suit_lower)..'_jazz',
            pos_style = 'ranks',
            loc_txt = {
                ['en-us'] = "Jazz Mister (Characters)"
            },
            colour = G.C[suit:upper()],
            artist = collab_credits[jazz_key],
        }},
        loc_txt = {
            ['en-us'] = "Jazz Mister"
        },
        generate_ds_card_ui = function(card, deckskin, palette, info_queue, desc_nodes, specific_vars, full_UI_table)
            if card.artist then
                local vars = (type(card.artist) == 'function' and card:artist()) or (type(card.artist) == 'table' and card.artist) or {card.artist}
                localize{type = 'other', nodes = desc_nodes, key = "artistcredit_"..#vars, set = "Other", vars = vars }
            end
        end,
        has_ds_card_ui = function(card, deckskin, palette)
            return card.artist
        end,
        prefix_config = { key = false },
    })
end