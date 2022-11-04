require 'TimedActions/ISBaseTimedAction'

HemoPowderAction = ISBaseTimedAction:derive('HemoPowderAction')

function HemoPowderAction:isValid()
    if ISHealthPanel.DidPatientMove(self.character, self.otherPlayer, self.patientPositionX, self.patientPositionY) then
        return false
    end
    return self.character:getInventory():contains(self.item)
end

function HemoPowderAction:waitToStart()
    if self.character == self.otherPlayer then
        return false
    end
    self.character:faceThisObject(self.otherPlayer)
    return self.character:shouldBeTurning()
end

function HemoPowderAction:update()
    if self.character ~= self.otherPlayer then
        self.character:faceThisObject(self.otherPlayer)
    end
    self.item:setJobDelta(self:getJobDelta())
    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, self, "Apply hemostatic powder", nil)
end

function HemoPowderAction:start()
    self.item:setJobType("Apply hemostatic powder");
    self.item:setJobDelta(0.0);
    if self.character == self.otherPlayer then
        self:setActionAnim(CharacterActionAnims.Bandage);
        self:setAnimVariable("BandageType", ISHealthPanel.getBandageType(self.bodyPart));
        self.character:reportEvent("EventBandage");
    else
        self:setActionAnim('Loot')
        self.character:SetVariable('LootPosition', 'Mid')
        self.character:reportEvent("EventLootItem")
    end

    self:setOverrideHandModels(self.item, nil)
end

function HemoPowderAction:stop()
    self.item:setJobDelta(0.0)
    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
    ISBaseTimedAction.stop(self)
end

function HemoPowderAction:perform()
    ISBaseTimedAction.perform(self);
    self.item:setJobDelta(0.0);
    if self.character:HasTrait("Hemophobic") and self.bodyPart:getBleedingTime() > 0 then
        self.character:getStats():setPanic(self.character:getStats():getPanic() + 50);
    end
    self.character:getInventory():Remove(self.item);
    Survivor:getBodyPartByType(bodyPart):setBleeding(false)
    Survivor:getBodyPartByType(bodyPart):setBleedingTime(0)
    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
end

function HemoPowderAction:new(doctor, otherPlayer, item, bodyPart)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = doctor;
    o.otherPlayer = otherPlayer;
    o.doctorLevel = doctor:getPerkLevel(Perks.Doctor);
    o.item = item;
    o.bodyPart = bodyPart;
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.bandagedPlayerX = otherPlayer:getX();
    o.bandagedPlayerY = otherPlayer:getY();
    o.maxTime = 120 - (o.doctorLevel * 4);
    if doctor:isTimedActionInstant() then
        o.maxTime = 1;
    end
    if doctor:getAccessLevel() ~= "None" then
        o.doctorLevel = 10;
    end
    return o;
end