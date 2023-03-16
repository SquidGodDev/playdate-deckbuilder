-- Put your utilities and other helper functions here.
-- The "Utilities" table is already defined in "noble/Utilities.lua."
-- Try to avoid name collisions.

function Utilities.getZero()
	return 0
end

function Utilities.createAnimatedSprite(imagetable)
    local sprite = NobleSprite()
    local loopDuration = 6
    sprite.drawLoopCounter = math.random(0, loopDuration - 1)
    sprite.drawLoopDuration = loopDuration
    sprite.drawLoopIndex = 1
    sprite.update = function(self)
        self.drawLoopCounter += 1
        if self.drawLoopCounter >= self.drawLoopDuration then
            self.drawLoopCounter = 1
            self.drawLoopIndex = (self.drawLoopIndex % #imagetable) + 1
        end
        self:setImage(imagetable[self.drawLoopIndex])
    end
    return sprite
end