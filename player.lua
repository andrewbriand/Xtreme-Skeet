PLAYER_SPEED = 1000
PLAYER_RADIUS = 10
PLAYER_FRICTION = .9

PLAYER_CONTROLS = {{
					up = "w",
					down = "s",
					left = "a",
					right = "d",
				  },{
					up = "up",
					down = "down",
					left = "left",
					right = "right",
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
		controls = controls,
		color = color,
		
		x = 100,
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
	
	if (love.keyboard.isDown(controls.down)) then
		self.dy = self.dy + self.speed * dt
	end
	if (love.keyboard.isDown(controls.up)) then
		self.dy = self.dy - self.speed * dt
	end
	if (love.keyboard.isDown(controls.right)) then
		self.dx = self.dx + self.speed * dt
	end
	if (love.keyboard.isDown(controls.left)) then
		self.dx = self.dx - self.speed * dt
	end
	
	self.dx = self.dx * PLAYER_FRICTION
	self.dy = self.dy * PLAYER_FRICTION
end

function drawPlayer(self)
	love.graphics.setColor(self.color)
	love.graphics.circle("fill", self.x, self.y, self.radius)
end