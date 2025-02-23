-- store color RGB values
local colorTable = {
	red 	= {1,0,0},
	green 	= {0,1,0},
	blue 	= {0,0,1},
	yellow 	= {1,1,0},
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
		[colorTable.red] 	= {0,1}, --self
		[colorTable.green] 	= {0,3}, 
		[colorTable.blue] 	= {0,2}, 
		[colorTable.yellow]	= {0,3} },

    [colorTable.green] = { 
    	[colorTable.red] 	= {0,2}, 
		[colorTable.green] 	= {0,1}, --self
		[colorTable.blue] 	= {0,2}, 
		[colorTable.yellow]	= {0,3} },

    [colorTable.blue] = { 
    	[colorTable.red] 	= {0,1}, 
		[colorTable.green] 	= {0,3}, 
		[colorTable.blue] 	= {0,1}, --self
		[colorTable.yellow]	= {0,3} },

    [colorTable.yellow] = { 
    	[colorTable.red] 	= {0,1}, 
		[colorTable.green] 	= {0,3}, 
		[colorTable.blue] 	= {0,2}, 
		[colorTable.yellow]	= {0,1} }--self
}

function forceEquation(i,distance,range)
	if distance > pRadius*2 then
		local x = distance/range

		if i == 1 then
			-- eq 1
			return x

		elseif i == 2 then
			-- eq 2
			--return -math.max(((math.atan(2*x - 0.1)/x)-1.08632) / 0.46097,-1)
			return -1/x

		elseif i == 3 then
			--return math.sin(2 * math.pi * (x + 0.25))
			return 1/x

		else
			return 0
		end

	else
		return -20
	end

end

function getParticleInteraction(p,pTarget,distance,range)
	local pInt = particleInteractions[p][pTarget][1]
	local eq = particleInteractions[p][pTarget][2]
	return forceEquation(eq,distance,range)
end
