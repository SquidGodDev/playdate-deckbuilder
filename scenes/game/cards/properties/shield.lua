class('Shield').extends()

function Shield:init(stats)
    assert(stats.shield)
end

function Shield:onPlay(stats, card, game, index)
    local player = game.player
    player:addShield(stats.shield)
end
