local Hand = require "objects.Hand"
local GameManager = Class {
    init = function(self)
        self.hands = {
            Hand(Vector(10, Push:getHeight() - CARD_HEIGHT - 50)),
            Hand(Vector(10, 50), true)
        }
        self.currentPlayer = 2
        self.currentPlayerHand = self.hands[self.currentPlayer]
        self.dealCoroutine = nil

        self.timeToDealOneCard = .1
        self.timer = self.timeToDealOneCard
        self:startNeWRound()
    end
}


function GameManager:mousepressed(button, x, y)
    if button == 1 then
        self.currentPlayerHand:mousepressed(x, y)
    end
end

function GameManager:keypressed(key)
    if key == "space" then
        self.currentPlayerHand:drawCard()
    end
    if key == "tab" then
        self.currentPlayer = self.currentPlayer % #self.hands + 1
        self.currentPlayerHand = self.hands[self.currentPlayer]
    end
end

function GameManager:startNeWRound()
    self.dealCoroutine = coroutine.create(function()
        for _, hand in ipairs(self.hands) do
            for i = 1, 7 do
                hand:drawCard()
                coroutine.yield()
            end
        end
    end)

    self:dealNextCard()
end

function GameManager:dealNextCard()
    -- Resume the coroutine to deal the next card
    if coroutine.status(self.dealCoroutine) ~= "dead" then
        coroutine.resume(self.dealCoroutine)
    else
        -- All cards have been dealt, reveal the first card
        self.dealCoroutine = nil
        self:revealFirstCard()
    end
end

function GameManager:revealFirstCard()
    Deck:revealFirstCard()
    Timer.after(.5, function()
        self:playTurn()
    end)
end

-- TODO: Create an indicator which players is on turn (top or bot player)


function GameManager:nextPlayer()
    self.currentPlayer = self.currentPlayer % #self.hands + 1
    self.currentPlayerHand = self.hands[self.currentPlayer]
    Timer.after(.5, function()
        self:playTurn()
    end)
end

function GameManager:playTurn()
    -- current players turn
    print(self.currentPlayerHand.isAi)
    if self.currentPlayerHand.isAi then
        self.currentPlayerHand:playCard()
        self:nextPlayer()
    end
end

function GameManager:update(dt)
    if self.dealCoroutine then
        self.timer = self.timer - dt
        if self.timer <= 0 then
            self.timer = self.timeToDealOneCard
            self:dealNextCard()
        end
    end
    for _, hand in ipairs(self.hands) do
        hand:update(dt)
    end
end

function GameManager:draw()
    for _, hand in ipairs(self.hands) do
        hand:draw()
    end
end

return GameManager
