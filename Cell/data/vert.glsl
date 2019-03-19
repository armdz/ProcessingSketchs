

uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;

varying vec4 vertColor;
varying vec2 vertTexCoord;


vec4 ambientColor = vec4(0.0,0.0,0.0,1.0);
vec4 diffuseColor = vec4(1.0,1.0,1.0,1.0);
vec3 lightPosition = vec3(0.0,0.0,1.0);


void main() {

  vec4 vWorld = modelview*position;
  vec3 nWorld = normalMatrix*normal;

  vec3 vertToLight = normalize(lightPosition - vWorld.xyz);
  float diffuseLight = max(dot(vertToLight, nWorld), 0.0);
  vertColor = ambientColor + vec4(diffuseLight * diffuseColor.xyz, diffuseColor.w);

  vec3 vWorldUnit = normalize(vWorld.xyz);
  vec3 f = reflect(vWorldUnit, nWorld);
  float m = 2.0 * sqrt(f.x*f.x + f.y*f.y + (f.z + 1.0)*(f.z + 1.0));
  vertTexCoord.xy = vec2(f.x/m + .5, -f.y/m + .5);

  gl_Position = transform*position;
}
