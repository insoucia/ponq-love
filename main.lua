WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

BALL_SIZE = 5

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
    victoryFont = love.graphics.newFont('/fonts/PixelifySans-Bold.ttf')
    scorefont = love.graphics.newFont('fonts/PixelifySans-Regular.ttf', 32)
    
    sounds = {
        ['paddle_hit'] = love.audio.newSource('/audio/paddle_hit.wav','static'),
        ['point_scored'] = love.audio.newSource('/audio/point_scored.wav','static'),
        ['wall_hit'] = love.audio.newSource('/audio/wall_hit.wav','static'),
        ['win_game'] = love.audio.newSource('/audio/win_game.wav','static')
    }
    player1Score=0
    player2Score=0

    servingPlayer = math.random(2) == 1 and 2

    winner = 0

    paddle1 =Paddle(5,20,5,20)
    paddle2 =Paddle(VIRTUAL_WIDTH -10, VIRTUAL_HEIGHT-30,5,20)
    ball =Ball(VIRTUAL_WIDTH/2-2,VIRTUAL_HEIGHT/2-2, BALL_SIZE, BALL_SIZE)
    
    gamestate = 'start'


    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen = false,
        vsync = true,
        resizable=true
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)

     if ball:collides(paddle1) then
        print("Collision with paddle1")
        ball.dx = -ball.dx
        sounds['paddle_hit']:play()
    end

    if ball:collides(paddle2) then
        print("Collision with paddle2")
        ball.dx = -ball.dx
        sounds['paddle_hit']:play()
    end

    if ball.y <= 0 then
        ball.dy = -ball.dy
        ball.y = 0
        sounds['wall_hit']:play()
    end

    if ball.y >= VIRTUAL_HEIGHT-BALL_SIZE then
        ball.dy = -ball.dy
        ball.y = VIRTUAL_HEIGHT-BALL_SIZE
        sounds['wall_hit']:play()
    end

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
            if ball.x <= 0 then
                player2Score = player2Score +1
                ball:reset()
                servingPlayer = 1
                ball.dx = 300
                sounds['point_scored']:play()
                if player2Score >= 10 then
                    gamestate = 'victory'
                    winner = 2
                    sounds['win_game']:play()
                else
                    gamestate= 'serve'
                end
            end

            if ball.x >= VIRTUAL_WIDTH - BALL_SIZE then
                player1Score = player1Score + 1
                ball:reset()
                servingPlayer  = 2
                ball.dx = -300
                sounds['point_scored']:play()
                if player1Score >= 10 then
                    gamestate = 'victory'
                    winner = 1
                    sounds['win_game']:play()
                else
                    gamestate = 'serve'
                end
            end
    end

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gamestate == 'start' or gamestate == 'serve' then 
            gamestate = 'play'
        elseif gamestate == 'victory' then
            gamestate = 'play'
            player1Score = 0
            player2Score = 0
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
        love.graphics.printf('Welcome to Ponq', 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Enter to Play', 0, 32, VIRTUAL_WIDTH, 'center')
    elseif gamestate == 'serve' then
        love.graphics.printf( "P " .. tostring(servingPlayer) .."'s serve", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Enter to Serve', 0, 32, VIRTUAL_WIDTH, 'center')
    elseif
        gamestate == 'victory' then
        love.graphics.setFont(victoryFont)
        love.graphics.printf( "P " .. tostring(winner) .." Wins!", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Enter to Play', 0, 32, VIRTUAL_WIDTH, 'center')
        
    end
    
    

    love.graphics.setFont(scorefont)
    love.graphics.print(player1Score, VIRTUAL_WIDTH /2 -70, 20-15)
    love.graphics.print(player2Score,VIRTUAL_WIDTH /2 +50,20-15)

    

    push:apply('end')
end

function displayFPS()
    love.graphics.setColor(0,255/255,255/255,255/255)
    love.graphics.setFont(smallfont)
    love.graphics.print('FPS:' .. tostring(love.timer.getFPS()),10,10)
    love.graphics.setColor(1,1,1,1)
end
