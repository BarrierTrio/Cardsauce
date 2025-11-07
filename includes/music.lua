-- TODO: move all music selection to arrow
if not csau_enabled['enableMusic'] then
    return
end

if not G.SETTINGS.music_selection then
	G.SETTINGS.music_selection = "cardsauce"
end

SMODS.Sound({
    vol = 0.6,
    pitch = 1,
    key = "csau_music1",
    path = "csau_music1.ogg",
    select_music_track = function()
        return (G.SETTINGS.music_selection == "cardsauce") and 10 or false
    end,
})
SMODS.Sound({
    vol = 0.6,
    pitch = 1,
    key = "csau_music2",
    path = "csau_music2.ogg",
    select_music_track = function()
        return (G.SETTINGS.music_selection == "cardsauce" and G.booster_pack_sparkles and not G.booster_pack_sparkles.REMOVED) and 11 or false
    end,
})
SMODS.Sound({
    vol = 0.6,
    pitch = 1,
    key = "csau_music3",
    path = "csau_music3.ogg",
    select_music_track = function()
        return (G.SETTINGS.music_selection == "cardsauce" and G.booster_pack_meteors and not G.booster_pack_meteors.REMOVED) and 11 or false
    end,
})
SMODS.Sound({
    vol = 0.6,
    pitch = 1,
    key = "csau_music4",
    path = "csau_music4.ogg",
    select_music_track = function()
        return (G.SETTINGS.music_selection == "cardsauce" and G.shop and not G.shop.REMOVED) and 11 or false
    end,
})
SMODS.Sound({
    vol = 0.6,
    pitch = 1,
    key = "csau_music5",
    path = "csau_music5.ogg",
    select_music_track = function()
        return (G.SETTINGS.music_selection == "cardsauce" and G.GAME.blind and G.GAME.blind.boss) and 11 or false
    end,
})

-- The music selector original pulled the two-entry table into a local function
-- I removed it since it was used only here ~Winter

--- Sets the current music in balatro's settings to one of the given args
G.FUNCS.change_music = function(args)
	G.ARGS.music_vals = G.ARGS.music_vals or { "cardsauce", "balatro" }
	G.SETTINGS.QUEUED_CHANGE.music_change = G.ARGS.music_vals[args.to_key]
	G.SETTINGS.music_selection = G.ARGS.music_vals[args.to_key]
end