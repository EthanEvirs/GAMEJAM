player = {}

function player:load()
    anim8 = require 'libraries/anim8'
    self.sprites = love.graphics.newImage("assets/Bubby1.png")

    self.x = 22
    self.y = 212
    self.speed = 40

    self:loadAnimations()

end

function player:loadAnimations()
    self.grid = anim8.newGrid(16, 16, self.sprites:getWidth(), self.sprites:getHeight())
    self.animations = {}
    self.animations.idol = anim8.newAnimation(self.grid(1, 1), 0.2)
    self.animations.right = anim8.newAnimation(self.grid('1-4', 1), 0.2)
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

    if love.keyboard.isDown('space') and love.keyboard.isDown('d') then
        self.y = self.y - (self.speed * dt)
        self.anim = self.animations.jumpright
        self.isJumping = true
        self.isMoving = true
    elseif love.keyboard.isDown('space') and love.keyboard.isDown('a') then
        self.y = self.y - (self.speed * dt)
        self.anim = self.animations.jumpleft
        self.isJumping = true
        self.isMoving = true
    end

    if not self.isMoving then
        self.anim:gotoFrame(1)
    end
end

function player:update(dt)
    self.anim:update(dt)
    self:handleInput(dt)
end


function player:draw()
    local drawX = math.floor(self.x)
    local drawY = math.floor(self.y)
    self.anim:draw(self.sprites, self.x, self.y, nil, 1, 1, 8, 8)
end

return player

