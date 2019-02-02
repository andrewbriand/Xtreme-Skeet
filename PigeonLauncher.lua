PigeonLauncher = {}

function PigeonLauncher.update()
	if (roundOver()) then
		local x = math.random() * SCREEN_WIDTH
		local y
		if (math.random() < .5) then
			y = 0
		else
			y = SCREEN_HEIGHT
		end
		-- the direction the pigeons will fly
		local targetX = SCREEN_WIDTH / 2 
		local targetY = SCREEN_HEIGHT / 2 
		
		local angle = math.atan2((targetY - y), (targetX - x))
		table.insert(objects.pigeons, Pigeon(x, y, {x = math.cos(angle) * PIGEON_SPEED, y = math.sin(angle) * PIGEON_SPEED}))
		
		love.audio.newSource(pigeonLauncerSound, "static"):play()
	end
end

function PigeonLauncher.draw()
	-- intentionally empty, only here so it can be called by physics
end

function roundOver()
	local returnVar = false
	for k, v in pairs(objects.pigeons) do
		if (v.x > 0) and (v.y > 0) and (v.x < SCREEN_WIDTH) and (v.y < SCREEN_HEIGHT) then
			return false
		end
	end
	for k, v in pairs(objects.bullets) do
		if (v.x > 0) and (v.y > 0) and (v.x < SCREEN_WIDTH) and (v.y < SCREEN_HEIGHT) then
			return false
		end
	end
	for k, v in pairs(objects.fragments) do
		if (v.x > 0) and (v.y > 0) and (v.x < SCREEN_WIDTH) and (v.y < SCREEN_HEIGHT) then
			return false
		end
	end
	return true
end