local Card = require "objects.Card"
local function generateUnoCardsForDeck()
    local cards = {}
    local colors = { "red", "blue", "green", "yellow" }
    local values = {
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
        "skip", "reverse", "draw2"
    }

    -- all but wild cards
    for _, color in pairs(Enums.Colors) do
        for _, value in pairs(Enums.Values) do
            if value ~= "wild" and value ~= "wild_draw" then
                local assetPath = "assets/art/" .. color:sub(1, 1):upper() .. color:sub(2) .. "_" .. value .. ".png"
                local card = Card(Vector(0, 0), color, value,
                    assetPath)
                table.insert(cards, card)
            end
        end
    end

    -- wild cards
    for i = 1, 4 do
        for _, value in pairs(Enums.Values) do
            if value == "wild" or value == "wild_draw" then
                local assetPath = "assets/art/" .. value:sub(1, 1):upper() .. value:sub(2) .. ".png"
                local card = Card(Vector(0, 0), nil, value,
                    assetPath)
                table.insert(cards, card)
            end
        end
    end

    -- shuffle cards
    for i = #cards, 2, -1 do
        local j = love.math.random(i)
        cards[i], cards[j] = cards[j], cards[i]
    end

    return cards
end

return generateUnoCardsForDeck
