
--- Requires: damage
AoeDamage = {}
class('AoeDamage').extends(Property)

function AoeDamage:init(stats)
    assert(stats.damage)
end

function AoeDamage:onPlay(stats, card, game, index)
    local enemyManager = game.enemyManager
    enemyManager:damageAllEnemies(stats.damage)
end