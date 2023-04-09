
--- Requires: damage
SingleTargetDamage = {}
class('SingleTargetDamage').extends(Property)

function SingleTargetDamage:init(stats)
    SingleTargetDamage.super.init(self, stats)
    assert(stats.damage)
    stats.singleTarget = true
    self.descriptionName = "damageDescription"
end

function SingleTargetDamage:onPlay(stats, card, game, index)
    local enemyManager = game.enemyManager
    enemyManager:damageEnemy(index, stats.damage)
end

function SingleTargetDamage:getDescription()
    return self:getPopulatedDescription(self.stats.damage)
end