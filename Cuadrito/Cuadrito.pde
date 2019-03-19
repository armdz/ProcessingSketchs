color[]  paleta = {#533A71, #6184D8, #50C5B7, #9CEC5B, #F0F465};
color getC()
{
  return paleta[(int)random(paleta.length)];
}
color adjustb(color _co, float _b)
{
  colorMode(HSB);
  color c = color(hue(_co), saturation(_co), brightness(_co)*_b);
  colorMode(RGB);
  return c;
}
boolean gen = false;



void  setup()
{
  size(600, 600, P3D);
  pixelDensity(2);
  smooth(8);
  gen = true;
}


void  draw()
{

  if (gen)
  {

    background(0);
    hint(DISABLE_DEPTH_TEST);



    pushMatrix();
    translate(width*.5, height*.5);
    float rot = 0;
    int it = (int)random(80, 120);
    for (int i=0; i<it; i++)
    {

      float ww = map(i, 0, it, width*1.5, width*.05);
      float hh = ww;

      float count = 4;
      float side = ww/count;


      rotateZ(rot);
      pushMatrix();

      translate(-ww*.5, -hh*.5);
      fill(255);
      noStroke();
      // rect(0, 0, ww, hh);

      for (int x=0; x<count; x++)
      {
        for (int y=0; y<count; y++)
        {
          pushMatrix();
          translate(x*side, y*side);


          translate(side*.5, side*.5);
          int rnd = (int)random(0, 1);

          if (rnd == 0)
          {
            float ia= radians(round(random(360)/45)*45);
            color col = getC();
            color colb = adjustb(getC(), .9);

            float st =10;
            for (int j=0; j<st; j++)
            {
              float delta = j/(float)st;
              float a= lerp(10, 0, delta);
              float s = lerp(1, 1.1, delta);

              pushMatrix();
              scale(s, s);
              noStroke();
              fill(0, a);
              ellipse(0, 0, side, side);
              popMatrix();
            }

            stroke(0);
            noStroke();
            fill(col);
            ellipse(0, 0, side, side);
            fill(colb);
            arc(0, 0, side, side, ia, ia+PI, PIE);
          }



          popMatrix();
        }
      }
      popMatrix();
    }



    popMatrix();

    
    pelo(20);
    addNoise(30);
    saveTheFrame();
    gen = false;
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
        color coco = color(random(255), 255, 255, 100);  

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
          stroke(0, delta*_alpha);
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
