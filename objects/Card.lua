local Card = Class {
    init = function(self, position, color, value, spriteSrc)
        -- vector
        self.position = position
        self.color = color
        self.value = value
        self.spriteSrc = spriteSrc
        self.faceDownSpriteSrc = "assets/art/Deck.png"
        self.texture = love.graphics.newImage(spriteSrc)
        self.faceDownTexture = love.graphics.newImage(self.faceDownSpriteSrc)
        self.isHovered = false
        self.isFaceDown = false
        self.w = self.texture:getWidth() * SCALE
        self.h = self.texture:getHeight() * SCALE
        self.animating = false
        self.hoverTargetPos = self.position
        self.allowedToHover = false
        self.tween = nil
        self.changingPosition = false
    end
}

function Card:setPosition(newPos, shouldAnimate, oncomplete)
    self.changingPosition = true
    if self.tween then self.tween:stop() end
    self.allowedToHover = false

    self.hoverTargetPos = newPos - Vector(0, 30)
    if shouldAnimate then
        local startTime = love.timer.getTime()
        self.tween = Flux.to(self.position, .5, { x = newPos.x, y = newPos.y }):oncomplete(function()
            self.changingPosition = false
            self.allowedToHover = true
            if oncomplete then oncomplete() end
        end)
    else
        if oncomplete then oncomplete() end
        self.position = newPos
    end

    self.hoverTargetPos = newPos
end

function Card:hoverUp()
    if self.changingPosition then return end
    self.tween = Flux.to(self.position, 0.5, { x = self.hoverTargetPos.x, y = self.hoverTargetPos.y - 30 })
end

function Card:hoverDown()
    if self.changingPosition then return end
    self.tween = Flux.to(self.position, 0.5, { x = self.hoverTargetPos.x, y = self.hoverTargetPos.y })
end

function Card:update(dt)
    -- when the player hovers over the card set isHovered to true
    local mouseX, mouseY = Push:toGame(love.mouse.getPosition())
    -- local mouseX, mouseY = love.mouse.getPosition()

    if not self.allowedToHover then
        self.isHovered = false
        return
    end

    if (mouseX and mouseY and mouseX > self.position.x and mouseX < self.position.x + self.w) and (mouseY > self.position.y and mouseY < self.position.y + self.h) then
        self.isHovered = true
    else
        self.isHovered = false
    end
end

function Card:draw()
    if self.isFaceDown then
        love.graphics.draw(self.faceDownTexture, self.position.x, self.position.y, 0, SCALE, SCALE)
    else
        love.graphics.draw(self.texture, self.position.x, self.position.y, 0, SCALE, SCALE)
    end
end

function Card:flip()
    self.isFaceDown = not self.isFaceDown
end

return Card
