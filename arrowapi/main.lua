ArrowAPI = SMODS.current_mod
ArrowAPI.ARROW_USE_CREDITS = true
ArrowAPI.startup_item_check = false
ArrowAPI.col_stand_hover = nil
ArrowAPI.palette_ui_config = {
	rgb = {0, 0, 0},
	open_palette = {
		set = '',
		idx = '',
	},
	hex_input = '',
	name_input = ''
}

-- TNSMI setup, aliased from ArrowAPI
TNSMI = SMODS.current_mod
TNSMI.cardareas = {}
TNSMI.prompt_text_input = ''
TNSMI.search_text = ''

G.C.SECONDARY_SET.SoundPack = HEX("56A887")
G.C.STAND = HEX('B85F8E')
G.C.VHS = HEX('a2615e')

G.C.BLIND.SHOWDOWN_COL_1 = copy_table(G.C.RED)
G.C.BLIND.SHOWDOWN_COL_2 = copy_table(G.C.BLUE)

-- copied from arrow
G.C.TAGS = {
    tag_uncommon = G.C.GREEN,
    tag_rare = G.C.RED,
    tag_negative = G.C.DARK_EDITION,
    tag_foil = G.C.DARK_EDITION,
    tag_holo = G.C.DARK_EDITION,
    tag_polychrome = G.C.DARK_EDITION,
    tag_investment = G.C.MONEY,
    tag_voucher = G.C.SECONDARY_SET.Voucher,
    tag_boss = G.C.IMPORTANT,
    tag_standard = G.C.IMPORTANT,
    tag_charm = G.C.SECONDARY_SET.Tarot,
    tag_meteor = G.C.SECONDARY_SET.Planet,
    tag_buffoon = G.C.RED,
    tag_handy = G.C.MONEY,
    tag_garbage = G.C.MONEY,
    tag_ethereal = G.C.SECONDARY_SET.Spectral,
    tag_coupon = G.C.MONEY,
    tag_double = G.C.IMPORTANT,
    tag_juggle = G.C.BLUE,
    tag_d_six = G.C.GREEN,
    tag_top_up = G.C.BLUE,
    tag_skip = G.C.MONEY,
    tag_orbital = G.C.SECONDARY_SET.Planet,
    tag_economy = G.C.MONEY,
	tag_spirit = G.C.STAND,
	tag_plinket = G.C.VHS
}

if not G.ARGS.LOC_COLOURS then loc_colour() end
G.ARGS.LOC_COLOURS['stand'] = G.C.STAND
G.ARGS.LOC_COLOURS['vhs'] = G.C.VHS
G.ARGS.LOC_COLOURS['eternal'] = G.C.ETERNAL
G.ARGS.LOC_COLOURS['perishable'] = G.C.PERISHABLE
G.ARGS.LOC_COLOURS['rental'] = G.C.RENTAL

-- dunno if I'll use these
G.ARGS.LOC_COLOURS['showdown1'] = G.C.BLIND.SHOWDOWN_COL_1
G.ARGS.LOC_COLOURS['showdown2'] = G.C.BLIND.SHOWDOWN_COL_2

local includes = {
	-- data types
	'sound',
	'compat',
	'math',
	'config',
	'logging',
	'string',
	'table',
	'pseudorandom',
	'colors',
	'ui',
	'credits',
	'shaders',
	'loading',

	'hooks/node',
	'hooks/blind',
	'hooks/button_callbacks',
	'hooks/common_events',
	'hooks/cardarea',
	'hooks/card',
	'hooks/game',
	'hooks/back',
	'hooks/smods',
	'hooks/UI_definitions',

	'overrides',
	'stands',
	'vhs',
	'game',
	'misc',
}

for _, include in ipairs(includes) do
	local init, error = SMODS.load_file("arrowapi/api/" .. include ..".lua")
	if error then sendErrorMessage("[Arrow] Failed to load "..include.." with error "..error) else
		local data = init()
		sendDebugMessage("[Arrow] Loaded hook: " .. include)
	end
end

sendDebugMessage('is arrow valid: '..tostring(ArrowAPI))