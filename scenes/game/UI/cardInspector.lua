class('CardInspector').extends(NobleSprite)

function CardInspector:init(cards, index)
    self.cards = {}
    self.descriptions = {}
    self.index = index

    local targetY = 120
    local startY = 380
    self.startY, self.targetY = startY, targetY
    local baseCardX = 315
    local baseDescriptionX = 145
    baseCardX -= (index - 1) * 400
    baseDescriptionX -= (index - 1) * 400

    local backgroundX = 200
    self.background = NobleSprite("assets/images/ui/cardInspector/gradientBackground")
    self.background:add(backgroundX, startY)

    for i=1, #cards do
        local card = cards[i]
        local scaledCard = card:copy()
        scaledCard:setScale(2)
        self.cards[i] = scaledCard
        scaledCard:add(baseCardX, startY)
        baseCardX += 400

        local descriptionSprite = self:createDescriptionSprite(card)
        self.descriptions[i] = descriptionSprite
        descriptionSprite:add(baseDescriptionX, startY)
        baseDescriptionX += 400
    end

    -- Arrows
    self.leftArrow = Utilities.createAnimatedSprite("assets/images/ui/cardInspector/arrowLeft")
    self.rightArrow = Utilities.createAnimatedSprite("assets/images/ui/cardInspector/arrowRight")
    self.leftArrow:add(18, startY)
    self.rightArrow:add(382, startY)

    self.animateInTime = 500
    self:animateIn()
end

local descriptionBackground = Graphics.imagetable.new("assets/images/ui/cardInspector/descriptionBackground")
local isJapanese = TEST_LOCALIZATION or (playdate.getSystemLanguage() == Graphics.font.kLanguageJapanese)
local japaneseFont = Japanese_Font

function CardInspector:createDescriptionSprite(card)
    local descriptionSprite = NobleSprite()
    local descriptionImagetable = Graphics.imagetable.new(#descriptionBackground)
    local spellName = card:getSpellName()
    local spellDescription = card:getSpellDescription()
    for i=1, #descriptionBackground do
        local descriptionImage = descriptionBackground[i]:copy()
        Graphics.pushContext(descriptionImage)
            if isJapanese then
                Graphics.setFont(japaneseFont)
            end
            Graphics.setImageDrawMode(Graphics.kDrawModeFillWhite)
            Graphics.drawTextInRect(spellDescription, 19, 53, 185, 113, nil, nil, kTextAlignment.center)
            Graphics.setImageDrawMode(Graphics.kDrawModeFillBlack)
            Graphics.drawTextAligned(spellName, 108, 14, kTextAlignment.center)
        Graphics.popContext()
        descriptionImagetable:setImage(i, descriptionImage)
    end
    Utilities.animateSprite(descriptionSprite, descriptionImagetable)
    return descriptionSprite
end

function CardInspector:animateIn()
    self:animate(true)
end

function CardInspector:animateOut(destroyOnFinish)
    self:animate(false, destroyOnFinish)
end

function CardInspector:animate(animateIn, destroyOnFinish)
    local animateInTime = 500
    local animateOutTime = 500
    if animateIn then
        self.animateInTimer = Timer.new(animateInTime, self.startY, self.targetY, Ease.outBack)
    else
        local current = 120
        if self.animateInTimer then
            current = self.animateInTimer.value
            self.animateInTimer:remove()
        end
        self.animateInTimer = Timer.new(animateOutTime, current, self.startY, Ease.inSine)
    end
    self.animateInTimer.updateCallback = function(timer)
        local animateY = timer.value
        self.background:moveTo(self.background.x, animateY)
        self.leftArrow:moveTo(self.leftArrow.x, animateY)
        self.rightArrow:moveTo(self.rightArrow.x, animateY)
        for i=1, #self.cards do
            local card = self.cards[i]
            card:moveTo(card.x, animateY)
            local description = self.descriptions[i]
            description:moveTo(description.x, animateY)
        end
    end
    self.animateInTimer.timerEndedCallback = function()
        if not animateIn and destroyOnFinish then
            self:destroy()
        end
    end
end

function CardInspector:destroy()
    for i=1, #self.cards do
        local card = self.cards[i]
        card:remove()
        local description = self.descriptions[i]
        description:remove()
    end
    self.background:remove()
    self.leftArrow:remove()
    self.rightArrow:remove()
end

function CardInspector:moveLeft()
    
end

function CardInspector:moveRight()
    
end