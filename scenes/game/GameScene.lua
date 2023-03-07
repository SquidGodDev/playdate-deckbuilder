class('GameScene').extends(NobleScene)
GameScene.backgroundColor = Graphics.kColorBlack

function GameScene:init()
    GameScene.super.init(self)
end

function GameScene:enter()
	GameScene.super.enter(self)
    self.hand = Hand()
end

-- Player Methods
function GameScene:damagePlayer(amount)
    
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
