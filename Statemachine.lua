Statemachine = class{}

function Statemachine:init(states)
    self.empty = {
        enter = function()
                end
                ,
        exit = function()
               end
               ,
        AI = function()
             end
             ,
        update = function()
                 end
                 ,
        draw = function()
               end
    }

    self.states = states or {}
    self.current = self.empty
end

-- switch from current state to a new state
function Statemachine:change(statename, statedata)

    -- check if requested state exists
    assert(self.states[statename])

    -- exit current active state
    self.current:exit()

    -- create and switch to new state
    self.current = self.states[statename]()

    -- initialize new state with optional parameters
    self.current:enter(statedata)
end

function Statemachine:update(dt)

    self.current:update(dt)
end

function Statemachine:draw()
    self.current:draw()
end

function Statemachine:AI(data, dt)
	self.current:AI(data, dt)
end