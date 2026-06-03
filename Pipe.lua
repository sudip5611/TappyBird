Pipe = class{}

local pipe_pic = love.graphics.newImage('pipe.png')

pipe_scrolling_speed = 90

pipe_width = pipe_pic:getWidth()
pipe_height = pipe_pic:getHeight()

function Pipe:init( orientation, y)

    -- pipe initialisation at right side of screen
    self.x = virtual_width
    self.y = y

    -- width of each pipe image
    self.width = pipe_width
    self.height = pipe_height

    self.orientation = orientation
end

function Pipe:update(dt)
end

function Pipe:draw()
    love.graphics.draw( pipe_pic, self.x,
    self.orientation == 'top' and self.y + pipe_height or self.y,
    0, 1,
    self.orientation == 'top' and -1 or 1)
end

