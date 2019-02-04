BULLET_SPEED = 2000
function Bullet(x, y, velocity, color, owner, seeking, spiral)
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
	bullet.seeking = seeking or false
	bullet.spiral = spiral or false
	bullet.thrust = 1000
	bullet.thrustDecay = 10
	if(bullet.seeking) then
		mindistPigeon = objects.pigeons[1]
		if(mindistPigeon ~= nil) then
			--currDist = dist(mindistPigeon.x, mindistPigeon.y, bullet.x, bullet.y)
			hereToPigeon = vSub(mindistPigeon, bullet)
			ownerPlayer = objects.players[bullet.owner]
			aimDir = {x = math.cos(ownerPlayer.dir), y = math.sin(ownerPlayer.dir)}
			currDist = math.acos(dotProduct(hereToPigeon, aimDir)/(magnitude(hereToPigeon)*magnitude(aimDir)))
			for key, pigeon in pairs(objects.pigeons) do
				--thisDist = dist(pigeon.x, pigeon.y, bullet.x, bullet.y)
				hereToPigeon = vSub(pigeon, bullet)
				thisDist = math.acos(dotProduct(hereToPigeon, aimDir)/(magnitude(hereToPigeon)*magnitude(aimDir)))
				if((currDist > thisDist and thisDist > 0) or currDist < 0) then
					currDist = thisDist
					mindistPigeon = pigeon
				end
			end
			print(currDist)
			if(currDist > 0) then
				bullet.target = mindistPigeon
			end
		end
	end
	return bullet
end

function bulletUpdate(bullet, dt)
	bullet.x = bullet.x + dt * bullet.velocity.x
	bullet.y = bullet.y + dt * bullet.velocity.y
	if(bullet.seeking and bullet.thrust > 0 and bullet.target ~= nil) then
		
		if((not bullet.target.destroyed) or bullet.spiral) then
			
			thrustDirection = vSub(bullet.target, bullet)
			thrustDirection = vScale(1/magnitude(thrustDirection), thrustDirection)
			bullet.velocity = vAdd(bullet.velocity, vScale(bullet.thrust, thrustDirection))
			bullet.velocity = vScale(BULLET_SPEED, vScale(1/magnitude(bullet.velocity), bullet.velocity))
			bullet.thrust = bullet.thrust - bullet.thrustDecay
		end
	end
end

function bulletDraw(bullet)
	love.graphics.setColor(bullet.color)
	love.graphics.circle("fill", bullet.x, bullet.y, bullet.radius)
end