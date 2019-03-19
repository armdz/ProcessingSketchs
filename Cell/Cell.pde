import peasy.*;


color[]  paleta = {#EA1834, #FFB40F, #BE5FFF, #C0D6DF};
color getColor()
{
  int in = (int)random(paleta.length);
  return paleta[in];
}

PeasyCam cam;
PShader  enviroment;
PShader  deform;
PImage   map;
boolean gen = false;

void  setup()
{
  size(600, 600, P3D);
  pixelDensity(2);
  smooth(8);
  map = loadImage("mapa.png");
  sphereDetail(128);
  gen = true;
  //cam = new PeasyCam(this, 400);
}

void  draw()
{
  if (gen) {
    gen = false;
    enviroment = loadShader("frag.glsl", "vert.glsl");
    deform = loadShader("defor.glsl");

    PGraphics gr = createGraphics(width, height, P3D);
    gr.beginDraw();
    gr.noStroke();
    gr.beginShape();
    gr.fill(255, 0, 0);
    gr.vertex(0, 0);
    gr.fill(getColor());
    gr.vertex(width, 0);
    gr.fill(getColor());
    gr.vertex(width, height);
    gr.fill(getColor());
    gr.vertex(0, height);
    gr.fill(getColor());
    gr.vertex(0, 0);
    gr.endShape();
    gr.endDraw();

    hint(ENABLE_DEPTH_TEST);
    background(0);
    image(gr, 0, 0);

    shader(enviroment);
    enviroment.set("environment", gr);

    int it = 100;
    for (int i=0; i<it; i++) {

      pushMatrix();
      translate(random(width), random(height));
      noStroke();


      if (random(100) > 90)
      {
        pushMatrix();
        fill(255);
        rotateX(random(TWO_PI));
        rotateY(random(TWO_PI));
        rotateZ(random(TWO_PI));

        box(2, random(300,1000), 2);
        popMatrix();
      } else {
        fill(255);
        pushMatrix();

        sphere(random(8, 80));
        popMatrix();
      }
      popMatrix();
    }

    resetShader();
    deform.set("t", frameCount);
    filter(deform);
    resetShader();

    hint(DISABLE_DEPTH_TEST);

    PImage p = get();
    p.filter(THRESHOLD, .99);
    // p.filter(INVERT);
    p.filter(BLUR, 12);
    blendMode(ADD);
    tint(255);
    image(p, 0, 0);
    blendMode(NORMAL);

    pelo(30);
    addNoise(40);
  }
}

void addNoise(float _alpha)
{
  PImage img = createImage(width, height, ARGB);
  img.loadPixels();
  loadPixels();
  int step = 1;
  for (int x=0; x<img.width; x+=step)
  {
    for (int y=0; y<img.height; y+=step)
    {
      color c = get((int)(x*2), (int)(y*2));
      float b = brightness(c);
      float n = noise(x*10, y*10, random(10));
      img.set(x, y, color(0, n*_alpha));
    }
  }
  img.updatePixels();
  image(img, 0, 0);
}


void pelo(float _alpha)
{
  // PImage img = createImage(width, height, ARGB);
  // img.loadPixels();
  float step = 4;
  int extra = 0;
  for (int x=0; x<width; x+=step)
  {
    for (int y=0; y<height; y+=step)
    {
      color co = color(0);
      if (random(100) > 85) {
        float px =x;
        float py =y;
        float it = random(10, 50);
        float sca = random(10, 100);
        float speed = random(.9, 1.2);
        float off = random(TWO_PI);

        beginShape(LINES);
        for (int i=0; i<it; i++)
        {
          float noi = off+noise(px/sca, py/sca)*TWO_PI*2;
          float nx = px+cos(noi)*speed;
          float ny = py+sin(noi)*speed;
          float delta = sin((i/(float)it)*PI);
          extra++;
          strokeWeight(.6);
          stroke(255, delta*_alpha);
          vertex(px, py);
          vertex(nx, ny);
          px=nx;
          py=ny;
          //img.set((int)px, (int)py, color(0));
        }
        endShape();
      }
    }
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
void keyPressed()
{
  if (key == 'g')
  {
    gen = true;
  }
}
