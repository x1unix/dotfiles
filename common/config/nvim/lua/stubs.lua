local M = {}

--- @alias LazyPlugin { [1]: string, config: fun(...), opts?: table | nil, dependencies?: table<LazyPlugin> | nil }

--- @param plug LazyPlugin
local function call_plug_config(plug)
    if type(plug.dependencies) == 'table' then
        for _, plugin in ipairs(plug.dependencies) do
            -- Dependencies may contain 'config' as well.
            call_plug_config(plugin)
        end
    end

    local opts = nil
    if type(plug.opts) == 'function' then
        plug.opts(nil, {})
    elseif plug.opts ~= nil then
        opts = plug.opts 
    end
    
    if type(plug.config) == 'function' then
        plug.config(opts)
    end
end

--- Stub to load plugins declared in lazy.nvim table format.
---
--- This funciton doesn't load or resolve any dependencies. Goal of a function
--- is to help migrating to lazy.nvim package manager.
---
--- @param modpath string The string path to the module to be required (e.g.,
--- 'my.plugins').
M.lazy_require = function(modpath)
    local plugs = require(modpath)
    for _, plugin in ipairs(plugs) do
        call_plug_config(plugin)
    end
end

return M
