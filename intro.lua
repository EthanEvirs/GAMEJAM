intro = {}

function intro:load()
    self.sprites = love.graphics.newImage("assets/intro.png")
end



function intro:draw()
    love.graphics.draw(self.sprites, 0, 0)
end

return intro
