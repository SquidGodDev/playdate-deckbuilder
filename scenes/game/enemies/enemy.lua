INTENTS = {
    attack = 1,
    heal = 2
}

class('Enemy').extends(NobleSprite)

function Enemy:init(imagePath, health)
    Enemy.super.init(self)

    local enemyImagetable = Graphics.imagetable.new(imagePath)
    self.animationLoop = Graphics.animation.loop.new(200, enemyImagetable, true)

    self.health = health

    self.intent = INTENTS.attack
    self.intentValue = 10

    local _, spriteHeight = self:getSize()
    self.healthYOffset = (spriteHeight / 2) + 45
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

function Enemy:update()
    self:setImage(self.animationLoop:image())
    self:centerUI(self.heartSprite, self.healthText, self.healthYOffset)
    self:centerUI(self.intentSprite, self.intentText, self.intentYOffset)
end

function Enemy:setGameScene(gameScene)
    self.gameScene = gameScene
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
        self:attack(self.intentValue)
    elseif self.intent == INTENTS.heal then
        self.heal(self.intentValue)
    end
end

function Enemy:attack(amount)
    -- Attack animation
    self.gameScene:damagePlayer(amount)
end

function Enemy:damage(amount)
    self.health -= amount
    if self.health <= 0 then
        self.health = 0
        self:die()
    end
    self:updateHeartDisplay()
end

function Enemy:heal(amount)
    self.health += amount
    self:updateHeartDisplay()
end

function Enemy:die()
    self:remove()
end