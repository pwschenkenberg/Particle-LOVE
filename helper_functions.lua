require("particles")

math.randomseed(os.time())

-- returns list of particle objects
function createParticles(qty, radius)

	local list_of_particles = {}

	for i=1,qty do
		--create particles, set default values
		local particle = {}

		particle.r = radius
		particle.range = 400 --range of influence

		--position
		particle.x = 0
		particle.y = 0

		--acceleration
		particle.ax = 0
		particle.ay = 0

		--velocity
		particle.vx = math.random(-10,10)
		particle.vy = math.random(-10,10)
		particle.vmax = 300

		particle.mass = 2
		particle.drag = .9

		particle.color = randomColor()

		table.insert(list_of_particles, particle)
	end

	return list_of_particles
end

-- takes list of particles and draws them in a rectangle based on 
-- particle radius and window width, does not account for window height
function placeParticles()
	local winWidth, winHeight = love.window.getMode()
	local initX = 200
	local initY = 150
	
	for i,v in ipairs(pList) do
		local spacing = v.r * 6
		local rowLength = (winWidth - initX*2)/spacing

		v.x = initX + (i-1) % rowLength * spacing
		v.y = initY + math.floor((i-1)/rowLength) * spacing +math.random(-10,10)
	end
end


-- returns distance in pixels between two particle objects
function pDistance(p1,p2)
	local distance = math.sqrt((p2.x-p1.x)^2 + (p2.y-p1.y)^2)
	return distance
end

-- takes a distance and converts it into a force multiplier from 0 to 1
function forceMultipler(distance,range)
	-- linear from 1 to 0, scaled by range
	-- TODO: add a smoothing function over the range
	local x = distance/range

	return -math.sin(5*x-1.6)
end

function updateAcceleration(p)
	p.ax = 0
	p.ay = 0

	for i,v in ipairs(pList) do
		if v == p then else
			local distance = pDistance(p,v)
			if distance < p.range then
				local dir = getParticleInteraction(p.color, v.color)
				local angle = math.atan2(v.y - p.y, v.x - p.x)
				local force = forceMultipler(distance,p.range)

				p.ax = p.ax + math.cos(angle) * dir * force / p.mass
				p.ay = p.ay + math.sin(angle) * dir * force / p.mass
			end
		end
	end

	--gravity
	p.ay = p.ay + 10

	if love.mouse.isDown(1) then
		local mousex, mousey = love.mouse.getPosition()
		if math.sqrt((mousex-p.x)^2 + (mousey-p.y)^2) < p.range then
			local mouseAngle = math.atan2(mousey - p.y, mousex - p.x)
			p.ax = p.ax - math.cos(mouseAngle) * 75
			p.ay = p.ay - math.sin(mouseAngle) * 75
		end
	end

	if love.mouse.isDown(2) then
		local mousex, mousey = love.mouse.getPosition()
		if math.sqrt((mousex-p.x)^2 + (mousey-p.y)^2) < p.range then
			local mouseAngle = math.atan2(mousey - p.y, mousex - p.x)
			p.ax = p.ax + math.cos(mouseAngle) * 75
			p.ay = p.ay + math.sin(mouseAngle) * 75
		end
	end
	
end

function updateVelocity(p,dt)
	local winWidth, winHeight = love.window.getMode()
	local angle = math.atan2(p.vy,p.vx)

	p.vx = (p.vx + p.ax) * p.drag
	p.vy = (p.vy + p.ay) * p.drag

	if p.y >= (winHeight - p.r) then
		p.vy = -p.vy
	end
	
end

function updatePosition(p,dt)
	local winWidth, winHeight = love.window.getMode()
	p.x = (p.x + p.vx * dt) % winWidth
	p.y = math.min(p.y + p.vy * dt,winHeight-p.r) --% winHeight
end

