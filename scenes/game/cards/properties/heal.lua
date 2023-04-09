
--- Requires: heal
Heal = {}
class('Heal').extends(Property)

function Heal:init(stats)
    Heal.super.init(self, stats)
    assert(stats.heal)
    self.descriptionName = "healDescription"
end

function Heal:onPlay(stats, card, game, index)
    local player = game.player
    player:heal(stats.heal)
end

function Heal:getDescription()
    return self:getPopulatedDescription(self.stats.heal)
end
