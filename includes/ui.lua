-- Mod Icon in Mods tab
SMODS.Atlas({
	key = "modicon",
	path = "csau_icon.png",
	px = 32,
	py = 32
})





---------------------------
--------------------------- Title Screen Easter eggs
---------------------------

if Cardsauce.config['enable_Logo'] then
	-- Title Screen Logo Texture
	local logo = "Logo.png"
	if Cardsauce.chadnova and Cardsauce.config['enable_EasterEggs'] then
		logo = "Logo-C.png"
	end

	ArrowAPI.ui.replace_title(Cardsauce, {
		path = logo,
		px = 333,
		py = 216,
	})
end