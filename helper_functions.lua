require("particles")

-- returns list of particle objects
function createParticles(qty, radius)

	local list_of_particles = {}

	for i=1,qty do
		--create particles, set default values
		local particle = {}

		particle.r = radius
		particle.range = 100 --range of influence

		--position
		particle.x = 0
		particle.y = 0

		--acceleration
		particle.ax = 0
		particle.ay = 0

		--velocity
		particle.vx = 0
		particle.vy = 0
		particle.vmax = 200

		particle.mass = 10
		particle.drag = 0.9

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
		local spacing = v.r * 6
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
	p.ax = 0
	p.ay = 0

	for i,v in ipairs(pList) do
		if v == p then else
			local distance = pDistance(p,v)
			if distance < p.range then
				local dir = seekOrAvoid(p,v)
				local angle = math.atan2(v.y - p.y, v.x - p.x)
				local force = forceMultipler(distance,p.range)

				p.ax = p.ax + math.cos(angle) * dir * force / p.mass
				p.ay = p.ax + math.sin(angle) * dir * force / p.mass
			end
		end

	end
end

function outOfBounds(p)
	local xin = 1
	local yin = 1
	local winWidth, winHeight = love.window.getMode()

	if p.x < 0 or p.x > winWidth then
		xin = -1
	end

	if p.y < 0 or p.y < winHeight then
		yin = -1
	end

	return xin, yin
end

function updateVelocity(p,dt)

	local xmult, ymult = outOfBounds(p)
	local angle = math.atan2(p.vy,p.vx)

	p.vx = (p.vx + p.ax) * xmult
	p.vy = (p.vy + p.ay) * ymult

	
end

function updatePosition(p,dt)
	p.x = p.x + p.vx * dt 
	p.y = p.y + p.vy * dt 
end
