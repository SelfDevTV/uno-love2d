local Hand = Class {
    init = function(self, position, isAi)
        self.position = position
        self.cards = {}
        self.isAi = isAi or false
        self.hoveredCard = nil
        self.hoveredCardIndex = nil
        self.prevCardX = 0
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


    card:setPosition(Vector(self.position.x + #self.cards * 80, self.position.y), true)
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
        else
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
    if self.isAi then
        return
    end
    self.hoveredCard, self.hoveredCardIndex = self:checkHovered()
    for _, card in ipairs(self.cards) do
        card:update(dt)
    end
end

function Hand:playCard(card)
    -- if no card is passed in, we assume its ai
    if not card and self.isAi then
        -- choose a random playable card
        for i, card in ipairs(self.cards) do
            if Deck:canPlayCard(card) then
                table.remove(self.cards, i)
                for j = i, #self.cards do
                    local c = self.cards[j]
                    c:setPosition(Vector(self.position.x + j * 80, self.position.y), true)
                end
                card:flip()
                Deck:playCard(card)
                break
            end
        end
        return
    end
    local playedCardIndex = self.hoveredCardIndex
    if Deck:canPlayCard(card) then
        table.remove(self.cards, playedCardIndex)
        for i = playedCardIndex, #self.cards do
            local c = self.cards[i]
            c:setPosition(Vector(self.position.x + i * 80, self.position.y), true)
        end
        Deck:playCard(card)
        GameManager:nextPlayer()
    end
end

return Hand
