PLAYER_SPEED = 0--1000    -- lateral movement speed
PLAYER_ROTATION_SPEED = 3 -- rotational movement speed
PLAYER_RADIUS = 10        -- draw radius
PLAYER_FRICTION = .9      -- later movement damper
BULLET_SPREAD = 10
NUM_BULLETS = 20
 

math.randomseed(os.time())
math.random()
math.random()
math.random()

--[[PLAYER_CONTROLS = {{ -- for use with moving players
					up = "w",
					down = "s",
					left = "a",
					right = "d",
					clockwise = "e",
					counterClockwise = "q",
					shoot = "lshift",
				  },{
					up = "i",
					down = "k",
					left = "j",
					right = "l",
					clockwise = "u",
					counterClockwise = "o",
					shoot = ";",
				  }}]]
				  
PLAYER_CONTROLS = {{ -- for use with still players
					up = "`", -- player one's controls set
					down = "`",
					left = "`",
					right = "`",
					clockwise = "d",
					counterClockwise = "a",
					shoot = "w",
					slow = "lshift",
					selectUp = "w",
					selectDown = "s",
				  },{
					up = "`", -- player two's control set
					down = "`",
					left = "`",
					right = "`",
					clockwise = "l",
					counterClockwise = "j",
					shoot = "i",
					slow = ";",
					selectUp = "i",
					selectDown = "k",
				  }}

function Player(name, controlSet)
	if (controlSet == 2) then -- player two if '2' is passed
		controls = PLAYER_CONTROLS[2]
		color = {1,0,0}
		x = SCREEN_WIDTH/4 * 3
		id = 2
		gruntSound = grunt2
		dir = math.pi+.08
		congrad = congrad2
		name = name or "player 2"
	else -- player one otherwise
		controls = PLAYER_CONTROLS[1]
		color = {0,0,1}
		x = SCREEN_WIDTH/4
		id = 1
		gruntSound = grunt1
		dir = .08
		congrad = congrad1
		name = name or "player 1"
	end
	
	local player = {
		name = name, -- name to be displayed
		radius = PLAYER_RADIUS,
		speed = PLAYER_SPEED,
		rotationSpeed = PLAYER_ROTATION_SPEED,
		controls = controls, -- array for storing player controls
		color = color,
		ammo = 1, -- TODO: update by pigeon launcher
		score = 0,
		id = id, -- 1 if player 1, 2 if player 2
		gruntSound = gruntSound, -- audio file to be played if player is hit
		congrad = congrad,       -- audio file to be played if player wins
		
		hasShoot = false, -- used to prevent repeated shooting
		
		x = x,               -- x pos; doesn't change
		y = SCREEN_HEIGHT/2, -- y pos; doesn't change
		dx = 0,              -- x vel; doesn't change
		dy = 0,              -- y vel; doesn't change
		dir = dir, -- direction measured in radians
		
		draw = drawPlayer, -- draw function
		update = updatePlayer, -- update function
		velocity = {x = 0, y = 0}, -- lateral movement of player (unused)
		
		-- power up stuff
		seek   = false, -- true if player has seek power up
		spiral = false, -- true if player has spiral power up
		aimBot = false, -- true if player has aim bot power up
		laser  = false, -- true if player has laser power up
		powerUpName = "", -- name of current power up to be displayed
		powerUpShots = 0, -- number of power up shots remaining
		ai = false,
		aimBotPastTargets = {},
		aimBotVariation = 0
	}
	player.psystem = love.graphics.newParticleSystem(smokeImage)
	player.psystem:setParticleLifetime(1,1) 
	player.psystem:setEmissionRate(0)
	player.psystem:setSizes(0.4) 
	player.psystem:setColors(255, 255, 255, 255, 255, 255, 255, 0)
	player.psystem:setLinearAcceleration(-100, -100, 100, 100)
	--player.psystem:setSpeed(5, 5)
	--player.psystem:setEmissionArea("ellipse", 0, 0, 2*math.pi, true )
	return player
end

function updatePlayer(self, dt)
	-- update lateral speed
	self.dx = self.dx * PLAYER_FRICTION
	self.dy = self.dy * PLAYER_FRICTION
	
	-- update lateral position
	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt
	
	-- lateral input
	if (love.keyboard.isDown(self.controls.down)) then
		self.dy = self.dy + self.speed * dt
	end
	if (love.keyboard.isDown(self.controls.up)) then
		self.dy = self.dy - self.speed * dt
	end
	if (love.keyboard.isDown(self.controls.right)) then
		self.dx = self.dx + self.speed * dt
	end
	if (love.keyboard.isDown(self.controls.left)) then
		self.dx = self.dx - self.speed * dt
	end
	
	-- slow rotation input
	if (love.keyboard.isDown(self.controls.slow)) then
		rotationSpeedMod = .2
	else
		rotationSpeedMod = 1
	end
	
	-- rotation input
	if(not self.aimBot) then -- ignore input if aimbot is on
		if (love.keyboard.isDown(self.controls.clockwise)) then
			self.dir = self.dir + self.rotationSpeed * dt * rotationSpeedMod
		end
		if (love.keyboard.isDown(self.controls.counterClockwise)) then
			self.dir = self.dir - self.rotationSpeed * dt * rotationSpeedMod
		end
	else -- calculate aimbot rotation
		mindistPigeon = objects.pigeons[1]
		mindistKey = 1
		if mindistPigeon ~= nil then
			for key, pigeon in pairs(objects.pigeons) do
				if(self.aimBotPastTargets[pigeon] == nil and vDist(self, pigeon) < vDist(self, mindistPigeon)) then
					mindistPigeon = pigeon
					mindistKey = key
				end
			end
			
			aimDir = vSub(vAdd(vScale(.25 + self.aimBotVariation, mindistPigeon.velocity), mindistPigeon), self)
			goalDir = math.atan2(aimDir.y, aimDir.x)
			goAhead = false
			if(math.abs(goalDir - self.dir) > self.rotationSpeed * dt * rotationSpeedMod and ai) then
					if(goalDir < self.dir) then
						self.dir = self.dir - self.rotationSpeed * dt * rotationSpeedMod
					else
						self.dir = self.dir + self.rotationSpeed * dt * rotationSpeedMod
					end
			else 
					self.dir = goalDir
					goAhead = true
			end
			if self.ammo > 0 and self.aimBotPastTargets[mindistPigeon] == nil and goAhead then 
				if(ai) then
					self.aimBotVariation = 4*(math.random() - 0.5)
				end
				shootPlayer(self)
				self.aimBotPastTargets[mindistPigeon] = true
			end
			
		end
	end
	
	-- shooting input
	if (love.keyboard.isDown(self.controls.shoot) and (not self.hasShot or self.laser)) then
		if(self.ammo > 0 or self.laser) then
			shootPlayer(self)
		else
			love.audio.newSource(clickSound, "static"):play()
		end
		self.hasShot = true
	end
	
	-- reset functions
	if ((not love.keyboard.isDown(self.controls.shoot)) and self.hasShot) then
		self.hasShot = false
	end
	if(self.powerUpShots <= 0) then
		resetPowerUps(self)
	end
	
	-- smoke effect
	self.psystem:update(dt)
end

-- shoots a cluster of bullets
function shootPlayer(self)
	for i = 1, NUM_BULLETS do -- fire a cluster of bullets
		spread = (math.random() - .5) / BULLET_SPREAD
		table.insert(objects.bullets, Bullet(self.x, self.y, {x = math.cos(self.dir + spread) * BULLET_SPEED, y = math.sin(self.dir + spread) * BULLET_SPEED}, {self.color[1]/2, self.color[2]/2, self.color[3]/2}, self.id, self.seek or self.spiral, self.spiral))
	end
	self.ammo = self.ammo - 1 -- reduce ammo
	if(self.powerUpShots > 0) then -- reduce powerup ammo if applicable
		self.powerUpShots = self.powerUpShots - 1
	end
	
	do -- smoke effect
		spreadMin = -.5 / BULLET_SPREAD * 15
		spreadMax =  .5 / BULLET_SPREAD * 15
		pVel = 200
		windSpeedEffect = 400
		
		self.psystem:setLinearAcceleration(
		math.cos(self.dir + spreadMin) * pVel + PigeonLauncher.windVelocity.x*windSpeedEffect,
		math.sin(self.dir + spreadMin) * pVel + PigeonLauncher.windVelocity.y*windSpeedEffect,
		math.cos(self.dir + spreadMax) * pVel + PigeonLauncher.windVelocity.x*windSpeedEffect,
		math.sin(self.dir + spreadMax) * pVel + PigeonLauncher.windVelocity.y*windSpeedEffect)
		
		self.psystem:setDirection(0)
		self.psystem:emit(10)
	end
	
	-- gun shot sound
	love.audio.newSource(shotgunSound, "static"):play()
end

--
function resetPowerUps(self)
	self.seek        = false
	self.spiral      = false
	self.powerUpName = ""
	self.aimBot      = false -- TODO: CHANGE
	self.laser       = false
end

-- draws the player
function drawPlayer(self)
	love.graphics.setColor(self.color)
	love.graphics.setLineWidth(2)
	
	-- draw shotgun arc
	numSegments = 10
	arcLength = 300
	for i = 0, numSegments do
		love.graphics.setColor({self.color[1],
								self.color[2],
								self.color[3],
								(-1 / numSegments) * i + 1})
		
		-- first arm
		x1Left  = ((((self.x + math.cos(self.dir - (.5/BULLET_SPREAD)) * arcLength) - self.x) / numSegments) * (i + 0)) + self.x
		y1Left  = ((((self.y + math.sin(self.dir - (.5/BULLET_SPREAD)) * arcLength) - self.y) / numSegments) * (i + 0)) + self.y
		x2Left  = ((((self.x + math.cos(self.dir - (.5/BULLET_SPREAD)) * arcLength) - self.x) / numSegments) * (i + 1)) + self.x
		y2Left  = ((((self.y + math.sin(self.dir - (.5/BULLET_SPREAD)) * arcLength) - self.y) / numSegments) * (i + 1)) + self.y
		
		--second arm
		x1Right = ((((self.x + math.cos(self.dir + (.5/BULLET_SPREAD)) * arcLength) - self.x) / numSegments) * (i + 0)) + self.x
		y1Right = ((((self.y + math.sin(self.dir + (.5/BULLET_SPREAD)) * arcLength) - self.y) / numSegments) * (i + 0)) + self.y
		x2Right = ((((self.x + math.cos(self.dir + (.5/BULLET_SPREAD)) * arcLength) - self.x) / numSegments) * (i + 1)) + self.x
		y2Right = ((((self.y + math.sin(self.dir + (.5/BULLET_SPREAD)) * arcLength) - self.y) / numSegments) * (i + 1)) + self.y
		love.graphics.line(x1Left, y1Left, x2Left, y2Left)
		love.graphics.line(x1Right, y1Right, x2Right, y2Right)
	end
	
	love.graphics.line(self.x, self.y, self.x + math.cos(self.dir) * self.radius * 2, self.y + math.sin(self.dir) * self.radius * 2)
	
	-- give player light outline
	brightness = .2 -- 0 is white, 1 is the original color
	love.graphics.setColor({self.color[1]*brightness + (1 - brightness),
							self.color[2]*brightness + (1 - brightness),
							self.color[3]*brightness + (1 - brightness)})
	love.graphics.circle("fill", self.x, self.y, self.radius*1.2)
	
	-- main player drawing
	love.graphics.setColor(self.color)
	love.graphics.circle("fill", self.x, self.y, self.radius)
	
	-- smoke effect
	love.graphics.setColor(1,1, 1)
	love.graphics.draw(self.psystem, self.x + self.radius*math.cos(self.dir), self.y + self.radius*math.sin(self.dir)) 
end