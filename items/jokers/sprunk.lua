
-- Modified code from Cryptid
local function fake_crash()
    messages = {
        "stack overflow",
        "The software was closed because an error occurred.",
        "YOU FUCKING IDIOT"
    }

    function getDebugInfoForCrash()
        local info = "Additional Context:\nBalatro Version: " .. VERSION .. "\nModded Version: " .. MODDED_VERSION
        local major, minor, revision, codename = love.getVersion()
        info = info .. "\nLove2D Version: " .. string.format("%d.%d.%d", major, minor, revision)

        local lovely_success, lovely = pcall(require, "lovely")
        if lovely_success then
            info = info .. "\nLovely Version: " .. lovely.version
        end
        if SMODS.mod_list then
            info = info .. "\nSteamodded Mods:"
            local enabled_mods = {}
            for _, v in ipairs(SMODS.mod_list) do
                if v.can_load then
                    table.insert(enabled_mods, v)
                end
            end
            for k, v in ipairs(enabled_mods) do
                info = info
                        .. "\n    "
                        .. k
                        .. ": "
                        .. v.name
                        .. " by "
                        .. table.concat(v.author, ", ")
                        .. " [ID: "
                        .. v.id
                        .. (v.priority ~= 0 and (", Priority: " .. v.priority) or "")
                        .. (v.version and v.version ~= "0.0.0" and (", Version: " .. v.version) or "")
                        .. "]"
                local debugInfo = v.debug_info
                if debugInfo then
                    if type(debugInfo) == "string" then
                        if #debugInfo ~= 0 then
                            info = info .. "\n        " .. debugInfo
                        end
                    elseif type(debugInfo) == "table" then
                        for kk, vv in pairs(debugInfo) do
                            if type(vv) ~= "nil" then
                                vv = tostring(vv)
                            end
                            if #vv ~= 0 then
                                info = info .. "\n        " .. kk .. ": " .. vv
                            end
                        end
                    end
                end
            end
        end
        return info
    end

    VERSION = VERSION
    MODDED_VERSION = MODDED_VERSION

    if SMODS.mod_list then
        for i, mod in ipairs(SMODS.mod_list) do
            mod.can_load = true
            mod.name = mod.name
            mod.id = mod.id
            mod.author = { 20 }
            mod.version = mod.version
            mod.debug_info = math.random(5, 100)
        end
    end

    do
        local utf8 = require("utf8")
        local linesize = 100

        -- Modifed from https://love2d.org/wiki/love.errorhandler
        function love.errorhandler(msg)
            msg = tostring(msg)

            if not love.window or not love.graphics or not love.event then
                return
            end

            if not love.graphics.isCreated() or not love.window.isOpen() then
                local success, status = pcall(love.window.setMode, 800, 600)
                if not success or not status then
                    return
                end
            end

            -- Reset state.
            if love.mouse then
                love.mouse.setVisible(true)
                love.mouse.setGrabbed(false)
                love.mouse.setRelativeMode(false)
                if love.mouse.isCursorSupported() then
                    love.mouse.setCursor()
                end
            end
            if love.joystick then
                -- Stop all joystick vibrations.
                for i, v in ipairs(love.joystick.getJoysticks()) do
                    v:setVibration()
                end
            end
            if love.audio then
                love.audio.stop()
            end

            love.graphics.reset()
            local font = love.graphics.setNewFont("resources/fonts/m6x11plus.ttf", 20)

            love.graphics.clear(G.C.BLACK)
            love.graphics.origin()

            local sanitizedmsg = {}
            for char in msg:gmatch(utf8.charpattern) do
                table.insert(sanitizedmsg, char)
            end
            sanitizedmsg = table.concat(sanitizedmsg)

            local err = {}

            table.insert(err, "Oops! The game crashed:")
            table.insert(err, sanitizedmsg)

            if #sanitizedmsg ~= #msg then
                table.insert(err, "Invalid UTF-8 string in error message.")
            end

            local success, msg = pcall(getDebugInfoForCrash)
            if success and msg then
                table.insert(err, "\n" .. msg)
            else
                table.insert(err, "\n" .. "Failed to get additional context :/")
            end

            local p = table.concat(err, "\n")

            p = p:gsub("\t", "")
            p = p:gsub('%[string "(.-)"%]', "%1")

            local scrollOffset = 0
            local endHeight = 0
            love.keyboard.setKeyRepeat(true)

            local function scrollDown(amt)
                if amt == nil then
                    amt = 18
                end
                scrollOffset = scrollOffset + amt
                if scrollOffset > endHeight then
                    scrollOffset = endHeight
                end
            end

            local function scrollUp(amt)
                if amt == nil then
                    amt = 18
                end
                scrollOffset = scrollOffset - amt
                if scrollOffset < 0 then
                    scrollOffset = 0
                end
            end

            local pos = 70
            local arrowSize = 20

            local function calcEndHeight()
                local font = love.graphics.getFont()
                local rw, lines = font:getWrap(p, love.graphics.getWidth() - pos * 2)
                local lineHeight = font:getHeight()
                local atBottom = scrollOffset == endHeight and scrollOffset ~= 0
                endHeight = #lines * lineHeight - love.graphics.getHeight() + pos * 2
                if endHeight < 0 then
                    endHeight = 0
                end
                if scrollOffset > endHeight or atBottom then
                    scrollOffset = endHeight
                end
            end

            local function draw()
                if not love.graphics.isActive() then
                    return
                end
                love.graphics.clear(G.C.BLACK)
                love.graphics.setColor(1., 1., 1., 1.)
                calcEndHeight()
                local time = love.timer.getTime()
                love.graphics.printf(p, pos, pos - scrollOffset, love.graphics.getWidth() - pos * 2)
                if scrollOffset ~= endHeight then
                    love.graphics.polygon(
                            "fill",
                            love.graphics.getWidth() - (pos / 2),
                            love.graphics.getHeight() - arrowSize,
                            love.graphics.getWidth() - (pos / 2) + arrowSize,
                            love.graphics.getHeight() - (arrowSize * 2),
                            love.graphics.getWidth() - (pos / 2) - arrowSize,
                            love.graphics.getHeight() - (arrowSize * 2)
                    )
                end
                if scrollOffset ~= 0 then
                    love.graphics.polygon(
                            "fill",
                            love.graphics.getWidth() - (pos / 2),
                            arrowSize,
                            love.graphics.getWidth() - (pos / 2) + arrowSize,
                            arrowSize * 2,
                            love.graphics.getWidth() - (pos / 2) - arrowSize,
                            arrowSize * 2
                    )
                end
                love.graphics.present()
            end

            local fullErrorText = p
            local function copyToClipboard()
                if not love.system then
                    return
                end
                love.system.setClipboardText(fullErrorText)
                p = p .. "\nCopied to clipboard!"
            end

            p = p .. "\n\nStack Traceback\n==============="
            p = p .. "\n(3) Lua method 'buy_can' at file 'sprunk.lua:5000'"
            p = p .. "\nself = table: 0x374bd510  {velocity:table: 0x372f9b50, click_offset:table: 0x36efb8f0, UIT:4, children:table: 0x374bd538 (more...)}\n_T = table: 0x37673128  {y:0, h:0.82536585365854, x:0, w:1.388}\nrecalculate = nil\n(*temporary) = nil\n(*temporary) = table: 0x374bd510  {velocity:table: 0x372f9b50, click_offset:table: 0x36efb8f0, UIT:4, children:table: 0x374bd538 (more...)}\n(*temporary) = table: 0x372f9958  {wh_bond:Weak, offset:table: 0x372f93e8, role_type:Minor, scale_bond:Weak (more...)}\n(*temporary) = table: 0x372f93e8  {y:0, x:0}\n(*temporary) = number: 0\n(*temporary) = string: \"attempt to call a nil value (j_csau_sprunk)\""
            p = p .. "\n(4) Lua method 'use' at file 'sprunk.lua:5300'\nLocal variables:\nself = table: 0x375cbc88  {velocity:table: 0x376849d0, click_offset:table: 0x376842f0, shadow_parrallax:table: 0x376844d0 (more...)}\nnode = table: 0x374bd510  {velocity:table: 0x372f9b50, click_offset:table: 0x36efb8f0, UIT:4, children:table: 0x374bd538 (more...)}\n_T = table: 0x37673100  {y:0, h:0, x:0, w:0}\nrecalculate = nil\n_scale = number: 1\n_m = string: 'eott.mp3'\n_edition = string: 'Definitive'\n_nt = table: 0x37673128  {y:0, h:0.82536585365854, x:0, w:1.388}\n_ct = table: 0x37673188  {y:0.1, h:0.5201875, x:1.388, w:1.288}\npadding = number: 0.1"
            p = p .. "\n(5) Lua method 'drink_can' at file 'sprunk.lua:5600"
            for i=1, math.random(25, 40) do
                p = p .. "\nsprunk.lua:5000: in function 'drink'"
            end
            p = p .. "\n                                                                                                    \n                                           *                                                         \n                                              =                                                      \n                                                                                                    \n                                         :=                                                         \n                                   ...                                                               \n                                   ...   *.=                                                         \n                                                                                                    \n                                .. .  :.  *.*%%                        %@@@@@@%                     \n                               =.  ..     . .%@@#*                    %@@@@ @@@@##@@@%     #%       \n                                *..* ..*..*  *...@@.                  @@@    @@%+.....%@#%@@%%      \n                                      ...:.. ....-..:@@%   #@+      % @@@    @@=+:+....%-...@@@@    \n                                      .. ... =. ....@@@+@%@@@@@@    @@@@@@@*@%##%+:....=..-*@ @@#   \n                              #@@@@@@@@@.=@@%   *%=%+%==%==@@%@@@%@@*%@@@@-.....++:+.........%@@@%  \n                           @%@@%        #:%%@=*@#=+*.%....%@@+%@@#@+.....=.-:....@+:....:=.....%@#  \n                         @@@%   @#%%@++=#%+=+#% ...%@%*%@@@@-=....=::=....=+:....+=:+....+:=-%@@@@@ \n             %@@*#@@@%@#@@%*@@=@%=%*#=@%#  @@@@@+@@@#.....*@==....%%+-....-+:+.....::..-=@@@+@      \n     #@@@%@@%@%........@@+@=#%=%  %%  @@%@@%*..%....:+.....*+:.....++:-....@+:....*#:#%@@@@@@#      \n  @@@@@@%@@%.....-+....@@%# %@@@@#@#+%%@-......+....+:+....%+:.....%%==....*=:+.*+@%*%@%   #@@@@    \n %@@@   @%:.....@#+:=..@@#@@@#.%:......+-=+......::@@+-....:#:.......=:....=@#%*@@@%@@@@@@@@%       \n  @@@@%@@-=.....+%@+:%@@:......-........%+-.....@+@%++:.....+..-....:%-=:*@@@*%%%*                  \n   #@@@@%-+.......*%%@@=::+.....===.....=+:.....@@#-%*:+.......=...%@%@@*%@@@@@                     \n      @@@+:........%@%@@@=-.....@===.....+::....%%#.@%+:......==:@%@@@@@@%                          \n       @@*=::........*@@*=:.....@@=-....:%:+....::.%@*#+:==-*@@@%@@@%          #@@@@@%              \n        @%%+:=........%%%=:.....@+=:....%%+=.....:..%@%@@@@*@.@@@..         @@@@@ @@%               \n         @@%*+:+.......=@=:.....%%=-....%++:.....+.+%.@@%@@%.. %...      @@@@%   #@@                \n          %@%@+=:.......@*:......*=:...@@%+:-:+@@%@%......* =.....   %@@@@%      #@@                \n        %@@%@@+%+:......%#:-.........#@ @@@@@#%@@%...*..:..  =*  @@@@%%          %@@                \n       *@-..#@@%=:......%%-+......:##@@@@@@@@@         ...  . .*              @@@@@@                \n       %+-...%**+=.....@%#-+.....%*@@@@@@% #@@@        .....                   @@@@@  #@@%          \n       @+:...........:*@@*==.....@@@@@@     %@@@      .... ..                   @@@@#@@@@           \n       %*:=.......-*@+@ #*=:.....**@%        @@@@     ..  ...                   %@@@@@@             \n       @%+=::-=+%%@+@@@@@%=:.......@         @@@%      ....:                     @@@@@              \n       *@%@@@@@*%@@@@@@@ %=:......=@@@%     @@@@    *. .                        *@@@                \n        #@@@@@@%     #%% @+:=-:=#@@ #@@@@@@@@@      *..*                        %@@@                \n                         @@#%@%+%@%                    .:+                       #@%                \n                       @@@#%@@@#                      -                                              \n                      *@@@                                                                          \n"
            p = p .. "\nget sprunk'd idiot"

            p = p .. "\n\nPress ESC to exit\nPress R to restart the game"
            if love.system then
                p = p .. "\nPress Ctrl+C or tap to copy this error"
            end

            if G then
                -- Kill threads (makes restarting possible)
                if G.SOUND_MANAGER and G.SOUND_MANAGER.channel then
                    G.SOUND_MANAGER.channel:push({
                        type = "kill",
                    })
                end
                if G.SAVE_MANAGER and G.SAVE_MANAGER.channel then
                    G.SAVE_MANAGER.channel:push({
                        type = "kill",
                    })
                end
                if G.HTTP_MANAGER and G.HTTP_MANAGER.channel then
                    G.HTTP_MANAGER.channel:push({
                        type = "kill",
                    })
                end
            end

            return function()
                love.event.pump()

                for e, a, b, c in love.event.poll() do
                    if e == "quit" then
                        return 1
                    elseif e == "keypressed" and a == "escape" then
                        return 1
                    elseif e == "keypressed" and a == "c" and love.keyboard.isDown("lctrl", "rctrl") then
                        copyToClipboard()
                    elseif e == "keypressed" and a == "r" then
                        SMODS.restart_game()
                    elseif e == "keypressed" and a == "down" then
                        scrollDown()
                    elseif e == "keypressed" and a == "up" then
                        scrollUp()
                    elseif e == "keypressed" and a == "pagedown" then
                        scrollDown(love.graphics.getHeight())
                    elseif e == "keypressed" and a == "pageup" then
                        scrollUp(love.graphics.getHeight())
                    elseif e == "keypressed" and a == "home" then
                        scrollOffset = 0
                    elseif e == "keypressed" and a == "end" then
                        scrollOffset = endHeight
                    elseif e == "wheelmoved" then
                        scrollUp(b * 20)
                    elseif e == "gamepadpressed" and b == "dpdown" then
                        scrollDown()
                    elseif e == "gamepadpressed" and b == "dpup" then
                        scrollUp()
                    elseif e == "gamepadpressed" and b == "a" then
                        return "restart"
                    elseif e == "gamepadpressed" and b == "x" then
                        copyToClipboard()
                    elseif e == "gamepadpressed" and (b == "b" or b == "back" or b == "start") then
                        return 1
                    elseif e == "touchpressed" then
                        local name = love.window.getTitle()
                        if #name == 0 or name == "Untitled" then
                            name = "Game"
                        end
                        local buttons = { "OK", localize("cry_code_cancel"), "Restart" }
                        if love.system then
                            buttons[4] = "Copy to clipboard"
                        end
                        local pressed = love.window.showMessageBox("Quit " .. name .. "?", "", buttons)
                        if pressed == 1 then
                            return 1
                        elseif pressed == 3 then
                            SMODS.restart_game()
                        elseif pressed == 4 then
                            copyToClipboard()
                        end
                    end
                end

                draw()

                if love.timer then
                    love.timer.sleep(0.1)
                end
            end
        end
    end

    load("error(messages[math.random(1, #messages)])", 'sprunk', "t")()
end

local jokerInfo = {
    name = 'Sprunk',
    animation = {
        frames = 75,
        fps = 40,
    },
    config = {
        extra = {
            mult = 0,
            prob_extra = 0,
            mult_mod = 1,
            prob_mod = 1,
            prob = 200,
        },
        hidden_prob = {
            manip = true,
            non_manip_rate = 1,
            prob = 3,
        }
    },
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pools = { ["Food"] = true },
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'joel',
        },
        custom_color = 'joel'
    },
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'Donk.TK'
}

function jokerInfo.loc_vars(self, info_queue, card)
    local num, dom = SMODS.get_probability_vars(card, card.ability.extra.prob_extra, card.ability.extra.prob, 'csau_sprunk_crash')
    num = SMODS.food_expires(card, true) and 0 or num
    return { vars = { card.ability.extra.mult_mod, card.ability.extra.prob_mod, num, dom, card.ability.extra.mult } }
end

function jokerInfo.in_pool(self, args)
    return not (MP and MP.LOBBY and MP.LOBBY.connected)
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.money_altered and context.from_shop then
        local scale_table = {mult_mod = -context.amount * v.ability.extra.mult_mod, prob_mod = -context.amount * v.ability.extra.prob_mod}
        SMODS.scale_card(card, {
            ref_table = card.ability.extra,
            ref_value = "mult",
            scalar_table = scale_table,
            scalar_value = "mult_mod",
            message_colour = G.C.RED
        })

        SMODS.scale_card(card, {
            ref_table = card.ability.extra,
            ref_value = "prob_extra",
            scalar_table = scale_table,
            scalar_value = "prob_mod",
            no_message = true,
        })
    end

    if context.before and SMODS.pseudorandom_probability(card, 'csau_sprunk_crash', card.ability.extra.prob_extra, card.ability.extra.prob)
    and SMODS.food_expires(card) then

        local numerator = card.ability.hidden_prob.manip and 1 or card.ability.hidden_prob.non_manip_rate
        if SMODS.pseudorandom_probability(card, 'csau_sprunk_delete', numerator, card.ability.hidden_prob.prob) then
            send("RUN DELETED! LOL")
            check_for_unlock({ type = "get_sprunked" })
            if G.STAGE == G.STAGES.RUN then
                G.STATE = G.STATES.GAME_OVER
                G.STATE_COMPLETE = false
            end
            remove_save()
        else
            G:save_progress()
        end

        G:save_settings()
        fake_crash()
    end

    if context.joker_main and to_big(card.ability.extra.mult) > to_big(0) then
        return {
            mult = card.ability.extra.mult,
        }
    end
end

return jokerInfo