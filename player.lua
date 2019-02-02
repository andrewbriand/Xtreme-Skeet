PLAYER_SPEED = 200
PLAYER_RADIUS = 20

function Player(name)
	local player = {
		name = name,
		x = 100,
		y = 150,
		
		dx = 100,
		dy = 0,
		
		dir = 0,
		
		radius = PLAYER_RADIUS,
		
		speed = PLAYER_SPEED,
		
		draw = drawPlayer,
		update = updatePlayer,
	}
end

function updatePlayer(self, dt)
	
end

function drawPlayer(self)
	love.graphics.circle("fill", self.x, self.y, self.radius)
end