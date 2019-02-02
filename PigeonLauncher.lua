PigeonLauncher = {}

function PigeonLauncher.update()
	if (roundOver()) then
		table.insert(objects.pigeons, Pigeon(50, 50, {x = 20, y = 16}))
	end
end

function PigeonLauncher.draw()
	-- intentionally empty, only here so it can be called by physics
end

function roundOver()
	local returnVar = false
	for k, v in pairs(objects.pigeons) do
		if (v.x > 0) and (v.y > 0) and (v.x < SCREEN_WIDTH) and (v.y < SCREEN_HEIGHT) then
			return false
		end
	end
	for k, v in pairs(objects.bullets) do
		if (v.x > 0) and (v.y > 0) and (v.x < SCREEN_WIDTH) and (v.y < SCREEN_HEIGHT) then
			return false
		end
	end
	for k, v in pairs(objects.fragments) do
		if (v.x > 0) and (v.y > 0) and (v.x < SCREEN_WIDTH) and (v.y < SCREEN_HEIGHT) then
			return false
		end
	end
	return true
end