
points = {}

gravity = vectors.of{0,-0.1,0}

function declarePoint()
    table.insert(points,{
        lastPosition = vectors.of{},
        position = vectors.of{0,13},
        velocity = vectors.of{1,0,0},
    })
end

function player_init()
    declarePoint()
end

function tick()
    for index, p in pairs(points) do
        p.lastPosition = p.position
        local result = renderer.raycastBlocks(p.position, p.position+p.velocity,"COLLIDER", "NONE")
        if result then
            p.position = result.pos
            p.velocity = p.position-result.pos
        else
            p.position = p.position + p.velocity
        end
        p.velocity = p.velocity + gravity
    end
end

function world_render(delta) 
    model.NO_PARENT_CUBE.setPos(vectors.lerp(points[1].lastPosition,points[1].position,delta)*vectors.of({-16,-16,16}))
end