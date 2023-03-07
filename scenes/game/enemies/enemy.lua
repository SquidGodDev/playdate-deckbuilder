
class('Enemy').extends(NobleSprite)

function Enemy:init(x, y, imagepath, health)
    Enemy.super.init(self)

    local enemyImagetable = Graphics.imagetable.new(imagepath)
    self.animationLoop = Graphics.animation.loop.new(200, enemyImagetable, true)

    self:moveTo(x, y)

    self.health = health
end

function Enemy:setGameScene(gameScene)
    self.gameScene = gameScene
end

function Enemy:setHealth(health)
    self.health = health
    -- Update heart display
end

function Enemy:update()
    self:setImage(animationLoop:image())
end

function Enemy:getIntent()
    
end

function Enemy:act()
    -- Override with action pattern
end

function Enemy:attack(amount)
    -- Attack animation
    self.gameScene:damagePlayer(amount)
end

function Enemy:damage(amount)
    self.health -= amount
    if self.health <= 0 then
        self:die()
    end
end

function Enemy:die()
    self:remove()
end