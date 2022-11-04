HemoPowderAction = ISBaseTimedAction:derive('HemoPowderAction')

function HemoPowderAction:addToMenu(context)
    if self.bodyPart:bleeding() and self.bodyPart:getBleedingTime() > 0 then
        context:addOption(getText("Apply hemostatic powder"), self, self.onMenuOptionSelected)
    end
end

function HApplyPlantain:new(panel, bodyPart)
    return HApplyPoultice.new(self, panel, bodyPart, "HemoPowderAction", "Apply hemostatic powder", HemoPowderAction)
end