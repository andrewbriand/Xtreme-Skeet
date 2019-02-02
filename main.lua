require 'Player'
require 'Pigeon'
require 'Bullet'
require 'Fragment'
require 'Physics'

function love.load()
	SCREEN_WIDTH = love.graphics.getWidth() --Screen width
	SCREEN_HEIGHT = love.graphics.getHeight() --Screen height
	
	objects = {}
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
	--objects.pigeonLauncher = PigeonLauncher()
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
	for key, t in pairs(objects) do 
		for key2, obj in pairs(t) do 
			obj:draw()
		end
	end
end

