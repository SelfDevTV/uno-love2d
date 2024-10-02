Flux = require "libs.flux"
Class = require "libs.class"
Vector = require "libs.vector"
Signal = require "libs.signal"
Push = require "libs.push"

local deck = require "objects.Deck"

SCALE = 0.5

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

Deck = deck(Vector(300, 100))
