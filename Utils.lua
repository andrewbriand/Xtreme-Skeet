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

--Returns the magnitude of a 2d vector v
--Pre: v has properties x and y
function magnitude(v)
	return math.sqrt(math.pow(v.x,2) + math.pow(v.y,2))
end