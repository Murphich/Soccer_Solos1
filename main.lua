require "CiderDebugger";
---------------------
--Hide the status bar
--------------------- 
display.setStatusBar(display.HiddenStatusBar)

---------------------
--Implement Physics
---------------------
local physics = require "physics"
physics.start()

-------------------------
--Declare Local variables
-------------------------
local myBall
local startBtn
local floor
local score
local total
local kick = audio.loadSound("Football_kick.mp3")
local bgSound = audio.loadSound("Stadium.mp3")
local newMess

-------------------------
--Declare Local Functions
-------------------------
local Main = {}
local startBtnListeners = {}
local beginGame = {}
local gameListeners = {}
local onTap = {}
local onBounce = {}
local result = {}
local theCreditsListener = {}
local showTitle = {}

-------------------------
-- Main Function
-------------------------
function Main()
    --Create start button and change colour
     startBtn = display.newText("Start", 225, 150, native.systemFont, 42)
     startBtn:setFillColor(1,0,1)
     startBtnListeners("tap")
end

---------------------------
-- Implement Game Listeners
---------------------------
function startBtnListeners(action)
    if (action == "tap")then
        startBtn:addEventListener("tap", beginGame)
    end
end

-------------------------
-- Begin the Game Function
-------------------------
function beginGame()
    --Create background image & center it
    local background = display.newImage("gameBg.png")
    background.x = display.contentWidth/2
    background.y = display.contentHeight/2
   
    --Implement Background sound with 1 loop
    audio.play(bgSound, {channel=2, loops=1, onComplete=audioEnded})

    --Create ball
    myBall = display.newCircle(100, 220, 21)
    myBall:setFillColor(.2,.012,.012)
    
    --Add Physics to the ball so it will fall
    physics.addBody( myBall, "dynamic")

    --Implement Score counter and place to bottom left
    score = display.newText("0", 62, 305, "Times New Roman", 16)
    score:setTextColor(255, 200, 0)
    
    --Create a floor
    floor = display.newRect(100, 320, 850, 10)
    floor:setFillColor(0.0, 1.0 ,0.0)
    --Add physics to the floor
    physics.addBody(floor, "static")
    
    --Add game listeners to activate functions within the game
    gameListeners("add")
end

----------------------------------
--Implement gameListeners Function
----------------------------------
function gameListeners(action)
	if(action == "add") then
                -- Listen for events
		myBall:addEventListener("tap", onTap)
		floor:addEventListener("collision", onBounce)
        
        else
                --Remove listeners based on events
		myBall:removeEventListener("collision", onTap)
		floor:removeEventListener("collision", onBounce)
                bgSound:removeEventListener("collision", onBounce)
	end
end

-----------------------------------------
--Implement function for tapping the ball
-----------------------------------------
function onTap(n)
        -- Implement audio sound for the kick
	audio.play(kick, {channel=1, loops=0, duration= 1000, onComplete=audioEnded})
        --generate force on the ball
	myBall:applyForce((myBall.x - n.x) * 0.1, -6, myBall.x, myBall.y)
	-- Update Score	and convert int to string
	score.text = tostring(tonumber(score.text) + 1)
        
        --Implement Messages based on Score
            if (tonumber(score.text) == 4)then
                newMess = display.newText("Keep Going!", 250, 60, native.systemFont, 42)
                newMess:setFillColor(255, 69, 0)
                --transition so the message fades out after 1 second
                transition.to(newMess, {time = 1000, alpha = 0})    
            elseif (tonumber(score.text) == 10)then
                newMess = display.newText("WoW!", 250, 60, native.systemFont, 42)
                newMess:setFillColor(255, 69, 0)
                --transition so the message fades out after 1.1 seconds
                transition.to(newMess, {time = 1100, alpha = 0}) 
            elseif (tonumber(score.text) == 15)then
                newMess = display.newText("Stop Showing Off!", 250, 60, native.systemFont, 42)
                newMess:setFillColor(255, 69, 0)
                --transition so the message fades out after 1.3 seconds
                transition.to(newMess, {time = 1300, alpha = 0}) 
            end
end

------------------------------------------------------------
--Implement function to finish game when the ball is dropped
------------------------------------------------------------
function onBounce(n)
    -- make sure user score more than 1 point
    if(tonumber(score.text) > 1) then
        result(score.text)
    end
    score.Text = 0
end

--------------------------------------------
--Implement function for finishing the game
--------------------------------------------
function result()
    -- Display Game Over message
    total = display.newText("Game Over", 250, 80, system.nativeFont, 30)
    total:setFillColor(1, .122,.111)
    -- Change score colour to red on result
    score:setFillColor(1, .122,.111) 
    -- End physics and music on dropping
    timer.performWithDelay(500,
        function() 
            physics.stop() audio.pause() 
        end)
        --display Finish button
        credits = display.newText("Finish", 70, 120)
        credits:setFillColor(.067, .057, .057)
        credits.alpha = 0
        --Transistion the finish button to appear after half a second
        transition.to(credits, {time = 500, alpha = 1})
        -- Add credits Listener
        credits:addEventListener("tap", theCreditsListener)
end

--------------------------------------
--Build a spritesheet for end of game
--------------------------------------
function theCreditsListener()
    --Width, Height & numFrames based on the dimensions of the SS.
    local options =
    {
        width = 50,
        height =72,
        numFrames = 10
    }
    --Implement sprite sheet
    local waveSheet = graphics.newImageSheet("duke_spritesheet.png", options)
    
    --Outline the waving sequence of the SS
    local waveSequenceData =
    {
        name = "waving",
        start = 1, 
        count = 10,
        time = 1000,
        loopCount = 0,
        loopDirection = "forward"
    }
    --Location of the display of the SS 
    local wave = display.newSprite(waveSheet,waveSequenceData)
    wave:setSequence("waving")
    wave.x, wave.y = 10, 200
    --transition SS to move accross the scree to the center
    transition.to(wave, { x= 250, time = 2000, onComplete = showTitle})
    wave:play()
end

---------------------------
-- Implement final Function
---------------------------
function showTitle()
    --Display message with final score
    local myText = display.newText("Thanks for playing, Your score is: " .. (tonumber(score.text)), 250, 140, "Times New Roman" )
    myText:setFillColor(1,0,1)
    myText.alpha = 0
    myText:scale(4,4)
    --transition message from above setting to full clarity and new x & y scales
    transition.to(myText, {time = 1000, alpha = 1, xScale = 2, yScale = 2})
end
  
--Run Main
Main()



