require("helper_functions")
require("tiling")
require("shaders")

function love.load()
    
    -- pList is a global list holding all the particles
    pList = createParticles(500,4)
    placeParticles()

    --gaussianBlur:send("image_size",{totalWidth,totalHeight})
    crowdsource:send("image_size",{totalWidth,totalHeight})

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

    --drawGaussianBlur()

    love.graphics.setShader(crowdsource)

    love.graphics.applyTransform(transform)
    for i, v in ipairs(pList) do
        drawTiles(v)
    end
    love.graphics.origin()

    love.graphics.setShader()



    --draw rectangle and fps counter
    love.graphics.setColor(.5,.5,.5)
    love.graphics.rectangle("line",transX,transY,winWidth,winHeight)

    love.graphics.print(FPS, 10, 10) 

end

function love.keypressed( k )
    if k == "r" then love.event.quit "restart" end
end
