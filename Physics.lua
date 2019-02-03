require 'Utils'

function Physics()
	local physics = {}
	physics.update = physicsUpdate
	physics.draw = physicsDraw
	return physics
end

function physicsUpdate(physics, dt)
	-- bullet-pigeon collision
	for key, bullet in pairs(objects.bullets) do
		for key2, pigeon in pairs(objects.pigeons) do
			if  dynamicCircleCollision(bullet, pigeon, dt, {}) then
				addPoint(pigeon.x, pigeon.y, "+1", objects.players[bullet.owner].color)
				--print("Collision")
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
				table.remove(objects.bullets, key)
				love.audio.newSource(pigeonBreakSound, "static"):play()
				pigeon.destroyed = true
			end
		end
	end
	
	-- bullet-powerup collision
	for key, bullet in pairs(objects.bullets) do
		for key2, powerUp in pairs(objects.powerUps) do
			if dynamicCircleCollision(bullet, powerUp, dt, {}) then
				addPoint(powerUp.x, powerUp.y, "0", objects.players[bullet.owner].color)
				if powerUp.type == "SEEK" then
					objects.players[bullet.owner].seek = true
				elseif powerUp.type == "SPIRAL" then
					objects.players[bullet.owner].spiral = true
				elseif powerUp.type == "AIMBOT" then
					objects.players[bullet.owner].aimBot = true
				end
				objects.players[bullet.owner].powerUpShots = 3
				objects.players[bullet.owner].powerUpName = powerUp.type
				table.remove(objects.powerUps, key2)
				table.remove(objects.bullets, key)
			end
		end
	end
	
	-- fragment-player collision
	for key, player in pairs(objects.players) do
		for key2, fragment in pairs(objects.fragments) do
			if circleCollision(player, fragment) then
				addPoint(player.x, player.y, "+1", objects.players[-key + 3].color)
				if (player.id == 1) then --update the appropriate scores
					objects.players[2].score = objects.players[2].score + 1
				else
					objects.players[1].score = objects.players[1].score + 1
				end
				table.remove(objects.fragments, key2)
				love.audio.newSource(player.gruntSound, "static"):play()
			end
		end
	end
	
	-- bullet-player collision
	for key, player in pairs(objects.players) do
		for key2, bullet in pairs(objects.bullets) do
			if dynamicCircleCollision(bullet, player, dt, {}) then
				addPoint(player.x, player.y, "-1", objects.players[bullet.owner].color)
				if (player.id == 1 and bullet.owner == 2) then --update the appropriate scores
					objects.players[2].score = objects.players[2].score - 1
					table.remove(objects.bullets, key2)
				elseif(player.id == 2 and bullet.owner == 1) then
					objects.players[1].score = objects.players[1].score - 1
					table.remove(objects.bullets, key2)
				end
				love.audio.newSource(player.gruntSound, "static"):play()
			end
		end
	end
	
	-- delete bullets, fragments, and pigeons when they are off the screen
	for key, bullet in pairs(objects.bullets) do
		if(isOffScreen(bullet.x, bullet.y, 150)) then
			table.remove(objects.bullets, key)
		end
	end
	for key, pigeon in pairs(objects.pigeons) do
		if(isOffScreen(pigeon.x, pigeon.y, 150)) then
			table.remove(objects.pigeons, key)
		end
	end
	for key, fragment in pairs(objects.fragments) do
		if(isOffScreen(fragment.x, fragment.y, 150)) then
			table.remove(objects.fragments, key)
		end
	end
end

function physicsDraw(physics)
	-- TODO (Andrew): Draw trajectory?
end

points = {{text = "-1" ,x = 100, y = 200, color = {1,1,1,1}}}
function addPoint(x, y, text, color)
	color = color or {1,1,1,1}
	color = {color[1],color[2],color[3],1}
	table.insert(points, {text = text ,x = x, y = y, color = color})
end

function updatePoints(dt)
	for k, v in ipairs(points) do
		v.color[4] = v.color[4] - dt/3
	end
end

function drawPoints()
	for k, v in ipairs(points) do
		love.graphics.setColor(v.color)
		love.graphics.setFont(controlsFont)
		love.graphics.print(v.text, v.x, v.y)
	end
end

-- returns true if the given point is outside the screen
-- buffer requires the object move an extra distance away
--    good for ensuring not just the center is off, but the entire object
function isOffScreen(x, y, buffer)
	buffer = buffer or 0
	return (x > SCREEN_WIDTH + buffer or x < 0 - buffer or y < 0 - buffer or y > SCREEN_HEIGHT + buffer)
end