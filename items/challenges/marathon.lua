
local default_card_bans = {
    [1] = {id = 'j_8_ball'},
    [2] = {id = 'j_superposition'},
    [3] = {id = 'j_vagabond'},
    [4] = {id = 'j_hallucination'},
    [5] = {id = 'j_fortune_teller'},
    [6] = {id = 'j_constellation'},
    [7] = {id = 'j_satellite'},
    [8] = {id = 'j_astronomer'},
    [9] = {id = 'j_sixth_sense'},
    [10] = {id = 'j_seance'},
    [11] = {id = 'v_crystal_ball', ids = {'v_crystal_ball', 'v_omen_globe'}},
    [12] = {id = 'v_telescope', ids = {'v_telescope', 'v_astronomer'}},
    [13] = {id = 'v_tarot_merchant', ids = {'v_tarot_merchant', 'v_tarot_tycoon'}},
    [14] = {id = 'v_planet_merchant', ids = {'v_planet_merchant', 'v_planet_tycoon'}},

    [15] = {id = 'p_celestial_normal_1', ids = {
        'p_celestial_normal_1','p_celestial_normal_2','p_celestial_jumbo_1','p_celestial_jumbo_2',
    }},
    [16] = {id = 'p_spectral_normal_1', ids = {
        'p_spectral_normal_1','p_spectral_normal_2','p_spectral_jumbo_1','p_spectral_jumbo_2',
    }},
    [17] = {id = 'p_arcana_normal_1', ids = {
        'p_arcana_normal_1','p_arcana_normal_2','p_arcana_jumbo_1','p_arcana_jumbo_2',
    }},
    [18] = {id = 'c_csau_banned_consumables', ids = {}},
    [19] = {id = 'v_csau_banned_vouchers', ids = {}},
    [20] = {id = 'p_csau_banned_boosters', ids = {}},
}

local default_tag_bans = {
    [1] = {id = 'tag_charm'},
    [2] = {id = 'tag_meteor'},
    [3] = {id = 'tag_etheral'},
    [4] = {id = 'tag_csau_spirit'},
    [5] = {id = 'tag_csau_banned_tags', ids = {}},
}

local function smods_pool_search(pool_key, string_exclude)
    local found_keys = {}
    local pool_keys = type(pool_key) == 'table' and pool_key or {pool_key}
    for _, key in ipairs(pool_keys) do
        if SMODS[key..'s'] then
            for k, v in pairs(SMODS[key]) do
                if not string_exclude or (not ArrowAPI.string.contains(k, string_exclude)) then
                    found_keys[#found_keys+1] = k
                end
            end
        else
            for k, v in pairs(SMODS.Centers) do
                if v.set == key and (not string_exclude or (not ArrowAPI.string.contains(k, string_exclude))) then
                    found_keys[#found_keys+1] = k
                end
            end
        end
    end
    return found_keys
end

local chalInfo = {
    rules = {
        custom = {
            {id = "csau_marathon" },
        },
    },
    vouchers = {
        { id = 'v_csau_scavenger'}
    },
    restrictions = {
        banned_cards = function()
            default_card_bans[18].ids = smods_pool_search({'Tarot', 'Planet', 'Spectral'}, 'csau_')
            default_card_bans[19].ids = smods_pool_search('Voucher', 'csau_')
            default_card_bans[20].ids = smods_pool_search('Booster', 'csau_')

            return default_card_bans
        end,
        banned_tags = function()
            default_tag_bans[5].ids = smods_pool_search('Tag', 'csau_')
            return default_tag_bans
        end,
    },
}


return chalInfo