local jokerInfo = {
    name = 'Wigsaw',
    config = {},
    rarity = 4,
    cost = 20,
    unlocked = false,
    unlock_condition = {type = '', extra = '', hidden = true},
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    hasSoul = true,
    streamer = "joel",
    artist = 'BarrierTrio/Gote'
}

function jokerInfo.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    ArrowAPI.ui.generate_legendary_desc(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
end

return jokerInfo
--[[

JOKERS AFFECTED BY WIGSAW MANUALLY (FUCK):

Vanilla:

--JOKERS:
- Greedy Joker ✔️
- Lusty Joker ✔️
- Wrathful Joker ✔️
- Gluttonous Joker ✔️
- Blackboard ✔️
- Ancient Joker ✔️
- Castle ✔️
- Rough Gem ✔️
- Bloodstone ✔️
- Arrowhead ✔️
- Onyx Agate ✔️
- Flowerpot ✔️
- The Idol ✔️
- Seeing Double ✔️

--CONSUMABLES:
- The Star ✔️
- The Moon ✔️
- The Sun ✔️
- The World ✔️
- Sigil ✔️

Cardsauce:

--JOKERS:
- The Purple Joker ✔️
- Cousin's Club ✔️
- Why Are You Red? ✔️
- Joey's Castle ✔️
- Choicest Voice ✔️
- Barbeque Shoes ✔️
- Dancing Joker ✔️

--STANDS:
- Star Platinum ✔️
- DIO's World ✔️
- Gold Experience ✔️

]]--