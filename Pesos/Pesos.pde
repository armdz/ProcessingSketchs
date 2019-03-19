color paleta[] = {#CAFFD0, #B4A0E5, #CA3CFF, #1E1014,#000000, #FFFFFF};
color getC()
{
  return paleta[(int)random(paleta.length)];
}



boolean gen = false;

void  setup()
{
  size(600, 600);
  smooth(8);
  pixelDensity(2);
  gen=true;
}


void  draw()
{
  if (gen)
  {
    gen = false;
    background(255);
    pushMatrix();
    translate(width*.5, height*.5);

    float w = width;
    float h = height;

    translate(-w*.5, -h*.5);

    Rectangle rect = new Rectangle(0, 0, w, h);


    subdivide(rect, 6);


    addNoise(15);
    blendMode(ADD);
    pelo(12);
    blendMode(NORMAL);
    popMatrix();
    saveTheFrame();
  }
}

void subdivide(Rectangle _rect, int _recall)
{

  float varw = _rect.w*.2;
  float varh = _rect.h*.2;

  float x = _rect.w*.5+random(-varw, varw);
  float y = _rect.h*.5+random(-varh, varh);

  Rectangle r1 = new Rectangle(_rect.x, _rect.y, x, y);
  Rectangle r2 = new Rectangle(_rect.x+x, _rect.y, _rect.w-x, y);
  Rectangle r3 = new Rectangle(_rect.x+x, _rect.y+y, _rect.w-x, _rect.h-y);
  Rectangle r4 = new Rectangle(_rect.x, _rect.y+y, x, _rect.h-y);


  drawRect(r1, 0);
  drawRect(r2, 1);
  drawRect(r3, 2);
  drawRect(r4, 3);

  _recall--;

  if (_recall > 0) {
    subdivide(r1, _recall);
    subdivide(r2, _recall);
    subdivide(r3, _recall);
    subdivide(r4, _recall);
  }
}

void drawRect(Rectangle _rect, int _index)
{

  color c1 = getC();
  color c2 = getC();

  ellipseMode(CENTER);
  noStroke();

  pushMatrix();
  translate(_rect.x, _rect.y);
  translate(_rect.w*.5, _rect.h*.5);

  float round = 20;
  fill(c1);
  float it = random(10, 20);
  ;
  float it2=20;
  strokeWeight(2);
  float som = 255;
  color colsom = getC();
  float intens = random(4, 10);
  float fs = .8;
  boolean addc = random(100) > 20;
  float mi = min(_rect.h, _rect.w);

  if (_index==0) {


    rect(-_rect.w*.5, -_rect.h*.5, _rect.w, _rect.h, 0, round, 0, round);

    if (addc)
    {
      float rad = (mi);
      fill(getC());
      arc( _rect.w*.5, _rect.h*.5, rad, rad, (PI), TWO_PI-PI*.5);
    }
    for (int i=0; i<it; i++)
    {
      float delta = i/(float)it;
      float a = lerp(intens, 0, delta);
      float s = lerp(1, fs, delta);

      pushMatrix();
      scale(s, s);
      noFill();
      stroke(colsom, a);
      rect(-_rect.w*.5, -_rect.h*.5, _rect.w, _rect.h, 0, round, 0, round);
      popMatrix();
    }
  } else if (_index==1) {

    rect(-_rect.w*.5, -_rect.h*.5, _rect.w, _rect.h, round, 0, round, 0);
    if (addc)
    {
      float rad = (mi);
      fill(getC());
      arc(-_rect.w*.5, _rect.h*.5, rad, rad, PI*1.5, TWO_PI);
    }
    for (int i=0; i<it; i++)
    {
      float delta = i/(float)it;
      float a = lerp(intens, 0, delta);
      float s = lerp(1, fs, delta);

      pushMatrix();
      scale(s, s);
      noFill();
      stroke(colsom, a);
      rect(-_rect.w*.5, -_rect.h*.5, _rect.w, _rect.h, round, 0, round, 0);
      popMatrix();
    }
  } else if (_index==2) {
    rect(-_rect.w*.5, -_rect.h*.5, _rect.w, _rect.h, 0, round, 0, round);

    if (addc)
    {
      float rad = (mi);
      fill(getC());
      arc(-_rect.w*.5, -_rect.h*.5, rad, rad, 0, PI*.5);
    }
    for (int i=0; i<it; i++)
    {
      float delta = i/(float)it;
      float a = lerp(intens, 0, delta);
      float s = lerp(1, fs, delta);

      pushMatrix();
      scale(s, s);
      noFill();
      stroke(colsom, a);
      rect(-_rect.w*.5, -_rect.h*.5, _rect.w, _rect.h, 0, round, 0, round);
      popMatrix();
    }
  } else if (_index == 3)
  {
    rect(-_rect.w*.5, -_rect.h*.5, _rect.w, _rect.h, round, 0, round, 0);
    if (addc)
    {
      float rad = (mi);
      fill(getC());
      arc(_rect.w*.5, -_rect.h*.5, rad, rad, PI-PI*.5, PI);
    }
    for (int i=0; i<it; i++)
    {
      float delta = i/(float)it;
      float a = lerp(intens, 0, delta);
      float s = lerp(1, fs, delta);

      pushMatrix();
      scale(s, s);
      noFill();
      stroke(colsom, a);
      rect(-_rect.w*.5, -_rect.h*.5, _rect.w, _rect.h, round, 0, round, 0);
      popMatrix();
    }
  }








  /*
  beginShape();
   fill(c1);
   vertex(0, 0);
   vertex(_rect.w, 0);
   fill(c1);
   vertex(_rect.w, _rect.h);
   vertex(0, _rect.h);
   fill(c1);
   vertex(0, 0);
   
   endShape();
   
   if (random(100) > 0)
   {
   beginShape();
   fill(0);
   vertex(0, 0);
   fill(0, 0);
   vertex(_rect.w, _rect.h);
   fill(0);
   vertex(0, _rect.h);
   vertex(0, 0);
   
   endShape();
   }
   
   */


  popMatrix();



  // rect(_rect.x, _rect.y, _rect.w, _rect.h);
}


void keyPressed()
{
  if (key == 'g')
  {
    gen = true;
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
      color c = get((int)(x), (int)(y));
      float b = brightness(c);
      float n = noise(x*100, y*100, x+y+b/255.0)*_alpha;
      img.set(x, y, color(0, random(_alpha)));
    }
  }
  img.updatePixels();
  image(img, 0, 0);
}



void pelo(float _alpha)
{
  // PImage img = createImage(width, height, ARGB);
  // img.loadPixels();
  float step = 8;
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
        color coco = getC();

        colorMode(HSB);
        beginShape(LINES);
        for (int i=0; i<it; i++)
        {
          float noi = off+noise(px/sca, py/sca)*PI;
          float nx = px+cos(noi)*speed;
          float ny = py+sin(noi)*speed;
          float delta = sin((i/(float)it)*PI);
          extra++;
          strokeWeight(.5);
          stroke(coco, delta*_alpha);
          vertex(px, py);
          vertex(nx, ny);
          px=nx;
          py=ny;
          //img.set((int)px, (int)py, color(0));
        }
        endShape();
      }
      colorMode(RGB);
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



class Rectangle {
  float x;
  float y;
  float w;
  float h;
  Rectangle(float _x, float _y, float _w, float _h)
  {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
  }
}
