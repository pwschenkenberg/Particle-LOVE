require("helper_functions")

function love.load()
    -- pList is a global list holding all the particles
    pList = createParticles(4000,3)
    placeParticles()
end

function love.update(dt)
    --iterate over particles , get new accel values
    for i,v in ipairs(pList) do
        updateAcceleration(v)
    end

    --other accel updates as needed

    --new loop
    --use accel values to update velocity

    --use velocity values to update position


end

function love.draw()
    for i, v in ipairs(pList) do
        love.graphics.setColor(v.color)
        love.graphics.circle("fill",v.x,v.y,v.r)
    end
end