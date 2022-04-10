
currentPosition = nil
lastPosition = nil
linear_velocity = nil

currentRotation = nil
lastRotation = nil
angular_velocity = nil

lastBodyYaw = nil
currentBodyYaw = nil

function player_init()
    currentPosition = player.getPos()
    lastPosition = currentPosition
    linear_velocity = vectors.of({0})

    currentRotation = player.getRot()
    lastRotation = currentRotation

    currentBodyYaw = player.getBodyYaw()
    lastBodyYaw = currentBodyYaw
end

function tick()
    lastPosition = currentPosition
    currentPosition = player.getPos()
    linear_velocity = currentPosition - lastPosition

    lastRotation = currentRotation
    currentRotation = player.getRot()
    angular_velocity = currentRotation - lastRotation

    lastBodyYaw = currentBodyYaw
    currentBodyYaw = player.getBodyYaw()
end


function tick()
    if player.getVehicle() ~= nil and (player.getVehicle().getType() == "minecraft:boat" )then
        renderer.setMountEnabled(false)
        vehicleMode(false)
     else
         renderer.setMountEnabled(true)
         vehicleMode(true)
     end
end

model.NO_PARENT.offset.setPos({0,-8,0})

function vehicleMode(is)
    for key, value in pairs(model.NO_PARENT.offset) do
        if type(value) == "table" then
            value.setEnabled((not is))
        end
    end
    if is then
        for key, value in pairs(vanilla_model) do
            value.setPos(vectors.of({0,0,0}))
        end
        camera.FIRST_PERSON.setPos({0})
        camera.THIRD_PERSON.setPos({0})
    else
        for key, value in pairs(vanilla_model) do
            value.setPos(vectors.of({0,-16,8}))
        end
        camera.FIRST_PERSON.setPos({0,1})
        camera.THIRD_PERSON.setPos({0,0})
    end
end

function world_render(delta)
    model.NO_PARENT.setPos(vectors.lerp(lastPosition,currentPosition,delta)*vectors.of({-16,-16,16}))
    model.NO_PARENT.setRot({0,-lerp(lastBodyYaw,currentBodyYaw,delta)+180})
    model.NO_PARENT.offset.handle.setRot({0,(lastBodyYaw-currentBodyYaw)*4})
    model.NO_PARENT.setUV(vectors.of({lastBodyYaw-currentBodyYaw,0}))
end

function lerp(a, b, x)
    return a + (b - a) * x
end

-- disable everything inside arg (table)
function disableStuff(arg)
    for key, value in pairs(arg) do
      value.setEnabled(false)
    end
  end
  
  function player_init()
    -- disable vanilla parts
    disableStuff(vanilla_model)
  
    
    --Custom shader stuff!
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
      out ivec2 myVec;
  
      vec4 minecraft_mix_light(vec3 lightDir0, vec3 lightDir1, vec3 normal, vec4 color) {
        lightDir0 = normalize(lightDir0);
        lightDir1 = normalize(lightDir1);
        float light0 = max(0.0, dot(lightDir0, normal));
        float light1 = max(0.0, dot(lightDir1, normal));
        float lightAccum = min(1.0, (light0 + light1) * 0.6 + 0.4);
        return vec4(color.rgb * lightAccum, color.a);
      }
  
      void main() {
        myVec = UV1;
        gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
  
        //This didn't fit in to the guide, but I made a slight modification here:
        //Now the sin function uses GameTime (notice how I declared it above)
        //To make the wiggle change over time!
  
  
        vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
        vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color);
        lightMapColor = texelFetch(Sampler2, UV2 / 16, 0);
        overlayColor = texelFetch(Sampler1, UV1, 0);
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
      uniform vec4 FogColor;
      uniform vec2 ScreenSize;

      in float vertexDistance;
      in vec4 vertexColor;
      in vec4 lightMapColor;
      in vec4 overlayColor;
      in vec2 texCoord0;
      in vec4 normal;
  
      out vec4 fragColor;
  
      vec4 linear_fog(vec4 inColor, float vertexDistance, float fogStart, float fogEnd, vec4 fogColor) {
        if (vertexDistance <= fogStart) {
          return inColor;
        }
  
        float fogValue = vertexDistance < fogEnd ? smoothstep(fogStart, fogEnd, vertexDistance) : 1.0;
        return vec4(mix(inColor.rgb, fogColor.rgb, fogValue * fogColor.a), inColor.a);
      }
  
      void main() {
        vec4 color = texture(Sampler0, ((-normal.xy) + ((gl_FragCoord.xy+vec2(0.5,0.5)) / (ScreenSize*-0.6))));
        if (color.a < 0.1) {
            discard;
        }
        color *= vertexColor * ColorModulator;
        color.rgb = mix(overlayColor.rgb, color.rgb, overlayColor.a);
        color *= lightMapColor;
        fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
  
        //Just added these 2 lines:
        float average = (fragColor.r + fragColor.g + fragColor.b) / 3.0;
        fragColor = color;
      }
    ]==]
    --Register the shader:
    renderlayers.registerShader("My Shader", format, vertexSource, fragmentSource, 3, nil)
  
    local before = function()
      renderlayers.useShader("My Shader")
      renderlayers.setTexture(0, "MY_TEXTURE")
      renderlayers.enableDepthTest()
      renderlayers.enableLightmap()
      renderlayers.disableCull()
      renderlayers.enableOverlay()
    end
    local after = function()
      renderlayers.disableLightmap()
      renderlayers.disableDepthTest()
      renderlayers.enableCull()
      renderlayers.disableOverlay()
    end
    --Register the render layer:
    renderlayers.registerRenderLayer("My Render Layer", {}, before, after)
  
    --Finally, set the render layer on whatever part you want!
    --I'm using model.Base, which in this avatar contains everything else.
    model.NO_PARENT.setRenderLayer("My Render Layer")
  end