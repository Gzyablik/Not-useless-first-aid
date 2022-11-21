HemoPowderPanel = {}
local NUFA_BaseHandler = require('NUFA_BaseHandler'):new()
HemoPowderPanel = NUFA_BaseHandler:derive("HemoPowderPanel")

function HemoPowderPanel:new(panel, bodyPart)
    local o = NUFA_BaseHandler.new(self, panel, bodyPart)
    o.items.ITEMS = {}
    return o
end

function HemoPowderPanel:checkItem(item)
    if item:getDisplayName() == "Hemostatic powder" then
        table.insert(self.items.ITEMS, item)
    end
end

function HemoPowderPanel:addToMenu(context)
    if not self.bodyPart:bleeding() or self.bodyPart:getBleedingTime() == 0 or #self.items.ITEMS==0 then
        return false
    end
        context:addOption("Apply hemostatic powder", self, self.onMenuOptionSelected, "Hemostatic powder")
end

function HemoPowderPanel:dropItems(items)
    local types = self:getAllItemTypes(items)
    if #self.items.ITEMS > 0 and #types == 1 and self:isInjured() then
        self:onMenuOptionSelected(types[1])
        return true
    end
    return false
end


function HemoPowderPanel:isValid(itemType)
    self:checkItems()
   return #self.items.ITEMS>0
end

function HemoPowderPanel:perform(previousAction, itemType)
    previousAction = self:toPlayerInventory(self.items.ITEMS[1], previousAction)
    local action = HemoPowderAction:new(self:getDoctor(), self:getPatient(), self.items.ITEMS[1], self.bodyPart)
    ISTimedActionQueue.add(action)
end

ContainerRegister:getContainer():register(
        require 'Before/HandlerDecorator',
        'nufa.healthpanel.hemostatic',
        {
            HemoPowderPanel
        },
        'nufa.healthpanel'
)