local Card                    = require "objects.Card"
local generateUnoCardsForDeck = require "utils.generateUnoCardsForDeck"
local Hand                    = require "objects.Hand"
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

local function addHands()
    local hands = {
        Hand(Vector(300, 500)),
        Hand(Vector(300, 0, true))
    }
end

local Deck = Class {
    init = function(self, position)
        self.position = position
        self.cards = generateUnoCardsForDeck()
        self.playedCards = {}
        self.deckCards = generateDeckCards(self.position:clone())
        self.playedCardsPosition = Vector(self.position.x - 2 * CARD_WIDTH, self.position.y)
        self.lastPlayedCard = nil


        self.hands = addHands()
        -- card thats animating
    end
}

function Deck:canPlayCard(card)
    local matchingColorOrValue = card.value == self.lastPlayedCard.value or card.color == self.lastPlayedCard.color
    local cardIsWildCard = card.value == Enums.Values.WILD or card.value == Enums.Values.WILDDRAW4
    local lastCardIsWildCard = self.lastPlayedCard.value == Enums.Values.WILD or
        self.lastPlayedCard.value == Enums.Values.WILDDRAW4
    if matchingColorOrValue or cardIsWildCard or lastCardIsWildCard then
        return true
    end

    return false
end

-- returns true or false
function Deck:playCard(card, onsuccess)
    if not card or not self:canPlayCard(card) then
        return
    end
    self.currentPlayedCard = card

    card:setPosition(self.playedCardsPosition:clone(), true, function()
        self.lastPlayedCard = card
        self.currentPlayedCard = nil
    end)
end

--returns a card from the deck
function Deck:getCard()
    if #self.cards == 0 then
        return
    end
    local card = table.remove(self.cards, 1)
    card:setPosition(self.playedCardsPosition:clone(), false)

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

function Deck:revealFirstCard()
    self.lastPlayedCard = self:getCard()
    self.lastPlayedCard:setPosition(self.position:clone(), false)
    self.lastPlayedCard:setPosition(self.playedCardsPosition:clone(), true)
end

function Deck:update(dt)
    for i, card in ipairs(self.deckCards) do
        card:update(dt)
    end
    -- self.lastPlayedCard:update(dt)
    if self.currentPlayedCard then
        self.currentPlayedCard:update(dt)
    end
end

function Deck:draw()
    -- draw deckCards
    for i, card in ipairs(self.deckCards) do
        card:draw()
    end
    -- draw lastPlayedCard
    if self.lastPlayedCard then
        self.lastPlayedCard:draw()
    end
    if self.currentPlayedCard then
        self.currentPlayedCard:draw()
    end
end

return Deck
