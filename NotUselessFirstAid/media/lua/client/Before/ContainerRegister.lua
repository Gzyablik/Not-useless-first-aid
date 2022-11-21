ContainerRegister = {}

function ContainerRegister:new()
    local public = {}
    local private = {}

    private.container = require('Before/Container'):new()

    function public:getContainer()
        return private.container
    end

    setmetatable(public, self)
    self.__index = self
    self.__metatable = 'ContainerRegister'

    return public
    end

ContainerRegister = ContainerRegister:new()

Events.OnGameBoot.Add(
        function()
            local container = ContainerRegister:getContainer()
        end
)
