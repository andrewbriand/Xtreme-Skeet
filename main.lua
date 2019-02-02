require 'player'

function love.load()
	objects = {}
	objects.pigeons = {}
	objects.players = {}
	objects.bullets = {}
	objects.fragments = {}
	objects.physics = Physics()
	objects.pigeonLauncher = PigeonLauncher()
end

function love.update(dt)
	for key, obj in ipairs(objects) do
		obj:update()
	end
end

function love.draw()
	for key, obj in ipairs(objects) do 
		obj:draw()
	end
end