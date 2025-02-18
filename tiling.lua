--window tiling logic

winWidth, winHeight = 1000, 700
totalWidth, totalHeight = love.window.getMode()

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

blurShader = love.graphics.newShader[[
	const float weight[10] = float[] (0.1845, 0.1790, 0.1624, 0.1384, 0.1125, 0.0849, 0.0590, 0.0406, 0.0240, 0.0148);
	extern vec2 image_size;
	extern bool horizontal;  
	  
	vec4 effect(vec4 color, Image image, vec2 texture_coords, vec2 _) {
	  vec2 tex_offset = 1.0 / image_size;
	  vec3 result = Texel(image, texture_coords).rgb * weight[0];
	  
	  if(horizontal) {
	    for(int i = 1; i < 10; ++i) {
	    result += Texel(image, texture_coords + vec2(tex_offset.x * i, 0.0)).rgb * weight[i] / 2; //Pixels to the right
	    result += Texel(image, texture_coords - vec2(tex_offset.x * i, 0.0)).rgb * weight[i] / 2; //Pixels to the left
	    }
	  }else {
	    for(int i = 1; i < 10; i++) {
	    result += Texel(image, texture_coords + vec2(0.0, tex_offset.y * i)).rgb * weight[i] / 2; //Pixels to the down
	    result += Texel(image, texture_coords - vec2(0.0, tex_offset.y * i)).rgb * weight[i] / 2; //Pixels to the up
	    }
	  }  
	      
	  return vec4(result, 1.0);
	}
]]



function drawbg( image )
    love.graphics.draw(image)
end

function runShader(screenshot)

	love.graphics.setShader(blurShader)
	love.graphics.draw(screenshot)
	love.graphics.setShader()
end