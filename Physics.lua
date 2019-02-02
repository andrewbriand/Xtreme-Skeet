require 'Utils'

function Physics()
	local physics = {}
	physics.update = physicsUpdate
	physics.draw = physicsDraw
	return physics
end

function physicsUpdate(physics, dt)
	for key, bullet in pairs(objects.bullets) do
		for key2, pigeon in pairs(objects.pigeons) do
			--Bullet and pigeon are colliding
			if  dist(bullet.x, bullet.y, pigeon.x, pigeon.y) < (bullet.radius + pigeon.radius) then
				print("Collision")
				bulletToPigeon = {}
				bulletToPigeon.x = 10*(pigeon.x - bullet.x)
				bulletToPigeon.y = 10*(pigeon.y - bullet.y)
				pigeon.velocity.x = pigeon.velocity.x + bulletToPigeon.x
				pigeon.velocity.y = pigeon.velocity.y + bulletToPigeon.y
				for i=1,pigeon.numFragments do
					local fragment = Fragment(pigeon.x, pigeon.y, {})
					fragment.velocity.x = pigeon.velocity.x
					fragment.velocity.y = pigeon.velocity.y
					table.insert(objects.fragments, fragment)
				end
				bullet.velocity.x = bullet.velocity.x - bulletToPigeon.x
				bullet.velocity.y = bullet.velocity.y - bulletToPigeon.y
				table.remove(objects.pigeons, key2)
			end
		end
	end
end

function physicsDraw(physics)
	
end