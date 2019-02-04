-- Returns: euclidean distance between points (x1, y1) and (x2, y2)
function dist(x1, y1, x2, y2)
	return math.sqrt(math.pow(x1-x2, 2) + math.pow(y1-y2,2))
end

--Returns: euclidean distance between v1 and v2 (as points)
function vDist(v1, v2)
	return dist(v1.x, v1.y, v2.x, v2.y)
end

-- Returns: boolean
-- Determnes if two circular objects are colliding
-- Pre: both objects must have properties x,y and radius 
function circleCollision(object1, object2)
	return dist(object1.x, object1.y, object2.x, object2.y) < (object1.radius + object2.radius)
end

-- Determines for 2 circular objects, object1 and object2
-- if object1 will collide with object2 "during" the next frame
-- Requires object1 to have velocity (a vector2), x, y, and radius
-- Requires object2 to have x, y, and radius
-- Works well for fast moving object1
-- modifies collPos
function dynamicCircleCollision(object1, object2, dt, collPos)
	object1Next = { x = object1.x + object1.velocity.x * dt, y = object1.y + object1.velocity.y*dt}
	obj1ToObj2 = vSub(object2, object1)
	local theta = math.atan2(obj1ToObj2.y, obj1ToObj2.x)
					- math.atan2(object1Next.y - object1.y, object1Next.x - object1.x)
	local mindist = math.abs(magnitude(obj1ToObj2) * math.sin(theta))
	if(mindist < (object1.radius + object2.radius) and dotProduct(object1.velocity, obj1ToObj2) > 0) then
		if (math.abs(magnitude(obj1ToObj2) * math.cos(theta)) - math.sqrt(math.pow(object2.radius, 2) - math.pow(mindist, 2)) < magnitude(object1.velocity) * dt) then
			return true
		end
	end
end


function dynamicCircleCollision2(object1, object2, dt, collPos)
	-- Two objects with the same velocity cannot collide
	if(vEqual(object1.velocity, object2.velocity)) then
		return false
	end
	vyTerm = object1.velocity.y - object2.velocity.y
	vxTerm = object1.velocity.x - object2.velocity.x
	oyTerm = object1.y - object2.y
	oxTerm = object1.x - object2.x
	s = (vyTerm*oyTerm - vxTerm*oxTerm)/(dt * (math.pow(vxTerm, 2) + math.pow(vyTerm, 2)))
	mindist = dist(s*dt*object1.velocity.x + object1.x, s*dt*object1.velocity.y + object1.y, s*dt*object2.velocity.x + object2.x, s*dt*object2.velocity.y + object2.y)
	if(s >= 0 and s <= 1 and mindist < object1.radius + object2.radius) then
		return true
	end
	return false
end

-- Returns the dot product of two 2d vectors
-- v1 and v2
-- Pre: both v1 and v2 have x and y components
function dotProduct(v1, v2) 
	return v1.x*v2.x + v1.y*v2.y
end

-- Checks if two 2d vectors are equal
-- Pre: both v1 and v2 have x and y components
function vEqual(v1, v2)
	return v1.x == v2.x and v1.y == v2.y
end

-- Returns v1 - v2
-- Where v1 and v2 are 2d vectors having x and y components
function vSub(v1, v2)
	return {x = v1.x - v2.x, y = v1.y - v2.y}
end

function vAdd(v1, v2)
	return {x = v1.x + v2.x, y = v1.y + v2.y}
end

function vScale(s, v)
	return {x = s*v.x, y = s*v.y}
end

--Returns the magnitude of a 2d vector v
--Pre: v has properties x and y
function magnitude(v)
	return math.sqrt(math.pow(v.x,2) + math.pow(v.y,2))
end

--draw a text but with a boarder
function love.graphics.printWithBoarder(text, x, y, size, mainColor, boarderColor, boarderSize)
	size         = size         or 21
	mainColor    = mainColor    or {1,1,1,1}
	boarderColor = boarderColor or {0,0,0,1}
	boarderSize  = boarderSize  or 1
	
	love.graphics.setFont(fonts[size])
	for i = 1, 8 do -- draws the boarder
		love.graphics.setColor(boarderColor)
		
		-- don't mind the magic equations
		xDiff =  math.floor(boarderSize * math.sqrt(4/3) * math.sin(8 * math.pi / 3 * math.ceil(i/3)) + .5)
		yDiff =  math.floor(boarderSize * math.sqrt(4/3) * math.sin(8 * math.pi / 3 * (i%3)         ) + .5)
		
		love.graphics.print(text,x + xDiff,y + yDiff)
	end
	
	love.graphics.setColor(mainColor)
	love.graphics.print(text, x, y) -- draw the regular text
end

--[[
 * Converts an HSV color value to RGB. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSV_color_space.
 * Assumes h, s, and v are contained in the set [0, 1] and
 * returns r, g, and b in the set [0, 1].
 *
 * @param   Number  h       The hue
 * @param   Number  s       The saturation
 * @param   Number  v       The value
 * @return  Array           The RGB representation
]]
function hsvToRgb(h, s, v, a)
	local r, g, b

	local i = math.floor(h * 6);
	local f = h * 6 - i;
	local p = v * (1 - s);
	local q = v * (1 - f * s);
	local t = v * (1 - (1 - f) * s);

	i = i % 6

	if i == 0 then r, g, b = v, t, p
	elseif i == 1 then r, g, b = q, v, p
	elseif i == 2 then r, g, b = p, v, t
	elseif i == 3 then r, g, b = p, q, v
	elseif i == 4 then r, g, b = t, p, v
	elseif i == 5 then r, g, b = v, p, q
	end

	return r, g, b, a
end