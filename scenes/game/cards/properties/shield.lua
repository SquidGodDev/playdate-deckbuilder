
--- Requires: shield
Shield = {}
class('Shield').extends(Property)

function Shield:init(stats)
    Shield.super.init(self, stats)
    assert(stats.shield)
    self.descriptionName = "shieldDescription"
end

function Shield:onPlay(stats, card, game, index)
    local player = game.player
    player:addShield(stats.shield)
end

function Shield:getDescription()
    return self:getPopulatedDescription(self.stats.shield)
end
