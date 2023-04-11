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
    self.background:setZIndex(GAME_Z_INDEXES.cardInspector)

    for i=1, #cards do
        local card = cards[i]
        local scaledCard = card:copy()
        scaledCard:setScale(2)
        self.cards[i] = scaledCard
        scaledCard:add(baseCardX, startY)
        scaledCard:setZIndex(GAME_Z_INDEXES.cardInspector)
        baseCardX += 400

        local descriptionSprite = self:createDescriptionSprite(card)
        self.descriptions[i] = descriptionSprite
        descriptionSprite:add(baseDescriptionX, startY)
        descriptionSprite:setZIndex(GAME_Z_INDEXES.cardInspector)
        baseDescriptionX += 400
    end

    -- Arrows
    self.leftArrow = Utilities.createAnimatedSprite("assets/images/ui/cardInspector/arrowLeft")
    self.rightArrow = Utilities.createAnimatedSprite("assets/images/ui/cardInspector/arrowRight")
    self.leftArrow:setZIndex(GAME_Z_INDEXES.cardInspector)
    self.rightArrow:setZIndex(GAME_Z_INDEXES.cardInspector)
    if #cards > 1 then
        self.leftArrow:add(18, startY)
        self.rightArrow:add(382, startY)
        if index == 1 then
            self.leftArrow:setVisible(false)
        elseif index == #cards then
            self.rightArrow:setVisible(false)
        end
    end

    self.animateInTime = 500
    self:animateIn()

    self.moveTimers = {}
end

local descriptionBackground = Graphics.imagetable.new("assets/images/ui/cardInspector/descriptionBackground")
local isJapanese = TEST_LOCALIZATION or (playdate.getSystemLanguage() == Graphics.font.kLanguageJapanese)
local japaneseFont = Japanese_Font

local descriptionCache = {}

function CardInspector:createDescriptionSprite(card)
    local descriptionSprite = NobleSprite()
    local spellName = card:getSpellName()
    local descriptionImagetable = descriptionCache[spellName]
    if not descriptionImagetable then
        descriptionImagetable = Graphics.imagetable.new(#descriptionBackground)
        local spellDescription = card:getSpellDescription()
        for i=1, #descriptionBackground do
            local descriptionImage = descriptionBackground[i]:copy()
            Graphics.pushContext(descriptionImage)
                if isJapanese then
                    Graphics.setFont(japaneseFont)
                end
                Graphics.setImageDrawMode(Graphics.kDrawModeFillWhite)
                local textImage = Graphics.imageWithText(spellDescription, 185, 113, nil, nil, nil, kTextAlignment.center, nil)
                textImage:drawAnchored(109, 100, 0.5, 0.5)
                Graphics.setImageDrawMode(Graphics.kDrawModeFillBlack)
                local nameY = 14
                if isJapanese then
                    nameY = 18
                end
                Graphics.drawTextAligned(spellName, 108, nameY, kTextAlignment.center)
            Graphics.popContext()
            descriptionImagetable:setImage(i, descriptionImage)
        end
        descriptionCache[spellName] = descriptionImagetable
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
        self.animateInTimer = Timer.new(animateOutTime, current, self.startY, Ease.inCubic)
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
    for i=1, #self.moveTimers do
        local timer = self.moveTimers[i]
        timer:remove()
    end
end

function CardInspector:moveLeft()
    if self.index <= 1 then
        return
    end

    self.index -= 1
    self.rightArrow:setVisible(true)
    if self.index == 1 then
        self.leftArrow:setVisible(false)
    end
    self:moveAllDescriptions()
end

function CardInspector:moveRight()
    if self.index >= #self.cards then
        return
    end

    self.index += 1
    self.leftArrow:setVisible(true)
    if self.index == #self.cards then
        self.rightArrow:setVisible(false)
    end
    self:moveAllDescriptions()
end

function CardInspector:moveAllDescriptions()
    for i=1, #self.moveTimers do
        local timer = self.moveTimers[i]
        timer:remove()
    end
    local moveTime = 500
    local baseCardX = 315
    local baseDescriptionX = 145
    baseCardX -= (self.index - 1) * 400
    baseDescriptionX -= (self.index - 1) * 400
    for i=1, #self.cards do
        local card = self.cards[i]
        local description = self.descriptions[i]
        local cardMoveTimer = Timer.new(moveTime, card.x, baseCardX, Ease.outCubic)
        cardMoveTimer.updateCallback = function(timer)
            card:moveTo(timer.value, card.y)
        end
        local descriptionMoveTimer = Timer.new(moveTime, description.x, baseDescriptionX, Ease.outCubic)
        descriptionMoveTimer.updateCallback = function(timer)
            description:moveTo(timer.value, description.y)
        end
        baseCardX += 400
        baseDescriptionX += 400
        table.insert(self.moveTimers, cardMoveTimer)
        table.insert(self.moveTimers, descriptionMoveTimer)
    end
end