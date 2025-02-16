--window tiling logic

winWidth, winHeight = 500, 500
local totalWidth, totalHeight = love.window.getMode()

transform = love.math.newTransform()

transX = (totalWidth-winWidth)/2
transY = (totalHeight-winHeight)/2
transform:translate(transX,transY)

local xTiles = math.ceil(transX/winWidth) * 2 + 1
local yTiles = math.ceil(transY/winHeight) * 2 + 1

function drawTiles(p)
	local tileOriginX = -math.ceil(transX/winWidth) * winWidth
	local tileOriginY = -math.ceil(transY/winHeight) * winHeight

	for i = 0,xTiles-1 do
		local xOff = tileOriginX + i * winWidth

		for j = 0, yTiles-1 do
			if i+1 == math.ceil(xTiles/2) and j+1 == math.ceil(yTiles/2) then
				love.graphics.setColor(p.color)
			else
				love.graphics.setColor(.5,.5,.5)
			end

			local yOff = tileOriginY + j * winHeight

			love.graphics.circle("line",p.x + xOff,p.y + yOff,p.r)

		end
	end

end