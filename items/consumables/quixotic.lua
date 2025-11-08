local consumInfo = {
    name = 'Quixotic',
    set = "Spectral",
    cost = 4,
    alerted = true,
    streamer = 'vinny',
    artist = 'BarrierTrio/Gote'
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_TAGS.tag_ethereal
    return {}
end

function consumInfo.use(self, card, area, copier)
    check_for_unlock({ type = "activate_quixotic" })
    G.E_MANAGER:add_event(Event({
        func = (function()
            add_tag(Tag('tag_ethereal'))
            play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
            play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
            return true
        end)
    }))
end

function consumInfo.can_use(self, card)
    return true
end

return consumInfo