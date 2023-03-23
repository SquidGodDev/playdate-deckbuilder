class('Player').extends()

function Player:init(game, maxHealth, health, baseMana)
    self.game = game
    self.maxHealth = maxHealth
    self.health = health
    self.shield = 0
    self.baseMana = baseMana
    self.mana = self.baseMana
end


-- UI Methods
function Player:createUI()
    local UIBaseX, UIBaseY = 18, 18
    local textBaseX = UIBaseX + 24
    local UIGap = 36

    local heartImageTable = Graphics.imagetable.new("assets/images/ui/heart")
    self.heartSprite = Utilities.createAnimatedSprite(heartImageTable)
    self.heartSprite:add(UIBaseX, UIBaseY)
    self.healthText = NobleSprite()
    self.healthText:setCenter(0, 0.5)
    self.healthText:add(textBaseX, UIBaseY)
    self:updateHealthText()

    local shieldImageTable = Graphics.imagetable.new("assets/images/ui/shield")
    self.shieldSprite = Utilities.createAnimatedSprite(shieldImageTable)
    self.shieldSprite:add(UIBaseX, UIBaseY + UIGap)
    self.shieldText = NobleSprite()
    self.shieldText:setCenter(0, 0.5)
    self.shieldText:add(textBaseX, UIBaseY + UIGap)
    self:updateShieldText()

    local manaImageTable = Graphics.imagetable.new("assets/images/ui/mana")
    self.manaSprite = Utilities.createAnimatedSprite(manaImageTable)
    self.manaSprite:add(UIBaseX, UIBaseY + UIGap * 2)
    self.manaText = NobleSprite()
    self.manaText:setCenter(0, 0.5)
    self.manaText:add(textBaseX, UIBaseY + UIGap * 2)
    self:updateManaText()
end

function Player:updateHealthText()
    local healthTextImage = Graphics.imageWithText(self.health .. "/" .. self.maxHealth, 100)
    self.healthText:setImage(healthTextImage)
    self.healthText:setImageDrawMode(Graphics.kDrawModeFillWhite)
end

function Player:updateShieldText()
    local shieldTextImage = Graphics.imageWithText(tostring(self.shield), 100)
    self.shieldText:setImage(shieldTextImage)
    self.shieldText:setImageDrawMode(Graphics.kDrawModeFillWhite)
end

function Player:updateManaText()
    local manaTextImage = Graphics.imageWithText(self.mana .. "/" .. self.baseMana, 100)
    self.manaText:setImage(manaTextImage)
    self.manaText:setImageDrawMode(Graphics.kDrawModeFillWhite)
end

-- Player Methods
function Player:damage(amount)
    self.game:screenShake()
    local amountAfterShield = self:hitShield(amount)
    if amountAfterShield > 0 then
        self.heartSprite:setImageDrawMode(Graphics.kDrawModeFillWhite)
        Timer.performAfterDelay(100, function()
            self.heartSprite:setImageDrawMode(Graphics.kDrawModeCopy)
        end)
    end
    self.health -= amountAfterShield
    if self.health <= 0 then
        self.health = 0
        self:die()
    end
    self:updateHealthText()
end

function Player:heal(amount)
    self.health = math.min(self.health + amount, self.maxHealth)
    self:updateHealthText()
end

function Player:getMana()
    return self.mana
end

function Player:hasEnoughMana(cost)
    return self:getMana() >= cost
end

function Player:useMana(amount)
    self.mana = math.max(self.mana - amount, 0)
    self:updateManaText()
end

function Player:restoreMana(amount)
    self.mana += amount
    self:updateManaText()
end

function Player:resetMana()
    self.mana = self.baseMana
    self:updateManaText()
end

function Player:addShield(amount)
    self.shield += amount
    self:updateShieldText()
end

function Player:resetShield()
    self.shield = 0
    self:updateShieldText()
end

function Player:hitShield(amount)
    if self.shield > 0 then
        self.shieldSprite:setImageDrawMode(Graphics.kDrawModeFillWhite)
        Timer.performAfterDelay(100, function()
            self.shieldSprite:setImageDrawMode(Graphics.kDrawModeCopy)
        end)
    end
    local remainder = math.max(amount - self.shield, 0)
    self.shield = math.max(self.shield - amount, 0)
    self:updateShieldText()
    return remainder
end

function Player:die()
    
end