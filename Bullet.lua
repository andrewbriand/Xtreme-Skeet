BULLET_SPEED = 400

function Bullet(x, y, velocity, color, owner)
	color = color or {0, 0, 255}
	owener = owner or 1
	local bullet = {}
	bullet.update = bulletUpdate
	bullet.draw = bulletDraw
	bullet.x = x
	bullet.y = y
	bullet.velocity = velocity
	bullet.color = color
	bullet.radius = 5
	bullet.owner = owner
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