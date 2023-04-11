SIGNALS = {
    death = 1,
    play = 2,
    draw = 3,
    discard = 4,
    banish = 5
}

GAME_STATE = {
    selectingCard = 1,
    expandedCard = 2,
    singleTargetSelection = 3,
    enemyAction = 4,
    enemiesDefeated = 5
}

GAME_Z_INDEXES = {
    cardInspector = 500
}

class('GameScene').extends(NobleScene)
GameScene.backgroundColor = Graphics.kColorBlack

function GameScene:init()
    GameScene.super.init(self)
end

function GameScene:enter()
	GameScene.super.enter(self)

    local playerMaxHealth = Noble.GameData.get("playerMaxHealth")
    local playerHealth = Noble.GameData.get("playerHealth")
    local deck = Noble.GameData.get("deck")

    -- Init
    self.deck = Deck(deck)
    self.player = Player(self, playerMaxHealth, playerHealth, 3)

    self.state = GAME_STATE.selectingCard

    self.screenShakeTimer = nil

    self.hand = Hand(self.deck, self)
    self.player:createUI()
    self.enemyManager = EnemyManager(self)
    self.reticle = Reticle(self, self.enemyManager)
    self:switchToPlayerTurn()
end

-- State transitions
function GameScene:switchToTargetSelection()
    self.state = GAME_STATE.singleTargetSelection
    self.reticle:animateIn()
end

function GameScene:switchToPlayerTurn()
    self.state = GAME_STATE.selectingCard
    self.enemyManager:updateIntents()
    self.hand:drawHand()
    self.player:resetMana()
    self.player:resetShield()
end

function GameScene:switchToEnemyTurn()
    self.state = GAME_STATE.enemyAction
    self.hand:discardHand()
    self.enemyManager:enemyTurn()
end

function GameScene:enemiesDefeated()
    self.state = GAME_STATE.enemiesDefeated
    self.hand:disable()
    Noble.GameData.set("playerHealth", self.player:getHealth(), nil, false)
    Timer.performAfterDelay(1000, function()
        Noble.transition(LevelScene)
    end)
end

function GameScene:playCard()
    if not self.hand:isEmpty() and self.hand:hasEnoughMana() then
        self.state = GAME_STATE.selectingCard
        if self.hand:cardIsSingleTarget() then
            if self.cardInspector then
                self.cardInspector:animateOut(false)
            end
            self:switchToTargetSelection()
        else
            if self.cardInspector then
                self.cardInspector:animateOut(true)
                self.cardInspector = nil
            end
            self.hand:playCard()
        end
    end
end

function GameScene:update()
	GameScene.super.update(self)
    if self.state == GAME_STATE.selectingCard then
        if playdate.buttonJustPressed(playdate.kButtonB) then
            self:switchToEnemyTurn()
        elseif playdate.buttonJustPressed(playdate.kButtonA) then
            self:playCard()
        elseif playdate.buttonJustPressed(playdate.kButtonUp) then
            if not self.hand:isEmpty() then
                self.cardInspector = CardInspector(self.hand:getHand(), self.hand:getSelectedIndex())
                self.state = GAME_STATE.expandedCard
            end
        elseif playdate.buttonJustPressed(playdate.kButtonLeft) then
            self.hand:selectCardLeft()
        elseif playdate.buttonJustPressed(playdate.kButtonRight) then
            self.hand:selectCardRight()
        end
    elseif self.state == GAME_STATE.expandedCard then
        if playdate.buttonJustPressed(playdate.kButtonA) then
            self:playCard()
        elseif playdate.buttonJustPressed(playdate.kButtonB) then
            self.cardInspector:animateOut(true)
            self.cardInspector = nil
            self.state = GAME_STATE.selectingCard
        elseif playdate.buttonJustPressed(playdate.kButtonLeft) then
            self.hand:selectCardLeft()
            self.cardInspector:moveLeft()
        elseif playdate.buttonJustPressed(playdate.kButtonRight) then
            self.hand:selectCardRight()
            self.cardInspector:moveRight()
        end
    elseif self.state == GAME_STATE.singleTargetSelection then
        if playdate.buttonJustPressed(playdate.kButtonLeft) then
            self.reticle:selectLeft()
        elseif playdate.buttonJustPressed(playdate.kButtonRight) then
            self.reticle:selectRight()
        elseif playdate.buttonJustPressed(playdate.kButtonA) then
            self.reticle:animateOut()
            self.hand:playCard(self.reticle:getIndex())
            if self.cardInspector then
                self.cardInspector:destroy()
                self.cardInspector = nil
            end
            self.state = GAME_STATE.selectingCard
        elseif playdate.buttonJustPressed(playdate.kButtonB) then
            self.reticle:animateOut()
            if self.cardInspector then
                self.cardInspector:animateIn()
                self.state = GAME_STATE.expandedCard
            else
                self.state = GAME_STATE.selectingCard
            end
        end
    elseif self.state == GAME_STATE.enemyAction then

    end
end

function GameScene:screenShake()
    if self.screenShakeTimer then
        self.screenShakeTimer:remove()
    end
    local shakeTime = 400
    local shakeIntensity = 5
    self.screenShakeTimer = Timer.new(shakeTime, shakeIntensity, 0)
    self.screenShakeTimer.timerEndedCallback = function()
        Display.setOffset(0, 0)
    end
    self.screenShakeTimer.updateCallback = function(timer)
        local shakeAmount = timer.value
        local shakeAngle = math.random()*math.pi*2;
        shakeX = math.floor(math.cos(shakeAngle)*shakeAmount);
        shakeY = math.floor(math.sin(shakeAngle)*shakeAmount);
        Display.setOffset(shakeX, shakeY)
    end
end

function GameScene:finish()
	GameScene.super.finish(self)
    self.deck:resetDeck()
end