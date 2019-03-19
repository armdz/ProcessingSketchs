
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

varying vec4 vertColor;
varying vec3 ecNormal;
varying vec3 lightDir;

uniform sampler2D environment;
uniform float ratio = 1.6;
varying vec2 vertTexCoord;



void main() {
	vec2 tex = vertTexCoord.xy;
	tex.y = tex.y;
	vec4 environmentColor = texture2D(environment, tex);
	vec4 finalColor = mix(vertColor, environmentColor, ratio);
finalColor.a=1.0;

 	gl_FragColor = finalColor;
}