require("particles")

-- returns list of particle objects
function createParticles(qty, radius)

	local list_of_particles = {}

	for i=1,qty do
		--create particles, set default values
		local particle = {}

		particle.r = radius
		particle.x = 0
		particle.y = 0

		--keep x and y separate for ease of math and drawing
		particle.accelx = 0
		particle.accely = 0
		particle.velocityX = 0
		particle.velocityY = 0

		particle.color = randomColor()

		table.insert(list_of_particles, particle)
	end

	return list_of_particles
end

-- takes list of particles and draws them in a rectangle based on 
-- particle radius and window width, does not account for window height
function placeParticles(pList)
	local winWidth, winHeight = love.window.getMode()
	local initX = 50
	local initY = 50
	
	for i,v in ipairs(pList) do
		local spacing = v.r * 4
		local rowLength = (winWidth - initX*2)/spacing

		v.x = initX + (i-1) % rowLength * spacing
		v.y = initY + math.floor((i-1)/rowLength) * spacing
	end
end



-- returns distance in pixels between two particle objects
function distanceFromParticle(p1,p2)
	local distance = math.sqrt((p2.x-p1.x)^2 + (p2.y-p1.y)^2)
	return distance
end

-- takes a distance and converts it into a force multiplier from 0 to 1
function forceMultipler(distance,range)
	--linear from 1 to 0, scaled by range
	-- TODO: add a smoothing function over the range
	return math.max(1 - distance/range, 0)
end