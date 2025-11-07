
-- string data helper functions
ArrowAPI.string = { 
    --- Checks if a string starts with a specified substring
    --- @param str string String to check
    --- @param start string Substring to search for within str
    --- @return boolean # If the string starts with the substring
    starts_with = function(str, start)
        return string.sub(str, 1, #start) == start
    end,

    --- Checks if a string ends with a specified substring
    --- @param str string String to check
    --- @param ending string Substring to search for within str
    --- @return boolean # If the string end with the substring
    ends_with = function(str, ending)
        return string.sub(str, -#ending) == ending
    end,

    --- Finds a substring within a given string, not case sensitive
    --- @param str string String to check
    --- @param substring string Substring to search for within str
    --- @return boolean # If the substring is found anywhere within str
    contains = function(str, substring)
        local lowerStr = string.lower(str)
        local lowerSubstring = string.lower(substring)
        return string.find(lowerStr, lowerSubstring, 1, true) ~= nil
    end,

    --- Formats a numeral for display. Numerals between 0 and 1 are written out fully
    --- @param n number Numeral to format
    --- @param number_type string | nil Type of display number ('number', 'order')
    --- @param caps_style string | nil Style of capitalization ('lower', 'upper', 'first')
    format_number = function(n, number_type, caps_style)
        number_type = number_type or 'number'
        local dict = {
            [0] = {number = 'zero', order = 'zeroth'},
            [1] = {number = 'one', order = 'first'},
            [2] = {number = 'two', order = 'second'},
            [3] = {number = 'three', order = 'third'},
            [4] = {number = 'four', order = 'fourth'},
            [5] = {number = 'five', order = 'fifth'},
            [6] = {number = 'six', order = 'sixth'},
            [7] = {number = 'seven', order = 'seventh'},
            [8] = {number = 'eight', order = 'eighth'},
            [9] = {number = 'nine', order = 'ninth'},
            [10] = {number = 'ten', order = 'tenth'},
            [11] = {number = '11', order = '11th'},
            [12] = {number = '12', order = '12th'},
        }
        if n < 0 or n > #dict then
            if number_type == 'number' then return n end

            local ret = ''
            local mod = n % 10
            if mod == 1 then
                ret = n..'st'
            elseif mod == 2 then
                ret = n..'nd'
            elseif mod == 3 then
                ret = n..'rd'
            else
                ret = n..'th'
            end
            return ret
        end

        local ret = dict[n][number_type]
        local style = caps_style and string.lower(caps_style) or 'lower'
        if style == 'upper' then
            ret = string.upper(ret)
        elseif n < 11 and style == 'first' then
            ret = ret:gsub("^%l", string.upper)
        end

        return ret
    end,

    --- Formats an integer count for grammatically correct display (once, twice, 3 times, etc)
    --- @param value number integer to format
    --- @param caps_style string | nil Style of capitalization ('lower', 'upper', 'first')
    count_grammar = function(value, caps_style, spell_numeral)
        caps_style = caps_style and string.lower(caps_style) or 'lower'
        local ret = ''
        if value == 1 then
            ret = 'once'
        elseif value == 2 then
            ret = 'twice'
        else
            ret = 'times'
        end

        if caps_style == 'first' then
            ret = (ret:gsub("^%l", string.upper))
        elseif caps_style == 'upper' then
            ret = string.upper(ret)
        end
        
        if value > 2 then
            local val = value
            if spell_numeral then
                val = ArrowAPI.string.format_number(value)
                if caps_style == 'first' then
                    ret = string.lower(ret)
                    val = val:gsub("^%l", string.upper)
                end
            end
            ret = val..' '..ret
        end
        
        return ret
    end,
}