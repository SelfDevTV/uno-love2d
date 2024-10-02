Flux = require "libs.flux"
Class = require "libs.class"
Vector = require "libs.vector"
Signal = require "libs.signal"
Timer = require "libs.timer"

-- push
Push = require "libs.push"
local gameWidth, gameHeight = 1920,
    1080 --fixed game resolution
local windowWidth, windowHeight = love.window.getDesktopDimensions()
windowWidth, windowHeight = gameWidth * .5,
    gameHeight *
    .5                                                                                                     --make the window a bit smaller
Push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, { fullscreen = false, highdpi = true }) --setup screen for push

local deck = require "objects.Deck"
local gm = require "objects.GameManager"

SCALE = 0.5
CARD_HEIGHT = 562 * SCALE
CARD_WIDTH = 388 * SCALE

Enums = {
    Colors = {
        RED = "red",
        BLUE = "blue",
        GREEN = "green",
        YELLOW = "yellow",

    },
    Values = {
        ZERO = 0,
        ONE = 1,
        TWO = 2,
        THREE = 3,
        FOUR = 4,
        FIVE = 5,
        SIX = 6,
        SEVEN = 7,
        EIGHT = 8,
        NINE = 9,
        SKIP = "skip",
        REVERSE = "reverse",
        DRAW2 = "draw",
        WILD = "wild",
        WILDDRAW4 = "wild_draw"
    }
}

Deck = deck(Vector(Push:getWidth() / 2 + CARD_WIDTH / 2, Push:getHeight() / 2 - CARD_HEIGHT / 2))
GameManager = gm()
