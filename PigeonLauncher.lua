POWERUP_PROBABILITY = 0.05
GOLD_PROBABILITY = 0.05

PigeonLauncher = {
	isShooting     = false,
	timer          = 0,
	pigeonsShot    = 0,
	round          = 0,
	speedMod       = 1,
	windVelocity   = {x = 0, y = 0},
}

-- a few variables for keeping track of timing
function loadPigeonLauncher()
	PigeonLauncher.isShooting   = false
	PigeonLauncher.timer        = 0
	PigeonLauncher.pigeonsShot  = 0
	PigeonLauncher.round        = 0
	PigeonLauncher.maxWindSpeed = 1
	PigeonLauncher.psystem = love.graphics.newParticleSystem(windParticle)
	PigeonLauncher.psystem:setParticleLifetime(2) -- Particles live at least 2s and at most 5s.
	PigeonLauncher.psystem:setEmissionRate(50)
	PigeonLauncher.psystem:setEmissionArea("uniform", SCREEN_HEIGHT, SCREEN_WIDTH)
	PigeonLauncher.psystem:setColors({1,1,1,.9},{1,1,1,0})
	PigeonLauncher.psystem:setSizeVariation(0)
	PigeonLauncher.psystem:setSizes(.5)
	PigeonLauncher.psystem:setRelativeRotation(true)
	PigeonLauncher.windSource = love.audio.newSource(windSound)
end

function PigeonLauncher.update(self, dt)
	PigeonLauncher.timer = PigeonLauncher.timer + dt
	if not PigeonLauncher.isShooting then -- if launcher has finished firing
		if (roundOver()) then -- if all bullets, pigeons, and fragments have left the screen
			PigeonLauncher.round       = PigeonLauncher.round + 1 -- next round
			PigeonLauncher.isShooting  = true -- launcher is firing
			PigeonLauncher.pigeonsShot = 0    -- counter for number of pigeons launcher has fired
			PigeonLauncher.timer       = 0    -- number of seconds since previous launch
			
			PigeonLauncher.speedMod = PigeonLauncher.speedMod * 1.01 -- everything is 28% faster by the 25th round
			
			--determine shooting pattern
			if (PigeonLauncher.round % 8 == 0) then -- every 8th round use the cascade launching pattern
				shootingPattern = PigeonLauncher.cascade
			else -- use the pigeons pattern for the rest
				shootingPattern = PigeonLauncher.pigeons
			end
			numPigeons = math.floor(math.sqrt(10*PigeonLauncher.round + 225) + -14) -- the number of pigeons increase over time
			local speedOfDecay = 30 -- used for calculation
			pigeonDelay = (speedOfDecay * .25)/(PigeonLauncher.round + speedOfDecay -1) -- the delay between pigeons decrease over time
			
			for k, v in pairs(objects.players) do -- reset the ammo of each (of the two) players
				v.ammo = shootingPattern.ammo(numPigeons)
			end
			
			windSpeed = math.random()*self.maxWindSpeed
			windDirection = math.random()*math.pi*2
			self.windVelocity = vFromDirMag(windDirection, windSpeed)
			self.psystem:setSpeed(windSpeed*500)
			self.psystem:setEmissionRate(windSpeed*50)
			self.psystem:setDirection(windDirection)
			self.windSource:setPitch(windSpeed*2)
			self.windSource:play()
		end
	else
		if(shootingPattern.shoot(numPigeons, pigeonDelay)) then -- simultaneously launches pigeons and checks if launching is finished
			PigeonLauncher.isShooting = false -- if launching is finished, set isShooting to reflect that
		end
	end
	PigeonLauncher.psystem:update(dt)
end

function PigeonLauncher.draw()
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(PigeonLauncher.psystem, SCREEN_HEIGHT/2, SCREEN_WIDTH/2,0,1)
end

-- returns true if the round is over, ie. all bullets, pigeons, and fragments are off the screen
function roundOver()
	local returnVar = false
	for k, v in pairs(objects.pigeons) do
		if not isOffScreen(v.x, v.y, SCREEN_BUFFER) then
			return false
		end
	end
	for k, v in pairs(objects.bullets) do
		if not isOffScreen(v.x, v.y, SCREEN_BUFFER) then
			return false
		end
	end
	for k, v in pairs(objects.fragments) do
		if not isOffScreen(v.x, v.y, SCREEN_BUFFER) then
			return false
		end
	end	
	for k, v in pairs(objects.powerUps) do
		if not isOffScreen(v.x, v.y, SCREEN_BUFFER) then
			return false
		end
	end
	for k, v in pairs(objects.goldPigeons) do
		if not isOffScreen(v.x, v.y, SCREEN_BUFFER) then
			return false
		end
	end
	return true
end

-- all shooting patterns
-- each pattern has a .shoot(numPigeons, delay)
--              and a .ammo(numPigeons)
PigeonLauncher.pigeon = {}
PigeonLauncher.pigeons = {}
PigeonLauncher.cascade = {}

-- shoots a single pigeon from the given location to the given target
function PigeonLauncher.pigeon.shoot(x, y, targetX, targetY, speedMod)
	speedMod = speedMod or 1
	speedMod = speedMod * PigeonLauncher.speedMod
	local angle = math.atan2((targetY - y), (targetX - x))
	
	randNum = math.random()
	if(randNum < POWERUP_PROBABILITY and randNum > 0) then
		powerUpType = POWER_UP_TYPES[math.random(#POWER_UP_TYPES)]
		table.insert(objects.powerUps, PowerUp(x, y, {x = math.cos(angle) * POWERUP_SPEED * speedMod, y = math.sin(angle) * POWERUP_SPEED *speedMod}, powerUpType))
	elseif(randNum < GOLD_PROBABILITY + POWERUP_PROBABILITY and randNum > POWERUP_PROBABILITY) then
		table.insert(objects.goldPigeons, GoldPigeon(x, y, {x = math.cos(angle) * GOLD_PIGEON_SPEED * speedMod, y = math.sin(angle) * GOLD_PIGEON_SPEED *speedMod}))
	else
		table.insert(objects.pigeons, Pigeon(x, y, {x = math.cos(angle) * PIGEON_SPEED * speedMod, y = math.sin(angle) * PIGEON_SPEED * speedMod}))
	end
end


-- single pigeon allows 1 ammo
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

-- pigeons allows half as many ammo as pigeons, rounded up
function PigeonLauncher.pigeons.ammo(numPigeons)
	return math.ceil(numPigeons/2+.01) -- the +.01 is so that 2/2 ceils to 2, not 1
end

-- shoots a wall from the top and bottom
function PigeonLauncher.cascade.shoot(numPigeons, delay)
	ySide = (math.random(2)-1)
	if(PigeonLauncher.launcherReady(numPigeons)) then
		local i = 1
		x = (((-SCREEN_WIDTH) / numPigeons) * (i + 0)) + SCREEN_WIDTH  + SCREEN_WIDTH/numPigeons/2
		y = ((i+ySide)%2) * SCREEN_HEIGHT
			
		local targetX = ((((SCREEN_WIDTH / 4) - (SCREEN_WIDTH / 4 * 3)) / numPigeons) * (i + 0)) + (SCREEN_WIDTH / 4 * 3)
		                - (((SCREEN_WIDTH / 4) - (SCREEN_WIDTH / 4 * 3)) / numPigeons)/2
		local targetY = SCREEN_HEIGHT / 2
		
		local d = math.sqrt((x-targetX)^2+(y-targetY)^2)
		local t = d/PIGEON_SPEED
		
		for i = 1, numPigeons do
			x = (((-SCREEN_WIDTH) / numPigeons) * (i + 0)) + SCREEN_WIDTH  + SCREEN_WIDTH/numPigeons/2
			y = ((i+ySide)%2) * SCREEN_HEIGHT
			
			local targetX = ((((SCREEN_WIDTH / 4) - (SCREEN_WIDTH / 4 * 3)) / numPigeons) * (i + 0)) + (SCREEN_WIDTH / 4 * 3)
				- (((SCREEN_WIDTH / 4) - (SCREEN_WIDTH / 4 * 3)) / numPigeons)/2
			local targetY = SCREEN_HEIGHT / 2
			
			local d = math.sqrt((x-targetX)^2+(y-targetY)^2)
			local s = d/t
			
			PigeonLauncher.pigeon.shoot(x, y, targetX, targetY, s/PIGEON_SPEED)
			PigeonLauncher.resetLauncer()
		end
	end
	return(PigeonLauncher.returnLauncher(numPigeons))
end

-- cascade allows 1 ammo
function PigeonLauncher.cascade.ammo(numPigeons)
	return 1
end

-- plays launcher sound, increments the number of pigeons shot, and resets the launch delay timer
function PigeonLauncher.resetLauncer()
		love.audio.newSource(pigeonLauncerSound, "static"):play()
		PigeonLauncher.pigeonsShot = PigeonLauncher.pigeonsShot + 1
		PigeonLauncher.timer = 0
end

-- returns true if all possible pigeons have be launched this round
function PigeonLauncher.returnLauncher(numPigeons)
	if(PigeonLauncher.pigeonsShot >= numPigeons) then
		return true
	else
		return false
	end
end

-- returns true if the launcher is ready to fire
function PigeonLauncher.launcherReady(numPigeons, delay)
	delay = delay or 0
	return ((PigeonLauncher.pigeonsShot < numPigeons and PigeonLauncher.timer >= delay) or (PigeonLauncher.pigeonsShot == 0))
end