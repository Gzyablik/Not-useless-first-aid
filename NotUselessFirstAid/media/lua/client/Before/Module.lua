Module = {}

function Module:new(module)
    local public = {}

    public.name = getmetatable(module)
    public.instance = module

    setmetatable(public, self)
    self.__index = self
    self.__metatable = 'Module'

    return public
end

return Module