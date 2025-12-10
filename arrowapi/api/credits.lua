ArrowAPI.DEFAULT_CREDIT_MATRIX = {col = 21, row = 10}
ArrowAPI.DEFAULT_CREDIT_SIZE = {w = 17, h = 6}
ArrowAPI.DEFAULT_CREDIT_SECTIONS = {
    {key = 'concept', title_colour = G.C.YELLOW},
    {key = 'artist', title_colour = G.C.ETERNAL},
    {key = 'programmer', title_colour = G.C.GOLD}
}

ArrowAPI.credits = {
    Cardsauce = {
        matrix = {col = 20, row = 10},
        {
            key = 'direction',
            title_colour = G.C.YELLOW,
            pos_start = {col = 0, row = 0},
            pos_end = {col = 5, row = 10},
            contributors = {
                {name = "BarrierTrio/Gote", name_scale = 1, name_colour = G.C.UI.TEXT_LIGHT},
                {name = "Kekulism", name_scale = 1, name_colour = G.C.UI.TEXT_LIGHT},
                {name = "Vivian Giacobbi", name_scale = 1, name_colour = G.C.UI.TEXT_LIGHT},
            }
        },
        {
            key = 'artist',
            title_colour = G.C.ETERNAL,
            pos_start = {col = 5, row = 0},
            pos_end = {col = 12.5, row = 10},
            contributors = {}
        },
        {
            key = 'programmer',
            title_colour = G.C.GOLD,
            pos_start = {col = 12.5, row = 0},
            pos_end = {col = 20, row = 5},
            contributors = {}
        },
        {
            key = 'graphics',
            title_colour = G.C.DARK_EDITION,
            pos_start = {col = 12.5, row = 5},
            pos_end = {col = 20, row = 10},
            contributors = {
                {name = "Vivian Giacobbi", name_scale = 1, name_colour = G.C.UI.TEXT_LIGHT},
                {name = "Sir. Gameboy", name_scale = 1, name_colour = G.C.UI.TEXT_LIGHT}
            }
        }
    },
}