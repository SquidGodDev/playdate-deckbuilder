SIGNALS = {
    death = 1,
    play = 2,
    draw = 3,
    discard = 4,
    banish = 5
}

class('GameScene').extends(NobleScene)
GameScene.backgroundColor = Graphics.kColorBlack

function GameScene:init(playerMaxHealth, playerHealth, deck)
    -- Temp values
    playerMaxHealth = 20
    playerHealth = 20
    local cardList = {}
    for _, card in pairs(CARDS) do
        table.insert(cardList, card)
    end
    deck = {}
    for i=1,20 do
        local card = Card(cardList[math.random(#cardList)])
        deck[i] = card
    end

    GameScene.super.init(self)
    self.maxHealth = playerMaxHealth
    self.health = playerHealth
    self.shield = 0
    self.baseMana = 3
    self.mana = self.baseMana
    self.deck = Deck(deck)
end

function GameScene:enter()
	GameScene.super.enter(self)
    self.hand = Hand(self.deck)
    self:createUI()
end

-- UI Methods
function GameScene:createUI()
    local UIBaseX, UIBaseY = 18, 18
    local textBaseX = UIBaseX + 24
    local UIGap = 36

    local heartImageTable = Graphics.imagetable.new("assets/images/ui/heart")
    local heartSprite = Utilities.createAnimatedSprite(heartImageTable)
    heartSprite:add(UIBaseX, UIBaseY)
    self.healthText = NobleSprite()
    self.healthText:setCenter(0, 0.5)
    self.healthText:add(textBaseX, UIBaseY)
    self:updateHealthText()

    local shieldImageTable = Graphics.imagetable.new("assets/images/ui/shield")
    local shieldSprite = Utilities.createAnimatedSprite(shieldImageTable)
    shieldSprite:add(UIBaseX, UIBaseY + UIGap)
    self.shieldText = NobleSprite()
    self.shieldText:setCenter(0, 0.5)
    self.shieldText:add(textBaseX, UIBaseY + UIGap)
    self:updateShieldText()

    local manaImageTable = Graphics.imagetable.new("assets/images/ui/mana")
    local manaSprite = Utilities.createAnimatedSprite(manaImageTable)
    manaSprite:add(UIBaseX, UIBaseY + UIGap * 2)
    self.manaText = NobleSprite()
    self.manaText:setCenter(0, 0.5)
    self.manaText:add(textBaseX, UIBaseY + UIGap * 2)
    self:updateManaText()
end

function GameScene:updateHealthText()
    local healthTextImage = Graphics.imageWithText(self.health .. "/" .. self.maxHealth, 100)
    self.healthText:setImage(healthTextImage)
    self.healthText:setImageDrawMode(Graphics.kDrawModeFillWhite)
end

function GameScene:updateShieldText()
    local shieldTextImage = Graphics.imageWithText(tostring(self.shield), 100)
    self.shieldText:setImage(shieldTextImage)
    self.shieldText:setImageDrawMode(Graphics.kDrawModeFillWhite)
end

function GameScene:updateManaText()
    local manaTextImage = Graphics.imageWithText(self.mana .. "/" .. self.baseMana, 100)
    self.manaText:setImage(manaTextImage)
    self.manaText:setImageDrawMode(Graphics.kDrawModeFillWhite)
end

-- Player Methods
function GameScene:damagePlayer(amount)
    local amountAfterShield = self:hitShield(amount)
    self.playerHealth -= amountAfterShield
    if self.playerHealth <= 0 then
        self.playerHealth = 0
        self:die()
    end
    self:updateHealthText()
end

function GameScene:healPlayer(amount)
    self.playerHealth = math.min(self.playerHealth + amount, self.playerMaxHealth)
    self:updateHealthText()
end

function GameScene:useMana(amount)
    self.mana = math.max(self.mana - amount, 0)
    self:updateManaText()
end

function GameScene:restoreMana(amount)
    self.mana += amount
    self:updateManaText()
end

function GameScene:resetMana()
    self.mana = self.baseMana
    self:updateManaText()
end

function GameScene:addShield(amount)
    self.shield += amount
    self:updateShieldText()
end

function GameScene:resetShield()
    self.shield = 0
    self:updateShieldText()
end

function GameScene:hitShield(amount)
    local remainder = math.max(amount - self.shield, 0)
    self.shield = math.max(self.shield - amount, 0)
    self:updateShieldText()
    return remainder
end

function GameScene:die()
    -- Die
end

function GameScene:update()
	GameScene.super.update(self)
    if playdate.buttonJustPressed(playdate.kButtonB) then
        self.hand:drawCard()
    elseif playdate.buttonJustPressed(playdate.kButtonA) then
        self.hand:playCard()
    end

    if playdate.buttonJustPressed(playdate.kButtonLeft) then
        self.hand:selectCardLeft()
    elseif playdate.buttonJustPressed(playdate.kButtonRight) then
        self.hand:selectCardRight()
    end
end
