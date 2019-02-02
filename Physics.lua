function Physics()
	local physics = {}
	physics.update = physicsUpdate
	physics.draw = physicsDraw
end

function physicsUpdate(physics, dt)
	for key, bullet in pairs(objects.bullets) do
		for key2, pigeon in pairs(objects.pigeons) do
			--Bullet and pigeon are colliding
			if  dist(bullet.x, bullet.y, pigeon.x, pigeon.y) < (bullet.radius + pigeon.radius) then
				
			end
		end
	end
end

function physicsDraw(physics)
	
end