player = {}

function player:load()
    anim8 = require 'libraries/anim8'
    self.sprites = love.graphics.newImage("assets/Bubby1.png")

    self.x = 22
    self.y = 212
    self.speed = 30
    self.jumpcooldown = 0
    self.walktimer = 0
    self.walkcooldown = 0.3
    self.walkSoundToggle = false


    self.jumpSound = love.audio.newSource("sounds/Jump.wav", "static")
    self.walkSound1 = love.audio.newSource("sounds/Step1.wav", "static")
    self.walkSound2 = love.audio.newSource("sounds/Step2.wav", "static")
    self.climbingSound = love.audio.newSource("sounds/ladder.mp3", "static")

    self:loadAnimations()
end

function player:loadAnimations()
    self.grid = anim8.newGrid(16, 16, self.sprites:getWidth(), self.sprites:getHeight())
    self.animations = {}
    self.animations.idol = anim8.newAnimation(self.grid(1, 1), 0.2)
    self.animations.right = anim8.newAnimation(self.grid('1-2', 1), 0.2)
    self.animations.left = anim8.newAnimation(self.grid('1-2', 4), 0.2)
    self.animations.up = anim8.newAnimation(self.grid('1-3', 2), 0.2)
    self.animations.jumpright = anim8.newAnimation(self.grid(1, 3), 0.3)
    self.animations.jump = anim8.newAnimation(self.grid(1, 3), 0.3)
    self.animations.jumpleft = anim8.newAnimation(self.grid(1, 5), 0.3)
    self.anim = self.animations.idol
end


function player:handleInput(dt)
    self.isMoving = false
    self.isClimbing = false
    self.isJumping = false

    local speed = self.speed

    if love.keyboard.isDown('d') then
        self.x = self.x + (self.speed * dt)
        self.anim = self.animations.right
        self.isMoving = true
    elseif love.keyboard.isDown('a') then
        self.x = self.x - (self.speed * dt)
        self.anim = self.animations.left
        self.isMoving = true
    end

    if love.keyboard.isDown('w') then
        self.y = self.y - (self.speed * dt)
        self.anim = self.animations.up
        self.isMoving = true
        self.isClimbing = true
    elseif love.keyboard.isDown('s') then
        self.y = self.y + (self.speed * dt)
        self.anim = self.animations.up
        self.isMoving = true
        self.isClimbing = true
    end

    if love.keyboard.isDown('space') and love.keyboard.isDown('d') and self.jumpcooldown == 0 then
        self.y = self.y - (self.speed * dt)
        self.anim = self.animations.jumpright
        self.isJumping = true
        self.isMoving = true
        self.jumpcooldown = 1.5
        self:playJumpSounds()
    elseif love.keyboard.isDown('space') and love.keyboard.isDown('a') and self.jumpcooldown == 0 then
        self.y = self.y - (self.speed * dt)
        self.anim = self.animations.jumpleft
        self.isJumping = true
        self.isMoving = true
        self.jumpcooldown = 1.5
        self:playJumpSounds()
    elseif love.keyboard.isDown('space') and self.jumpcooldown == 0 then 
        self.anim = self.animations.jumpright
        self.isJumping = true
        self.isMoving = true
        self.jumpcooldown = 1.5
        self:playJumpSounds()
    end

    if self.jumpcooldown > 0 then
        self.jumpcooldown = math.max(0, self.jumpcooldown - dt)
    end
    

    if not self.isMoving then
        self.anim:gotoFrame(1)
    end

    if self.isMoving == true and not self.isJumping and not self.isClimbing then
        self.walktimer = self.walktimer + dt
        if self.walktimer > self.walkcooldown then 
            self:playWalkSounds()
            self.walktimer = 0
        end
    end

    -- need to fix this to play it in a loop
    if self.isClimbing or love.keyboard.isDown('w') then
        self:playClimbingSounds()
    end




end

function player:playClimbingSounds()
    if self.climbingSound then
        self.climbingSound:stop()
        self.climbingSound:play()
    end
end



function player:playJumpSounds()
    if self.jumpSound then
        self.jumpSound:stop()
        self.jumpSound:play()
    end
end

function player:playWalkSounds()
    if not self.walkSoundToggle then
        self.walkSound1:stop()
        self.walkSound1:play()
        self.walkSoundToggle = true
    else
        self.walkSound2:stop()
        self.walkSound2:play()
        self.walkSoundToggle = false
    end
end



function player:update(dt)
    self.anim:update(dt)
    self:handleInput(dt)
end


function player:draw()
    local drawX = math.floor(self.x)
    local drawY = math.floor(self.y)
    self.anim:draw(self.sprites, self.x, self.y + 8, nil, 1, 1, 8, 16)
end


return player

