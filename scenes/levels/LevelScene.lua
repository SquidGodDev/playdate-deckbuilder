class('LevelScene').extends(NobleScene)
LevelScene.backgroundColor = Graphics.kColorBlack

function LevelScene:init()
    LevelScene.super.init(self)
    self.maxLevel = 5
    self.level = Noble.GameData.get("level")
    self.world = Noble.GameData.get("world")
end

function LevelScene:enter()
    LevelScene.super.enter(self)

    self:createHealthUI()
    self:createLevelIcons()
end

function LevelScene:start()
    LevelScene.super.start(self)

    if #self.level == self.maxLevel - 1 then
        self.cardSelection = CardSelection(200, 150, {SELECTION_CHOICES.campfire, SELECTION_CHOICES.market, SELECTION_CHOICES.chest})
        self.cardSelection:animateIn()

        Noble.Input.setHandler({
            AButtonDown = function()
                Noble.Input.clearHandler()
                self:selected(self.cardSelection:select())
                self.cardSelection:animateOut()
            end,
            leftButtonDown = function()
                self.cardSelection:selectLeft()
            end,
            rightButtonDown = function()
                self.cardSelection:selectRight()
            end
        })
    elseif #self.level == self.maxLevel then
        self:endLevel()
    else
        if #self.level == 0 then
            self:selected(SELECTION_CHOICES.enemy)
        else
            local animateDelay = 500
            Timer.performAfterDelay(animateDelay, function()
                self:selected(SELECTION_CHOICES.enemy)
            end)
        end
    end
end

function LevelScene:selected(choice)
    local nextLevelIndex = #self.level + 1
    self:animateCursor(nextLevelIndex, function()
        self:screenShake()
        local curIcon = self.levelIcons[nextLevelIndex]
        local newIcon = self:getSpriteFromChoice(choice)
        newIcon:add(curIcon.x, curIcon.y)
        Utilities.particle(curIcon.x, curIcon.y, "assets/images/ui/level/levelEnterParticles", 15, false)
        curIcon:remove()
        table.insert(self.level, choice)
        Noble.GameData.set("level", self.level)

        local transitionDelay = 1000
        Timer.performAfterDelay(transitionDelay, function()
            if choice == SELECTION_CHOICES.campfire then
                Noble.transition(CampfireScene)
            elseif choice == SELECTION_CHOICES.chest then
                Noble.transition(ChestScene)
            elseif choice == SELECTION_CHOICES.enemy then
                Noble.transition(GameScene)
            elseif choice == SELECTION_CHOICES.market then
                Noble.transition(MarketScene)
            end
        end)
    end)
end

function LevelScene:endLevel()
    self:animateCursor(self.maxLevel + 1, function()
        Noble.GameData.set("level", {})
        Noble.GameData.set("world", self.world + 1)
        local transitionDelay = 1000
        Timer.performAfterDelay(transitionDelay, function()
            Noble.transition(LevelScene)
        end)
    end)
end

function LevelScene:animateCursor(index, callback)
    local targetX = self.levelIcons[index].x
    local animateTimer = Timer.new(1000, self.cursor.x, targetX, Ease.inOutCubic)
    animateTimer.updateCallback = function(timer)
        self.cursor:moveTo(timer.value, self.cursor.y)
    end
    animateTimer.timerEndedCallback = function()
        if callback then
            callback()
        end
    end
end

function LevelScene:createHealthUI()
    local playerMaxHealth = Noble.GameData.get("playerMaxHealth")
    local playerHealth = Noble.GameData.get("playerHealth")
    local UIBaseX, UIBaseY = 18, 18
    local textBaseX = UIBaseX + 24
    local heartImageTable = Graphics.imagetable.new("assets/images/ui/heart")
    self.heartSprite = Utilities.createAnimatedSprite(heartImageTable)
    self.heartSprite:add(UIBaseX, UIBaseY)
    self.healthText = NobleSprite()
    self.healthText:setCenter(0, 0.5)
    self.healthText:add(textBaseX, UIBaseY)
    local healthTextImage = Graphics.imageWithText(playerHealth .. "/" .. playerMaxHealth, 100)
    self.healthText:setImage(healthTextImage)
    self.healthText:setImageDrawMode(Graphics.kDrawModeFillWhite)
end

function LevelScene:createLevelIcons()
    local baseX, baseY = 80, 120
    local iconGap = 48
    self.levelIcons = {}
    for i=1, self.maxLevel + 1 do
        local iconSprite
        if i > self.maxLevel then
            iconSprite = Utilities.createAnimatedSprite("assets/images/ui/level/arrow")
        elseif i > #self.level then
            iconSprite = Utilities.createAnimatedSprite("assets/images/ui/level/question")
        else
            local choice = self.level[i]
            iconSprite = self:getSpriteFromChoice(choice)
        end
        iconSprite:add(baseX + (i-1)*iconGap, baseY)
        self.levelIcons[i] = iconSprite
    end

    self.cursor = Utilities.createAnimatedSprite("assets/images/ui/level/cursor")
    local cursorX = math.max(baseX + (#self.level-1)*iconGap, baseX)
    self.cursor:add(cursorX, baseY)
end

function LevelScene:getSpriteFromChoice(choice)
    if choice == SELECTION_CHOICES.campfire then
        return Utilities.createAnimatedSprite("assets/images/ui/level/campfire")
    elseif choice == SELECTION_CHOICES.chest then
        return Utilities.createAnimatedSprite("assets/images/ui/level/chest")
    elseif choice == SELECTION_CHOICES.enemy then
        return Utilities.createAnimatedSprite("assets/images/ui/level/skull")
    elseif choice == SELECTION_CHOICES.market then
        return Utilities.createAnimatedSprite("assets/images/ui/level/market")
    end
end

function LevelScene:screenShake()
    if self.screenShakeTimer then
        self.screenShakeTimer:remove()
    end
    local shakeTime = 400
    local shakeIntensity = 5
    self.screenShakeTimer = Timer.new(shakeTime, shakeIntensity, 0)
    self.screenShakeTimer.timerEndedCallback = function()
        Display.setOffset(0, 0)
    end
    self.screenShakeTimer.updateCallback = function(timer)
        local shakeAmount = timer.value
        local shakeAngle = math.random()*math.pi*2;
        shakeX = math.floor(math.cos(shakeAngle)*shakeAmount);
        shakeY = math.floor(math.sin(shakeAngle)*shakeAmount);
        Display.setOffset(shakeX, shakeY)
    end
end

function LevelScene:finish()
	LevelScene.super.finish(self)
end