PigeonLauncher = {}

function PigeonLauncher.update()
	if (roundOver) then
		table.insert(objects.pigeons, Pigeon(50, 50, {x = 20, y = 16}))
	end
end

function PigeonLauncher.draw()
	-- intentionally empty, only here so it can be called by physics
end

function roundOver()
	return true
end