Container = {}

function Container:new()
    local public = {}
    local private = {}

    private.services = {}
    private.taggedServices = {}

    setmetatable(public, self)
    self.__index = self
    self.__metatable = 'Container'

    function public:register(module, alias, arguments, tag)
        if private.services[alias] == nil then
            local service = require 'Before/Module'

            private.services[alias] = service:new(module:new(unpack(arguments)))

            if tag ~= nil then
                if private.taggedServices[tag] == nil then
                    private.taggedServices[tag] = {}
                end

                private.taggedServices[tag][alias] = private.services[alias].instance
            end
        end
    end

    function public:get(alias)
        if private.services[alias] ~= nil then
            return private.services[alias].instance
        end

        return nil
    end

    function public:getByTag(tag)
        if private.taggedServices[tag] ~= nil then
            return private.taggedServices[tag]
        end

        return nil
    end

    return public
end

return Container