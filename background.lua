background = {}

function background:load()
    anim8 = require 'libraries/anim8'
    self.sprites = love.graphics.newImage("assets/background.png")

    self.floors = {
        { x = 18, y = 56, width = 224, height = 8 },
        { x = 18, y = 104, width = 224, height = 8 },
        { x = 18, y = 152, width = 224, height = 8 },
        { x = 18, y = 220, width = 224, height = 8 }
    }

    self.ladders = {
        { x = 20, y = 56, width = 16, height = 32 },
        { x = 120, y = 56, width = 16, height = 32 },
        { x = 200, y = 152, width = 16, height = 48 }
    }

    self:loadLadderAnimations()
    self:loadFloorAnimations()
end

function background:loadLadderAnimations()
    local grid = anim8.newGrid(16, 16, self.sprites:getWidth(), self.sprites:getHeight())
    self.ladderTile = anim8.newAnimation(grid(1, 1), 1)
end

function background:loadFloorAnimations()
    local grid = anim8.newGrid(16, 16, self.sprites:getWidth(), self.sprites:getHeight())
    self.floorTile = anim8.newAnimation(grid(1, 2), 1)
end

function background:draw()
    for _, f in ipairs(self.floors) do
        local tilesWide = math.floor(f.width / 16)
        for j = 0, tilesWide - 1 do
            self.floorTile:draw(self.sprites, f.x + j * 16, f.y)
        end
    end

    for _, l in ipairs(self.ladders) do
        local tilesTall = math.floor(l.height / 16)
        for j = 0, tilesTall - 1 do
            self.ladderTile:draw(self.sprites, l.x, l.y + j * 16)
        end
    end
end

return background
