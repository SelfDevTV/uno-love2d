local Card = require "objects.Card"
local generateUnoCardsForDeck = require "utils.generateUnoCardsForDeck"
-- displays a deck of cards and the last played card,
-- can be shuffled and generated


local function generateDeckCards(position)
    local cards = {}
    for i = 1, 3 do
        local card = Card(Vector(position.x + (i - 1) * 40, position.y), Enums.Colors.RED, Enums.Values.ZERO,
            "assets/art/Red_0.png")
        card:flip()
        table.insert(cards, card)
    end
    return cards
end

local Deck = Class {
    init = function(self, position)
        self.position = position
        self.cards = generateUnoCardsForDeck()
        self.playedCards = {}
        self.deckCards = generateDeckCards(self.position:clone())
        self.playedCardsPosition = Vector(0, self.position.y)
        self.lastPlayedCard = self:getCard()
        self.lastPlayedCard.position = self.playedCardsPosition:clone()
        self.lastPlayedCard:setPosition(self.playedCardsPosition:clone(), true)
        -- card thats animating
    end
}

function Deck:canPlayCard(card)
    if card.value == self.lastPlayedCard.value or card.color == self.lastPlayedCard.color then
        return true
    end

    return false
end

-- returns true or false
function Deck:playCard(card, onsuccess)
    if not card or not self:canPlayCard(card) then
        return
    end
    card:setPosition(self.playedCardsPosition:clone(), true, function()
        self.lastPlayedCard = card
        self.currentPlayedCard = nil
        if onsuccess then onsuccess() end
    end)
end

--returns a card from the deck
function Deck:getCard()
    if #self.cards == 0 then
        return
    end
    local card = table.remove(self.cards, 1)

    return card
end

-- returns a table of cards from the deck
function Deck:getCards(amount)
    local cards = {}
    for i = 1, amount do
        table.insert(cards, self:getCard())
    end
    return cards
end

function Deck:update(dt)
    for i, card in ipairs(self.deckCards) do
        card:update(dt)
    end
    self.lastPlayedCard:update(dt)
end

function Deck:draw()
    -- draw deckCards
    for i, card in ipairs(self.deckCards) do
        card:draw()
    end
    -- draw lastPlayedCard
    self.lastPlayedCard:draw()
end

return Deck
