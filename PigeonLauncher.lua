numPigeons = 3
pigeonDelay = .5

PigeonLauncher = {
	isShooting = false,
	timer = 0,
	pigeonsShot = 0,
	round = 0
}

function PigeonLauncher.update(self, dt)
	PigeonLauncher.timer = PigeonLauncher.timer + dt
	if not PigeonLauncher.isShooting then
		if (roundOver()) then
			PigeonLauncher.round = PigeonLauncher.round + 1
			PigeonLauncher.isShooting = true
			PigeonLauncher.pigeonsShot = 0
			PigeonLauncher.timer = 0
			
			--determine shooting pattern
			shootingPattern = PigeonLauncher.pigeons
			--shootingPattern = PigeonLauncher.cascade
			numPigeons = math.floor(math.sqrt(PigeonLauncher.round/.77))
			pigeonDelay = .15--math.random()
			
			for k, v in pairs(objects.players) do
				--v.ammo = shootingPattern.ammo
				v.ammo = shootingPattern.ammo(numPigeons)
			end
		end
	else
		if(shootingPattern.shoot(numPigeons, pigeonDelay)) then
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

PigeonLauncher.pigeon = {}
PigeonLauncher.pigeons = {}
PigeonLauncher.cascade = {}

-- shoots a single pigeon from the given location to the given target
function PigeonLauncher.pigeon.shoot(x, y, targetX, targetY, speedMod)
	speedMod = speedMod or 1
	local angle = math.atan2((targetY - y), (targetX - x))
	table.insert(objects.pigeons, Pigeon(x, y, {x = math.cos(angle) * PIGEON_SPEED * speedMod, y = math.sin(angle) * PIGEON_SPEED * speedMod}))
end

function PigeonLauncher.pigeon.ammo(numPigeons)
	return 1
end

-- shoots a cluster of pigeons at random
function PigeonLauncher.pigeons.shoot(numPigeons, delay)
	numPigeons = numPigeons or 1
	delay = delay or 0
	-- the direction the pigeons will fly
	local targetX = targetX or SCREEN_WIDTH / 2  + ((math.random() - .5) * 2 * SCREEN_WIDTH/4)
	local targetY = targetY or SCREEN_HEIGHT / 2
	
	if(PigeonLauncher.launcherReady(numPigeons, delay)) then
		local x = math.random() * SCREEN_WIDTH
		local y
		if (math.random() < .5) then
			y = 0
		else
			y = SCREEN_HEIGHT
		end
		
		PigeonLauncher.pigeon.shoot(x, y, targetX, targetY)
		PigeonLauncher.resetLauncer()
	end
	
	return(PigeonLauncher.returnLauncher(numPigeons))
end

function PigeonLauncher.pigeons.ammo(numPigeons)
	return math.ceil(numPigeons/2+.01) -- the +.01 is so that 2/2 ceils to 2, not 1
end

-- shoots a wall from the top and bottom
function PigeonLauncher.cascade.shoot(numPigeons, delay)
	ySide = (math.random(2)-1)
	if(PigeonLauncher.launcherReady(numPigeons)) then
		for i = 1, numPigeons do
			x = (((-SCREEN_WIDTH) / numPigeons) * (i + 0)) + SCREEN_WIDTH  + SCREEN_WIDTH/numPigeons/2
			y = ((i+ySide)%2) * SCREEN_HEIGHT
			
			local targetX = ((((SCREEN_WIDTH / 4) - (SCREEN_WIDTH / 4 * 3)) / numPigeons) * (i + 0)) + (SCREEN_WIDTH / 4 * 3)
				- (((SCREEN_WIDTH / 4) - (SCREEN_WIDTH / 4 * 3)) / numPigeons)/2
			local targetY = SCREEN_HEIGHT / 2
			
			PigeonLauncher.pigeon.shoot(x, y, targetX, targetY)
			PigeonLauncher.resetLauncer()
		end
	end
	return(PigeonLauncher.returnLauncher(numPigeons))
end

function PigeonLauncher.cascade.ammo(numPigeons)
	return 1
end

function PigeonLauncher.resetLauncer()
		love.audio.newSource(pigeonLauncerSound, "static"):play()
		PigeonLauncher.pigeonsShot = PigeonLauncher.pigeonsShot + 1
		PigeonLauncher.timer = 0
end

function PigeonLauncher.returnLauncher(numPigeons)
	if(PigeonLauncher.pigeonsShot >= numPigeons) then
		return true
	else
		return false
	end
end

function PigeonLauncher.launcherReady(numPigeons, delay)
	delay = delay or 0
	return ((PigeonLauncher.pigeonsShot < numPigeons and PigeonLauncher.timer >= delay) or (PigeonLauncher.pigeonsShot == 0))
end