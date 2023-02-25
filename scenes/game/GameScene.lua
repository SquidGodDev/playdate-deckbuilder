class('GameScene').extends(NobleScene)
GameScene.backgroundColor = Graphics.kColorBlack

local MAX_HAND_SIZE <const> = 10

local cardBase = Graphics.imagetable.new("assets/images/cards/cardBase")

function GameScene:init()
    GameScene.super.init(self)
    self.cardSprite = self:createCardSprite(cards.zap)

    self.cardSprites = {}

    self.cardPlacements = {}
    for i=1, MAX_HAND_SIZE do
        local baseX = 200
        local gap = 60

        local gapDecreaseIndex = 6
        local gapDecreaseSize = 6
        if i >= 6 then
            gap -= (i - gapDecreaseIndex + 1) * gapDecreaseSize
        end

        if i%2 == 0 then
            baseX = baseX - (gap/2) - gap * (i/2 - 1)
        else
            baseX = baseX - gap * math.floor(i/2)
        end
        local placements = {}
        for j=1, i do
            table.insert(placements, baseX + (j-1) * gap)
        end
        table.insert(self.cardPlacements, placements)
    end

    self.handSize = 1
end

function GameScene:enter()
	GameScene.super.enter(self)

    self:createHand(self.handSize)
end

function GameScene:createHand(handSize)
    local cardY = 220
    local cardPlacement = self.cardPlacements[handSize]
    for i=1, #cardPlacement do
        local cardX = cardPlacement[i]
        local cardSprite = self:createCardSprite(cards.zap)
        cardSprite:add(cardX, cardY)
        -- table.insert(self.cardSprites, cardSprite)
    end
end

function GameScene:update()
	GameScene.super.update(self)
    if playdate.buttonJustPressed(playdate.kButtonA) then
        self.handSize += 1
        Graphics.sprite.removeAll()
        local backgroundImage = Graphics.image.new(400, 240, Graphics.kColorBlack)
        local backgroundSprite = NobleSprite()
        backgroundSprite:setImage(backgroundImage)
        backgroundSprite:add(200, 120)
        backgroundSprite:setZIndex(-1000)
        -- for i=1, #self.cardSprites do
        --     self.cardSprites[i]:remove()
        -- end
        -- self.cardSprites = {}
        self:createHand(self.handSize)
    end
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