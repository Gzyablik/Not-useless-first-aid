require 'TimedActions/ISBaseTimedAction'

HemoPowderAction = {}
HemoPowderAction = ISBaseTimedAction:derive('HemoPowderAction')

function HemoPowderAction:isValid()
    if ISHealthPanel.DidPatientMove(self.character, self.otherPlayer, self.bandagedPlayerX, self.bandagedPlayerY) then
        return false
    end
    if self.item then
        return self.character:getInventory():contains(self.item);
    else
        if not self.bodyPart:bandaged() then return false end
        return true
    end
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
    if self.item then
        self.item:setJobDelta(self:getJobDelta());
    end
    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, self, "Apply hemostatic powder", nil)
end

function HemoPowderAction:start()
    if self.character == self.otherPlayer then
        self:setActionAnim(CharacterActionAnims.Bandage);
        self:setAnimVariable("BandageType", ISHealthPanel.getBandageType(self.bodyPart));
    else
        self:setActionAnim('Loot')
        self.character:SetVariable('LootPosition', 'Mid')
    end
    self:setOverrideHandModels(nil, nil)
end

function HemoPowderAction:stop()
    ISHealthPanel.setBodyPartActionForPlayer(self.otherPlayer, self.bodyPart, nil, nil, nil)
    ISBaseTimedAction.stop(self)
    if self.item then
        self.item:setJobDelta(0.0);
    end
end

function HemoPowderAction:perform()
    ISBaseTimedAction.perform(self);
    if self.item then
        self.item:setJobDelta(0.0);
        self.character:getInventory():Remove(self.item);
    end
    self.bodyPart:setBleeding(false)
    self.bodyPart:setBleedingTime(0)
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