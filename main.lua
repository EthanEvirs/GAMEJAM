function love.load()
    -- first thing to load in code
    anim8 = require 'libraries/anim8'
    wf = require 'libraries/windfield'
    love.graphics.setDefaultFilter("nearest", "nearest")


    world = wf.newWorld(0, 512, true)
    world:addCollisionClass('Platform')
    world:addCollisionClass('Player')

    player = {}
    player.x = 200
    player.y = 200
    player.speed = 20
    player.sprites = love.graphics.newImage("Bubby.png")
    player.grid = anim8.newGrid(16, 16, player.sprites:getWidth(), player.sprites:getHeight())

    player.animations = {}
    player.animations.idol = anim8.newAnimation(player.grid(1, 1), 0.2)
    player.animations.right = anim8.newAnimation(player.grid('1-2', 1), 0.2)
    player.animations.left = anim8.newAnimation(player.grid('1-2', 4), 0.2)
    player.animations.up = anim8.newAnimation(player.grid('1-3', 2), 0.2)
    player.animations.jumpright = anim8.newAnimation(player.grid(1, 3), 0.3)
    player.animations.jumpleft = anim8.newAnimation(player.grid(1, 5), 0.3)


    player.anim = player.animations.idol

end

function love.update(dt)
    local isMoving = false
    -- updated every frame

    if love.keyboard.isDown('d') then
        player.x = player.x + (player.speed * dt)
        player.anim = player.animations.right
        isMoving = true
    end

    if love.keyboard.isDown('a') then
        player.x = player.x - (player.speed * dt)
        player.anim = player.animations.left
        isMoving = true
    end
    
    if love.keyboard.isDown('s') then
        player.y = player.y + (player.speed * dt)
        player.anim = player.animations.up
        isMoving = true
    end
    
    if love.keyboard.isDown('w') then
        player.y = player.y - (player.speed * dt)
        player.anim = player.animations.up
        isMoving = true
    end

    if love.keyboard.isDown('space') and love.keyboard.isDown('d') then
        player.y = player.y - (player.speed * dt)
        player.anim = player.animations.jumpright
        isMoving = true
    end

    if love.keyboard.isDown('space') and love.keyboard.isDown('a') then
        player.y = player.y - (player.speed * dt)
        player.anim = player.animations.jumpleft
        isMoving = true
    end


    if isMoving == false then
        player.anim:gotoFrame(1)
    end

    world:update(dt)
    player.anim:update(dt)

end


function love.draw()
    -- draws to the screen
    player.anim:draw(player.sprites, player.x, player.y, nil, 10)
    world:draw()

end
