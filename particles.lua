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
function randomColor(num)
	local color = colorKeys[math.random(math.min(#colorKeys,num))]
	return getRGB(color)
end

local particleInteractions = {
	-- positive = attraction
    [colorTable.red] = { 
		[colorTable.red] 	= {-1,1}, --self
		[colorTable.green] 	= {1,2}, 
		[colorTable.blue] 	= {1,2}, 
		[colorTable.yellow]	= {1,2} },

    [colorTable.green] = { 
    	[colorTable.red] 	= {-1,3}, 
    	[colorTable.green] 	= {-1,3}, --self
    	[colorTable.blue] 	= {-1,3}, 
    	[colorTable.yellow]	= {-1,3} },

    [colorTable.blue] = { 
    	[colorTable.red] 	= {-1,2}, 
    	[colorTable.green] 	= {1,2}, 
    	[colorTable.blue] 	= {-1,1},--self
    	[colorTable.yellow]	= {-1,3} },

    [colorTable.yellow] = { 
    	[colorTable.red] 	= {-1,2}, 
    	[colorTable.green] 	= {1,2}, 
    	[colorTable.blue] 	= {1,2},
    	[colorTable.yellow]	= {-1,1} }--self
}

function forceEquation(i,distance,range)
	local x = distance/range
	if i == 1 then
		-- eq 1
		return math.sin((1.6 * (x^1 - 1))^3) * 2
	elseif i == 2 then
		-- eq 2
		--return -math.max(((math.atan(2*x - 0.1)/x)-1.08632) / 0.46097,-1)
		return 1-x
	elseif i == 3 then
		return math.sin(2 * math.pi * (x + 0.25))
	else
		return 0
	end

end

function getParticleInteraction(p,pTarget,distance,range)
	local pInt = particleInteractions[p][pTarget][1]
	local eq = particleInteractions[p][pTarget][2]
	return pInt,forceEquation(eq,distance,range)
end
