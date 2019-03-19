color[]  paleta = {#5EFC8D, #8EF9F3, #93BEDF, #8377D1, #6D5A72};
color getC()
{
  return paleta[(int)random(paleta.length)];
}
boolean gen = false;
float y = 0;
float speed = .2;
float limit = height;
float seed = random(10000);
color col2;
int index=0;
int seg;
float div = random(.01, .1);
float h = 60;

Circle c;


void setup() {
  size(600, 600, P3D);
  pixelDensity(2);
  smooth(8);
  background(0);
  index = (int)random(paleta.length);
  if (index > paleta.length-1)
    index = 0;
  col2 = paleta[index];
  h =  random(50, 120);
  limit = height*.8;
  y=(height-height*.8)-h;
  seg = (int)(width*.5);
  div = random(.001, .01);
  c = new Circle();
  c.x = width*.5;
  c.y =width*.5;
  c.r = random(120, 200);
}


void draw()
{




  float py = 0;
  float px = 0;
  float w=width*.8;
  // y = height*.5;
  pushMatrix();
  translate(width*.5, height*.5);
  translate(-w*.5, -height*.5);

  blendMode(ADD);
  beginShape(LINES);
  stroke(0);
  for (int i=0; i<seg+1; i++) {
    float delta = i/(float)seg;
    float x = delta*w;
    float my =(delta+frameCount*.01)*h;
    float noi = noise(x*.02, y*.002, seed+frameCount*div);
    int ci = (int)(noi*paleta.length);
    color col = paleta[ci];
    float my2 = noi*h;
    float fy = y+my2;
    float d = dist(c.x, c.y, x, fy);
    float al = 10;
    if (d < c.r*.5)
    {
      float a = atan2(c.y-fy, c.x-x);
      float r2 = (c.r)*noi;

      x = c.x+cos(a)*-r2;
      fy = c.y+sin(a)*-r2;
    }



    if (i > 0) {
      stroke(col2, noi*al);
      vertex(px, py);

      vertex(x, fy);
    }

    py = fy;
    px = x;
  }
  endShape();
  blendMode(NORMAL);
  popMatrix();

  y+=speed;
  if (y > limit)
  {

    index++;
    if (index > paleta.length-1)
      index = 0;
    col2 = paleta[index];
    h = random(50, 120);
    y=(height-height*.8)-h;
    seed = random(10000);
    seg = (int)(width*(random(.05, .5)));
    div = random(.001, .01);
    c.x = random(0, width);
    c.y =random(0, height);
    c.r =  random(60, 200);
  }
  if (gen)
  {
    gen = false;
    saveTheFrame();
    println("SAVE");
  }
}

void keyPressed()
{
  if (key == 'g')
  {
    gen = true;
  }
}

void saveTheFrame()
{

  String path = sketchPath();
  File f = new File(path+"/render");
  int ind = 0;
  if (f.list() != null) {
    ind = f.list().length;
  }

  saveFrame("render/out"+Integer.toString(ind)+".png");
}

class Circle
{
  float x;
  float y;
  float r;
  Circle()
  {
  }
}
