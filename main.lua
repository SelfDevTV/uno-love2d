require "globals"

local Hand = require "objects.Hand"

local hand

function love.load()
    local gameWidth, gameHeight = 1920,
        1080 --fixed game resolution
    local windowWidth, windowHeight = love.window.getDesktopDimensions()
    windowWidth, windowHeight = windowWidth * .8,
        windowHeight *
        .8                                                                                                     --make the window a bit smaller
    Push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, { fullscreen = false, highdpi = true }) --setup screen for push
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    hand = Hand(Vector(300, 800), false)
end

function love.keypressed(key)
    -- debug
    if key == "space" then
        hand:drawCard()
    end
end

function love.update(dt)
    Flux.update(dt)
    Deck:update(dt)
    hand:update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        hand:mousepressed(x, y)
    end
end

function love.draw()
    Push:start()
    Deck:draw()
    hand:draw()
    Push:finish()
end
