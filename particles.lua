-- store color RGB values
local colorTable = {
	red 	= {.8,0,0},
	green 	= {0,.8,0},
	blue 	= {.2,.4,1},
	yellow 	= {.8,.8,0},
	--purple 	= {1,0,1},
	--cyan 	= {0,1,1},
	--white	= {1,1,1},
	--black 	= {0,0,0}
}

local colorKeys = {}
for k in pairs(colorTable) do
	table.insert(colorKeys,k)
end


-- take color name as a string and return rgb, 
-- return white if string is not recognized
function getRGB(color)
	if colorTable[color] then
		return colorTable[color]
	else
		return {1,1,1}
	end
end

-- returns random {r,g,b} value from colorTable
function randomColor()
	local color = colorKeys[math.random(#colorKeys)]
	return getRGB(color)
end

local particleInteractions = {
	-- positive = attraction
    [colorTable.red] = { 
   		[colorTable.red] 	= -1, --self
		[colorTable.green] 	= 1, 
		[colorTable.blue] 	= -1, 
		[colorTable.yellow]	= 1 },

    [colorTable.green] = { 
    	[colorTable.red] 	= -1, 
    	[colorTable.green] 	= -1, --self
    	[colorTable.blue] 	= 1, 
    	[colorTable.yellow]	= -1 },

    [colorTable.blue] = { 
    	[colorTable.red] 	= 1, 
    	[colorTable.green] 	= -1, 
    	[colorTable.blue] 	= -1,--self
    	[colorTable.yellow]	= 1 },

    [colorTable.yellow] = { 
    	[colorTable.red] 	= 1, 
    	[colorTable.green] 	= 1, 
    	[colorTable.blue] 	= -1,
    	[colorTable.yellow]	= -1 }--self
}

function getParticleInteraction(p,pTarget)
	return particleInteractions[p][pTarget]
end

function pushToCenter(p)
	local winWidth, winHeight = love.window.getMode()
	local angle = math.atan2(winHeight/2 - p.y, winWidth/2 - p.x)

	if p.x < 10 or math.abs(winWidth-p.x) < 10 or p.y < 10 or math.abs(winHeight-p.y) < 10 then
		p.ax = p.ax + math.cos(angle)*20
		p.ay = p.ay + math.sin(angle)*20
	end
end