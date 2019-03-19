color[]  paleta = {#340068, #FF6978, #FFFCF9, #B1EDE8, #6D435A};
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

PShader noiseShader;


void  setup()
{
  size(600, 600, P3D);
  pixelDensity(2);
  smooth(8);
  gen = true;
}


void  draw()
{
  noiseShader = loadShader("defor.glsl");

  if (gen)
  {

    background(255);
    hint(DISABLE_DEPTH_TEST);



    pushMatrix();
    translate(width*.5, height*.5);




    float w2 = width*.9;
    float h2 = w2;
    float minw = width*.8;
    int it = (int)random(5, 10);
    for (int i=0; i<it; i++) {
      pushMatrix();
      float lw = map(i, 0, it, width, minw);

      rotate(radians((int)random(360/90)*90));
      translate(-lw*.5, -lw*.5);
      color coco = getC();
      color coco2 = adjustb(coco, .8);

      beginShape();
      fill(coco);
      vertex(0, 0);
      vertex(lw, lw);
      vertex(0, lw);
      endShape();

      beginShape();
      fill(coco2);
      vertex(0, 0);
      vertex(lw, 0);
      vertex(lw, lw);
      endShape();
      popMatrix();
    }

    pushMatrix();
    translate(-minw*.5, -minw*.5);

    float rot = 0;
    float count2 = (int)random(4, 6);
    float stepQ = minw/count2;

    for (int xx=0; xx<count2; xx++)
    {
      for (int yy=0; yy<count2; yy++)
      {
        noFill();
        stroke(255);

        color somc = getC();

        pushMatrix();
        translate(xx*stepQ, yy*stepQ);
        translate(stepQ*.5, stepQ*.5);

        int rnd = (int)random(0, 2);
        int it2 = (int)random(3, 10);

        for (int i=0; i<it2; i++) {
          //  translate(i*4,0,0);
          float ia= radians(round(random(360)/90)*90);
          color col = getC();
          color colb = adjustb(getC(), .9);
          float side = map(i, 0, it2, stepQ*.95, stepQ*.1);
          float side3= side*.8;

          float st =10;
          for (int j=0; j<st; j++)
          {
            float delta = j/(float)st;
            float a= lerp(10, 0, delta);
            float s = lerp(1, 1.2, delta);

            pushMatrix();
            scale(s, s);
            noStroke();
            fill(0, a);
            if (rnd == 0) {
              ellipse(0, 0, side, side);
            } else if (rnd == 1)
            {
              rect(-side3*.5, -side3*.5, side3, side3);
            }
            popMatrix();
          }
          if (rnd == 0) {
            stroke(0);
            noStroke();
            fill(col);
            ellipse(0, 0, side, side);
            fill(colb);
            arc(0, 0, side, side, ia, ia+PI, PIE);
          } else if (rnd == 1)
          {

            fill(col);
            rect(-side3*.5, -side3*.5, side3, side3);
            pushMatrix();
            float rr= radians(round(random(360)/90)*90);
            rotate(rr);

            translate(-side3*.5, -side3*.5);
            fill(colb);
            beginShape();
            vertex(0, 0);
            vertex(side3, side3); 
            vertex(0, side3);
            endShape();
            popMatrix();
          }
        }
        popMatrix();
      }
    }

    popMatrix();


    /*
    for (int i=0; i<it; i++)
     {
     
     float ww = map(i, 0, it, width*1.5, width*.2);
     float posy = map(i,0,it,0,width);
     //  ww = width;
     float hh = ww;
     
     float count = 8;
     float side = ww/count;
     
     
     //rotateZ(rot);
     pushMatrix();
     
     translate(-ww*.5, -hh*.5);
     translate(0,posy);
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
     */


    popMatrix();

    noiseShader.set("t", (float)frameCount);
    filter(noiseShader);
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
