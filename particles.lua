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
		[colorTable.blue] 	= -3, 
		[colorTable.yellow]	= 4 },

    [colorTable.green] = { 
    	[colorTable.red] 	= 4, 
    	[colorTable.green] 	= -1, --self
    	[colorTable.blue] 	= 1, 
    	[colorTable.yellow]	= -10 },

    [colorTable.blue] = { 
    	[colorTable.red] 	= 4, 
    	[colorTable.green] 	= 1, 
    	[colorTable.blue] 	= -1,--self
    	[colorTable.yellow]	= -1 },

    [colorTable.yellow] = { 
    	[colorTable.red] 	= -1, 
    	[colorTable.green] 	= 5, 
    	[colorTable.blue] 	= -1,
    	[colorTable.yellow]	= -.5 }--self
}

function getParticleInteraction(p,pTarget)
	return particleInteractions[p][pTarget]
end
