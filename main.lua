require("helper_functions")
require("tiling")

function love.load()
    
    -- pList is a global list holding all the particles
    pList = createParticles(500,2)
    placeParticles()

    blurShader:send("image_size",{totalWidth,totalHeight})

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
--[[
    love.graphics.setCanvas(canvas1)

    --draw dots to canvas1
    love.graphics.applyTransform(transform)
    for i, v in ipairs(pList) do
        drawTiles(v)
    end
    love.graphics.origin()

    --apply vertical blur and draw to canvas2
    love.graphics.setCanvas(canvas2)
    love.graphics.setShader(blurShader)
    blurShader:send("horizontal", false)
    love.graphics.draw(canvas1)

    --apply horizontal blur and draw to canvas3
    love.graphics.setCanvas(canvas3)
    blurShader:send("horizontal", true)
    love.graphics.draw(canvas2)
    love.graphics.setShader()

    --draw canvas3 to screen
    love.graphics.setCanvas()
    love.graphics.draw(canvas3)

    --apply fade to canvas3 and draw back to canvas1
    love.graphics.setCanvas(canvas1)
    love.graphics.setShader(fadeShader)
    love.graphics.draw(canvas3)
    love.graphics.setCanvas()
    love.graphics.setShader()
]]

    love.graphics.setCanvas(canvas2)
    love.graphics.draw(canvas1)


    love.graphics.setCanvas(canvas1)
    love.graphics.setShader(fadeShader)
    love.graphics.draw(canvas2)
    love.graphics.setShader()
    

    love.graphics.applyTransform(transform)
    for i, v in ipairs(pList) do
        drawTiles(v)
    end
    love.graphics.origin()

    love.graphics.setCanvas()
    love.graphics.draw(canvas1)



    --draw rectangle and fps counter
    love.graphics.setColor(.5,.5,.5)
    love.graphics.rectangle("line",transX,transY,winWidth,winHeight)

    love.graphics.print(FPS, 10, 10) 

end

function love.keypressed(k)
    if k == "r" then love.event.quit "restart" end
end