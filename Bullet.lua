function Bullet(x, y, velocity)
	local bullet = {}
	bullet.update = bulletUpdate
	bullet.draw = bulletDraw
	bullet.x = x
	bullet.y = y
	bullet.velocity = velocity
	bullet.color = {1, 127/255, 80/255}
	bullet.radius = 1
	return bullet
end

function bulletUpdate(bullet, dt)
	bullet.x = bullet.x + dt * bullet.velocity.x
	bullet.y = bullet.y + dt * bullet.velocity.y
end

function bulletDraw(bullet)
	love.graphics.setColor(bullet.color)
	love.graphics.circle("fill", bullet.x, bullet.y, bullet.radius)
end