class('EnemyManager').extends(Graphics.sprite)

local maxEnemies <const> = 4
local enemyPlacements <const> = {}
for i=1, maxEnemies do
    local baseX = 250
    local gap = 70
    if i%2 == 0 then
        baseX = baseX - (gap/2) - gap * (i/2 - 1)
    else
        baseX = baseX - gap * math.floor(i/2)
    end
    local placements = {}
    for j=1, i do
        table.insert(placements, baseX + (j-1) * gap)
    end
    table.insert(enemyPlacements, placements)
end

function EnemyManager:init(game)
    self.game = game
    self.enemies = {
        BasicEnemy(game, ENEMIES.chunkus),
        BasicEnemy(game, ENEMIES.chunkus),
        BasicEnemy(game, ENEMIES.chunkus)
    }
    self.enemyBaseY = 90

    self.enemySpawnY = self.enemyBaseY

    self:addEnemies()
    Noble.currentScene():addSprite(self)
end

function EnemyManager:enemyTurn()
    local delayBetweenEnemies = 500
    local postTurnDelay = 500
    local delayTime = 0
    local turnCoroutine = coroutine.create(function(co)
        for i=1,#self.enemies do
            local enemy = self.enemies[i]
            Timer.performAfterDelay(delayTime, function()
                delayTime = enemy:act() + delayBetweenEnemies
                coroutine.resume(co)
            end)
            coroutine.yield()
        end
        Timer.performAfterDelay(postTurnDelay, function ()
            self.game:switchToPlayerTurn()
        end)
    end)
    coroutine.resume(turnCoroutine, turnCoroutine)
end

function EnemyManager:updateIntents()
    for _, enemy in ipairs(self.enemies) do
        enemy:setIntent()
        enemy:updateIntentDisplay()
    end
end

function EnemyManager:damageEnemy(index, amount)
    local enemy = self.enemies[index]
    if not enemy then
        return
    end

    local enemyDied = enemy:damage(amount)
    if enemyDied then
        table.remove(self.enemies, index)
    end

    if #self.enemies == 0 then
        self.game:enemiesDefeated()
    end
end

function EnemyManager:damageAllEnemies(amount)
    for i=#self.enemies,1,-1 do
        self:damageEnemy(i, amount)
    end
end

function EnemyManager:getEnemyCount()
    return #self.enemies
end

function EnemyManager:getPlacement()
    return enemyPlacements[#self.enemies]
end

function EnemyManager:addEnemies()
    local enemyCount = #self.enemies
    local enemyPlacement = enemyPlacements[enemyCount]
    for i=1,#self.enemies do
        local enemy = self.enemies[i]
        local targetX = enemyPlacement[i]
        enemy:add(targetX, self.enemySpawnY)
    end
end

function EnemyManager:update()
    local enemyCount = #self.enemies
    local enemyPlacement = enemyPlacements[enemyCount]
    for i=1, enemyCount do
        local enemy = self.enemies[i]
        local targetX = enemyPlacement[i]
        enemy:lerpTo(targetX, self.enemyBaseY)
    end
end