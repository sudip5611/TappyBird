Pipepair = class{}


function Pipepair:init(y)

    self.x = virtual_width

    self.y = y

    gap_height = math.random(80,100)

    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + gap_height + pipe_height)
    }

    self.remove = false

    self.scored = false
end

function Pipepair:update(dt)

    if self.x > -pipe_width then
        self.x = self.x - pipe_scrolling_speed * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end

function Pipepair:draw()
    for k, pipe in pairs(self.pipes) do
        pipe:draw()
    end
end