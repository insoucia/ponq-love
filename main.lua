WINDOW_WIDTH=1280
WINDOW_HEIGHT=720

VIRTUAL_WIDTH= 432
VIRTUAL_HEIGHT=243

PADDLE_SPEED = 200

push = require 'push'

function love.load()

    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest','nearest')
    
    smallfont = love.graphics.newFont('/fonts/PixelifySans-Medium.ttf')
    
    scorefont = love.graphics.newFont('fonts/PixelifySans-Bold.ttf', 32)
    
    player1Score=0
    player2Score=0

    player1Y =30
    player2Y= VIRTUAL_HEIGHT-50

    ballX = VIRTUAL_WIDTH/2-2
    ballY = VIRTUAL_HEIGHT/2-2

    ballDX = math.random(2) == 1 and -100 or 100
    ballDY= math.random(-50,50)

    gamestate = 'start'


    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen = false,
        vsync = true,
        resizable=false
    })
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        player1Y= math.max(1, player1Y-PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        player1Y= math.min(VIRTUAL_HEIGHT-22,player1Y+PADDLE_SPEED * dt)
    end

    if love.keyboard.isDown('up') then
        player2Y= math.max(1,player2Y-PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then
        player2Y= math.min(VIRTUAL_HEIGHT-22,player2Y+PADDLE_SPEED * dt)
    end    

    if gamestate == 'play' then
        ballX = ballX+ ballDX*dt
        ballY = ballY+ballDY*dt
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
            ballX = VIRTUAL_WIDTH/2-2
            ballY = VIRTUAL_HEIGHT/2-2

            ballDX = math.random(2) == 1 and -100 or 100
            ballDY= math.random(-50,50)
        end
    end
end

function love.draw()
    push:apply('start')
    love.graphics.clear(40/255,45/255,52/255,1)

    love.graphics.rectangle('fill',ballX,ballY,5,5)
    love.graphics.rectangle('fill',5,player1Y,5,20)
    love.graphics.rectangle('fill',VIRTUAL_WIDTH-10, player2Y,5,20)
    love.graphics.setFont(smallfont)
    if gamestate == 'start' then
        love.graphics.printf("Ponq", 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gamestate == 'play' then
        love.graphics.printf("Score", 0, 20, VIRTUAL_WIDTH, 'center')
    end
        love.graphics.setFont(scorefont)
    love.graphics.print(player1Score, VIRTUAL_WIDTH /2 -50, VIRTUAL_HEIGHT/3)
    love.graphics.print(player2Score,VIRTUAL_WIDTH /2 +30,VIRTUAL_HEIGHT/3)
    push:apply('end')
end
