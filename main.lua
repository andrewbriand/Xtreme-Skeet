require 'Player'
require 'Pigeon'
require 'Bullet'
require 'Fragment'
require 'Physics'
require 'PigeonLauncher'
require 'PowerUp'

function love.load()
	drawTimer = 0
	SCREEN_WIDTH = love.graphics.getWidth() -- screen width
	SCREEN_HEIGHT = love.graphics.getHeight() -- screen height
	love.graphics.setBackgroundColor(89/255,100/255,105/255)
	
	objects = {}
	objects.pigeons   = {}
	objects.bullets   = {}
	objects.fragments = {}
	objects.powerUps = {}
	table.insert(objects.powerUps, PowerUp(50, 50, {x = 100, y = 100}))
	objects.pigeonLauncher = {}
	table.insert(objects.pigeonLauncher, PigeonLauncher)
	objects.players   = {}
	table.insert(objects.players, Player("Player 1", 1))
	table.insert(objects.players, Player("Player 2", 2))
	physics = Physics()
	
	-- fonts
	controlsFont = love.graphics.newFont(21)
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
	meunSound          = love.sound.newSoundData("menu select.mp3")
	
	gameState = "menu" -- "menu", "game", "controls"
	selectedMenu = 0
	beginText = "Begin"
end

function love.keypressed(k)
	if gameState == "game" then
		if k == 'escape' then
			gameState = "menu"
			beginText = "Resume"
				love.audio.newSource(meunSound, "static"):play()
		end
	elseif gameState == "menu" then
		if k == 'up' or k == objects.players[1].controls.selectUp or k == objects.players[2].controls.selectUp then
			if selectedMenu > 0 then
				selectedMenu = selectedMenu - 1
				love.audio.newSource(meunSound, "static"):play()
			end
		end
		if k == 'down' or k == objects.players[1].controls.selectDown or k == objects.players[2].controls.selectDown then
			if selectedMenu < 2 then
				selectedMenu = selectedMenu + 1
				love.audio.newSource(meunSound, "static"):play()
			end
		end
		if k == 'return' then
			if selectedMenu == 0 then
				gameState = "game"
			elseif selectedMenu == 1 then
				gameState = "controls"
			elseif selectedMenu == 2 then
				love.event.quit()
			end
			love.audio.newSource(meunSound, "static"):play()
		end
		if k == 'escape' then
			love.event.quit()
		end
	elseif gameState == "controls" then
		gameState = "menu"
		love.audio.newSource(meunSound, "static"):play()
	end
end

function love.resize(w, h)
	SCREEN_WIDTH = love.graphics.getWidth() -- screen width
	SCREEN_HEIGHT = love.graphics.getHeight() -- screen height
	
	-- player positions
	objects.players[1].x = SCREEN_WIDTH  / 4
	objects.players[1].y = SCREEN_HEIGHT / 2
	objects.players[2].x = SCREEN_WIDTH  / 4 * 3
	objects.players[2].y = SCREEN_HEIGHT / 2
	
	-- fonts
	controlsFont = love.graphics.newFont(math.min(SCREEN_WIDTH/800,SCREEN_HEIGHT/600)*21)
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
	drawTimer = dt + drawTimer
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
		love.graphics.setFont(controlsFont)
		text = love.graphics.newText(controlsFont, "1")
		
		love.graphics.print("Player 1 controls:",0,text:getHeight() * 0)
		love.graphics.print("	Aim: " .. objects.players[1].controls.counterClockwise .. " " .. objects.players[1].controls.clockwise,0,text:getHeight() * 1)
		love.graphics.print("	Shoot: " .. objects.players[1].controls.shoot,0,text:getHeight() * 2)
		love.graphics.print("	Slow turn: " .. objects.players[1].controls.slow,0,text:getHeight() * 3)
		
		love.graphics.print("Player 2 controls:",0,text:getHeight() * 5)
		love.graphics.print("	Aim: " .. objects.players[2].controls.counterClockwise .. " " .. objects.players[2].controls.clockwise,0,text:getHeight() * 6)
		love.graphics.print("	Shoot: " .. objects.players[2].controls.shoot,0,text:getHeight() * 7)
		love.graphics.print("	Slow turn: " .. objects.players[2].controls.slow,0,text:getHeight() * 8)
		
		love.graphics.print("Try to shoot the clay pigeons",0,text:getHeight() * 10)
		love.graphics.print("Every pigeon you shoot is worth one point",0,text:getHeight() * 11)
		love.graphics.print("If you shoot your oponent directly, you loose one point",0,text:getHeight() * 12)
		love.graphics.print("If the fragments from a shot pigeon hit your opponent, you gain one point",0,text:getHeight() * 13)
		
		love.graphics.print("Press any key to return to the menu",0,text:getHeight() * 16)
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
		waveFactor = (math.sin(drawTimer*10) + 1.5)/2
		love.graphics.setColor({objects.players[1].color[1]*brightness + (1 - brightness) *  waveFactor,
								objects.players[1].color[2]*brightness + (1 - brightness) * waveFactor,
								objects.players[1].color[3]*brightness + (1 - brightness) * waveFactor})
		love.graphics.print(objects.players[1].powerUpName, 0, text:getHeight())
		text = love.graphics.newText(scoreFont, objects.players[2].name .. "'s score: 99")
		
		-- players 2 score
		love.graphics.setColor({objects.players[2].color[1]*brightness + (1 - brightness),
								objects.players[2].color[2]*brightness + (1 - brightness),
								objects.players[2].color[3]*brightness + (1 - brightness)})
		love.graphics.print(objects.players[2].name .. "'s score: " .. objects.players[2].score,SCREEN_WIDTH-text:getWidth(),0)
		love.graphics.print(objects.players[2].powerUpName, SCREEN_WIDTH - text:getWidth(), text:getHeight())
		
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
	love.graphics.print(beginText,   titleScreen:getWidth()*scale*xPos+x,titleScreen:getHeight()*scale*yPos+y + text:getHeight() * 0 * scale)
	love.graphics.print("Controls",titleScreen:getWidth()*scale*xPos+x,titleScreen:getHeight()*scale*yPos+y + text:getHeight() * 1 * scale)
	love.graphics.print("Exit",    titleScreen:getWidth()*scale*xPos+x,titleScreen:getHeight()*scale*yPos+y + text:getHeight() * 2 * scale)
	
	love.graphics.setLineWidth(3)
	love.graphics.rectangle("line",titleScreen:getWidth()*scale*xPos+x,
								titleScreen:getHeight()*scale*yPos+y + text:getHeight() * selectedMenu * scale,
								text:getWidth()+1,
								text:getHeight()+1)
end