class('EnemyManager').extends(Graphics.sprite)

local lerp <const> = function(a, b, t)
    return a * (1-t) + b * t
end

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

function EnemyManager:init()
    self.enemies = {
        BasicEnemy(ENEMIES.blokus),
        BasicEnemy(ENEMIES.blokus),
        BasicEnemy(ENEMIES.blokus)
    }
    self.enemiesLerpSpeed = 0.1
    self.enemyBaseY = 90

    self.enemySpawnY = -30

    self:addEnemies()
    Noble.currentScene():addSprite(self)
end

function EnemyManager:damageEnemy(index, amount)
    local enemy = self.enemies[index]
    if not enemy then
        return
    end

    enemy:damage(amount)
end

function EnemyManager:damageAllEnemies(amount)
    for _, enemy in ipairs(self.enemies) do
        enemy:damage(amount)
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
        local enemyX = lerp(enemy.x, targetX, self.enemiesLerpSpeed)
        local enemyY = lerp(enemy.y, self.enemyBaseY, self.enemiesLerpSpeed)
        enemy:moveTo(enemyX, enemyY)
    end
end