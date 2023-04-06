local function createCard(imagetablePath)
    local cardBase = Graphics.imagetable.new("assets/images/cards/cardBase")
    local imagetable = Graphics.imagetable.new(imagetablePath)
    local imagetableCount = #imagetable
    local cardImagetable = Graphics.imagetable.new(imagetableCount)
    for i=1,imagetableCount do
        local cardImage = cardBase[i]:copy()
        Graphics.pushContext(cardImage)
            imagetable[i]:drawAnchored(26, 25, 0.5, 0.5)
        Graphics.popContext()
        cardImagetable:setImage(i, cardImage)
    end
    return Utilities.createAnimatedSprite(cardImagetable)
end

local selectionSprites <const> = {
    [SELECTION_CHOICES.campfire] = createCard("assets/images/ui/level/campfire"),
    [SELECTION_CHOICES.chest] = createCard("assets/images/ui/level/chest"),
    [SELECTION_CHOICES.market] = createCard("assets/images/ui/level/market"),
    [SELECTION_CHOICES.enemy] = createCard("assets/images/ui/level/skull"),
}

local lerp <const> = function(a, b, t)
    return a * (1-t) + b * t
end

class('CardSelection').extends(NobleSprite)

function CardSelection:init(x, y, options, background)
    CardSelection.super.init(self)
    self.cardPlacements = {}
    local gap = 100
    local maxHandSize = 5
    for i=1, maxHandSize do
        local baseX = x
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

    self.offScreenTopY = -60
    self.offScreenBottomY = 300
    self.baseY = y
    self.selectY = y - 20
    self.targetY = self.offScreenBottomY

    self.lerpSpeed = 0.2
    self.active = false

    if background then
        self.background = NobleSprite("assets/images/ui/level/fadedBackground")
        self.background:add(x, self.targetY)
    end

    self.options = options
    self.cards = {}
    local placements = self.cardPlacements[#options]
    for i, selection in ipairs(options) do
        local card = selectionSprites[selection]
        card:add(placements[i], self.targetY)
        self.cards[i] = card
    end
    self.index = math.ceil(#options/2)

    self:add()
end

function CardSelection:update()
    local placements = self.cardPlacements[#self.options]
    for i=1, #self.cards do
        local card = self.cards[i]
        local targetX = placements[i]
        local targetY = self.targetY
        if i == self.index and self.active then
            targetY = self.selectY
        end
        local x = lerp(card.x, targetX, self.lerpSpeed)
        local y = lerp(card.y, targetY, self.lerpSpeed)
        card:moveTo(x, y)
    end
    if self.background then
        local targetY = self.targetY
        if targetY == self.offScreenTopY then
            targetY = self.offScreenBottomY
        end
        local y = lerp(self.background.y, targetY, self.lerpSpeed)
        self.background:moveTo(self.background.x, y)
    end
end

function CardSelection:animateIn()
    self.targetY = self.baseY
    self.active = true
end

function CardSelection:animateOut()
    self.targetY = self.offScreenTopY
    self.active = false
end

function CardSelection:selectLeft()
    if not self.active then
        return
    end
    self.index = math.ringInt(self.index - 1, 1, #self.options)
end

function CardSelection:selectRight()
    if not self.active then
        return
    end
    self.index = math.ringInt(self.index + 1, 1, #self.options)
end

function CardSelection:select()
    return self.options[self.index]
end