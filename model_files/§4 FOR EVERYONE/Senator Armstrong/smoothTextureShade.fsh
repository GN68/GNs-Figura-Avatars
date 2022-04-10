vec4 textureRes = ivec2(16,16) //texture resolution

vec4 color = vec4(0.0);
mat4 = rotationMatrix = glm::rot
vec4 bl = texture(Sampler0, (floor(texCoord0*textureRes))/textureRes);
vec4 br = texture(Sampler0, floor(texCoord0*textureRes+vec2(1.0,0))/textureRes);
vec4 tl = texture(Sampler0, floor(texCoord0*textureRes+vec2(0.0,1.0))/textureRes);
vec4 tr = texture(Sampler0, floor(texCoord0*textureRes+vec2(1.0,1.0))/textureRes);
vec4 bx = mix(bl,br,((texCoord0.x*textureRes.x)-floor(texCoord0.x*textureRes.x)));
vec4 tx = mix(tl,tr,((texCoord0.x*textureRes.x)-floor(texCoord0.x*textureRes.x)));
color = mix(bx,tx,((texCoord0.y*textureRes.y)-floor(texCoord0.y*textureRes.y)));