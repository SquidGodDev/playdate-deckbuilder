INTENTS = {
    attack = 1,
    heal = 2
}

local lerp <const> = function(a, b, t)
    return a * (1-t) + b * t
end

class('Enemy').extends(NobleSprite)

function Enemy:init(game, imagePath, health)
    Enemy.super.init(self)

    self.game = game
    local enemyImagetable = Graphics.imagetable.new(imagePath)
    Utilities.animateSprite(self, enemyImagetable)

    self.health = health

    self.intent = INTENTS.attack
    self.intentValue = 5

    local _, spriteHeight = self:getSize()
    self.healthYOffset = (spriteHeight / 2) + 10
    self.intentYOffset = -self.healthYOffset

    local heartImageTable = Graphics.imagetable.new("assets/images/enemies/smallHeart")
    self.heartSprite = Utilities.createAnimatedSprite(heartImageTable)
    self.heartSprite:setCenter(0, 0.5)
    self.heartSprite:add()

    self.healthText = NobleSprite()
    self.healthText:setCenter(0, 0.5)
    self.healthText:add()

    self.swordImageTable = Graphics.imagetable.new("assets/images/enemies/smallSword")
    self.plusImageTable = Graphics.imagetable.new("assets/images/enemies/plus")
    self.intentSprite = Utilities.createAnimatedSprite(self.swordImageTable)
    self.intentSprite:setCenter(0, 0.5)
    self.intentSprite:add()

    self.intentText = NobleSprite()
    self.intentText:setCenter(0, 0.5)
    self.intentText:add()

    self:updateHeartDisplay()
    self:updateIntentDisplay()

    self.lerpSpeed = 0.2
    self.animating = false

    self.animator = nil
end

function Enemy:centerUI(icon, text, yOffset)
    if not icon or not text then
        return
    end
    local padding = 10
    local iconWidth = icon:getSize()
    local textWidth = text:getSize()
    local iconX = self.x - (iconWidth + padding + textWidth) / 2
    local textX = iconX + iconWidth + padding
    icon:moveTo(iconX, self.y + yOffset)
    text:moveTo(textX, self.y + yOffset)
end

function Enemy:lerpTo(x, y)
    if not self.animator then
        local enemyX = lerp(self.x, x, self.lerpSpeed)
        local enemyY = lerp(self.y, y, self.lerpSpeed)
        self:moveTo(enemyX, enemyY)
    end
end

function Enemy:update()
    self:centerUI(self.heartSprite, self.healthText, self.healthYOffset)
    self:centerUI(self.intentSprite, self.intentText, self.intentYOffset)
    if self.animator then
        local point = self.animator:currentValue()
        self:moveTo(point.x, point.y)
        if self.animator:ended() then
            self.animator = nil
        end
    end
end

function Enemy:updateHeartDisplay()
    local textImage = Graphics.imageWithText(tostring(self.health), 100)
    self.healthText:setImage(textImage)
    self.healthText:setImageDrawMode(Graphics.kDrawModeFillWhite)
end

function Enemy:updateIntentDisplay()
    if self.intent == INTENTS.attack then
        self.intentSprite.imagetable = self.swordImageTable
    elseif self.intent == INTENTS.heal then
        self.intentSprite.imagetable = self.plusImageTable
    end
    local textImage = Graphics.imageWithText(tostring(self.intentValue), 100)
    self.intentText:setImage(textImage)
    self.intentText:setImageDrawMode(Graphics.kDrawModeFillWhite)
end

function Enemy:setIntent()
    -- Override with subclass
end

function Enemy:act()
    if self.intent == INTENTS.attack then
        return self:attack(self.intentValue)
    elseif self.intent == INTENTS.heal then
        return self:heal(self.intentValue)
    end
end

function Enemy:attack(amount)
    -- Attack animation
    local anim1Time, anim2Time = 200, 100
    local attackAnimationTime = anim1Time + anim2Time
    local attackLine1 = Geometry.lineSegment.new(self.x, self.y, self.x, self.y - 20)
    local attackLine2 = Geometry.lineSegment.new(self.x, self.y, self.x - 20, self.y + 10)
    self.animator = Graphics.animator.new({anim1Time, anim2Time}, {attackLine1, attackLine2}, {Ease.linear, Ease.linear})
    Timer.performAfterDelay(attackAnimationTime, function()
        self.game.player:damage(amount)
    end)
    return attackAnimationTime
end

function Enemy:damage(amount)
    self.health -= amount
    if self.health <= 0 then
        self.health = 0
        self:die()
        return true
    end
    self:updateHeartDisplay()
    self:setImageDrawMode(Graphics.kDrawModeFillWhite)
    Timer.performAfterDelay(100, function()
        self:setImageDrawMode(Graphics.kDrawModeCopy)
    end)

    local hitLine = Geometry.lineSegment.new(self.x, self.y, self.x + 10, self.y - 10)
    self.animator = Graphics.animator.new(100, hitLine)
    return false
end

function Enemy:heal(amount)
    local healTime = 100
    self.health += amount
    self:updateHeartDisplay()
    return healTime
end

function Enemy:die()
    self.intentSprite:remove()
    self.intentText:remove()
    self.heartSprite:remove()
    self.healthText:remove()

    local animateOutTime = 700
    local animateOutLine = Geometry.lineSegment.new(self.x, self.y, self.x, 300)
    self.animator = Graphics.animator.new(animateOutTime, animateOutLine, Ease.inBack)
    Timer.performAfterDelay(animateOutTime, function()
        self:remove()
    end)
end