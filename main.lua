WINDOW_WIDTH=1280
WINDOW_HEIGHT=720

VIRTUAL_WIDTH= 432
VIRTUAL_HEIGHT=243

PADDLE_SPEED = 200

Class = require 'class'
push = require 'push'
require 'Paddle'
require 'Ball'

function love.load()
    love.window.setTitle('ponq')
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest','nearest')
    
    smallfont = love.graphics.newFont('/fonts/PixelifySans-Medium.ttf')
    
    scorefont = love.graphics.newFont('fonts/PixelifySans-Bold.ttf', 32)
    
    player1Score=0
    player2Score=0

    paddle1 =Paddle(5,20,5,20)
    paddle2 =Paddle(VIRTUAL_WIDTH -10, VIRTUAL_HEIGHT-30,5,20)
    ball =Ball(VIRTUAL_WIDTH/2-2,VIRTUAL_HEIGHT/2-2)
    
    gamestate = 'start'


    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen = false,
        vsync = true,
        resizable=false
    })
end

function love.update(dt)

    paddle1:update(dt)
    paddle2:update(dt)

    if love.keyboard.isDown('w') then
        paddle1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        paddle1.dy = PADDLE_SPEED
    else
        paddle1.dy = 0
    end

    if love.keyboard.isDown('up') then
        paddle2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        paddle2.dy =PADDLE_SPEED
    else
        paddle2.dy = 0
    
    end    

    if gamestate == 'play' then
        ball:update(dt)
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gamestate == 'start' then 
            gamestate = 'play'
        elseif gamestate == 'play' then
            gamestate = 'start'
            ball:reset()
        end
    end
end

function love.draw()
    push:apply('start')
    love.graphics.clear(40/255,45/255,52/255,1)

    ball:render()
    displayFPS()
    paddle1:render()
    paddle2:render()
    love.graphics.setFont(smallfont)
    if gamestate == 'start' then
        love.graphics.printf("Ponq", 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gamestate == 'play' then
        love.graphics.printf("Score", 0, 20, VIRTUAL_WIDTH, 'center')
    end
        love.graphics.setFont(scorefont)
    love.graphics.print(player1Score, VIRTUAL_WIDTH /2 -50, 20-15)
    love.graphics.print(player2Score,VIRTUAL_WIDTH /2 +30,20-15)

    

    push:apply('end')
end

function displayFPS()
    love.graphics.setColor(0,255/255,255/255,255/255)
    love.graphics.setFont(smallfont)
    love.graphics.print('FPS:' .. tostring(love.timer.getFPS()),10,10)
    love.graphics.setColor(1,1,1,1)
end
