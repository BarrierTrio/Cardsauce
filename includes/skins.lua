

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
            key = "csau_default_"..suit_lower..'_nocharacters',
            ranks = {'Ace'},
            display_ranks = {'Jack', 'Queen', 'King', 'Ace'},
            atlas = 'csau_'..(suit_lower)..'_vineshroom',
            pos_style = {
                ['Jack'] = {atlas = 'arrow_'..suit_lower, pos = {x = 0, y = 0}},
                ['Queen'] = {atlas = 'arrow_'..suit_lower, pos = {x = 1, y = 0}},
                ['King'] = {atlas = 'arrow_'..suit_lower, pos = {x = 2, y = 0}},
                ['Ace'] = {atlas = 'csau_'..(suit_lower)..'_vineshroom', pos = {x = 3, y = 0}}
            },
            loc_txt = {
                ['en-us'] = "Vineshroom"
            },
            colour = G.C[suit:upper()],
            suit_icon = {
                atlas = 'suits'
            },
            artist = 'Kekulism'
        },{
            key = "csau_default_"..suit_lower..'_characters',
            ranks = {'Jack', 'Queen', 'King', 'Ace'},
            display_ranks = {'Jack', 'Queen', 'King', 'Ace'},
            atlas = 'csau_'..(suit_lower)..'_vineshroom',
            pos_style = 'ranks',
            loc_txt = {
                ['en-us'] = "Vineshroom (Characters)"
            },
            colour = G.C[suit:upper()],
            suit_icon = {
                atlas = 'suits'
            },
            artist = 'Kekulism'
        }},
        loc_txt = {
            ['en-us'] = "Vineshroom"
        },
        prefix_config = { key = false },
    })



    --------------------------- Add varg skins
    ArrowAPI.loading.load_deckskin({
        key = "csau_varg_"..suit_lower,
        suit = suit,
        palettes = {{
            key = "csau_varg_"..suit_lower..'_nocharacters',
            ranks = {'Ace'},
            display_ranks = {'Jack', 'Queen', 'King', 'Ace'},
            atlas = 'csau_'..(suit_lower)..'_vargshroom',
            pos_style = {
                ['Jack'] = {atlas = 'arrow_'..suit_lower, pos = {x = 0, y = 0}},
                ['Queen'] = {atlas = 'arrow_'..suit_lower, pos = {x = 1, y = 0}},
                ['King'] = {atlas = 'arrow_'..suit_lower, pos = {x = 2, y = 0}},
                ['Ace'] = {atlas = 'csau_'..(suit_lower)..'_vargshroom', pos = {x = 3, y = 0}}
            },
            loc_txt = {
                ['en-us'] = "Vargshroom"
            },
            colour = G.C[suit:upper()],
            suit_icon = {
                atlas = 'suits'
            },
            artist = 'Kekulism'
        },{
            key = "csau_varg_"..suit_lower..'_characters',
            ranks = {'Jack', 'Queen', 'King', 'Ace'},
            display_ranks = {'Jack', 'Queen', 'King', 'Ace'},
            atlas = 'csau_'..(suit_lower)..'_vargshroom',
            pos_style = 'ranks',
            loc_txt = {
                ['en-us'] = "Vargshroom (Characters)"
            },
            colour = G.C[suit:upper()],
            suit_icon = {
                atlas = 'suits'
            },
            artist = 'Kekulism'
        }},
        loc_txt = {
            ['en-us'] = "Vargshroom"
        },
        prefix_config = { key = false },
    })

    --------------------------- Add varg skins
    ArrowAPI.loading.load_deckskin({
        key = "csau_jazz_"..suit_lower,
        suit = suit,
        palettes = {{
            key = 'csau_jazz_'..suit_lower..'_characters',
            ranks = {'Ace'},
            display_ranks = {'Jack', 'Queen', 'King', 'Ace'},
            atlas = 'csau_'..(suit_lower)..'_jazz',
            pos_style = {
                ['Jack'] = {atlas = 'arrow_'..suit_lower, pos = {x = 0, y = 0}},
                ['Queen'] = {atlas = 'arrow_'..suit_lower, pos = {x = 1, y = 0}},
                ['King'] = {atlas = 'arrow_'..suit_lower, pos = {x = 2, y = 0}},
                ['Ace'] = {atlas = 'csau_'..(suit_lower)..'_jazz', pos = {x = 3, y = 0}}
            },
            loc_txt = {
                ['en-us'] = "Jazz Mister"
            },
            colour = G.C[suit:upper()],
            suit_icon = {
                atlas = 'suits'
            },
            artist = 'Kekulism'
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
            suit_icon = {
                atlas = 'suits'
            },
            artist = 'Kekulism'
        }},
        loc_txt = {
            ['en-us'] = "Jazz Mister"
        },
        prefix_config = { key = false },
    })
end