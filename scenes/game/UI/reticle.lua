local lerp <const> = function(a, b, t)
    return a * (1-t) + b * t
end

class('Reticle').extends(NobleSprite)

function Reticle:init(game, enemyManager)
    Reticle.super.init(self)
    self.game = game
    self.enemyManager = enemyManager
    self.inY = 90
    self.outY = -50
    self.targetY = self.outY
    self.index = 1
    self.lerpSpeed = 0.3
    self:moveTo(200, self.outY)

    local reticleImagetable = Graphics.imagetable.new("assets/images/ui/reticle")
    Utilities.animateSprite(self, reticleImagetable)
    self:add()
end

function Reticle:selectLeft()
    self.index -= 1
    if self.index < 1 then
        self.index = 1
    end
end

function Reticle:selectRight()
    self.index += 1
    local enemyCount = self.enemyManager:getEnemyCount()
    if self.index > enemyCount then
        self.index = enemyCount
    end
end

function Reticle:getIndex()
    return self.index
end

function Reticle:animateIn()
    self.targetY = self.inY
    local enemyCount = self.enemyManager:getEnemyCount()
    if self.index > enemyCount then
        self.index = enemyCount
    end
end

function Reticle:animateOut()
    self.targetY = self.outY
end

function Reticle:update()
    local enemyPlacement = self.enemyManager:getPlacement()
    local targetX = self.x
    if enemyPlacement then
        targetX = enemyPlacement[self.index] or enemyPlacement[self.enemyManager:getEnemyCount()]
    end
    local reticleX = lerp(self.x, targetX, self.lerpSpeed)
    local reticleY = lerp(self.y, self.targetY, self.lerpSpeed)
    self:moveTo(reticleX, reticleY)
end