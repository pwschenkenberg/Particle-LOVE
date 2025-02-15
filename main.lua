require("helper_functions")

function love.load()
    listOfParticles = createParticles(4000,3)
    placeParticles(listOfParticles)
end

function love.update(dt)
    --iterate over particles , get new accel values
    

    --other accel updates as needed

    --new loop
    --use accel values to update velocity

    --use velocity values to update position


end

function love.draw()
    for i, v in ipairs(listOfParticles) do
        love.graphics.setColor(v.color)
        love.graphics.circle("fill",v.x,v.y,v.r)
    end
end