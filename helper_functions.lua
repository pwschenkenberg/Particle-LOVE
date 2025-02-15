require("particles")

-- returns list of particle objects
function createParticles(qty, radius)

	local list_of_particles = {}

	for i=1,qty do
		--create particles, set default values
		local particle = {}

		particle.r = radius
		particle.range = 300 --range of influence

		--position
		particle.x = 0
		particle.y = 0

		--acceleration
		particle.ax = 0
		particle.ay = 0

		--velocity
		particle.vx = 0
		particle.vy = 0
		particle.vMax = 500

		particle.color = randomColor()

		table.insert(list_of_particles, particle)
	end

	return list_of_particles
end

-- takes list of particles and draws them in a rectangle based on 
-- particle radius and window width, does not account for window height
function placeParticles()
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
function pDistance(p1,p2)
	local distance = math.sqrt((p2.x-p1.x)^2 + (p2.y-p1.y)^2)
	return distance
end

-- takes a distance and converts it into a force multiplier from 0 to 1
function forceMultipler(distance,range)
	--linear from 1 to 0, scaled by range
	-- TODO: add a smoothing function over the range
	return math.max(1 - distance/range, 0)
end

function updateAcceleration(p)
	for i,v in ipairs(pList) do
				
	end
end