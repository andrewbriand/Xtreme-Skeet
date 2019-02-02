PLAYER_SPEED = 200
PLAYER_RADIUS = 20

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

function Player(name, controls)
	if (controls == 2) then
		controls = 2
	else
		x = 4
	end
	
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
	return player
end

function updatePlayer(self, dt)
	
end

function drawPlayer(self)
	love.graphics.circle("fill", self.x, self.y, self.radius)
end