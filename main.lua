require 'Player'
require 'Pigeon'


function love.load()
	objects = {}
	objects.pigeons = {}
	--table.insert(objects.pigeons, Pigeon(50, 50))
	objects.players = {}
	objects.bullets = {}
	objects.fragments = {}
	--objects.physics = Physics()
	--objects.pigeonLauncher = PigeonLauncher()
end

function love.update(dt)
	for key, t in pairs(objects) do
		for key2, obj in pairs(t) do 
			obj:update()
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