#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif


#define PI 3.14159265358979323846

#define PROCESSING_TEXTURE_SHADER
vec2 fade(vec2 t) {return t*t*t*(t*(t*6.0-15.0)+10.0);}
vec4 permute(vec4 x){return mod(((x*34.0)+1.0)*x, 289.0);}
vec4 taylorInvSqrt(vec4 r){return 1.79284291400159 - 0.85373472095314 * r;}
vec3 fade(vec3 t) {return t*t*t*(t*(t*6.0-15.0)+10.0);}

float cnoise(vec2 P){
  vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
  vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
  Pi = mod(Pi, 289.0); // To avoid truncation effects in permutation
  vec4 ix = Pi.xzxz;
  vec4 iy = Pi.yyww;
  vec4 fx = Pf.xzxz;
  vec4 fy = Pf.yyww;
  vec4 i = permute(permute(ix) + iy);
  vec4 gx = 2.0 * fract(i * 0.0243902439) - 1.0; // 1/41 = 0.024...
  vec4 gy = abs(gx) - 0.5;
  vec4 tx = floor(gx + 0.5);
  gx = gx - tx;
  vec2 g00 = vec2(gx.x,gy.x);
  vec2 g10 = vec2(gx.y,gy.y);
  vec2 g01 = vec2(gx.z,gy.z);
  vec2 g11 = vec2(gx.w,gy.w);
  vec4 norm = 1.79284291400159 - 0.85373472095314 * 
    vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11));
  g00 *= norm.x;
  g01 *= norm.y;
  g10 *= norm.z;
  g11 *= norm.w;
  float n00 = dot(g00, vec2(fx.x, fy.x));
  float n10 = dot(g10, vec2(fx.y, fy.y));
  float n01 = dot(g01, vec2(fx.z, fy.z));
  float n11 = dot(g11, vec2(fx.w, fy.w));
  vec2 fade_xy = fade(Pf.xy);
  vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
  float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
  return 2.3 * n_xy;
}

uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;
uniform float time;

void main(void) {
  // Grouping texcoord variables in order to make it work in the GMA 950. See post #13
  // in this thread:
  // http://www.idevgames.com/forums/thread-3467.html
  vec2 st = gl_FragCoord.xy/(vec2(1200,1200));
    vec2 stok = gl_FragCoord.xy/(vec2(1200,1200));
  vec4 col = texture2D(texture, st);
  float dis = distance(gl_FragCoord.xy,vec2(600.0,600.0));


  float a = (dis/700.0)*PI;


  
  float aa = st.x;
  float ann2 = cos(aa*PI*.4);
  //st.y=pow(ann2,st.y/700.0);
  //st.xy*=cos(ann2);

  float ll = sin((time*.1)*PI*2)*1.2;

  float noi = cnoise(time*.1+st.xy*0.6);//bajo este
  float an = (noi*PI*5);
  float mul = .06;
  st.x+=cos(an)*mul;
  st.y+=sin(an)*mul;


  vec4 col0 = texture2D(texture, st);
  vec4 colb = texture2D(texture, st);
  float b = (colb.r+colb.g+colb.b)/3.0;
  colb = b > .8 ? colb : vec4(0.0);
  

  gl_FragColor = col0;
}
