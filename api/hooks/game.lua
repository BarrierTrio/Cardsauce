local ps_ref = Game.prep_stage
function Game:prep_stage(new_stage, new_state, new_game_obj)
    ps_ref(self, new_stage, new_state, new_game_obj)
    G.FUNCS.initPostSplash()
end

local ref_game_start = Game.start_run
function Game:start_run(args)
    G.GAME.arrow_gradient_background = nil
    G.GAME.arrow_gradient_ui = nil
    local ret = ref_game_start(self, args)

    if (not args or not args.savetext) and G.GAME.modifiers.all_bosses then
        G.GAME.round_resets.blind_choices.Small = get_new_boss('Small')
        G.GAME.round_resets.blind_choices.Big = get_new_boss('Big')
    end

    local obj = G.GAME.blind.config.blind
    if G.GAME.blind.in_blind and obj.post_load and type(obj.post_load) == 'function' then
        obj:post_load()
    end

    return ret
end

local ref_game_delete = Game.delete_run
function Game:delete_run(...)
    local ret = ref_game_delete(self, ...)

    -- for the sake of cleanup, I don't want these hanging in the background
    if G.GAME and G.GAME.arrow_extra_blinds and next(G.GAME.arrow_extra_blinds) then
        for _, v in ipairs(G.GAME.arrow_extra_blinds) do
            v:remove()
        end
        G.GAME.arrow_extra_blinds = nil
    end

    return ret
end

local ref_load_profile = Game.load_profile
function Game:load_profile(_profile)
    local ret = ref_load_profile(self, _profile)
    G.PROFILES[G.SETTINGS.profile].stand_usage = G.PROFILES[G.SETTINGS.profile].stand_usage or {}

    return ret
end