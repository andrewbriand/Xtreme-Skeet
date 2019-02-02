require 'Player'
require 'Pigeon'



function love.load()
	objects = {}
	objects.pigeons = {}
	table.insert(objects.pigeons, Pigeon(50, 50, {x = 5, y = 4}))
	objects.players = {}
	table.insert(objects.players, Player("Player 1", 1))
	table.insert(objects.players, Player("Player 2", 2))
	objects.bullets = {}
	objects.fragments = {}
	--objects.physics = Physics()
	--objects.pigeonLauncher = PigeonLauncher()
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