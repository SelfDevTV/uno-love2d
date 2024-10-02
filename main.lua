require "globals"




function love.load()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
end

function love.keypressed(key)
    GameManager:keypressed(key)
end

function love.update(dt)
    Flux.update(dt)
    Timer.update(dt)
    GameManager:update(dt)
    Deck:update(dt)

    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    GameManager:mousepressed(button, x, y)
end

function love.draw()
    Push:start()
    GameManager:draw()
    Deck:draw()
    Push:finish()
end
