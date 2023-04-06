class('Deck').extends()

function Deck:init(deck)
    self.deck = deck
    self.discardPile = {}
end

function Deck:draw()
    if #self.deck == 0 then
        self:reshuffle()
    end
    if #self.deck == 0 then
        return
    end
    return table.remove(self.deck, math.random(#self.deck))
end

function Deck:discard(card)
    table.insert(self.discardPile, card)
end

function Deck:reshuffle()
    -- 1. Append discard pile to deck
    -- 2. Clear discard pile
    -- 3. Play shuffle SFX
    if #self.discardPile > 0 then
        table.move(self.discardPile, 1, #self.discardPile, #self.deck + 1, self.deck)
    end
    self.discardPile = {}
end

function Deck:resetDeck()
    self:reshuffle()
    for i=1, #self.deck do
        local card = self.deck[i]
        card:resetModifiers()
    end
end