--- Custom math functions used by ArrowAPI
ArrowAPI.math = {
    --- Creates a hashed number based on a string input, primarily for shaders
    hash_string = function(input)
        local hash = 5381  -- Seed value
        for i = 1, #input do
            local char = string.byte(input, i)
            hash = ((hash * 32) + hash + char) % 2^15  -- Wrap to 16-bit integer
        end
        return hash
    end,

    --- A collection of easing functions
    ease_funcs = {
        --- x^4 easing function both in and out
        --- @param x number Value to ease (between 0 and 1)
        --- @return number # Eased value between 0 and 1
        in_out_quart = function(x)
            return x < 0.5 and (8 * x^4) or 1 - (-2 * x + 2)^4 / 2;
        end,

        --- sin ease out function
        --- @param x number Value to ease (between 0 and 1)
        --- @return number # Eased value between 0 and 1
        out_quint = function(x)
            return 1 - (1-x)^5;
        end,

        --- x^4 easing function in
        --- @param x number Value to ease (between 0 and 1)
        --- @return number # Eased value between 0 and 1
        in_cubic = function(x)
            return x ^ 3
        end,

        --- Sine Wave easing function both in and out
        --- @param x string Value to ease (between 0 and 1)
        --- @return number # Eased value between 0 and 1
        in_out_sin = function(x)
            return -(math.cos(math.pi * x) - 1) / 2
        end,
    },

    --- Linear interpolation of a to b, given time t
    --- @param a number Value to lerp from
    --- @param b number Value to lerp to
    --- @param t number Lerp/time variable, between 0 and 1
    --- @return number # Interpolated value between a and b
    lerp = function(a,b,t)
        return (1-t)*a + t*b
    end,

    --- Factorial of non-negative integer
    --- @param n integer
    --- @return number # Factorial of n
    fact = function(n)
        if n <= 0 then
        return 1
        else
        return n * ArrowAPI.math.fact(n-1)
        end
    end
}
