
boolean gen = true;
float   rootW;
PImage root;
PShader shader;
void  setup()
{
  size(600, 600, P3D);
  pixelDensity(2);
}


void  draw()
{
  shader =loadShader("frag.glsl", "vert.glsl");
  if (gen)
  {
    background(255);
    shader(shader);

    pushMatrix();
    translate(width*.5, height*.5);
    rootW = width*.9;
    float w = rootW;
    float h = w;

    translate(-w*.5, -h*.5);

    Rectangle rec = new Rectangle(0, 0, w, h);
    divide(8, rec);


    popMatrix();
    resetShader();

    PImage g = get();
    g.filter(BLUR, 3);
    tint(255, 100);
    image(g, 0, 0);
    tint(255);

    pelo(25);
    addNoise(25);
    //filter(INVERT);
    saveTheFrame();
    gen = false;
  }
}

void drawRect(Rectangle _rec, boolean _left)
{

  float x = _rec.x;
  float y = _rec.y;
  float w = _rec.w;
  float h = _rec.h;
  float sc = 1;

  pushMatrix();
  translate(x, y);
  translate(w*.5, h*.5);
  if (!_left)
  {
    scale(-sc, sc);
  }
  translate(-w*.5, -h*.5);

  noFill();
  stroke(100);
  if (random(100) > 60) {
    float rr = random(10, 50);

    beginShape();
    noStroke();
    fill(rr);
    vertex(0, 0);
    fill(rr*2);
    vertex(w, 0);

    vertex(w, h);
    fill(rr);
    vertex(0, h);
    vertex(0, 0);

    endShape();
  } else {
    // rect(0, 0, w, h);
  }




  int r = (int)random(0, 3);
  float redu = random(.2, .9);
  float ww = w*redu;
  float hh = h*redu;


  float round = 20;

  if (r == 0) {

    rect(w-ww, h-hh, ww, hh);
    line(0, 0, w-ww, h-hh);
  } else if (r == 1)
  {
    line(0, 0, w, h);
  } else if (r == 2)
  {
    beginShape();
    stroke(0);
    vertex(0, 0);
    vertex(w, h);
    vertex(0, h);
    vertex(0, 0);

    endShape();
  }



  popMatrix();
}

void divide(int _levels, Rectangle _rec)
{
  _levels--;
  if (_levels > 0)
  {
    if (random(100) > 30 && _rec.w > 10)
    {
      float side = _rec.w/2;
      for (int x=0; x<2; x++)
      {
        for (int y=0; y<2; y++)
        {
          float nx = _rec.x+x*side;
          float ny = _rec.y+y*side;
          divide(_levels, new Rectangle(nx, ny, side, side));
        }
      }
    } else {
      if (_rec.x+_rec.w < (rootW*.5)) {
        drawRect(_rec, true);
        Rectangle _new = new Rectangle((rootW-_rec.x-_rec.w), _rec.y, _rec.w, _rec.h);
        drawRect(_new, false);
      }
    }
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
  float step = 10;
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
          stroke(0, delta*_alpha);
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
