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
			if  circleCollision(pigeon, bullet) then
				if (bullet.owner == 2) then --update the appropriate scores
					objects.players[2].score = objects.players[2].score + 1
				else
					objects.players[1].score = objects.players[1].score + 1
				end
				-- Fake physics: push the pigeon and bullet away from each other's centers when they collide
				bulletToPigeon = {}
				bulletToPigeonMag = dist(pigeon.x, pigeon.y, bullet.x, bullet.y)
				bulletToPigeon.x = (pigeon.x - bullet.x)/bulletToPigeonMag
				bulletToPigeon.y = (pigeon.y - bullet.y)/bulletToPigeonMag
				
				pigeon.velocity.x = 0*pigeon.velocity.x + 200*bulletToPigeon.x
				pigeon.velocity.y = 0*pigeon.velocity.y + 200*bulletToPigeon.y
				bullet.velocity.x = bullet.velocity.x - bulletToPigeon.x
				bullet.velocity.y = bullet.velocity.y - bulletToPigeon.y

				-- Generate the pigeon fragments
				for i=1,pigeon.numFragments do
					local fragment = Fragment(pigeon.x, pigeon.y, {})
					-- Randomize the initial velocity of the fragments using 
					-- the 2d rotation matrix and a magnitude factor
					theta = math.random()
					randMag = math.random()/2 + 1
					fragment.velocity.x = (pigeon.velocity.x * math.cos(theta) - pigeon.velocity.y * math.sin(theta)) * randMag
					fragment.velocity.y = (pigeon.velocity.x * math.sin(theta) + pigeon.velocity.y * math.cos(theta)) * randMag
					table.insert(objects.fragments, fragment)
				end
				-- Remove the pigeon from the game
				table.remove(objects.pigeons, key2)
			end
		end
	end
	-- Fragment-player collision
	for key, player in pairs(objects.players) do
		for key2, fragment in pairs(objects.fragments) do
			if circleCollision(player, fragment) then
				if (player.id == 1) then --update the appropriate scores
					objects.players[2].score = objects.players[2].score + 1
				else
					objects.players[1].score = objects.players[1].score + 1
				end
				table.remove(objects.fragments, key2)
			end
		end
	end
	-- Bullet-player collision
	for key, player in pairs(objects.players) do
		for key2, bullet in pairs(objects.bullets) do
			if circleCollision(player, bullet) then
				if (player.id == 1 and bullet.owner == 2) then --update the appropriate scores
					objects.players[2].score = objects.players[2].score - 1
					table.remove(objects.bullets, key2)
				elseif(player.id == 2 and bullet.owner == 1) then
					objects.players[1].score = objects.players[1].score - 1
					table.remove(objects.bullets, key2)
				end
			end
		end
	end
end

function physicsDraw(physics)
	-- TODO (Andrew): Draw trajectory?
end