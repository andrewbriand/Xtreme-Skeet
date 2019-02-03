function Fragment(x, y, velocity)
	local fragment = {}
	fragment.update = fragmentUpdate
	fragment.draw = fragmentDraw
	fragment.x = x
	fragment.y = y
	fragment.velocity = velocity
	fragment.color = {255/255 /1.1, 127/255 /1.1, 80/255 /1.1}
	fragment.radius = 5
	return fragment
end

function fragmentUpdate(fragment, dt)
	fragment.x = fragment.x + dt * fragment.velocity.x
	fragment.y = fragment.y + dt * fragment.velocity.y
end

function fragmentDraw(fragment)
	love.graphics.setColor(fragment.color)
	love.graphics.circle("fill", fragment.x, fragment.y, fragment.radius, 5)
end