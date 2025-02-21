

gaussianBlur = love.graphics.newShader[[
	const float weight[10] = float[] (0.1845, 0.1790, 0.1624, 0.1384, 0.1125, 0.0849, 0.0590, 0.0406, 0.0240, 0.0148);
	const int rangeMult = 3;
	extern vec2 image_size;
	extern bool horizontal;  
	  
	vec4 effect(vec4 color, Image image, vec2 texture_coords, vec2 screen_coords ) {
	  vec2 tex_offset = 1.0 / image_size;
	  vec3 result = Texel(image, texture_coords).rgb * weight[0];


	  
	  if(horizontal) {
	    for(int i = 1; i < 10; ++i) {
	    result += Texel(image, texture_coords + vec2(tex_offset.x * rangeMult*i, 0.0)).rgb * weight[i] / 2; //Pixels to the right
	    result += Texel(image, texture_coords - vec2(tex_offset.x * rangeMult*i, 0.0)).rgb * weight[i] / 2; //Pixels to the left
	    }
	  }else {
	    for(int i = 1; i < 10; i++) {
	    result += Texel(image, texture_coords + vec2(0.0, tex_offset.y * rangeMult*i)).rgb * weight[i] / 2; //Pixels to the down
	    result += Texel(image, texture_coords - vec2(0.0, tex_offset.y * rangeMult*i)).rgb * weight[i] / 2; //Pixels to the up
	    }
	  }  


	  return vec4(result, 1) ;
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

smallBlur = love.graphics.newShader[[
	const float weight[4] = float[] (.5,.3,.15,.05);
	extern vec2 image_size;
	extern vec2 color_window;
	extern vec2 draw_offset;
	extern bool horizontal;  
	  
	vec4 effect(vec4 color, Image image, vec2 texture_coords, vec2 screen_coords ) {
	  vec2 tex_offset = 1.0 / image_size;
	  vec3 result = Texel(image, texture_coords).rgb * weight[0];

	  if(screen_coords.x < draw_offset.x || screen_coords.x > draw_offset.x + color_window.x){
		return Texel(image, texture_coords ) * color;
		}

		if(screen_coords.y < draw_offset.y || screen_coords.y > draw_offset.y + color_window.y){
		return Texel(image, texture_coords ) * color;
		}
	  
	  if(horizontal) {
	    for(int i = 1; i < 4; ++i) {
	    result += Texel(image, texture_coords + vec2(tex_offset.x * i, 0.0)).rgb * weight[i] / 2; //Pixels to the right
	    result += Texel(image, texture_coords - vec2(tex_offset.x * i, 0.0)).rgb * weight[i] / 2; //Pixels to the left
	    }
	  }else {
	    for(int i = 1; i < 4; i++) {
	    result += Texel(image, texture_coords + vec2(0.0, tex_offset.y * i)).rgb * weight[i] / 2; //Pixels to the down
	    result += Texel(image, texture_coords - vec2(0.0, tex_offset.y * i)).rgb * weight[i] / 2; //Pixels to the up
	    }
	  }  


	  return vec4(result, 1) ;
	}
  ]]


crowdsource = love.graphics.newShader[[
	const float radius = 1;
	const int samples = 20;
	const float step = .05;
	vec4 result = vec4(0,0,0,1);
	const float cutoff = 2;

	extern vec2 image_size;
	extern vec2 color_window;
	extern vec2 draw_offset;

	vec4 effect(vec4 color, Image image, vec2 texture_coords, vec2 screen_coords ) {

	if(screen_coords.x < draw_offset.x || screen_coords.x > draw_offset.x + color_window.x){
		return Texel(image, texture_coords ) * color;
	}

	if(screen_coords.y < draw_offset.y || screen_coords.y > draw_offset.y + color_window.y){
		return Texel(image, texture_coords ) * color;
	}

	  vec2 tex_offset = 1.0 / image_size;
	  vec3 totalRGB = vec3(0,0,0);


	  for(int i = 0; i < samples; i++){
	  	totalRGB += Texel(image, texture_coords + vec2(tex_offset.x * radius * cos(step * i), tex_offset.y * radius * sin(step * i))).rgb;
	  }

	  float maxColor = max(max(totalRGB.r, totalRGB.g), totalRGB.b);

	  //if(maxColor == 0){return result;}

	  if(totalRGB.r > cutoff){ result.r = 1;}
	  if(totalRGB.g > cutoff){ result.g = 1;}
	  if(totalRGB.b > cutoff){ result.b = 1;}

	  //result.rgb = totalRGB/maxColor;

	  return result;
	}
]]
