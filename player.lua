PLAYER_SPEED = 1000
PLAYER_ROTATION_SPEED = 5
PLAYER_RADIUS = 10
PLAYER_FRICTION = .9

math.randomseed(os.time())
math.random()
math.random()
math.random()

PLAYER_CONTROLS = {{
					up = "w",
					down = "s",
					left = "a",
					right = "d",
					clockwise = "e",
					counterClockwise = "q",
					shoot = "shift",
				  },{
					up = "i",
					down = "k",
					left = "j",
					right = "l",
					clockwise = "u",
					counterClockwise = "o",
					shoot = ";"
				  }}

function Player(name, controlSet)
	if (controlSet == 2) then
		controls = PLAYER_CONTROLS[2]
		color = {1,0,0}
	else
		controls = PLAYER_CONTROLS[1]
		color = {.25,.25,1}
	end
	
	local player = {
		name = name,
		radius = PLAYER_RADIUS,
		speed = PLAYER_SPEED,
		rotationSpeed = PLAYER_ROTATION_SPEED,
		controls = controls,
		color = color,
		ammo = 0,
		
		x = math.random()*200,
		y = 150,
		dx = 100,
		dy = 150,
		dir = 0,
		
		draw = drawPlayer,
		update = updatePlayer,
	}
	return player
end

function updatePlayer(self, dt)
	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt
	
	-- lateral
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
	
	-- rotation
	if (love.keyboard.isDown(self.controls.clockwise)) then
		self.dir = self.dir + self.rotationSpeed * dt
	end
	if (love.keyboard.isDown(self.controls.counterClockwise)) then
		self.dir = self.dir - self.rotationSpeed * dt
	end
	
	self.dx = self.dx * PLAYER_FRICTION
	self.dy = self.dy * PLAYER_FRICTION
	
end

function shootPlayer(self)
	
end

function drawPlayer(self)
	love.graphics.setColor(self.color)
	love.graphics.line(self.x, self.y, self.x + math.cos(self.dir) * self.radius * 2, self.y + math.sin(self.dir) * self.radius * 2)
	love.graphics.circle("fill", self.x, self.y, self.radius)
end