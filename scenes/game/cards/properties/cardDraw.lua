class('CardDraw').extends(Property)

function CardDraw:init(stats)
    assert(stats.drawCount)
end

function CardDraw:onPlay(stats, card, game, index)
    local hand = game.hand
    hand:drawCard(stats.drawCount)
end