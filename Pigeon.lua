function Pigeon(x, y)
	local pigeon = {}
	pigeon.update = pigeonUpdate
	pigeon.draw = pigeonDraw
	pigeon.x = x
	pigeon.y = y
	return pigeon
end

function pigeonUpdate(pigeon)
	
end

function pigeonDraw(pigeon)
	love.graphics.circle("fill", pigeon.x, pigeon.y, 10)
end