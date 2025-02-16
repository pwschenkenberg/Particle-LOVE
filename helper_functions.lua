require("particles")

math.randomseed(os.time())

-- returns list of particle objects
function createParticles(qty, radius)

	local list_of_particles = {}

	for i=1,qty do
		--create particles, set default values
		local particle = {}

		particle.r = radius
		particle.range = 700 --range of influence

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
<<<<<<< Updated upstream
		particle.drag = .95

		particle.color = randomColor(4)
=======
		particle.drag = .955

		if particle.color == getRGB("red") then
			particle.mass = 10
			particle.range = 600
			particle.drag = .98
		elseif particle.color == getRGB("green") then
			particle.mass = 1
			particle.drag = .9
			particle.range = 400
		end

		-- for wraparound logic
		particle.wrapRange = 100
		particle.wrapXvert = 0
		particle.wrapYvert = 0
		particle.wrapXhor = 0
		particle.wrapYhor = 0
		particle.wrapXcorn = 0
		particle.wrapYcorn = 0
>>>>>>> Stashed changes

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

function wrapDistance(p1,p2)
	local distance = math.sqrt((p2.wrapXvert-p1.x)^2 + (p2.wrapYvert-p1.y)^2)
	local dir = 1
	
	distanceH = math.min(distance,math.sqrt((p2.wrapXhor-p1.x)^2 + (p2.wrapYhor-p1.y)^2))
	distanceC = math.sqrt((p2.wrapXcorn-p1.x)^2 + (p2.wrapYcorn-p1.y)^2)
	
	if distanceH < distance then
		distance = distanceH
		dir = 2
	end

	if distanceC < distance then
		distance = distanceC
		dir = 3
	end

	return distance, dir
end

function wrapCoords(p,dir)
	if dir == 1 then
		return p.wrapXvert, p.wrapYvert
	elseif dir == 2 then
		return p.wrapXhor, p.wrapYhor
	elseif dir == 3 then
		return p.wrapXcorn, p.wrapYcorn
	end
end

function updateAcceleration(p)
	p.ax = 0
	p.ay = 0

	local winWidth, winHeight = love.window.getMode()

	for i,v in ipairs(pList) do
		if v == p then else
			local distance = pDistance(p,v)
			local wrapDistance, dir = 69420, 0

			if p.x < p.wrapRange or p.x > (winWidth - p.wrapRange) or p.y < p.wrapRange or p.y > (winHeight - p.wrapRange) then
				wrapDistance,dir = wrapDistance(p,v)
			end

			if distance < p.range then
				local pInt,eq = getParticleInteraction(p.color, v.color,distance,p.range)
				local angle = math.atan2(v.y - p.y, v.x - p.x)

				p.ax = p.ax + math.cos(angle) * pInt * eq / p.mass
				p.ay = p.ay + math.sin(angle) * pInt * eq / p.mass
			elseif wrapDistance < p.wrapRange then
				local x, y = wrapCoords(v,dir)
				local pInt,eq = getParticleInteraction(p.color, v.color,wrapDistance,p.range)
				local angle = math.atan2(y - p.y, x - p.x)

				p.ax = p.ax + math.cos(angle) * pInt * eq / p.mass
				p.ay = p.ay + math.sin(angle) * pInt * eq / p.mass
			end
		end
	end

	--gravity
	--p.ay = p.ay + 8

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

	--if p.y >= (winHeight - p.r) then
	--	p.vy = -p.vy
	--end	
end

function updatePosition(p,dt)
	local winWidth, winHeight = love.window.getMode()
	p.x = (p.x + p.vx * dt) % winWidth
	--p.y = math.min(p.y + p.vy * dt,winHeight-p.r)
	p.y = (p.y + p.vy * dt) % winHeight
end

