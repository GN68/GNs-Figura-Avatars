timeSinceStart = 0

function player_init()

    -- Custom shader stuff!
    local format = "POSITION_COLOR_TEXTURE_OVERLAY_LIGHT_NORMAL"
    local vertexSource = [==[
    #version 150

    in vec3 Position;
    in vec4 Color;
    in vec2 UV0;
    in ivec2 UV1;
    in ivec2 UV2;
    in vec3 Normal;

    uniform sampler2D Sampler1; //Overlay Sampler
    uniform sampler2D Sampler2; //Lightmap Sampler

    //This line wasn't in the template, but I added it in so I could use the GameTime in the calculation.
    uniform float GameTime;

    uniform mat4 ModelViewMat;
    uniform mat4 ProjMat;

    uniform vec3 Light0_Direction;
    uniform vec3 Light1_Direction;

    out float vertexDistance;
    out vec4 vertexColor;
    out vec4 lightMapColor;
    out vec4 overlayColor;
    out vec2 texCoord0;
    out vec4 normal;

    void main() {
      gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

      vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
      texCoord0 = UV0;
      normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
    }
  ]==]
    local fragmentSource = [==[
    #version 150

    uniform sampler2D Sampler0;

    uniform vec4 ColorModulator;
    uniform float FogStart;
    uniform float FogEnd;
    uniform vec2 ScreenSize;
    uniform vec4 FogColor;

    vec4 tint = vec4(0.9,0.9,0.9,0);

    ivec2 textureRes = ivec2(55,886);
    in float vertexDistance;
    in vec4 vertexColor;
    in vec4 lightMapColor;
    in vec4 overlayColor;
    in vec2 texCoord0;
    in vec4 normal;

    out vec4 fragColor;

    void main() {
        vec4 color = vec4(0.0);
        vec4 bl = texture(Sampler0, (floor(texCoord0*textureRes))/textureRes);
        vec4 br = texture(Sampler0, floor(texCoord0*textureRes+vec2(1.0,0))/textureRes);
        vec4 tl = texture(Sampler0, floor(texCoord0*textureRes+vec2(0.0,1.0))/textureRes);
        vec4 tr = texture(Sampler0, floor(texCoord0*textureRes+vec2(1.0,1.0))/textureRes);
        vec4 bx = mix(bl,br,((texCoord0.x*textureRes.x)-floor(texCoord0.x*textureRes.x)));
        vec4 tx = mix(tl,tr,((texCoord0.x*textureRes.x)-floor(texCoord0.x*textureRes.x)));
        color = mix(bx,tx,((texCoord0.y*textureRes.y)-floor(texCoord0.y*textureRes.y)));
      fragColor = color;
    }
  ]==]
    -- Register the shader:
    renderlayers.registerShader("My Shader", format, vertexSource,
                                fragmentSource, 3, nil)

    local before = function()
        renderlayers.useShader("My Shader")
        renderlayers.setTexture(0, "MY_TEXTURE")
        renderlayers.enableDepthTest()
        renderlayers.disableCull()
    end
    local after = function() renderlayers.enableCull() end
    -- Register the render layer:
    renderlayers.registerRenderLayer("My Render Layer", {}, before, after)

    -- Finally, set the render layer on whatever part you want!
    -- I'm using model.Base, which in this avatar contains everything else.
    model.NO_PARENT.setRenderLayer("My Render Layer")
end

function world_render(delta)
    local camRot = renderer.getCameraRot()
    local camPos = renderer.getCameraPos() * vectors.of {-16, -16, 16}
    model.NO_PARENT.setPos(camPos)
    model.NO_PARENT.setRot(camRot)
end

function angleToDir(direction)
    if type(direction) == "table" then direction = vectors.of {direction} end
    return vectors.of({
        math.cos(math.rad(direction.y + 90)) * math.cos(math.rad(direction.x)),
        math.sin(math.rad(-direction.x)),
        math.sin(math.rad(direction.y + 90)) * math.cos(math.rad(direction.x))
    })
end

t = 0
e = 1
function tick()
    if timeSinceStart == 20 then
        sound.playCustomSound("pre", renderer.getCameraPos(), {1, 1})
    end
    if timeSinceStart == 220 then
        timeSinceStart = 51
        sound.playCustomSound("mid", renderer.getCameraPos(), {1, 1})
    end
    if timeSinceStart == 50 then
        sound.playCustomSound("mid", renderer.getCameraPos(), {1, 1})
    end

    timeSinceStart = timeSinceStart + 1
    e = e + 1
    if e == 2 then
        e = 0
        model.NO_PARENT.setUV({0, math.floor(t) / 22})
        t = (t + 1.1) % 22
    end
end
