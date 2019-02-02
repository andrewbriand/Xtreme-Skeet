function Fragment(x, y, velocity)
	local fragment = {}
	fragment.update = fragmentUpdate
	fragment.draw = fragmentDraw
	fragment.x = x
	fragment.y = y
	fragment.velocity = velocity
	fragment.color = {0, 0, 255}
	fragment.radius = 5
	return fragment
end

function fragmentUpdate(fragment, dt)
	fragment.x = fragment.x + dt * fragment.velocity.x
	fragment.y = fragment.y + dt * fragment.velocity.y
end

function fragmentDraw(fragment)
	love.graphics.setColor(fragment.color)
	love.graphics.circle("fill", fragment.x, fragment.y, fragment.radius)
end