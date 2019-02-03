require 'Player'
require 'Pigeon'
require 'Bullet'
require 'Fragment'
require 'Physics'
require 'PigeonLauncher'

function love.load()
	SCREEN_WIDTH = love.graphics.getWidth() --Screen width
	SCREEN_HEIGHT = love.graphics.getHeight() --Screen height
	love.graphics.setBackgroundColor(89/255,100/255,105/255)
	
	objects = {}
	objects.pigeons   = {}
	objects.bullets   = {}
	objects.fragments = {}
	objects.powerUps = {}
	table.insert(objects.powerUps, PowerUp(50, 50, {x = 1, y = -1}))
	objects.pigeonLauncher = {}
	table.insert(objects.pigeonLauncher, PigeonLauncher)
	objects.players   = {}
	table.insert(objects.players, Player("Player 1", 1))
	table.insert(objects.players, Player("Player 2", 2))
	physics = Physics()
	
	-- fonts
	scoreFont = love.graphics.newFont(30)
	menuFont = love.graphics.newFont(50)
	
	-- images
	background  = love.graphics.newImage("grass.jpg")
	titleScreen = love.graphics.newImage("title screen.png")
	
	-- sounds
	shotgunSound       = love.sound.newSoundData("shotgun.mp3")
	pigeonLauncerSound = love.sound.newSoundData("pigeon launcher.mp3")
	clickSound         = love.sound.newSoundData("Gun_Click.mp3")
	pigeonBreakSound   = love.sound.newSoundData("pigeon break.mp3")
	
	gameState = "game" -- "menu", "game"
	selectedMenu = 0
end

function love.keypressed(k)
	if k == 'escape' then
		love.event.quit()
	end
	if gameState == "game" then
	elseif gameState == "menu" then
		if k == 'up' or k == objects.players[1].controls.selectUp or k == objects.players[2].controls.selectUp then
			selectedMenu = selectedMenu - 1
		end
		if k == 'down' or k == objects.players[1].controls.selectDown or k == objects.players[2].controls.selectDown then
			selectedMenu = selectedMenu + 1
		end
		if k == 'return' then
			if selectedMenu == 0 then
				gameState = "game"
			elseif selectedMenu == 1 then
				gameState = "controls"
			elseif selectedMenu == 2 then
				love.event.quit()
			end
		end
	elseif gameState == "controls" then
		gameState = "menu"
	end
end

function love.resize(w, h)
	SCREEN_WIDTH = love.graphics.getWidth() --Screen width
	SCREEN_HEIGHT = love.graphics.getHeight() --Screen height
	
	objects.players[1].x = SCREEN_WIDTH  / 4
	objects.players[1].y = SCREEN_HEIGHT / 2
	objects.players[2].x = SCREEN_WIDTH  / 4 * 3
	objects.players[2].y = SCREEN_HEIGHT / 2
	
	scoreFont = love.graphics.newFont(math.min(SCREEN_WIDTH/800,SCREEN_HEIGHT/600)*30)
	menuFont = love.graphics.newFont(math.min(SCREEN_WIDTH/800,SCREEN_HEIGHT/600)*50)
end

function love.update(dt)
	if gameState == "game" then
		physics:update(dt)
		for key, t in pairs(objects) do
			for key2, obj in pairs(t) do 
				obj:update(dt)
			end
		end
	elseif gameState == "menu" then
	end
end

function love.draw()
	if gameState == "game" then
		-- draw background
		love.graphics.setColor(1,1,1)
		love.graphics.draw(background,0,0,0,SCREEN_WIDTH/background:getWidth())
		
		-- draw score board
		drawScoreBoard()

		-- draw objects
		for key, t in pairs(objects) do 
			for key2, obj in pairs(t) do 
				obj:draw()
			end
		end
	elseif gameState == "menu" then
		local scale = math.min(SCREEN_WIDTH/titleScreen:getWidth(),SCREEN_HEIGHT/titleScreen:getHeight())
		local x = (SCREEN_WIDTH-titleScreen:getWidth()*scale)/2
		local y = (SCREEN_HEIGHT-titleScreen:getHeight()*scale)/2
		love.graphics.draw(titleScreen, x, y, 0, scale)
		drawButtons()
	elseif gameState == "controls" then
		love.graphics.setFont(scoreFont)
		love.graphics.print("Player 1 controls:")
		love.graphics.print("Press any key to return to the menu")
		love.graphics.print("Press any key to return to the menu")
	end
end

function drawScoreBoard()
	-- draw score
	do
		-- boarders of both scores
		love.graphics.setFont(scoreFont)
		for i = 1, 8 do
			love.graphics.setColor(0,0,0)
			xDiff =  math.floor(2*1.1547 * math.sin(8.37758 * math.ceil(i/3)) + .5) -- don't mind the magic equations
			yDiff =  math.floor(2*1.1547 * math.sin(8.37758 * (i%3)) + .5)
			love.graphics.print(objects.players[1].name .. "'s score: " .. objects.players[1].score,xDiff,yDiff)
			text = love.graphics.newText(scoreFont, objects.players[2].name .. "'s score: 99")
			love.graphics.print(objects.players[2].name .. "'s score: " .. objects.players[2].score,SCREEN_WIDTH-text:getWidth() + xDiff,yDiff)
			
			-- draw round
			roundString = "Round: " .. objects.pigeonLauncher[1].round
			text = love.graphics.newText(scoreFont, roundString)
			love.graphics.print(roundString,SCREEN_WIDTH/2-text:getWidth()/2 + xDiff,yDiff)
		end
		
		brightness = .2 -- 0 is white, 1 is the original color
		-- players 1 score
		love.graphics.setColor({objects.players[1].color[1]*brightness + (1 - brightness),
								objects.players[1].color[2]*brightness + (1 - brightness),
								objects.players[1].color[3]*brightness + (1 - brightness)})
		love.graphics.print(objects.players[1].name .. "'s score: " .. objects.players[1].score,0,0)
		text = love.graphics.newText(scoreFont, objects.players[2].name .. "'s score: 99")
		
		-- players 2 score
		love.graphics.setColor({objects.players[2].color[1]*brightness + (1 - brightness),
								objects.players[2].color[2]*brightness + (1 - brightness),
								objects.players[2].color[3]*brightness + (1 - brightness)})
		love.graphics.print(objects.players[2].name .. "'s score: " .. objects.players[2].score,SCREEN_WIDTH-text:getWidth(),0)
		
		-- round number
		love.graphics.setColor(1,1,1)
		roundString = "Round: " .. objects.pigeonLauncher[1].round
		text = love.graphics.newText(scoreFont, roundString)
		love.graphics.print(roundString,SCREEN_WIDTH/2-text:getWidth()/2)
	end
end

function drawButtons()
	love.graphics.setFont(menuFont)
	local scale = math.min(SCREEN_WIDTH/titleScreen:getWidth(),SCREEN_HEIGHT/titleScreen:getHeight())
	local x = (SCREEN_WIDTH-titleScreen:getWidth()*scale)/2
	local y = (SCREEN_HEIGHT-titleScreen:getHeight()*scale)/2
	
	text = love.graphics.newText(menuFont, "Controls")
	
	local xPos = .55
	local yPos = .6
	love.graphics.print("Begin",   titleScreen:getWidth()*scale*xPos+x,titleScreen:getHeight()*scale*yPos+y + text:getHeight() * 0 * scale)
	love.graphics.print("Controls",titleScreen:getWidth()*scale*xPos+x,titleScreen:getHeight()*scale*yPos+y + text:getHeight() * 1 * scale)
	love.graphics.print("Exit",    titleScreen:getWidth()*scale*xPos+x,titleScreen:getHeight()*scale*yPos+y + text:getHeight() * 2 * scale)
	
	love.graphics.setLineWidth(3)
	love.graphics.rectangle("line",titleScreen:getWidth()*scale*xPos+x,
								titleScreen:getHeight()*scale*yPos+y + text:getHeight() * selectedMenu * scale,
								text:getWidth()+1,
								text:getHeight()+1)
end