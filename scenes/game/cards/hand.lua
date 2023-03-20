class('Hand').extends(NobleSprite)

local MAX_HAND_SIZE <const> = 10

local lerp <const> = function(a, b, t)
    return a * (1-t) + b * t
end

local cardPlacements <const> = {}
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
    table.insert(cardPlacements, placements)
end

function Hand:init(deck, game)
    Hand.super.init(self)
    self.deck = deck
    self.game = game
    self.player = game.player

    self.cards = {}
    self.cardBaseY = 220
    self.cardSelectY = 200
    self.cardSelectIndex = 1

    self.cardAnimationLerpSpeed = 0.2

    self.handSize = 1
    self:add()
end

function Hand:update()
    local handCount = #self.cards
    local cardPlacement = cardPlacements[handCount]
    for i=1, handCount do
        local card = self.cards[i]
        local cardTargetX = cardPlacement[i]
        local cardX = lerp(card.x, cardTargetX, self.cardAnimationLerpSpeed)
        local cardTargetY = self.cardBaseY
        if i == self.cardSelectIndex then
            cardTargetY = self.cardSelectY
        end
        local cardY = lerp(card.y, cardTargetY, self.cardAnimationLerpSpeed)
        card:moveTo(cardX, cardY)
    end
end

function Hand:selectCardLeft()
    if #self.cards <= 0 then
        return
    end
    self.cardSelectIndex = math.ringInt(self.cardSelectIndex - 1, 1, #self.cards)
end

function Hand:selectCardRight()
    if #self.cards <= 0 then
        return
    end
    self.cardSelectIndex = math.ringInt(self.cardSelectIndex + 1, 1, #self.cards)
end

function Hand:drawCard()
    if #self.cards >= MAX_HAND_SIZE then
        return
    end
    self:addCard(self.deck:draw())
end

function Hand:isEmpty()
    return #self.cards <= 0
end

function Hand:cardIsSingleTarget()
    return self.cards[self.cardSelectIndex]:isSingleTarget()
end

function Hand:hasEnoughMana()
    local card = self.cards[self.cardSelectIndex]
    local cardCost = card:getCost()
    return self.player:hasEnoughMana(cardCost)
end

function Hand:playCard(enemyIndex)
    if #self.cards <= 0 then
        return
    end

    local playedCard = self.cards[self.cardSelectIndex]
    local cardCost = playedCard:getCost()
    if not self.player:hasEnoughMana(cardCost) then
        return
    end

    playedCard:onPlay(self.game, enemyIndex)
    self.player:useMana(cardCost)
    table.remove(self.cards, self.cardSelectIndex)
    if self.cardSelectIndex > #self.cards then
        self.cardSelectIndex = #self.cards
    end
    local playAnimateTimer = Timer.new(700, playedCard.y, -120, playdate.easingFunctions.outCubic)
    playAnimateTimer.updateCallback = function(timer)
        playedCard:moveTo(playedCard.x, timer.value)
    end
    playAnimateTimer.timerEndedCallback = function()
        playedCard:remove()
        self.deck:discard(playedCard)
    end
end

function Hand:addCard(card)
    if #self.cards >= MAX_HAND_SIZE or not card then
        return
    end
    card:add(-20, self.cardBaseY)
    table.insert(self.cards, 1, card)
    self.cardSelectIndex = 1
end