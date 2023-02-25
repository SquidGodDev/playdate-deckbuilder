class('GameScene').extends(NobleScene)
GameScene.backgroundColor = Graphics.kColorBlack

local cardBase = Graphics.imagetable.new("assets/images/cards/cardBase")

function GameScene:init()
    GameScene.super.init(self)
    self.cardSprite = self:createCardSprite(cards.zap)
end

function GameScene:enter()
	GameScene.super.enter(self)
	self.cardSprite:add(200, 120)
end

function GameScene:update()
	GameScene.super.update(self)
end

function GameScene:createCardSprite(card)
    local cardImagetable = self:createCardImagetable(card)

    local cardSprite = NobleSprite()
    local animationLoop = Graphics.animation.loop.new(200, cardImagetable, true)
    cardSprite.update = function(sprite)
        sprite:setImage(animationLoop:image())
    end
    return cardSprite
end

function GameScene:createCardImagetable(card)
    local spellImagetable = Graphics.imagetable.new(card.imagePath)
    local imagetableCount = #spellImagetable
    local cardImagetable = Graphics.imagetable.new(imagetableCount)
    for i=1,#spellImagetable do
        local cardImage = cardBase[i]:copy()
        Graphics.pushContext(cardImage)
            Graphics.setImageDrawMode(Graphics.kDrawModeFillWhite)
            spellImagetable[i]:draw(15, 24)
            Graphics.drawText(card.cost, 31, 4)
        Graphics.popContext()
        cardImagetable:setImage(i, cardImage)
    end
    return cardImagetable
end