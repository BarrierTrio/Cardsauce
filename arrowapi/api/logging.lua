ArrowAPI.logging = {
    --- Wrapper for SMODS debug mesage functions
    --- @param message string Message text
    --- @param level string | nil Debug level ('debug', 'info', 'warn')
    send = function(message, level)
        level = level or 'debug'
        if type(message) == 'table' then
            if level == 'debug' then sendDebugMessage(tprint(message))
            elseif level == 'info' then sendInfoMessage(tprint(message))
            elseif level == 'warn' then sendWarnMessage(tprint(message))
            elseif level == 'error' then sendErrorMessage(tprint(message)) end
        else
            if level == 'debug' then sendDebugMessage(message)
            elseif level == 'info' then sendInfoMessage(message)
            elseif level == 'warn' then sendWarnMessage(message)
            elseif level == 'error' then sendErrorMessage(message) end
        end
    end
}