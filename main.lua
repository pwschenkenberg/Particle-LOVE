require("helper_functions")
require("tiling")
require("shaders")

function love.load()
    
    -- pList is a global list holding all the particles
    pList = createParticles(500,3)
    placeParticles()

    gaussianBlur:send("image_size",{totalWidth,totalHeight})
    crowdsource:send("image_size",{totalWidth,totalHeight})
    smallBlur:send("image_size",{totalWidth,totalHeight})
    crowdsource:send("color_window",{winWidth,winHeight})
    crowdsource:send("draw_offset",{transX,transY})

    canvas1 = love.graphics.newCanvas()
    canvas2 = love.graphics.newCanvas()
    canvas3 = love.graphics.newCanvas()

end


function love.update(dt)
    --iterate over particles , get new accel values
    for i,v in ipairs(pList) do
        updateAcceleration(v)
    end

    for i,v in ipairs(pList) do
        updateVelocity(v,dt)
        updatePosition(v,dt)
    end

    FPS = math.floor(1/dt)

end




function love.draw()

    love.graphics.setCanvas(canvas1)
    love.graphics.clear()

    love.graphics.applyTransform(transform)
    for i, v in ipairs(pList) do
        drawTiles(v)
    end
    love.graphics.origin()



    love.graphics.setShader(gaussianBlur)
    gaussianBlur:send("horizontal", false)

    love.graphics.setCanvas(canvas2)
    love.graphics.draw(canvas1)

    love.graphics.setCanvas(canvas3)
    gaussianBlur:send("horizontal", true)
    love.graphics.draw(canvas2)


    love.graphics.setCanvas(canvas1)

    love.graphics.setShader(crowdsource)
    love.graphics.draw(canvas3)

    love.graphics.setShader(smallBlur)
    smallBlur:send("horizontal", true)
    love.graphics.setCanvas(canvas2)
    love.graphics.draw(canvas1)

    smallBlur:send("horizontal", false)
    love.graphics.setCanvas()
    love.graphics.draw(canvas2)

    love.graphics.setShader()

    --draw rectangle and fps counter
    love.graphics.setColor(.5,.5,.5)
    love.graphics.rectangle("line",transX,transY,winWidth,winHeight)

    love.graphics.print(FPS, 10, 10) 

end

function love.keypressed( k )
    if k == "r" then love.event.quit "restart" end
end
