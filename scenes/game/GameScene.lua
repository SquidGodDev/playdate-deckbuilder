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
    enemyAction = 4
}

class('GameScene').extends(NobleScene)
GameScene.backgroundColor = Graphics.kColorBlack

function GameScene:init(playerMaxHealth, playerHealth, deck)
    GameScene.super.init(self)
    -- ===== Temp values =====
    local cardList = {}
    for _, card in pairs(CARDS) do
        table.insert(cardList, card)
    end
    deck = {}
    for i=1,20 do
        local card = Card(cardList[math.random(#cardList)])
        deck[i] = card
    end
    playerMaxHealth = 20
    playerHealth = 20
    -- =======================

    -- Init
    self.deck = Deck(deck)
    self.player = Player(playerMaxHealth, playerHealth, 3)

    self.state = GAME_STATE.selectingCard
end

function GameScene:enter()
	GameScene.super.enter(self)

    -- Init
    self.hand = Hand(self.deck, self)
    self.player:createUI()
    self.enemyManager = EnemyManager()
    self.reticle = Reticle(self, self.enemyManager)
    self:addSprite(self.reticle)
end

function GameScene:switchToTargetSelection()
    self.state = GAME_STATE.singleTargetSelection
    self.reticle:animateIn()
end

function GameScene:update()
	GameScene.super.update(self)
    if self.state == GAME_STATE.selectingCard then
        if playdate.buttonJustPressed(playdate.kButtonB) then
            self.hand:drawCard()
        elseif playdate.buttonJustPressed(playdate.kButtonA) and not self.hand:isEmpty() then
            if self.hand:cardIsSingleTarget() then
                self:switchToTargetSelection()
            else
                self.hand:playCard()
            end
        elseif playdate.buttonJustPressed(playdate.kButtonLeft) then
            self.hand:selectCardLeft()
        elseif playdate.buttonJustPressed(playdate.kButtonRight) then
            self.hand:selectCardRight()
        end
    elseif self.state == GAME_STATE.expandedCard then

    elseif self.state == GAME_STATE.singleTargetSelection then
        if playdate.buttonJustPressed(playdate.kButtonLeft) then
            self.reticle:selectLeft()
        elseif playdate.buttonJustPressed(playdate.kButtonRight) then
            self.reticle:selectRight()
        elseif playdate.buttonJustPressed(playdate.kButtonA) then
            self.reticle:animateOut()
            self.hand:playCard(self.reticle:getIndex())
            self.state = GAME_STATE.selectingCard
        end
    elseif self.state == GAME_STATE.enemyAction then

    end
end
