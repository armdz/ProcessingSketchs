
color paleta[] = { #711c91, #711c91, #0abdc6, #133e7c, #091833};
color getC()
{
  return paleta[(int)random(paleta.length)];
}



boolean gen = false;


void  setup()
{
  size(600, 600, P3D);

  smooth(8);
  gen = true;
}

void draw()
{

  if (gen)
  {
    gen = false;
    background(0);
    pushMatrix();

    hint(DISABLE_DEPTH_TEST);

    float step = 10;
    blendMode(ADD);
    for (int x=0; x<width; x+=step)
    {
      for (int y=0; y<height; y+=step)
      {
        float xx = x+random(-step, step);
        float yy = y+random(-step, step);
        float rad = random(step*.1, step*.5);
        float noi = noise(xx, yy);

        if (noi > .5) {
          int it = 10;

          for (int i=0; i<it; i++)
          {
            float rad2 = rad*random(1.1, 2);
            float xxx = xx+random(-rad2, rad2);
            float yyy = yy+random(-rad2, rad2);
            float angle = atan2(yyy-height*.5, xxx-width*.5);
            color c=getC();
            float did = dist(xxx, yyy, width*.5, height*.5);
            float ad = did/(width*.5);
            float a = random(10, 60)*ad;
            fill(c, a);
            circle(xxx, yyy, rad);
            if (random(100) > 70) {
              float l = random(2, 50);
              stroke(c, a);
              line(xxx, yyy, xxx+cos(angle)*l, yyy+sin(angle)*l);
            }
          }


          fill(60);
          noStroke();
          // circle(xx, yy, rad);
        }
      }
    }

    hint(ENABLE_DEPTH_TEST);


    translate(width*.5, height*.5);
    rotateX(radians(60));
    // rotateY(random(TWO_PI));

    rotateZ(random(TWO_PI));

    int t = (int)random(100, 350);
    for (int i=0; i<t; i++) {
      float minRad = width*.1;
      float maxRad = width*.6;
      float rad = random(minRad, maxRad);

      int   a1= (int)random(360);
      int   a2= a1+(int)random(90, 100);
      int seg = 128;

      float px = 0;
      float py = 0;
      float pz = 0;

      color col = getC();
      float mul = random(0, 100);


      //
      //blendMode(ADD);

      fill(255);
      sphere(minRad*random(.8, .95));
      beginShape(LINES);
      stroke(col);
      for (int a=a1; a<a2; a++)
      {
        float angle = radians(a);
        float x = cos(angle)*rad;
        float y = sin(angle)*rad;
        float z = noise(i+angle)*mul;
        float delta = a1/(float)a2;
        float we = lerp(4, .5, delta);

        strokeWeight(we);

        if (a > a1)
        {
          vertex(px, py, pz);
          vertex(x, y, z);
        }
        px=x;
        py=y;
        pz=z;
      }

      endShape();

      fill(col);
      noStroke();
      pushMatrix();
      translate(px, py, pz);
      sphere(random(2, 10));

      popMatrix();

      blendMode(NORMAL);
    }



    popMatrix();


    hint(DISABLE_DEPTH_TEST);
    PImage img = get();
    img.filter(BLUR, 4);

    blendMode(ADD);
    image(img, 0, 0);
    blendMode(NORMAL);

    pelo(30);
    addNoise(10);
    saveTheFrame();
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
        color coco = color(0);

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

void keyPressed()
{
  if (key == 'g')
  {
    gen = true;
  }
}
