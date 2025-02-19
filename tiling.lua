--window tiling logic

winWidth, winHeight = 1100, 700
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
	const float weight[5] = float[] (0.5, 0.25, 0.12, 0.07, 0.05);
	extern vec2 image_size;
	extern bool horizontal;  
	  
	vec4 effect(vec4 color, Image image, vec2 texture_coords, vec2 screen_coords ) {
	  vec2 tex_offset = 1.0 / image_size;
	  vec3 result = Texel(image, texture_coords).rgb * weight[0];
	  
	  if(horizontal) {
	    for(int i = 1; i < 5; ++i) {
	    result += Texel(image, texture_coords + vec2(tex_offset.x * i, 0.0)).rgb * weight[i] / 2; //Pixels to the right
	    result += Texel(image, texture_coords - vec2(tex_offset.x * i, 0.0)).rgb * weight[i] / 2; //Pixels to the left
	    }
	  }else {
	    for(int i = 1; i < 5; i++) {
	    result += Texel(image, texture_coords + vec2(0.0, tex_offset.y * i)).rgb * weight[i] / 2; //Pixels to the down
	    result += Texel(image, texture_coords - vec2(0.0, tex_offset.y * i)).rgb * weight[i] / 2; //Pixels to the up
	    }
	  }  
	      
	  return vec4(result, 1.0);
	}
]]

fadeShader = love.graphics.newShader[[
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
      if((pixel.r + pixel.g + pixel.b)/3 < .1){
      	pixel.r = 0;
      	pixel.g = 0;
      	pixel.b = 0;
      }
      return pixel * .1;
    }
  ]]


myShader = love.graphics.newShader[[
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
      return pixel * (1-color);
    }
  ]]