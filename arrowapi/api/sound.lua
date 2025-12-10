SMODS.Atlas({key = 'arrow_sp_default', path = 'soundpacks/sp_default.png', px = 71, py = 71, prefix_config = false})
SMODS.Atlas({key = 'arrow_sp_balatro', path = 'soundpacks/sp_balatro.png', px = 71, py = 71, prefix_config = false})

TNSMI.SoundPacks = {}
TNSMI.SoundPack = SMODS.GameObject:extend ({
    obj_buffer = {},
    set = 'SoundPack',
    obj_table = TNSMI.SoundPacks,
    class_prefix = "sp",
    atlas = 'arrow_sp_default',
    required_params = {
        'key',
        'sound_table'
    },
    process_loc_text = function(self) -- LOC_TXT structure = name = string, text = table of strings
        SMODS.process_loc_text(G.localization.descriptions.SoundPacks, self.key, self.loc_txt)
    end,
    register = function(self)
        if self.registered then
            sendWarnMessage(('Detected duplicate register call on object %s'):format(self.key), self.set)
            return
        end

        TNSMI.SoundPack.super.register(self)
    end,
    inject = function(self)
        if self.key == 'sp_balatro' then return end

        for _, v in ipairs(self.sound_table) do
            if v.key and not v.replace_key and not v.select_music_track then
                v.replace_key = v.key
            end

            if not v.key and v.replace_key then v.key = v.replace_key end

            local path = v.path or v.file
            if not path then
                path = (v.key..'.ogg')
            elseif not string.find(path, '.ogg') and not string.find(path, '.wav') then
                path = path..'.ogg'
            end
            v.key = self.key..'_'..v.key

            local select_music_track = v.select_music_track
            if string.find(v.key, "music") and not select_music_track then
                -- simple priority selection from highest to lowest
                select_music_track = function()
                    for i = #TNSMI.config.loaded_packs, 1, -1 do
                        if TNSMI.config.loaded_packs[i] == self.key then return i end
                    end
                end
            end

            if not v.req_mod or next(SMODS.find_mod(v.req_mod)) then
                local new_sound = SMODS.Sound ({
                    key = v.key,
                    path = path,
                    pitch = v.pitch or self.pitch,
                    volume = v.volume or self.volume,
                    sync = v.sync,
                    select_music_track = v.music_track,
                    prefix_config = {
                        key = false
                    }
                })

                new_sound.mod = self.mod
                new_sound.original_mod = self.mod

                -- have to do these manually I think?
                new_sound:inject()
                new_sound:process_loc_text()
            end
        end
    end,
})

function TNSMI.save_soundpacks()
    -- resets all existing replace sounds
    local replace_map = TNSMI.config.loaded_packs.replace_map or {}
    for k, v in pairs (replace_map) do
        if type(v) == 'table' then
            SMODS.Sounds[v.key].replace = nil
            SMODS.Sound.replace_sounds[k] = nil
        end
    end

    -- in descending priority order, fill in any replace sounds
    -- not already replaced at higher priority
    replace_map = {}
    if #TNSMI.config.loaded_packs > 0 then
        for i, v in ipairs(TNSMI.config.loaded_packs) do
            sendDebugMessage('loaded soundpacks: '..v)
            -- Save the priority to the config file.
            local pack = TNSMI.SoundPacks[v]

            for _, sound in ipairs(pack.sound_table) do
                if pack.key == 'sp_balatro' then
                    -- fill the replace map slot to prevent overriding of vanilla sounds at priority
                    replace_map[sound.key] = true
                elseif sound.replace_key and not replace_map[sound.replace_key] then
                    replace_map[sound.replace_key] = { key = sound.key }
                    local obj = SMODS.Sounds[sound.key]
                    obj:create_replace_sound(sound.replace_key)
                end
            end
        end
    end
    TNSMI.config.loaded_packs.replace_map = replace_map

    SMODS.save_mod_config(TNSMI)
end

TNSMI.SoundPack({
    key = 'sp_balatro',
    atlas = 'arrow_sp_balatro',
    prefix_config = false,
    sound_table = {
        { key = "ambientFire1" },
        { key = "ambientFire2"  },
        { key = "ambientFire3"  },
        { key = "ambientOrgan1"  },
        { key = "button"  },
        { key = "cancel"  },
        { key = "card1"  },
        { key = "card3"  },
        { key = "cardFan2"  },
        { key = "cardSlide1"  },
        { key = "cardSlide2"  },
        { key = "chips1"  },
        { key = "chips2"  },
        { key = "coin1"  },
        { key = "coin2"  },
        { key = "coin3"  },
        { key = "coin4"  },
        { key = "coin5"  },
        { key = "coin6"  },
        { key = "coin7"  },
        { key = "crumple1"  },
        { key = "crumple2"  },
        { key = "crumple3"  },
        { key = "crumple4"  },
        { key = "crumple5"  },
        { key = "crumpleLong1"  },
        { key = "crumpleLong2"  },
        { key = "explosion_buildup1"  },
        { key = "explosion_release1"  },
        { key = "explosion1"  },
        { key = "foil1"  },
        { key = "foil2"  },
        { key = "generic1"  },
        { key = "glass1"  },
        { key = "glass2"  },
        { key = "glass3"  },
        { key = "glass4"  },
        { key = "glass5"  },
        { key = "glass6"  },
        { key = "gold_seal"  },
        { key = "gong"  },
        { key = "highlight1"  },
        { key = "highlight2"  },
        { key = "holo1"  },
        { key = "introPad1"  },
        { key = "magic_crumple"  },
        { key = "magic_crumple2"  },
        { key = "magic_crumple3"  },
        { key = "multhit1"  },
        { key = "multhit2"  },
        { key = "negative"  },
        { key = "other1"  },
        { key = "paper1"  },
        { key = "polychrome1"  },
        { key = "slice1"  },
        { key = "splash_buildup"  },
        { key = "tarot1"  },
        { key = "tarot2"  },
        { key = "timpani"  },
        { key = "voice1"  },
        { key = "voice2"  },
        { key = "voice3"  },
        { key = "voice4"  },
        { key = "voice5"  },
        { key = "voice6"  },
        { key = "voice7" },
        { key = "voice8" },
        { key = "voice9" },
        { key = "voice10" },
        { key = "voice11" },
        { key = "whoosh_long" },
        { key = "whoosh" },
        { key = "whoosh1" },
        { key = "whoosh2" },
        { key = "win" },
        { key = "music1" },
        { key = "music2" },
        { key = "music3" },
        { key = "music4" },
        { key = "music5" }
    },
})