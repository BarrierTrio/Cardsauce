
ArrowAPI.table = {
    --- Table extension, finds a value in a table
    --- @param table table table to traverse for element
    --- @param element any value to find in the table
    --- @return boolean # true if this table contains this element paired with any key
    contains = function(table, element)
        for _, value in pairs(table) do
            if value == element then
                return true
            end
        end
        return false
    end,

    clear = function(t)
        for k in pairs(t) do
            t[k] = nil
        end
    end,

    --- Recursively modifies number values in a table given a multipliative mod, or a reset table and comparator conditions to reset from.
    --- If no parameters but a table are provided, the function returns a deep copy of all non-object values
    --- @param table table A table to modify.
    --- @param mod number | nil A modifier value (such as 0.5 or 2). Default is 1
    --- @param reset_table table | nil Table to reset directly comparable values from based on comparator
    --- @param compare string | nil A comparator to determine when to reset ('pos', 'neg', or 'dif', default is 'neg')
    --- @return table # A modified copy of the given table
    recursive_mod = function(table, mod, reset_table, compare)
        local val_type = type(table)
        local mod_copy = nil
        if val_type ~= 'table' then
            -- modify number values
            if val_type == 'number' and (not reset_table or type(reset_table) == 'number') then
                -- default value
                mod_copy = table * (mod or 1)

                if not compare then
                    compare = 'neg'
                end

                -- reset if a reset table is provided
                if reset_table and ((compare == 'neg' and table < reset_table)
                or (compare == 'pos' and table > reset_table)
                or (compare == 'dif' and table ~= reset_table)) then
                    mod_copy = reset_table
                end

                return mod_copy
            end

            -- weird scenarios with a table mismatch
            return table
        end

        -- recursive to arbitrary depth
        mod_copy = {}
        for k, v in next, table, nil do
            if (k == 'order' and type(v) == 'number') or (type(v) == 'table' and v.is and (v:is(Card) or v:is(Cardarea))) then
                -- don't copy certain values
                mod_copy[k] = v
            else
                if mod and mod ~= 1 and type(v) == 'number' and (k == 'x_mult' or k == 'Xmult' or k == 'x_chips' or k == 'Xchips') then
                    if v == 1 then
                        mod_copy[k] = math.max(0, ArrowAPI.table.recursive_mod(0, mod, reset_table and reset_table[k] or nil, compare))
                    else
                        mod_copy[k] = math.max(0, ArrowAPI.table.recursive_mod(v - 1, mod, reset_table and reset_table[k] or nil, compare))
                    end
                else
                    mod_copy[k] = ArrowAPI.table.recursive_mod(v, mod, reset_table and reset_table[k] or nil, compare)
                end

            end
        end

        return mod_copy
    end,


    --- Deep compares the values of tables, rather than their memory IDs
    --- Object tables are still compared by ID to prevent recursive nesting
    --- @param tbl1 table First table
    --- @param tbl2 table Second table
    --- @return boolean # If every key and value on the table is identical
    deep_compare = function(tbl1, tbl2)
        if type(tbl1) == "table" and type(tbl2) == "table" then
            -- don't do a nested compare for objects, just compare the reference IDs
            if (tbl1.is and tlb1:is(Object)) or (tbl2.is and tbl2:is(Object)) then
                return tbl1 == tbl2
            end

            for k, v in pairs(tbl1) do
                -- avoid the type call for missing keys in tbl2 by directly comparing with nil
                if tbl2[k] == nil then
                    return false
                elseif v ~= tbl2[k] then
                    if type(v) == "table" and type(tbl2[k]) == "table" then
                        return ArrowAPI.table.deep_compare(v, tbl2[k])
                    else
                        return v == tbl2[k]
                    end
                end
            end

            -- check for missing keys in tbl1
            for k, _ in pairs(tbl2) do
                if tbl1[k] == nil then
                    return false
                end
            end

            -- this means both tables are empty, which are functionally equal
            return true
        end

        -- direct comparison after all other checks
        return tbl1 == tbl2
    end,

    --- Parses a multi-entry string table as a single-line, human readable string
    --- @param tbl table Array table of strings
    --- @param sep string | nil String separator between entries. Default is a single space
    --- @return string # Single-line return string
    to_string = function(tbl, sep)
        local result = {}
        for _, line in ipairs(tbl) do
            local cleanedLine = line:gsub("{.-}", "")
            table.insert(result, cleanedLine)
        end
        return table.concat(result, (sep or " "))
    end
}