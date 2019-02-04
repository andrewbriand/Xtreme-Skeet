require 'Player'
require 'Pigeon'
require 'Bullet'
require 'Fragment'
require 'Physics'
require 'PigeonLauncher'
require 'PowerUp'
require 'GoldPigeon'

POINTS_REQUIRED = 50

function resetGame()
	objects = {}
	objects.pigeons   = {}
	objects.bullets   = {}
	objects.fragments = {}
	objects.powerUps = {}
	objects.goldPigeons = {}
	objects.pigeonLauncher = {}
	table.insert(objects.pigeonLauncher, PigeonLauncher)
	objects.players   = {}
	table.insert(objects.players, Player("Andrew", 1))
	table.insert(objects.players, Player("David", 2))
	physics = Physics()
	
	loadPigeonLauncher()
	
	currentMusic = love.audio.newSource(menuMusic, "static")
	currentMusic:setLooping(true)
	currentMusic:play()
	MUSIC_VOLUME = .3
	currentMusic:setVolume(MUSIC_VOLUME)
	
	gameState = "menu" -- "menu", "game", "controls", "won"
	menuTimer = 0
	selectedMenu = 0
	beginText = "Begin"
	winnerLength = 2.7
end

function love.load()
	load()
	
	globalTimer = 0
	
	drawTimer = 0
	SCREEN_WIDTH = love.graphics.getWidth() -- screen width
	SCREEN_HEIGHT = love.graphics.getHeight() -- screen height
	love.graphics.setBackgroundColor(89/255,100/255,105/255)
	
	resetGame()
	
	-- fonts
	fonts = {}
	for i = 1, 100 do
		table.insert(fonts, love.graphics.newFont(i))
	end
	controlsFont = love.graphics.newFont(21)
	scoreFont = love.graphics.newFont(30)
	menuFont = fonts[50]
end

function love.keypressed(k)
	if gameState == "game" then
		if k == 'escape' then
			gameState = "menu"
			beginText = "Resume"
			currentMusic:stop()
			currentMusic = love.audio.newSource(menuMusic, "static")
			currentMusic:setLooping(true)
			currentMusic:play()
			currentMusic:setVolume(MUSIC_VOLUME)
		end
	elseif gameState == "menu" then
		if k == 'up' or k == objects.players[1].controls.selectUp or k == objects.players[2].controls.selectUp then
			if selectedMenu > 0 then
				selectedMenu = selectedMenu - 1
				love.audio.newSource(menuSound, "static"):play()
			end
		end
		if k == 'down' or k == objects.players[1].controls.selectDown or k == objects.players[2].controls.selectDown then
			if selectedMenu < 2 then
				selectedMenu = selectedMenu + 1
				love.audio.newSource(menuSound, "static"):play()
			end
		end
		if k == 'return' then
			if selectedMenu == 0 then
				gameState = "game"
				gameWon = false
				currentMusic:stop()
				currentMusic = love.audio.newSource(gameMusic, "static")
				currentMusic:setLooping(true)
				currentMusic:play()
				currentMusic:setVolume(MUSIC_VOLUME)
			elseif selectedMenu == 1 then
				gameState = "controls"
			elseif selectedMenu == 2 then
				love.event.quit()
			end
			love.audio.newSource(menuSound, "static"):play()
		end
		if k == 'escape' then
			love.event.quit()
		end
	elseif gameState == "controls" then
		gameState = "menu"
		love.audio.newSource(menuSound, "static"):play()
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
	globalTimer = globalTimer + dt
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
	
	updatePoints(dt)
	updateWinner(dt)
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
		
		drawPoints()
	elseif gameState == "menu" then
		love.graphics.setColor(1,1,1,1)
		local scale = math.min(SCREEN_WIDTH/titleScreen:getWidth(),SCREEN_HEIGHT/titleScreen:getHeight())
		local x = (SCREEN_WIDTH-titleScreen:getWidth()*scale)/2
		local y = (SCREEN_HEIGHT-titleScreen:getHeight()*scale)/2
		love.graphics.draw(titleScreen, x, y, 0, scale)
		drawButtons()
		drawGameWinner()
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
		
		love.graphics.print("Try to shoot the clay pigeons.",0,text:getHeight() * 10)
		love.graphics.print("Every pigeon you shoot is worth one point.",0,text:getHeight() * 11)
		love.graphics.print("If you shoot your oponent directly, you loose one point.",0,text:getHeight() * 12)
		love.graphics.print("If the fragments from a shot pigeon hit your opponent, you gain one point.",0,text:getHeight() * 13)
		love.graphics.print("The first player to get " .. POINTS_REQUIRED .. " points wins.",0,text:getHeight() * 14)
		
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
			xDiff =  math.floor(2 * math.sqrt(4/3) * math.sin(8 * math.pi / 3 * math.ceil(i/3)) + .5) -- don't mind the magic equations
			yDiff =  math.floor(2 * math.sqrt(4/3) * math.sin(8 * math.pi / 3 * (i%3)         ) + .5)
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
		love.graphics.setColor({objects.players[2].color[1]*brightness + (1 - brightness) *  waveFactor,
								objects.players[2].color[2]*brightness + (1 - brightness) * waveFactor,
								objects.players[2].color[3]*brightness + (1 - brightness) * waveFactor})
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

function load()
	-- images
	background  = love.graphics.newImage("images/grass.jpg")
	titleScreen = love.graphics.newImage("images/title screen.png")
	smokeImage  = love.graphics.newImage("images/smoke.png")
	fireImage   = love.graphics.newImage("images/fire 2.png")
	pigeonImage = love.graphics.newImage("images/pigeon.png")
	seekPowerUpImage = love.graphics.newImage("images/powerup.png")
	
	-- sounds
	grunt1             = love.sound.newSoundData("sounds/grunt 1.mp3")
	grunt2             = love.sound.newSoundData("sounds/grunt 2.mp3")
	shotgunSound       = love.sound.newSoundData("sounds/shotgun.mp3")
	pigeonLauncerSound = love.sound.newSoundData("sounds/pigeon launcher.mp3")
	clickSound         = love.sound.newSoundData("sounds/Gun_Click.mp3")
	pigeonBreakSound   = love.sound.newSoundData("sounds/pigeon break.mp3")
	menuSound          = love.sound.newSoundData("sounds/menu select.mp3")
	congrad1          = love.sound.newSoundData("sounds/congrad 1.mp3")
	congrad2          = love.sound.newSoundData("sounds/congrad 2.mp3")
	
	-- music
	menuMusic          = love.sound.newSoundData("sounds/menu music.mp3")
	gameMusic          = love.sound.newSoundData("sounds/game music.mp3")
end

function updateWinner(dt)
	if not gameWon then
		for i = 1, 2 do
			if (objects.players[i].score >= POINTS_REQUIRED) then
				love.audio.stop()
				resetGame()
				gameWon = i
				love.audio.newSource(objects.players[i].congrad, "static"):play()
--				gameState = "menu"
--				beginText = "Begin"
--				menuTimer = 0
--				objects.players[1].score = 0
--				objects.players[2].score = 0
			end
		end
	end
	menuTimer = menuTimer + dt
end

function drawGameWinner()
	for i = 1, 2 do
		if gameWon == i and menuTimer < winnerLength then
			love.graphics.setColor(objects.players[i].color)
			text = love.graphics.newText(fonts[100], "WNNER:")
			love.graphics.printWithBoarder("WNNER: \n" .. objects.players[i].name,SCREEN_WIDTH/2-text:getWidth()/2,SCREEN_HEIGHT/3,100,objects.players[i].color,{1,1,1,1},2)
		end
	end
end