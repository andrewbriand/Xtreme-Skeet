function Pigeon(x, y, velocity)
	local pigeon = {}
	pigeon.update = pigeonUpdate
	pigeon.draw = pigeonDraw
	pigeon.x = x
	pigeon.y = y
	pigeon.velocity = velocity
	pigeon.color = {1, 127/255, 80/255}
	return pigeon
end

function pigeonUpdate(pigeon)
	pigeon.x = pigeon.x + pigeon.velocity.x
	pigeon.y = pigeon.y + pigeon.velocity.y
end

function pigeonDraw(pigeon)
	love.graphics.setColor(pigeon.color)
	love.graphics.circle("fill", pigeon.x, pigeon.y, 10)
end