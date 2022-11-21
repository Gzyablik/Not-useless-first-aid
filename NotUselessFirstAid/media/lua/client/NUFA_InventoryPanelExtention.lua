--[[
NUFA_InventoryPanelExtention = {}
NUFA_InventoryPanelExtention.maxItems = 20

NUFA_InventoryPanelExtention.init = function(specificPlayer, context, items, test)
    if test and ISWorldObjectContextMenu.Test then
        return false
    end
    local player = getSpecificPlayer(specificPlayer)
    local clickedItems = items

    if #clickedItems > 1 then
        return false
    end
    for _, item in ipairs(clickedItems) do
        if not instanceof(item, 'InventoryItem') then
            item = item.items[2]
        end
        if instanceof(item, 'InventoryItem') then
            NUFA_InventoryPanelExtention.createMenu(player, context, item)
        end
    end
end

NUFA_InventoryPanelExtention.createMenu = function(player, context, item)
    local handlers = {}

    for _, handler in pairs(ContainerRegister:getContainer():getByTag('nufa.healthpanel')) do
        table.insert(handlers, handler:getInstance():new(self, bodyPart))
    end

    for _, handler in ipairs(handlers) do
        if handler:supports(item, player) then
            local option = context:addOption(handler:getActionTitle(), nil)
            local subMenu = context:getNew(context)
            context:addSubMenu(option, subMenu)
            handler:addSubMenu(subMenu, player, item)
        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(NUFA_InventoryPanelExtention.init)]]
