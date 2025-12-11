-- Mod Icon in Mods tab
SMODS.Atlas({
	key = "jojobal_modicon",
	path = "stand_icon.png",
	px = 32,
	py = 32,
    prefix_config = false
})

if JojobalMod.current_config['enable_Title'] then
	-- Title Screen Logo Texture
	ArrowAPI.ui.replace_title(Cardsauce, {
		path = 'jojobal_title_alt.png',
		px = 489,
		py = 216,
	})
end