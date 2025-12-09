JojobalMod = SMODS.current_mod

local includes = {
	-- object hooks
	'hooks/card',
	'hooks/misc_functions',
	'hooks/smods',

	'ui',
	'items',
}

for _, module in ipairs(includes) do
	local init, error = NFS.load(SMODS.current_mod.path .. "jojobal/includes/" .. module ..".lua")
	if error then sendErrorMessage("[Stands] Failed to load "..module.." with error "..error) else
		init()
		sendDebugMessage("[Stands] Loaded module: " .. module)
	end
end