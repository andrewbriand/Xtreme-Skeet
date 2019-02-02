numPigeons = 3
pigeonDelay = .5

PigeonLauncher = {
	isShooting = false,
	timer = 0,
	pigeonsShot = 0,
}

function PigeonLauncher.update(self, dt)
	PigeonLauncher.timer = PigeonLauncher.timer + dt
	if not PigeonLauncher.isShooting then
		if (roundOver()) then
			PigeonLauncher.isShooting = true
			PigeonLauncher.pigeonsShot = 0
			PigeonLauncher.timer = 0
			
			--determine shooting pattern
			shootingPattern = shootPigeon
			numPigeons = 3
			pigeonDelay = .5
			
			for k, v in pairs(objects.players) do
				v.ammo = numPigeons
			end
		end
	else
		if(shootingPattern(numPigeons, pigeonDelay)) then
			PigeonLauncher.isShooting = false
		end
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

-- shoots a single pigeon towards the given target (defaults to the center of the screen)
--    
function shootPigeon(numPigeons, delay, targetX, targetY)
	numPigeons = numPigeons or 1
	delay = delay or 0
	-- the direction the pigeons will fly
	local targetX = targetX or SCREEN_WIDTH / 2  + ((math.random() - .5) * 2 * SCREEN_WIDTH/4)
	local targetY = targetY or SCREEN_HEIGHT / 2
	
	if((PigeonLauncher.pigeonsShot < numPigeons and PigeonLauncher.timer >= delay) or (PigeonLauncher.pigeonsShot == 0)) then
		local x = math.random() * SCREEN_WIDTH
		local y
		if (math.random() < .5) then
			y = 0
		else
			y = SCREEN_HEIGHT
		end
		
		local angle = math.atan2((targetY - y), (targetX - x))
		table.insert(objects.pigeons, Pigeon(x, y, {x = math.cos(angle) * PIGEON_SPEED, y = math.sin(angle) * PIGEON_SPEED}))
		
		love.audio.newSource(pigeonLauncerSound, "static"):play()
		PigeonLauncher.pigeonsShot = PigeonLauncher.pigeonsShot + 1
		PigeonLauncher.timer = 0
	end
	if(PigeonLauncher.pigeonsShot >= numPigeons) then
		return true
	else
		return false
	end
end