
--- Requires: damage
SingleTargetDamage = {}
class('SingleTargetDamage').extends(Property)

function SingleTargetDamage:init(stats)
    assert(stats.damage)
    stats.singleTarget = true
end

function SingleTargetDamage:onPlay(stats, card, game, index)
    local enemyManager = game.enemyManager
    enemyManager:damageEnemy(index, stats.damage)
end