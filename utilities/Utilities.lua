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
    sprite.imagetable = imagetable
    sprite.update = function(self)
        self.drawLoopCounter += 1
        if self.drawLoopCounter >= self.drawLoopDuration then
            self.drawLoopCounter = 1
            self.drawLoopIndex = (self.drawLoopIndex % #self.imagetable) + 1
        end
        self:setImage(self.imagetable[self.drawLoopIndex])
    end
    return sprite
end

function Utilities.animateSprite(sprite, imagetable)
    sprite:setImage(imagetable[1])
    local loopDuration = 5
    local animateTimer = playdate.frameTimer.new(loopDuration)
    animateTimer.repeats = true
    local repeatFrame = math.random(0, loopDuration)
    local imagetableIndex = math.random(1, #imagetable)
    animateTimer.updateCallback = function(timer)
        if timer.frame == repeatFrame then
            imagetableIndex = (imagetableIndex % #imagetable) + 1
            sprite:setImage(imagetable[imagetableIndex])
        end
    end
end

function Utilities.particle(x, y, imagetablePath, frameTime, repeats)
    local imagetable = Graphics.imagetable.new(imagetablePath)
    assert(imagetable)
    local particle = NobleSprite()
    particle:setImage(imagetable[1])
    particle:add(x, y)
    local animationLoop = Graphics.animation.loop.new(frameTime, imagetable, repeats)
    particle.update = function(self)
        self:setImage(animationLoop:image())
        if not animationLoop:isValid() then
            self:remove()
        end
    end
    return particle
end