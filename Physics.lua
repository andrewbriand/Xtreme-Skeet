require 'Utils'

function Physics()
	local physics = {}
	physics.update = physicsUpdate
	physics.draw = physicsDraw
end

function physicsUpdate(physics, dt)
	print("physicsUpdate")
	for key, bullet in pairs(objects.bullets) do
		for key2, pigeon in pairs(objects.pigeons) do
			--Bullet and pigeon are colliding
			print(dist(bullet.x, bullet.y, pigeon.x, pigeon.y))
			if  dist(bullet.x, bullet.y, pigeon.x, pigeon.y) < (bullet.radius + pigeon.radius) then
				bulletToPigeon = {}
				bulletToPigeon.x = 2*(pigeon.x - bullet.x)
				bulletToPigeon.y = 2*(pigeon.y - bullet.y)
				pigeon.velocity.x = pigeon.velocity.x + bulletToPigeon.x
				pigeon.velocity.y = pigeon.velocity.y + bulletToPigeon.y
				bullet.velocity.x = bullet.velocity.x - bulletToPigeon.x
				bullet.velocity.y = bullet.velocity.y - bulletToPigeon.y
				print("Collision")
			end
		end
	end
end

function physicsDraw(physics)
	
end