require 'Utils'
PIGEON_SPEED = 180

function Pigeon(x, y, velocity)
	local pigeon = {}
	pigeon.update = pigeonUpdate
	pigeon.draw = pigeonDraw
	pigeon.x = x
	pigeon.y = y
	pigeon.velocity = velocity
	pigeon.color = {255/255, 127/255, 80/255}
	pigeon.radius = 10
	pigeon.numFragments = 10
	pigeon.psystem = love.graphics.newParticleSystem(fireImage)
	pigeon.psystem:setParticleLifetime(2, 5) -- Particles live at least 2s and at most 5s.
	pigeon.psystem:setEmissionRate(10)
	pigeon.psystem:setSizeVariation(0)
	pigeon.psystem:setSizes(pigeon.radius*2/pigeon.psystem:getTexture():getWidth()*1.6)
	pigeon.psystem:setLinearAcceleration(0, 0, 0, 0) -- Random movement in all directions.
	pigeon.psystem:setColors({1,0,0,.9},{1,1,0,0})
	pigeon.psystem:setParticleLifetime(1)
	--pigeon.psystem:setLinearAcceleration(-pigeon.velocity.x, -pigeon.velocity.y, -pigeon.velocity.x, -pigeon.velocity.y) 
	pigeon.psystem:setSpeed(magnitude(pigeon.velocity), magnitude(pigeon.velocity))
	pigeon.psystem:setDirection(math.pi + math.atan2(pigeon.velocity.y, pigeon.velocity.x), math.atan2(pigeon.velocity.y, pigeon.velocity.x))
	pigeon.psystem:setRelativeRotation(true)
	pigeon.destroyed = false
	return pigeon
end

function pigeonUpdate(pigeon, dt)
	pigeon.velocity = vAdd(PigeonLauncher.windVelocity, pigeon.velocity)
	pigeon.x = pigeon.x + dt * pigeon.velocity.x
	pigeon.y = pigeon.y + dt * pigeon.velocity.y
	pigeon.psystem:setSpeed(magnitude(pigeon.velocity), magnitude(pigeon.velocity))
	pigeon.psystem:setDirection(math.pi + math.atan2(pigeon.velocity.y, pigeon.velocity.x), math.atan2(pigeon.velocity.y, pigeon.velocity.x))
	pigeon.psystem:update(dt)
	
end

function pigeonDraw(pigeon)
	love.graphics.draw(pigeon.psystem, pigeon.x, pigeon.y, 0, 1)
	
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(pigeonImage, pigeon.x - pigeon.radius, pigeon.y - pigeon.radius, 0, pigeon.radius*2/pigeonImage:getWidth())
end