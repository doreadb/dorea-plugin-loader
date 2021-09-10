Manager = {}

Manager.plugins = {}
Manager.tables = {}
Manager.timer = {}

function Manager.load(name, option)
    Manager.plugins[name] = option
end

function Manager.require(addr)

    local tables = {}

    for key, val in pairs(Manager.plugins) do

        local temp = dofile("./plugin/" .. key .. "/init.lua")

        temp.db.addr = addr
        temp.db.password = val["token"]

        tables[key] = temp

        Manager.timer[key] = 0

    end

    Manager.tables = tables

end

function Manager.call_onload()

    local result = {}

    for key, val in pairs(Manager.tables) do
        result[key] = val.func.plugin_onload()
    end

    return result
end

function Manager.call_unload()

    local result = {}

    for key, val in pairs(Manager.tables) do
        result[key] = val.func.plugin_unload()
    end

    return result
end

function Manager.call_interval()

    local result = {}

    for key, val in pairs(Manager.tables) do

        if Manager.timer[key] >= val.setting.interval then
            Manager.timer[key] = 0
            result[key] = val.func.plugin_interval()
        else
            Manager.timer[key] = Manager.timer[key] + 1
        end


    end

    return result
end

return Manager