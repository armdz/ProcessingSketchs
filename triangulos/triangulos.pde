
color paleta[] = {#910ADA, #A6FA87, #FFFF64};
boolean gen = false;

color rColor()
{
  return paleta[(int)random(paleta.length)];
}

color adjustB(color _color, float _b)
{
  color newColor = _color;
  colorMode(HSB);
  newColor = color(hue(_color), saturation(_color), (_b*255));
  colorMode(RGB);
  return newColor;
}

void  setup()
{
  size(600, 600, P3D);
  pixelDensity(2);
  gen = true;
}

void  draw()
{

  if (gen) {

    background(rColor());
    //randomSeed(100);

    int totalIt = (int)random(40, 100);
    float lWidth = random(2, 20);
    float rad =  lWidth;

    int seg = (int)random(3, 12);

    pushMatrix();
    translate(width*.5, height*.5);
    for (int i=0; i<totalIt; i++)
    {
      float delta = i/(float)totalIt;

      strokeWeight(1);

      float px0 = 0;
      float py0 = 0;
      float px1 = 0;
      float py1 = 0;

      float st = 20;
      for (int som=0; som<st; som++) {
        float deltaS = som/(float)st;
        float a = map(deltaS, 0, 1, 10, 0);
        float size = map(deltaS, 0, 1, 1, 1.07);
        boolean shadow = true;
        if (som == st-1)
        {
          shadow = false;
        }

        pushMatrix();
        scale(size, size);

        beginShape(QUAD);
        for (int s=0; s<seg+1; s++)
        {
          float deltas = s/(float)seg;
          float angle= (deltas*TWO_PI);
          float x = cos(i+angle)*rad;
          float y = sin(i+angle)*rad;
          float a0 = angle;
          float a1 = angle+PI;
          float x0 = x+cos(a0)*lWidth;
          float y0 = y+sin(a0)*lWidth;
          float x1 = x+cos(a1)*lWidth;
          float y1 = y+sin(a1)*lWidth;

          if (s > 0) {
            color c =rColor();
            color c2 = adjustB(c, .2);

            if (!shadow) {
              noStroke();
              fill(c);
              vertex(px0, py0);

              vertex(x0, y0);

              vertex(x1, y1);

              vertex(px1, py1);
            } else {
              color co = color(rColor(), a);
              noStroke();
              fill(co);
              vertex(px0, py0);
              vertex(x0, y0);
              vertex(x1, y1);
              vertex(px1, py1);
            }
          }

          px0 = x0;
          py0 = y0;
          px1 = x1;
          py1 = y1;
        }
        endShape();

        popMatrix();
      }

      rad+=lWidth*2.0;
      // seg+=2;
    }
    popMatrix();
    gen = false;

    noi(30);
    saveTheFrame();
  }
}

void noi(float _alpha)
{
  PImage img = createImage(width, height, ARGB);
  img.loadPixels();
  float step = 1;
  for (int x=0; x<width; x+=step)
  {
    for (int y=0; y<height; y+=step)
    {
      float noi = noise(x, y, frameCount);

      img.set(x, y, color(0, noi*_alpha));
    }
  }
  img.updatePixels();
  image(img, 0, 0);
}

void  keyPressed() {
  if (key == 'g')
  {
    gen = true;
  } else if (key == 's')
  {
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
