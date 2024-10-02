local Hand = Class {
    init = function(self, position, isAi)
        self.position = position
        self.cards = {}
        self.isAi = isAi or false
        self.hoveredCard = nil
        self.hoveredCardIndex = nil
    end
}

function Hand:drawCard()
    local card = Deck:getCard()
    if not card then
        return
    end
    if self.isAi then
        card:flip()
    end


    card:setPosition(Vector(self.position.x + (#self.cards - 1) * 80, self.position.y), true)
    table.insert(self.cards, card)
end

function Hand:checkHovered()
    local hoveredCardIndex = nil
    local hoveredCard = nil

    -- Check cards in reverse order (starting from the topmost one)
    for i = #self.cards, 1, -1 do
        local card = self.cards[i]
        if card.isHovered then
            hoveredCard = card

            hoveredCardIndex = i

            break -- Stop as soon as the topmost card is found
        end
    end

    return hoveredCard, hoveredCardIndex
end

function Hand:draw()
    for i, card in ipairs(self.cards) do
        if self.hoveredCardIndex and i == self.hoveredCardIndex then
            card:hoverUp()
            love.graphics.setColor(1, 0, 0)
        else
            love.graphics.setColor(1, 1, 1, 1)
            card:hoverDown()
        end
        card:draw()
    end
end

function Hand:mousepressed(x, y)
    if not self.hoveredCard then
        return
    end
    self:playCard(self.hoveredCard)
end

function Hand:update(dt)
    self.hoveredCard, self.hoveredCardIndex = self:checkHovered()
    for _, card in ipairs(self.cards) do
        card:update(dt)
    end
end

function Hand:playCard(card)
    local playedCardIndex = self.hoveredCardIndex
    Deck:playCard(card, function()
        table.remove(self.cards, playedCardIndex)
    end)
end

return Hand
