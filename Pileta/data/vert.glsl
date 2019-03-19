//#define PROCESSING_COLOR_SHADER

uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;

uniform vec4 lightPosition;

uniform vec3 lightNormal;

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;

varying vec4 vertColor;
varying vec3 ecNormal;
varying vec3 lightDir;

float fogFactorLinear(
  const float dist,
  const float start,
  const float end
) {
  return 1.0 - clamp((end - dist) / (end - start), 0.0, 1.0);
}

#define FOG_START 100
#define FOG_END 1000

varying float fogAmount;

void main() {
  vec4 pos = transform * position;

  //pos-= vec4( 0.0, (pos.z * pos.z)*0.0005, .0, .0 );
  pos.x+=sin(pos.y*.02)*200;
  pos.y+=cos(pos.x*.02)*3;

  gl_Position = pos;
  //float fogDistance = length(gl_Position.xyz);
  //fogAmount = fogFactorLinear(fogDistance, FOG_START, FOG_END);
  //ecNormal = normalize(normalMatrix * normal);
  //lightDir = normalize(lightPosition.xyz - ecPosition);


  vertColor = color;
}

/*	vec4 ver = gl_ModelViewProjectionMatrix*gl_Vertex;
	
	ver -= vec4( 0.0, (ver.z * ver.z) * - 0.02, 0.0, 0.0 );*
	*/