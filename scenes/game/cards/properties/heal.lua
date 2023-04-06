class('Heal').extends()

function Heal:init(stats)
    assert(stats.heal)
end

function Heal:onPlay(stats, card, game, index)
    local player = game.player
    player:heal(stats.heal)
end
