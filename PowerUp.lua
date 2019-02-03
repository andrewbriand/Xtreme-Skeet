require 'Utils'
POWER_UP_COLOR = {0, 0, 1}

function PowerUp(x, y, velocity)
	local powerUp = {}
	powerUp.update = powerUpUpdate
	powerUp.draw = powerUpDraw
	powerUp.x = x
	powerUp.y = y
	powerUp.velocity = velocity
	powerUp.color = {0, 0, 1}
	powerUp.radius = 10
	powerUp.psystem = love.graphics.newParticleSystem(love.graphics.newImage("Fire.png"))
	powerUp.psystem:setParticleLifetime(2, 5) -- Particles live at least 2s and at most 5s.
	powerUp.psystem:setEmissionRate(10)
	powerUp.psystem:setSizeVariation(0)
	powerUp.psystem:setSizes(0.5)
	powerUp.psystem:setLinearAcceleration(0, 0, 0, 0) -- Random movement in all directions.
	powerUp.psystem:setColors(255, 255, 255, 255, 255, 255, 255, 0)
	powerUp.psystem:setParticleLifetime(1)
	--powerUp.psystem:setLinearAcceleration(-powerUp.velocity.x, -powerUp.velocity.y, -powerUp.velocity.x, -powerUp.velocity.y) 
	powerUp.psystem:setSpeed(magnitude(powerUp.velocity), magnitude(powerUp.velocity))
	powerUp.psystem:setDirection(math.pi + math.atan2(powerUp.velocity.y, powerUp.velocity.x), math.atan2(powerUp.velocity.y, powerUp.velocity.x))
	powerUp.psystem:setRelativeRotation(true)
	powerUp.destroyed = false
	powerUp.type = "SPIRAL"
	return powerUp
end

function powerUpUpdate(powerUp, dt)
	powerUp.x = powerUp.x + dt * powerUp.velocity.x
	powerUp.y = powerUp.y + dt * powerUp.velocity.y
	
	powerUp.psystem:update(dt)
end

function powerUpDraw(powerUp)
	love.graphics.setColor(POWER_UP_COLOR)
	love.graphics.draw(powerUp.psystem, powerUp.x, powerUp.y)
	love.graphics.setColor(powerUp.color)
	love.graphics.circle("fill", powerUp.x, powerUp.y, powerUp.radius)
	
end