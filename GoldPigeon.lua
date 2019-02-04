require 'Utils'

function GoldPigeon(x, y, velocity, pType)
	local goldPigeon = {}
	goldPigeon.update = goldPigeonUpdate
	goldPigeon.draw = goldPigeonDraw
	goldPigeon.x = x
	goldPigeon.y = y
	goldPigeon.velocity = velocity
	goldPigeon.color = {0, 0, 1}
	goldPigeon.radius = 10
	goldPigeon.birth = globalTimer
	goldPigeon.psystem = love.graphics.newParticleSystem(fireImage)
	goldPigeon.psystem:setParticleLifetime(2, 5) -- Particles live at least 2s and at most 5s.
	goldPigeon.psystem:setEmissionRate(10)
	goldPigeon.psystem:setSizeVariation(0)
	goldPigeon.psystem:setSizes(.5)
	goldPigeon.psystem:setLinearAcceleration(0, 0, 0, 0) -- Random movement in all directions.
	goldPigeon.psystem:setColors({.95,.95,.1,1},{1,1,0,.5},{1,1,0,0})
	goldPigeon.psystem:setParticleLifetime(1)
	--goldPigeon.psystem:setLinearAcceleration(-goldPigeon.velocity.x, -goldPigeon.velocity.y, -goldPigeon.velocity.x, -goldPigeon.velocity.y) 
	goldPigeon.psystem:setSpeed(magnitude(goldPigeon.velocity), magnitude(goldPigeon.velocity))
	goldPigeon.psystem:setDirection(math.pi + math.atan2(goldPigeon.velocity.y, goldPigeon.velocity.x), math.atan2(goldPigeon.velocity.y, goldPigeon.velocity.x))
	goldPigeon.psystem:setRelativeRotation(true)
	goldPigeon.destroyed = false
	goldPigeon.image = fireImage
	return goldPigeon
end

function goldPigeonUpdate(goldPigeon, dt)
	goldPigeon.x = goldPigeon.x + dt * goldPigeon.velocity.x
	goldPigeon.y = goldPigeon.y + dt * goldPigeon.velocity.y
	
	goldPigeon.psystem:update(dt)
end

function goldPigeonDraw(goldPigeon)
	--love.graphics.setColor(POWER_UP_COLOR)
	love.graphics.setColor(1,1,1)
	love.graphics.draw(goldPigeon.psystem, goldPigeon.x, goldPigeon.y)
	
	love.graphics.setColor(.9,.9,0,1)
	love.graphics.draw(goldPigeon.image, goldPigeon.x - goldPigeon.radius, goldPigeon.y - goldPigeon.radius, 0, goldPigeon.radius*2/goldPigeon.image:getWidth())	
	
end