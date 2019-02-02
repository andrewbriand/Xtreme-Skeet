function Pigeon(x, y, velocity)
	local pigeon = {}
	pigeon.update = pigeonUpdate
	pigeon.draw = pigeonDraw
	pigeon.x = x
	pigeon.y = y
	pigeon.velocity = {}
	pigeon.velocity.x = 0
	pigeon.velocity.y = 0
	return pigeon
end

function pigeonUpdate(pigeon)
	pigeon.x = pigeon.x + velocity.x
	pigeon.y = pigeon.y + velocity.y
end

function pigeonDraw(pigeon)
	love.graphics.circle("fill", pigeon.x, pigeon.y, 10)
end