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
			--shootingPattern = shootPigeons
			shootingPattern = shootCascade
			numPigeons = 20--math.random(4)
			pigeonDelay = 0--math.random()
			
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
function shootPigeons(numPigeons, delay, targetX, targetY)
	numPigeons = numPigeons or 1
	delay = delay or 0
	-- the direction the pigeons will fly
	local targetX = targetX or SCREEN_WIDTH / 2  + ((math.random() - .5) * 2 * SCREEN_WIDTH/4)
	local targetY = targetY or SCREEN_HEIGHT / 2
	
	if(launcherReady(numPigeons, delay)) then
		local x = math.random() * SCREEN_WIDTH
		local y
		if (math.random() < .5) then
			y = 0
		else
			y = SCREEN_HEIGHT
		end
		
		shootPigeon(x, y, targetX, targetY)
		resetLauncer()
	end
	
	return(returnLauncher(numPigeons))
end

-- shoots a wall from the top and bottom
function shootCascade(numPigeons, delay)
	ySide = (math.random(2)-1)
	if(launcherReady(numPigeons)) then
		for i = 1, numPigeons do
			y = ((i+ySide)%2) * SCREEN_HEIGHT
			x = (((-SCREEN_WIDTH) / numPigeons) * (i + 0)) + SCREEN_WIDTH
			
			local targetX = ((((SCREEN_WIDTH / 4) - (SCREEN_WIDTH / 4 * 3)) / numPigeons) * (i + 0)) + (SCREEN_WIDTH / 4 * 3)
			local targetY = SCREEN_HEIGHT / 2
			
			shootPigeon(x, y, targetX, targetY)
			resetLauncer()
		end
	end
	return(returnLauncher(numPigeons))
end

function shootPigeon(x, y, targetX, targetY, speedMod)
	speedMod = speedMod or 1
	local angle = math.atan2((targetY - y), (targetX - x))
	table.insert(objects.pigeons, Pigeon(x, y, {x = math.cos(angle) * PIGEON_SPEED * speedMod, y = math.sin(angle) * PIGEON_SPEED * speedMod}))
end

function resetLauncer()
		love.audio.newSource(pigeonLauncerSound, "static"):play()
		PigeonLauncher.pigeonsShot = PigeonLauncher.pigeonsShot + 1
		PigeonLauncher.timer = 0
end

function returnLauncher(numPigeons)
	if(PigeonLauncher.pigeonsShot >= numPigeons) then
		return true
	else
		return false
	end
end

function launcherReady(numPigeons, delay)
	delay = delay or 0
	return ((PigeonLauncher.pigeonsShot < numPigeons and PigeonLauncher.timer >= delay) or (PigeonLauncher.pigeonsShot == 0))
end