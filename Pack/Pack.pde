

ArrayList<Circle>  circles = new ArrayList<Circle>();
int cur = 0;
boolean added = false;
int state = 0;
int maxh = 40;
boolean sav = false;
void  setup()
{
  size(600, 600, P3D);
  pixelDensity(2);
  smooth(8);
}


void draw()
{
  background(255);

  if (state == 0)
  {
    state = 1;
    float x = random(width);
    float y = random(height);
    float rad = random(width*.01, width*.3);
    Circle circle = new Circle(x, y, rad);
    circle.heigh = (int)random(maxh*.5, maxh);
    circle.am = (int)random(5, 10);
    circles.add(circle);
  } else if (state == 1)
  {
    Circle last = circles.get(circles.size()-1);
    int collide = -1;
    int i = 0;
    while (i < circles.size() && collide == -1)
    {
      if (i != circles.size()-1) {
        Circle cur = circles.get(i);
        if (dist(cur.x, cur.y, last.x, last.y) < (cur.radius*.5+last.radius*.5))
        {
          collide = i;
        }
      }
      i++;
    }
    if (collide != -1)
    {
      Circle cur = circles.get(collide);

      float an = atan2(cur.y-last.y, cur.x-last.x);
      last.x = cur.x+cos(an)*(cur.radius*.5+last.radius*.5);
      last.y = cur.y+sin(an)*(cur.radius*.5+last.radius*.5);



      last.radius-=1;
    } else {
      state = 0;
    }
  }



  pushMatrix();

  for (int i=0; i<circles.size(); i++)
  {
    Circle cir = circles.get(i);
    pushMatrix();
    translate(cir.x, cir.y);
    // translate(cir.radius*.5, cir.radius*.5);

    int it = 40;
    noStroke();

    for (int j=0; j<it; j++) {
      float dej = j/(float)it;
      color co = lerpColor(color(0), color(255), dej);

      translate(0, 0, (-j*.2));

      if (j == it-1)
      {

        float st = 20;

        for (float s=0; s<st; s++)
        {
          float delta = s/st;
          float a = lerp(30, 0, delta);
          float sc= lerp(1, 1.5, delta);
          pushMatrix();
          scale(sc, sc);
          fill(0, a);
          ellipse(0, 0, cir.radius, cir.radius);
          popMatrix();
        }
      }

      fill(co);
      ellipse(0, 0, cir.radius, cir.radius);


      if (j == 0) {

        float st = cir.am;
        boolean inv = false;
        for (float s=0; s<st; s++)
        {
          float delta = s/st;
          float a = lerp(30, 0, delta);
          float sc= lerp(1, 0.0, delta);
          pushMatrix();
          scale(sc, sc);

          if (inv)
          {
            fill(255);
          } else {
            fill(0);
          }

          noStroke();
          ellipse(0, 0, cir.radius, cir.radius);

          popMatrix();
          inv=!inv;
        }
      }
    }


    popMatrix();
  }

  hint(DISABLE_DEPTH_TEST);
  color c0 = #FF3974;
  color c1= #397CFF;
  blendMode(ADD);
  float a = 50;
  beginShape();
  fill(c0, a);
  vertex(0, 0);
  vertex(width, 0);
  fill(c1, a);
  vertex(width, height);
  vertex(0, height);
  fill(c0, a);
  vertex(0, 0);

  endShape();
  blendMode(NORMAL);


  pelo(30);
  addNoise(20);
  hint(ENABLE_DEPTH_TEST);

  if (sav)
  {
    sav = false;
    saveTheFrame();
  }

  popMatrix();
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
      float n = noise(x, y, x*y);

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


void keyPressed()
{
  if (key == 'g')
  {
    sav = true;
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
  float radius;
  int heigh;
  int am;
  Circle(float _x, float _y, float _rad)
  {
    x = _x;
    y = _y;
    radius = _rad;
  }

  void update()
  {
  }
}
