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
end

function GameScene:enter()
	GameScene.super.enter(self)

    -- Init
    self.hand = Hand(self.deck, self)
    self.player:createUI()
    self.enemyManager = EnemyManager()
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
