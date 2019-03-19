color   paleta[]  = {#23B5D3, #75ABBC, #A2AEBB, #DFE0E2};

color getColor()
{
  return paleta[(int)(random(paleta.length))];
}

boolean gen = false;
PShader noiseShader;

void   setup()
{
  size(600, 600, P3D);
  pixelDensity(2);
  gen = true;
}

void draw()
{
  noiseShader = loadShader("defor.glsl");
  if (gen)
  {
    gen = false;

    background(0);



    //pelo2(20);





    resetShader();


    float step = 20;
    float w = width*.8;
    float h = height*.8;
    float size = step*.8;
    float w2 = w+size*.5;
    float h2 = h+size*.5;

    pushMatrix();
    translate(width*.5, height*.5);



    int it =(int)random(3, 10);
    for (int i=0; i<it; i++) {
      pushMatrix();
      float sc = map(i, 0, it, 1.5, .25);
      float r = radians(round(random(360)/90)*90);

      float wl = map(i, 0, it, width, width*.1);
      pushMatrix();
      // scale(sc, sc);

      int st = 15;
      for (int s=0; s<st; s++)
      {
        float delta = s/(float)st;
        float alpha = map(delta, 0, 1, 0, 20);
        float scale = map(delta, 0, 1, 1.1, 1);
        pushMatrix();
        fill(255, alpha);
        scale(scale, scale);
        translate(-wl*.5, -wl*.5);
        noStroke();
        rect(0, 0, wl, wl);
        popMatrix();
      }

      rotate(r);
      translate(-wl*.5, -wl*.5);


      //  pelo(30);
      pelo2(255, wl, wl);


      popMatrix();

      translate(-wl*.5, -wl*.5);
      stroke(0);
      noFill();
      rect(0, 0, wl, wl);



      popMatrix();
    }
    resetShader();
    hint(DISABLE_DEPTH_TEST);
    popMatrix();

    pelo(20);
    addNoise(150);


    saveTheFrame();
      //stroke(0);
      //fill(255);
      //  rect(-w2*.5, -h2*.5, w2, h2);

      //    translate(-w*.5, -h*.5);



    /*
    for (float x=0; x<w; x+=step)
     {
     for (float y=0; y<h; y+=step)
     {
     float noi = noise(x, y, frameCount);
     
     
     
     pushMatrix();
     translate(x, y);
     translate(step*.5, step*.5);
     
     
     int st = 20;
     for (int i=0; i<st; i++)
     {
     float delta = i/(float)st;
     float alpha = map(delta, 0, 1, 0, 20);
     float scale = map(delta, 0, 1, 1.4, 1);
     
     pushMatrix();
     
     scale(scale, scale);
     translate(-size*.5, -size*.5);
     
     noStroke();
     fill(0, alpha);
     float rou = 5;
     //rect(0, 0, size, size, rou, rou, rou, rou);
     popMatrix();
     }
     noStroke();
     fill(getColor());
     
     color c1 =getColor();
     color c2 =getColor();
     
     translate(-size*.5, -size*.5);
     noStroke();
     beginShape();
     
     fill(c1);
     vertex(0, 0);
     vertex(size, 0);
     fill(c2);
     vertex(size, size);
     vertex(0, size);
     fill(c1);
     vertex(0, 0);
     
     
     endShape();
     
     
     /// rect(, size, size);
     popMatrix();
     }
     }*/
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


void pelo2(float _alpha, float _w, float _h)
{
  // PImage img = createImage(width, height, ARGB);
  // img.loadPixels();
  PGraphics p = createGraphics((int)_w, (int)_h, P3D);
  p.beginDraw();
  p.background(0);


  float step = 4;
  int extra = 0;
  for (int x=0; x<_w; x+=step)
  {
    for (int y=0; y<_h; y+=step)
    {
      color co = color(0);
      if (random(100) > 85) {
        float px =x;
        float py =y;
        float it = random(10, 25);
        float sca = random(10, 100);
        float speed = random(.9, 1.2);
        float off = random(TWO_PI);

        p.beginShape(LINES);
        for (int i=0; i<it; i++)
        {
          float noi = off+noise(px/sca, py/sca)*TWO_PI*2;
          float nx = px+cos(noi)*speed;
          float ny = py+sin(noi)*speed;
          float delta = sin((i/(float)it)*PI);
          extra++;
          p.strokeWeight(.6);
          p.stroke(255, delta*_alpha);
          p.vertex(px, py);
          p.vertex(nx, ny);
          px=nx;
          py=ny;
          //img.set((int)px, (int)py, color(0));
        }
        p.endShape();
      }
    }
  }
  p.endDraw();
  // if (random(100) > 80) {
  noiseShader.set("t", random(1000));
  noiseShader.set("mul2", random(.02, .2));

  p.filter(noiseShader);
  // }

  image(p, 0, 0);
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
    gen = true;
  }
}
