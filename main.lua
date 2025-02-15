require("helper_functions")

function love.load()
    -- pList is a global list holding all the particles
    pList = createParticles(500,3)
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


end

function love.draw()
    for i, v in ipairs(pList) do
        love.graphics.setColor(v.color)
        love.graphics.circle("fill",v.x,v.y,v.r)
    end
end