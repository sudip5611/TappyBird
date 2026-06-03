-- library that handles virtual resolution
push = require 'push'

-- helper class
class = require 'class'

require 'Bird'

require 'Pipe'

require 'Pipepair'

require 'Statemachine'

require 'states.BaseState'

require 'states.PlayState'

require 'states.TitleState'

require 'states.ScoreState'

require 'states.CountdownState'

-- actual screen resoltion
window_width = 1280
window_height = 720

-- virtual screen resoltion
virtual_width = 512
virtual_height = 288

-- background scrolling start position 
local background_scroll = 0

-- ground scrolling start position
local ground_scroll = 0

-- backgroung and ground image scrolling speed
local background_scrolling_speed = 24
local ground_scrolling_speed = 56

-- point where we repeat our background back to 0
local background_looping_point = 973.8

-- scrolling is true upto collision
scroll = true

function love.load()
    bgm = love.audio.newSource('music.mp3', 'stream')
    bgm:setLooping(true)
    bgm:setVolume(0.35)
    bgm:play()

    countdown_sound = love.audio.newSource('countdown.wav', 'static')

    jump = love.audio.newSource('jump.wav', 'static')
    jump:setVolume(0.65)

    point = love.audio.newSource('point.wav', 'static')

    over = love.audio.newSource('over.wav', 'static')

    -- nearest neighbouring filter
    love.graphics.setDefaultFilter('nearest','nearest')

    -- window title
    love.window.setTitle('Tappy Bird')

    -- load images to draw
    background = love.graphics.newImage('background.png')
    ground = love.graphics.newImage('ground.png')

    -- load medal images
    bronze = love.graphics.newImage('bronze.png')
    silver = love.graphics.newImage('silver.png')
    gold = love.graphics.newImage('gold.png')
    diamond = love.graphics.newImage('diamond.png')

    titlefont = love.graphics.newFont('titlefont.ttf', 56)
    overfont = love.graphics.newFont('overfont.ttf', 47)
    playfont = love.graphics.newFont('playfont.ttf', 21)
    scorefont = love.graphics.newFont('titlefont.ttf', 29)

    -- setup virtual and actual resolution allows resizing and enables vsync
    push:setupScreen( virtual_width, virtual_height, window_width, window_height,{
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- create statemachine and register all game states
    statemachine = Statemachine{
        
        -- titlestate creator
        ['title'] = function()
                        return TitleState()
                    end
                    ,
        -- playstate creator
        ['play'] = function()
                       return PlayState()
                   end
                   ,
        ['score'] = function()
                        return ScoreState()
                    end
                    ,
        ['countdown'] = function()
                            return CountdownState()
                        end
    }

    -- initialise the empty state to TitleState
    statemachine:change('title')

    -- initialisation of input table
    love.keyboard.keyspressed = {}

    if love.filesystem.getInfo('highscore.txt') then
        highscore = tonumber((love.filesystem.read('highscore.txt'))) or 0
    else
        highscore = 0
    end

end

-- keyboard input handling
function love.keypressed(key)

    -- corresponding value is true for the key which is pressed
    love.keyboard.keyspressed[key] = true

    -- close game when escape is pressed
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'p' and statemachine.current.togglePause then
        statemachine.current:togglePause()
    end
end

-- check if a key was pressed during current frame
function love.keyboard.waspressed(key)

    if love.keyboard.keyspressed[key] then
        return true
    else
        return false
    end
end

function love.resize(w,h)
    push:resize(w,h)
end

function love.update(dt)

    -- update background and ground image every frame
    if scroll == true and not statemachine.current.paused and not statemachine.current.freezescroll then

        background_scrolling_speed =
            background_scrolling_speed + 0.25 * dt

        ground_scrolling_speed =
            ground_scrolling_speed + 0.25 * dt

        background_scroll = ( background_scroll + background_scrolling_speed * dt) % background_looping_point
        ground_scroll = ( ground_scroll + ground_scrolling_speed * dt) % virtual_width
    end
    
    -- update current active gamestate
    statemachine:update(dt)

    -- reset input table to empty
    love.keyboard.keyspressed = {}
end

function love.draw()
    push:start()

    -- darws background starting at (0,0)
    love.graphics.draw( background, -background_scroll, 0)

    -- render everything belonging to the currently active state
    statemachine:draw()

    love.graphics.setColor(1,1,1,1)

    -- draws ground upon background starting at (0,virtual_height-16)
    love.graphics.draw(ground, -ground_scroll, virtual_height - 16)

    if statemachine.current.paused then
        love.graphics.setFont(titlefont)
        love.graphics.setColor(0,0,0,1)
        love.graphics.printf('Game Paused', 0, virtual_height/2 - 30, virtual_width,'center')
        love.graphics.printf('Game Paused', 0, virtual_height/2 - 26, virtual_width,'center')
        love.graphics.printf('Game Paused', 0, virtual_height/2 - 28, virtual_width - 4,'center')
        love.graphics.printf('Game Paused', 0, virtual_height/2 - 28, virtual_width + 4,'center')

        love.graphics.setColor(1,1,1,1)
        love.graphics.printf('Game Paused', 0, virtual_height/2 - 28, virtual_width,'center')

        love.graphics.setFont(playfont)
        love.graphics.setColor(0,0,0,1)
        love.graphics.printf('Press P to Resume', 0, 20, virtual_width,'center')
        love.graphics.setColor(1,1,1,1)
    end

    push:finish()
end