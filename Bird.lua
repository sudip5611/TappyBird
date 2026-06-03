Bird = class{}

local gravity = 900

function Bird:init()

    -- load spritesheet
    self.image = love.graphics.newImage('bird.png')

    -- actual size of each frame in spritesheet
    self.width = 36
    self.height = 28

    -- table to store framres
    self.frames = {}

    self.animationtimer = 0

    for i = 0, 3 do

        self.frames[i + 1] = love.graphics.newQuad(i * self.width, 0, self.width, self.height,
        self.image:getDimensions())
    end

    -- current frame (initialisation)
    self.currentFrame = 1

    -- horizontal posn of bird
    self.x = (virtual_width - self.width ) / 4

    -- vertical position of bird
    self.y = (virtual_height - self.height ) / 2 - 35
    
    -- initial y speed
    self.dy = 0

end

function Bird:collides(pipe)

    if self.x + self.width - 6 >= pipe.x and self.x + 16 <= pipe.x + pipe_width then
        if self.y + self.height - 6 >= pipe.y and self.y + 6 <= pipe.y + pipe_height then
            return true
        end
    end

    return false
end

function Bird:update(dt)

    self.animationtimer = self.animationtimer + dt

    if self.animationtimer > 0.05 then
        self.currentFrame = self.currentFrame % 4 + 1
        self.animationtimer = 0
    end

    -- applying gravity
    self.dy = self.dy + gravity * dt

    if love.keyboard.waspressed('space') then
        self.dy = -285
        jump:stop()
        jump:play()
    end
    -- new y position
    self.y =  self.y + self.dy * dt

end

function Bird:draw()
    
    love.graphics.draw( self.image, self.frames[self.currentFrame], self.x, self.y, 0)
end