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
    GameScene.super.init(self)
    self.playerMaxHealth = playerMaxHealth
    self.playerHealth = playerHealth
    self.deck = Deck(deck)
end

function GameScene:enter()
	GameScene.super.enter(self)
    self.hand = Hand(self.deck)
    self:createUI()
end

function GameScene:createUI()
    local UIBaseX, UIBaseY = 18, 18
    local UIGap = 36

    local heartImageTable = Graphics.imagetable.new("assets/images/ui/heart")
    local heartSprite = Utilities.createAnimatedSprite(heartImageTable)
    heartSprite:add(UIBaseX, UIBaseY)

    local shieldImageTable = Graphics.imagetable.new("assets/images/ui/shield")
    local shieldSprite = Utilities.createAnimatedSprite(shieldImageTable)
    shieldSprite:add(UIBaseX, UIBaseY + UIGap)

    local manaImageTable = Graphics.imagetable.new("assets/images/ui/mana")
    local manaSprite = Utilities.createAnimatedSprite(manaImageTable)
    manaSprite:add(UIBaseX, UIBaseY + UIGap * 2)
end

-- Player Methods
function GameScene:damagePlayer(amount)
    self.playerHealth -= amount
    if self.playerHealth <= 0 then
        self:die()
    end
end

function GameScene:healPlayer(amount)
    self.playerHealth += amount
    if self.playerHealth > self.playerMaxHealth then
        self.playerHealth = self.playerMaxHealth
    end
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
