class('SingleTargetDamage').extends(Property)

function SingleTargetDamage:init(stats)
    assert(stats.damage)
end

function SingleTargetDamage:onPlay(stats, card, game, index)
    local enemyManager = game.enemyManager
    enemyManager:damageEnemy(index, stats.damage)
end