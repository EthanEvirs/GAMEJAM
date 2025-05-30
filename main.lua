local screenWidth, screenHeight = 256, 240
local canvas 
local scale
local isClimbing
local ladderColliders = {}
local floorColliders = {}

local floors = {
    { x = 20, y = 56, width = 224, height = 8 },
    { x = 20, y = 104, width = 224, height = 8 },
    { x = 20, y = 152, width = 224, height = 8 },
    { x = 20, y = 200, width = 224, height = 8 }
}

local ladder = {
    { x = 20, y = 56, width = 16, height = 32 },
    { x = 120, y = 56, width = 16, height = 32 },
    { x = 200, y = 152, width = 16, height = 48 }
}


function love.load()
    -- first thing to load in code
    anim8 = require 'libraries/anim8'
    wf = require 'libraries/windfield'
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- step sound logic
    stepSounds = {
        love.audio.newSource("Step1.wav", "static"),
        love.audio.newSource("Step2.wav", "static")
    }
    currentStepIndex = 1
    stepTimer = 0
    stepCooldown = 0.2

    -- ladder sound logic
    ladderSound = love.audio.newSource("ladder.mp3", "static")
    ladderTimer = 0
    ladderCooldown = 0.25
    ladderSound:setVolume(0.7)

    jumpSound = love.audio.newSource("Jump.wav", "static")
    -- LEVEL1 = love.audio.newSource("LLleveltheme.mp3", "static")

    canvas = love.graphics.newCanvas(screenWidth, screenHeight)
    local windowWidth, windowHeight = love.graphics.getDimensions()
    scale = math.floor(math.min(windowWidth / screenWidth, windowHeight / screenHeight))


    world = wf.newWorld(0, 500, true)
    world:addCollisionClass('Platform')
    world:addCollisionClass('Ladder')

    player = {}
    player.collider = world:newRectangleCollider(100, 150, 16, 16)
    player.collider:setFixedRotation(true)
    player.x = 200
    player.y = 200
    player.speed = 40
    player.sprites = love.graphics.newImage("Bubby1.png")
    player.grid = anim8.newGrid(16, 16, player.sprites:getWidth(), player.sprites:getHeight())

    player.animations = {}
    player.animations.idol = anim8.newAnimation(player.grid(1, 1), 0.2)
    player.animations.right = anim8.newAnimation(player.grid('1-4', 1), 0.2)
    player.animations.left = anim8.newAnimation(player.grid('1-2', 4), 0.2)
    player.animations.up = anim8.newAnimation(player.grid('1-3', 2), 0.2)
    player.animations.jumpright = anim8.newAnimation(player.grid(1, 3), 0.3)
    player.animations.jump = anim8.newAnimation(player.grid(1, 3), 0.3)
    player.animations.jumpleft = anim8.newAnimation(player.grid(1, 5), 0.3)
    player.anim = player.animations.idol


    tileImage = love.graphics.newImage("background.png")
    ladderTileGrid = anim8.newGrid(16, 16, tileImage:getWidth(), tileImage:getHeight())
    ladderTile = anim8.newAnimation(ladderTileGrid(1, 1), 1)
    floorTileGrid = anim8.newGrid(16, 16, tileImage:getWidth(), tileImage:getHeight())
    floorTile = anim8.newAnimation(floorTileGrid(1, 2), 1)

    floorColliders = {}
    for _, f in ipairs(floors) do
       local collider = world:newRectangleCollider(f.x, f.y, f.width, f.height)
        collider:setType('static')
        collider:setCollisionClass('Platform')
        table.insert(floorColliders, collider)
    end

    ladderColliders = {}
    for _, l in ipairs(ladder) do 
        local collider = world:newRectangleCollider(l.x, l.y, l.width, l.height)
        collider:setType('static')
        collider:setCollisionClass('Ladder')
        collider:setSensor(true)
        table.insert(ladderColliders, collider)
    end
end



function love.update(dt)
    local isMoving = false
    local isJumping = false
    isClimbing = false
    local vx = 0
    local vy = 0
    -- LEVEL1:play()
    -- updated every frame

    if love.keyboard.isDown('d') then
        vx = player.speed
        player.anim = player.animations.right
        isMoving = true
    end

    if love.keyboard.isDown('a') then
        vx = player.speed * -1
        player.anim = player.animations.left
        isMoving = true
    end
    
    if love.keyboard.isDown('s') then
        vy = player.speed
        player.anim = player.animations.up
        isMoving = true
        isClimbing = true
    end
    
    if love.keyboard.isDown('w') then
        vy = player.speed * -1
        player.anim = player.animations.up
        isMoving = true
        isClimbing = true
    end

    if love.keyboard.isDown('space') and love.keyboard.isDown('d') then
        player.collider:setLinearVelocity(vx, -100)
        player.anim = player.animations.jumpright
        jumpSound:play()
        isMoving = true
        isJumping = true
    end

    if love.keyboard.isDown('space') and love.keyboard.isDown('a') then
        player.collider:setLinearVelocity(vx, -100)
        player.anim = player.animations.jumpleft
        jumpSound:play()
        isMoving = true
        isJumping = true
    end

    -- walking sound logic
    local isWalking = (love.keyboard.isDown('a') or love.keyboard.isDown('d')) and not isJumping

    if isWalking then
        stepTimer = stepTimer - dt
        if stepTimer <= 0 then
            stepSounds[currentStepIndex]:stop()
            stepSounds[currentStepIndex]:play()

            currentStepIndex = (currentStepIndex == 1) and 2 or 1
            stepTimer = stepCooldown
            end
    else
        stepTimer = 0
    end
    

    -- climbing sounds logic
    if isClimbing then
        ladderTimer = ladderTimer - dt
        if ladderTimer <= 0 then
            ladderSound:stop()
            ladderSound:play()

            ladderTimer = ladderCooldown
        end
    else
        ladderTimer = 0
    end

    -- gravity logic

    if isClimbing then
        player.collider:setGravityScale(0)
        player.collider:setLinearVelocity(vx, vy)

       for _, fc in ipairs(floorColliders) do
        fc:setSensor(true)
       end

    else
        for _, fc in ipairs(floorColliders) do
        fc:setSensor(false)
        end
        player.collider:setGravityScale(1)
        local _, currentY = player.collider:getLinearVelocity()
        player.collider:setLinearVelocity(vx, currentY)
    end


    if isMoving == false then
        player.anim:gotoFrame(1)
    end

    world:update(dt)
    player.x = player.collider:getX()
    player.y = player.collider:getY()
    player.anim:update(dt)

end


function love.draw()
    love.graphics.setCanvas(canvas)
    love.graphics.clear()

    -- Draw floor tiles using the same center coordinates as colliders
    for i, f in ipairs(floors) do
        local tilesWide = math.floor(f.width / 16)
        local drawX = f.x
        local drawY = f.y

        for j = 0, tilesWide - 1 do
            floorTile:draw(tileImage, drawX + j * 16, drawY)
        end
    end

    -- Draw ladder tiles using the same center coordinates as colliders
    for i, l in ipairs(ladder) do
        local tilesTall = math.floor(l.height / 16)
        local drawX = l.x
        local drawY = l.y

        for j = 0, tilesTall - 1 do
            ladderTile:draw(tileImage, drawX, drawY + j * 16)
        end
    end

    -- Draw player
    player.anim:draw(player.sprites, player.x, player.y, nil, 1, 1, 8, 8)

    -- world:draw()

    love.graphics.setCanvas()
    love.graphics.scale(scale)
    love.graphics.draw(canvas, 0, 0)
end

