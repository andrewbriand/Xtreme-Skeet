-- Returns: euclidean distance between points (x1, y1) and (x2, y2)
function dist(x1, y1, x2, y2)
	return math.sqrt(math.pow(x1-x2, 2) + math.pow(y1-y2,2))
end

-- Returns: boolean
-- Determines if two circular objects are colliding
-- Pre: both objects must have properties x,y and radius 
function circleCollision(object1, object2)
	return dist(object1.x, object1.y, object2.x, object2.y) < (object1.radius + object2.radius)
end

function dynamicCircleCollision(object1, object2, dt, collPos)
	object1Next = { x = object1.x + object1.velocity.x * dt, y = object1.y + object1.velocity.y*dt}
	local theta = math.atan2(object2.y - object1.y, object2.x - object1.x)
					- math.atan2(object1Next.y - object1.y, object1Next.x - object1.x)
	local mindist = math.abs(dist(object1.x, object1.y, object2.x, object2.y) * math.sin(theta))
	return mindist < (object1.radius + object2.radius) and dotProduct(object1.velocity, {x = object2.x - object1.x, y = object2.y - object1.y}) > 0
end

-- Returns the dot product of two 2d vectors
-- v1 and v2
-- Pre: both v1 and v2 have x and y components
function dotProduct(v1, v2) 
	return v1.x*v2.x + v1.y*v2.y
end

--Returns the magnitude of a 2d vector v
--Pre: v has properties x and y
function magnitude(v)
	return math.sqrt(math.pow(v.x,2) + math.pow(v.y,2))
end