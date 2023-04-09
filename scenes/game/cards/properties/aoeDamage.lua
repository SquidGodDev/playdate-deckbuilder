
--- Requires: damage
AoeDamage = {}
class('AoeDamage').extends(Property)

function AoeDamage:init(stats)
    AoeDamage.super.init(self, stats)
    assert(stats.damage)
    self.descriptionName = "drawDescription"
end

function AoeDamage:onPlay(stats, card, game, index)
    local enemyManager = game.enemyManager
    enemyManager:damageAllEnemies(stats.damage)
end

function AoeDamage:getDescription()
    return self:getPopulatedDescription(self.stats.damage)
end