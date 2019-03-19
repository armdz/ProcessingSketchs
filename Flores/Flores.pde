color paleta[] = {#F8FC03, #F397FA, #E51C23, #D6FFED};
boolean gen = false;

color getC()
{
  return paleta[(int)(random(paleta.length))];
}
color adjustb(color _col, float _b)
{
  colorMode(HSB);
  color c = color(hue(_col), saturation(_col), brightness(_col)*_b);
  colorMode(RGB);
  return c;
}


PShader noiseShader;

void  setup()
{
  size(600, 600, P3D);
  pixelDensity(2);
  gen = true;
  smooth(8);
}


void  draw()
{
  noiseShader = loadShader("defor.glsl");

  if (gen)
  {
    gen = false;
    background(0);

    pushMatrix();

    // translate(width*.5, height*.5);
    float step = 20;
    for (int x=0; x<width; x+=step)
    {
      for (int y=0; y<height; y+=step)
      {
        float noi = noise(x*.4, y*.2, frameCount*.2);

        if (noi > .1) {
          pushMatrix();
          translate(x, y);
          float mul = 10;
          float xx = cos(noi)*mul;
          float yy =sin(noi)*mul;
          translate(xx, yy);

          rotate(random(TWO_PI));

          float lon = lerp(5, 80, noi*.7);
          translate(lon*.5, lon*.5);




          flor(1, lon, lon/3, noi*.8);

          if (random(100) > 95)
          {
            float px =0;
            float py =0;
            float it = 40;
            float sca = 50;
            float speed = random(5, 15);
            float off = random(TWO_PI);
            color coco = getC();
            float _alpha = 200;
            float wei = random(1, 3);
            color rrr = color(0, random(0, 50), random(60, 120));


            beginShape(LINES);
            for (int i=0; i<it; i++)
            {
              float nois = off+noise(px/sca, py/sca)*PI;
              float nx = px+cos(nois)*speed;
              float ny = py+sin(nois)*speed;
              float delta = sin((i/(float)it)*PI);
              float del2 = i/(float)it;
              strokeWeight(delta*wei);
              stroke(rrr);
              stroke(coco);
              vertex(px, py);
              vertex(nx, ny);
              px=nx;
              py=ny;
              //img.set((int)px, (int)py, color(0));
            }
            endShape();
          }

          popMatrix();
        }
      }
    }

    popMatrix();

    noiseShader.set("t", (float)frameCount);
    filter(noiseShader);
    pelo(40);
    saveTheFrame();
  }
}

void flor(int tot, float maxlon, float minlon, float _deltax)
{
  color elcolor = getC();
        color col2 = adjustb(elcolor, random(.8,.9));

  hint(DISABLE_DEPTH_TEST);

  boolean side = random(100)> 50;
  for (int t=0; t<tot; t++) {

    float lon = map(t, 0, tot, maxlon, minlon);
    float he = lon/4;

    ellipseMode(CENTER);

    stroke(0);
    fill(255);


    int it = (int)random(8, 16);
    for (int i=0; i<it; i++)
    {
      float delta = i/(float)it;
      float angle = delta*TWO_PI;

      pushMatrix();
      rotate(angle);
      translate(0, lon*.5);
      int st = 8;
      for (int j=0; j<st; j++)
      {
        float delta2 = j/(float)st;
        float sc = lerp(1, 3, delta2);
        float alpha = lerp(60, 0, delta2);

        pushMatrix();
        translate(0, lon*.5);
        fill(lerpColor(elcolor, color(0), _deltax), alpha);


        scale(sc, sc);
        noStroke();
        translate(0, -lon*.5);
        ellipse(0, 0, he, lon);
        popMatrix();
      }
      popMatrix();
    }


    for (int i=0; i<it; i++)
    {
      float delta = i/(float)it;
      float angle = delta*TWO_PI;

      pushMatrix();
      rotate(angle);
      translate(0, lon*.5);

      noStroke();



      int it2 = 12;

      for (int j=0; j<it2; j++)
      {
        float delta2 = j/(float)it2;
        float sc = lerp(1, .5, delta2);
        color c = lerpColor(col2, elcolor, delta2);

        if (side)
        {
          c = lerpColor(elcolor, col2, delta2);
        }


        pushMatrix();
        translate(0, -lon*.5);
        fill(c);
        scale(1, sc);
        translate(0, lon*.5);
        ellipse(0, 0, he, lon);
        popMatrix();
      }




      popMatrix();
    }

    int cit = 8;

    for (int i=0; i<cit; i++)
    {
      float delta = i/(float)cit;
      float alpha = lerp(0, 255, delta);
      float sc = lerp(1, .5, delta);
      pushMatrix();
      scale(sc, sc);

      fill(elcolor, alpha);
      ellipse(0, 0, lon, lon);
      popMatrix();
    }
  }
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
