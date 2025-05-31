local screenWidth, screenHeight = 256, 240
local canvas 
local scale

local anim8 = require 'libraries/anim8'
local player = require 'player'
local background = require 'background'
local intro = require 'intro'

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest") --no smoothing
    wf = require "libraries/windfield"
                    --gravity x/y    
    world = wf.newWorld(0, 150)
    
    player:load(world)
    background:load(world)
    intro:load()

    canvas = love.graphics.newCanvas(screenWidth, screenHeight)
    local windowWidth, windowHeight = love.graphics.getDimensions()
    scale = math.floor(math.min(windowWidth / screenWidth, windowHeight / screenHeight))
end

function love.update(dt)
    player:update(dt)
    world:update(dt)
end

function love.draw()
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    world:draw()

    -- intro:draw()
    -- Draw background
    background:draw()
    -- Draw player
    player:draw()

    love.graphics.setCanvas()
    love.graphics.scale(scale)
    love.graphics.draw(canvas, 0, 0)
    -- print(player.jumpcooldown)
end

