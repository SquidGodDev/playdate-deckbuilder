class('Property').extends()

function Property:init(stats)
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