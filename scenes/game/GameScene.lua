class('GameScene').extends(NobleScene)
GameScene.backgroundColor = Graphics.kColorBlack

local MAX_HAND_SIZE <const> = 10

local lerp <const> = function(a, b, t)
    return a * (1-t) + b * t
end

local cardBase = Graphics.imagetable.new("assets/images/cards/cardBase")

function GameScene:init()
    GameScene.super.init(self)
    self.cardSprite = self:createCardSprite(cards.zap)

    self.cardSprites = {}
    self.cardBaseY = 220
    self.cardSelectY = 200
    self.cardSelectIndex = 1

    self.cardAnimationLerpSpeed = 0.2

    self.handSize = 1

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
end

function GameScene:enter()
	GameScene.super.enter(self)
end

function GameScene:update()
	GameScene.super.update(self)
    local handCount = #self.cardSprites
    for i=1, handCount do
        local cardPlacement = self.cardPlacements[handCount]
        local cardSprite = self.cardSprites[i]
        local cardTargetX = cardPlacement[i]
        local cardX = lerp(cardSprite.x, cardTargetX, self.cardAnimationLerpSpeed)
        local cardTargetY = self.cardBaseY
        if i == self.cardSelectIndex then
            cardTargetY = self.cardSelectY
        end
        local cardY = lerp(cardSprite.y, cardTargetY, self.cardAnimationLerpSpeed)
        cardSprite:moveTo(cardX, cardY)
    end
    if playdate.buttonJustPressed(playdate.kButtonA) then
        self:addCard(cards.zap)
    end

    if playdate.buttonJustPressed(playdate.kButtonLeft) then
        self.cardSelectIndex = math.ringInt(self.cardSelectIndex - 1, 1, #self.cardSprites)
    elseif playdate.buttonJustPressed(playdate.kButtonRight) then
        self.cardSelectIndex = math.ringInt(self.cardSelectIndex + 1, 1, #self.cardSprites)
    end
end

function GameScene:addCard(card)
    if #self.cardSprites >= MAX_HAND_SIZE then
        return
    end
    local cardSprite = self:createCardSprite(card)
    cardSprite:add(-20, self.cardBaseY)
    table.insert(self.cardSprites, 1, cardSprite)
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