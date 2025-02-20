
--[[
gaussianBlur = love.graphics.newShader[[
	const float weight[10] = float[] (.3, .3, .15, 0.1384, 0.1125, 0.0849, 0.0590, 0.0406, 0.0240, 0.0148);
	extern vec2 image_size;
	extern bool horizontal;  
	  
	vec4 effect(vec4 color, Image image, vec2 texture_coords, vec2 screen_coords ) {
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


	  return vec4(result, .2) ;
	}
]]

colorMask = love.graphics.newShader[[
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords );

      if(color.rgb == vec3(0,0,0)){
      	color.a = 0;
      }

      return pixel * color;
    }
  ]]

boxBlur = love.graphics.newShader[[
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
      return pixel * (1-color);
    }
  ]]


crowdsource = love.graphics.newShader[[
	const int radius = 10;
	extern vec2 image_size;

	vec4 effect(vec4 color, Image image, vec2 texture_coords, vec2 screen_coords ) {
	  vec2 tex_offset = 1.0 / image_size;
	  vec3 avgPixel = vec3(0,0,0);

	  int pixelCount = radius * radius;

	  for(int i = 0; i < radius; i++){
	  	for(int j = 0; j < radius; j++){
	  		avgPixel += Texel(image, texture_coords + vec2(tex_offset.x * i, tex_offset.y * j)).rgb / pixelCount;
	  	}
	  }

	  //avgPixel /= pixelCount;

	  if(avgPixel.r < 0.5){ avgPixel.r = 0; }
	  if(avgPixel.g < 0.5){ avgPixel.g = 0; }
	  if(avgPixel.b < 0.5){ avgPixel.b = 0; }

	  return vec4(avgPixel,1);
	}
]]
