PLAYER_SPEED = 0--1000    -- lateral movement speed
PLAYER_ROTATION_SPEED = 5 -- rotational movement speed
PLAYER_RADIUS = 10        -- draw radius
PLAYER_FRICTION = .9      -- later movement damper

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
				  },{
					up = "`", -- player two's control set
					down = "`",
					left = "`",
					right = "`",
					clockwise = "right",
					counterClockwise = "left",
					shoot = "up",
				  }}

function Player(name, controlSet)
	if (controlSet == 2) then -- player two if '2' is passed
		controls = PLAYER_CONTROLS[2]
		color = {1,.3,.3}
		x = SCREEN_WIDTH/4 * 3
	else -- player one otherwise
		controls = PLAYER_CONTROLS[1]
		color = {.3,.3,1}
		x = SCREEN_WIDTH/4
	end
	
	local player = {
		name = name,
		radius = PLAYER_RADIUS,
		speed = PLAYER_SPEED,
		rotationSpeed = PLAYER_ROTATION_SPEED,
		controls = controls,
		color = color,
		ammo = 1, -- TODO: update by pigeon launcher
		
		hasShoot = false, -- used to prevent repeated shooting
		
		x = x,
		y = SCREEN_HEIGHT/2,
		dx = 0,
		dy = 0,
		dir = 0,
		
		draw = drawPlayer,
		update = updatePlayer,
	}
	return player
end

function updatePlayer(self, dt)
	-- update lateral position
	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt
	
	-- update lateral speed
	self.dx = self.dx * PLAYER_FRICTION
	self.dy = self.dy * PLAYER_FRICTION
	
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
	
	-- rotation input
	if (love.keyboard.isDown(self.controls.clockwise)) then
		self.dir = self.dir + self.rotationSpeed * dt
	end
	if (love.keyboard.isDown(self.controls.counterClockwise)) then
		self.dir = self.dir - self.rotationSpeed * dt
	end
	
	-- shooting input
	if (love.keyboard.isDown(self.controls.shoot) and not self.hasShot) then
		self.hasShot = true
		shootPlayer(self)
	end
	if ((not love.keyboard.isDown(self.controls.shoot)) and self.hasShot) then
		self.hasShot = false
	end
end

function shootPlayer(self)
	local numBullets = 3
	local spread = 2
	for i = 1, numBullets do
		xSpread = math.random()/spread - .5/spread
		ySpread = math.random()/spread - .5/spread
		table.insert(objects.bullets, Bullet(self.x, self.y, {x = math.cos(self.dir + xSpread) * BULLET_SPEED, y = math.sin(self.dir + ySpread) * BULLET_SPEED}, {self.color[1]/2, self.color[2]/2, self.color[3]/2}))
	end
end

function drawPlayer(self)
	love.graphics.setColor(self.color)
	love.graphics.setLineWidth(4)
	love.graphics.line(self.x, self.y, self.x + math.cos(self.dir) * self.radius * 2, self.y + math.sin(self.dir) * self.radius * 2)
	love.graphics.circle("fill", self.x, self.y, self.radius)
end