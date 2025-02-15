-- store color RGB values
local colorTable = {
	red 	= {1,0,0},
	green 	= {0,1,0},
	blue 	= {0,0,1},
	--yellow 	= {1,1,0},
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

function seekOrAvoid(p,pTarget)
	if p.color == colorTable.red then
		if pTarget.color == colorTable.green then
			return 2
		else
			return -1
		end
	elseif p.color == colorTable.green then
		if pTarget.color == colorTable.blue then
			return 1
		else
			return -1
		end
	elseif p.color == colorTable.blue then
		if pTarget.color == colorTable.red then
			return 2
		else
			return -2
		end
	else
		return 0
	end
end

function getCenter(color)
	local winWidth, winHeight = love.window.getMode()
	return winWidth/2, winHeight/2
end