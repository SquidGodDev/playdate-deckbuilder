local cardBase <const> = Graphics.imagetable.new("assets/images/cards/cardBase")

class('Card').extends(NobleSprite)

function Card:init(data)
    Card.super.init(self)
    self.data = data
    self.stats = table.shallowcopy(data.stats)
    self.properties = {}
    for i=1,#data.properties do
        local Property = data.properties[i]
        self.properties[i] = Property(self.stats)
    end

    self.flatModifiers = {}
    self.multiplicativeModifiers = {}

    self.baseImagetable = self:createCardImagetable(data)
    self:createAnimationLoop(data.stats.cost)

    self.drawLoopCounter = 0
    self.drawLoopDuration = 6
    self.drawLoopIndex = 1
end

function Card:getStats()
    local modifiedStats = table.shallowcopy(self.stats)
    for stat, flatModifier in pairs(self.flatModifiers) do
        local modifiedStat = modifiedStats[stat] + flatModifier
        if modifiedStat < 0 then
            modifiedStat = 0
        end
        modifiedStats[stat] = modifiedStat
    end
    for stat, multiplicativeModifier in pairs(self.multiplicativeModifiers) do
        local modifiedStat = modifiedStats[stat] * multiplicativeModifier
        modifiedStats[stat] = math.floor(modifiedStat + 0.5)
    end
    return modifiedStats
end

function Card:isSingleTarget()
    return self.stats.singleTarget
end

function Card:getCost()
    local cost = self.stats.cost
    if self.flatModifiers.cost then
        cost += self.flatModifiers.cost
    end
    if self.multiplicativeModifiers.cost then
        cost *= self.multiplicativeModifiers.cost
    end
    if cost < 0 then
        cost = 0
    end
    return cost
end

function Card:setModifier(stat, value, multiplicative)
    if not self.stats[stat] then
        return
    end

    local modifiers = self.flatModifiers
    if multiplicative then
        modifiers = self.multiplicativeModifiers
    end

    if modifiers[stat] then
        modifiers[stat] += value
    else
        modifiers[stat] = value
    end

    if stat == "cost" then
        local newCost = self:getCost()
        self:createAnimationLoop(newCost)
    end
end

function Card:resetModifiers()
    self.flatModifiers = {}
    self.multiplicativeModifiers = {}
end

function Card:onPlay(game, index)
    for _, property in ipairs(self.properties) do
        property:onPlay(self.stats, self, game, index)
    end
end

function Card:onDraw()
    for _, property in ipairs(self.properties) do
        property:onDraw(self.stats, self, game)
    end
end

function Card:onDiscard(game)
    for _, property in ipairs(self.properties) do
        property:onDiscard(self.stats, self, game)
    end
end

function Card:onBanish(game)
    for _, property in ipairs(self.properties) do
        property:onBanish(self.stats, self, game)
    end
end

function Card:update()
    self.drawLoopCounter += 1
    if self.drawLoopCounter >= self.drawLoopDuration then
        self.drawLoopCounter = 0
        self.drawLoopIndex = (self.drawLoopIndex % #self.imagetable) + 1
    end
    self:setImage(self.imagetable[self.drawLoopIndex])
end

function Card:createAnimationLoop(cost)
    self.imagetable = self:getCardImagetableWithCost(cost)
    self:setImage(self.imagetable[1])
end

function Card:getCardImagetableWithCost(cost)
    local cardImagetable = Graphics.imagetable.new(#self.baseImagetable)
    for i=1,#cardImagetable do
        local cardImage = self.baseImagetable[i]:copy()
        Graphics.pushContext(cardImage)
            Graphics.setImageDrawMode(Graphics.kDrawModeFillWhite)
            Graphics.drawText(cost, 31, 4)
        Graphics.popContext()
        cardImagetable:setImage(i, cardImage)
    end
    return cardImagetable
end

function Card:createCardImagetable(data)
    local spellImagetable = Graphics.imagetable.new(data.imagePath)
    local imagetableCount = #spellImagetable
    local cardImagetable = Graphics.imagetable.new(imagetableCount)
    for i=1,#spellImagetable do
        local cardImage = cardBase[i]:copy()
        Graphics.pushContext(cardImage)
            spellImagetable[i]:draw(15, 24)
        Graphics.popContext()
        cardImagetable:setImage(i, cardImage)
    end
    return cardImagetable
end