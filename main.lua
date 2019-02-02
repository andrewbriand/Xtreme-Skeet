require 'Player'
require 'Pigeon'
require 'Bullet'
require 'Fragment'
require 'Physics'
require 'PigeonLauncher'

function love.load()
	SCREEN_WIDTH = love.graphics.getWidth() --Screen width
	SCREEN_HEIGHT = love.graphics.getHeight() --Screen height
	
	objects = {}
	objects.pigeonLauncher = {}
	table.insert(objects.pigeonLauncher, PigeonLauncher)
	objects.pigeons = {}
	table.insert(objects.pigeons, Pigeon(50, 50, {x = 20, y = 64}))
	objects.players = {}
	table.insert(objects.players, Player("Player 1", 1))
	table.insert(objects.players, Player("Player 2", 2))
	objects.bullets = {}
	table.insert(objects.bullets, Bullet(100, 100, {x = -60, y = -64}))
	objects.fragments = {}
	table.insert(objects.fragments, Fragment(150, 150, {x = 80, y = 64}))
	objects.physics = {Physics()}
	--objects.pigeonLauncher = PigeonLauncher()=
	
	scoreFont = love.graphics.newFont(30)
	background = love.graphics.newImage("grass.jpg")
	shotgunSound = love.sound.newSoundData("shotgun.mp3")
	pigeonLauncerSound = love.sound.newSoundData("pigeon launcher.mp3")
end

function love.keypressed(k)
	if k == 'escape' then
		love.event.quit()
	end
end

function love.update(dt)
	for key, t in pairs(objects) do
		for key2, obj in pairs(t) do 
			obj:update(dt)
		end
	end
end

function love.draw()
	-- draw background
	love.graphics.setColor(1,1,1)
	love.graphics.draw(background)
	
	-- draw score
	do
		-- boarders of both scores
		love.graphics.setFont(scoreFont)
		love.graphics.setColor(0,0,0)
		for i = 1, 8 do
			xDiff =  math.floor(2*1.1547 * math.sin(8.37758 * math.ceil(i/3)) + .5) -- don't mind the magic equations
			yDiff =  math.floor(2*1.1547 * math.sin(8.37758 * (i%3)) + .5)
			love.graphics.print(objects.players[1].name .. "'s score: " .. objects.players[1].score,xDiff,yDiff)
			text = love.graphics.newText(scoreFont, objects.players[2].name .. "'s score: 99")
			love.graphics.print(objects.players[2].name .. "'s score: " .. objects.players[2].score,SCREEN_WIDTH-text:getWidth() + xDiff,yDiff)
		end
		
		brightness = .2 -- 0 is white, 1 is the original color
		-- players 1 score
		love.graphics.setColor({objects.players[1].color[1]*brightness + (1 - brightness),
								objects.players[1].color[2]*brightness + (1 - brightness),
								objects.players[1].color[3]*brightness + (1 - brightness)})
		love.graphics.print(objects.players[1].name .. "'s score: " .. objects.players[1].score,0,0)
		text = love.graphics.newText(scoreFont, objects.players[2].name .. "'s score: 99")
		
		--players 2 score
		love.graphics.setColor(1,.8,.8)
		love.graphics.print(objects.players[2].name .. "'s score: " .. objects.players[2].score,SCREEN_WIDTH-text:getWidth(),0)
	end

	-- draw objects
	for key, t in pairs(objects) do 
		for key2, obj in pairs(t) do 
			obj:draw()
		end
	end
end

