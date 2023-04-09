
--- Requires: drawCount
CardDraw = {}
class('CardDraw').extends(Property)

function CardDraw:init(stats)
    CardDraw.super.init(self, stats)
    assert(stats.drawCount)
    self.descriptionName = "drawDescription"
end

function CardDraw:onPlay(stats, card, game, index)
    local hand = game.hand
    hand:drawCard(stats.drawCount)
end

function CardDraw:getDescription()
    return self:getPopulatedDescription(self.stats.drawCount)
end