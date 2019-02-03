require 'Utils'
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
	pigeon.psystem = love.graphics.newParticleSystem(love.graphics.newImage("Fire.png"))
	pigeon.psystem:setParticleLifetime(2, 5) -- Particles live at least 2s and at most 5s.
	pigeon.psystem:setEmissionRate(10)
	pigeon.psystem:setSizeVariation(0)
	pigeon.psystem:setSizes(0.5)
	pigeon.psystem:setLinearAcceleration(0, 0, 0, 0) -- Random movement in all directions.
	pigeon.psystem:setColors(255, 255, 255, 255, 255, 255, 255, 0)
	pigeon.psystem:setParticleLifetime(1)
	--pigeon.psystem:setLinearAcceleration(-pigeon.velocity.x, -pigeon.velocity.y, -pigeon.velocity.x, -pigeon.velocity.y) 
	pigeon.psystem:setSpeed(magnitude(pigeon.velocity), magnitude(pigeon.velocity))
	pigeon.psystem:setDirection(math.pi + math.atan2(pigeon.velocity.y, pigeon.velocity.x), math.atan2(pigeon.velocity.y, pigeon.velocity.x))
	pigeon.psystem:setRelativeRotation(true)
	return pigeon
end

function pigeonUpdate(pigeon, dt)
	pigeon.x = pigeon.x + dt * pigeon.velocity.x
	pigeon.y = pigeon.y + dt * pigeon.velocity.y
	
	pigeon.psystem:update(dt)
end

function pigeonDraw(pigeon)
	love.graphics.setColor(FRAGMENT_COLOR)
	love.graphics.draw(pigeon.psystem, pigeon.x, pigeon.y)
	love.graphics.setColor(pigeon.color)
	love.graphics.circle("fill", pigeon.x, pigeon.y, pigeon.radius)
	
end