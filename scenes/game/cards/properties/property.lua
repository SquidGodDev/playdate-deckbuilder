Property = {}
class('Property').extends()

function Property:init(stats)
    self.name = stats.name
    self.stats = stats
    -- Assert stats in child class
end

function Property:onPlay(stats, card, game, index)
    -- Override on child class
end

function Property:onDraw(stats, card, game)
    -- Override on child class
end

function Property:onDiscard(stats, card, game)
    -- Override on child class
end

function Property:onBanish(stats, card, game)
    -- Override on child class
end

function Property:getDescription()
    -- Override on child class
end

function Property:getPopulatedDescription(value)
    local description = Utilities.getLocalizedString(self.descriptionName)
    return description:gsub("{}", value)
end