local restrict = SMODS.Challenges.c_jokerless_1.restrictions
table.insert(restrict.banned_tags, {id = 'tag_csau_corrupted'})
SMODS.Challenge:take_ownership('jokerless_1', {
    restrictions = restrict
}, true)





---------------------------
--------------------------- Wings of Time unlock
---------------------------

local ref_bones_calc = function(self, card, context)
    if context.end_of_round and context.game_over and G.GAME.chips/G.GAME.blind.chips >= 0.25 then
        G.E_MANAGER:add_event(Event({
            func = function()
                G.hand_text_area.blind_chips:juice_up()
                G.hand_text_area.game_chips:juice_up()
                play_sound('tarot1')
                card:start_dissolve()
                return true
            end
        }))
        return {
            message = localize('k_saved_ex'),
            saved = true,
            colour = G.C.RED
        }
    end
end

SMODS.Joker:take_ownership('mr_bones', {
    calculate = function(self, card, context)
        local ret = ref_bones_calc(self, card, context)
        if ret and ret.saved then
            check_for_unlock({ type = 'unlock_epoch' })
        end
    end
}, true)





---------------------------
--------------------------- Austin unlock
---------------------------

SMODS.Blind:take_ownership('bl_wall', {
    calculate = function(self, context)
        if context.blind_defeated and G.GAME.blind.config.blind.key == self.key then
            check_for_unlock({ type = 'defeat_wall' })
        end
    end
}, true)





---------------------------
--------------------------- All the various wheel code
---------------------------

SMODS.Consumable:take_ownership('wheel_of_fortune', {
    use = function(self, card, area, copier)
        if SMODS.pseudorandom_probability(card, 'wheel_of_fortune', 1, card.ability.extra) then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    local edition = nil
                    local nukie = ArrowAPI.vhs.find_activated_tape('c_csau_nukie')
                    if nukie and SMODS.pseudorandom_probability(nukie, 'csau_nukie_negative', 1, nukie.ability.extra.chance) then
                        edition = {negative = true}
                    else
                        edition = poll_edition('wheel_of_fortune', nil, true, true)
                    end

                    if edition == 'e_polychrome' and next(SMODS.find_card('j_csau_speen')) then
                        check_for_unlock({ type = "high_speen" })
                    end

                    local eligible_card = pseudorandom_element(card.eligible_strength_jokers, 'wheel_of_fortune')
                    eligible_card:set_edition(edition, true)
                    check_for_unlock({type = 'have_edition'})
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        else
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    check_for_unlock({ type = 'wheel_nope' })
                    attention_text({
                        text = localize('k_nope_ex'),
                        scale = 1.3,
                        hold = 1.4,
                        major = card,
                        backdrop_colour = G.C.SECONDARY_SET.Tarot,
                        align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and 'tm' or 'cm',
                        offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0},
                        silent = true
                    })
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.06*G.SETTINGS.GAMESPEED,
                        blockable = false,
                        blocking = false,
                        func = function()
                            local nutbuster_active = SMODS.find_card('j_csau_nutbuster')
                            play_sound(nutbuster_active and 'csau_doot' or 'tarot2', nutbuster_active and 1 or 0.76, 0.4);
                            return true
                        end
                    }))
                    play_sound('tarot2', 1, 0.4)
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end
        delay(0.6)
    end
}, true)