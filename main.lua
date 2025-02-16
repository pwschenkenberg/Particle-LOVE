require("helper_functions")
require("tiling")

function love.load()
    
    -- pList is a global list holding all the particles
    pList = createParticles(400,.2)
    placeParticles()
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
    love.graphics.applyTransform(transform)
    love.graphics.rectangle("line",0,0,winWidth,winHeight)


    for i, v in ipairs(pList) do
        --love.graphics.setColor(v.color)
        --love.graphics.circle("line",v.x,v.y,v.r)
        drawTiles(v)
    end


    love.graphics.origin()
    love.graphics.setColor(.5,.5,.5)
    love.graphics.print(FPS, 10, 10) 

end