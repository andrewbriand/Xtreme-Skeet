PIGEON_SPEED = 180

function Pigeon(x, y, velocity)
	local pigeon = {}
	pigeon.update = pigeonUpdate
	pigeon.draw = pigeonDraw
	pigeon.x = x
	pigeon.y = y
	pigeon.velocity = velocity
	pigeon.color = {1, 127/255, 80/255}
	pigeon.radius = 10
	pigeon.numFragments = 10
	return pigeon
end

function pigeonUpdate(pigeon, dt)
	pigeon.x = pigeon.x + dt * pigeon.velocity.x
	pigeon.y = pigeon.y + dt * pigeon.velocity.y
end

function pigeonDraw(pigeon)
	love.graphics.setColor(pigeon.color)
	love.graphics.circle("fill", pigeon.x, pigeon.y, pigeon.radius)
end