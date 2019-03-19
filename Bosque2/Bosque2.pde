color[]  paleta = {#1722FF, #BDEDE0, #090C9B, #B4C5E4, #FBFFF1};
color getCG(float _num)
{
  float num = _num*paleta.length-2;//random(0, paleta.length-1);
  int index = (int)num;
  int index2 = index+1;
  color c1 = paleta[index];
  color c2 = paleta[index2];
  return lerpColor(c1, c2, num%1);
}
color getC()
{
  return paleta[(int)random(paleta.length)];
}
color adjustB(color _co, float _b)
{
  color c = _co;
  colorMode(HSB);
  c = color(hue(c), saturation(c), brightness(c)*_b);
  colorMode(RGB);
  return c;
}

PShader noiseShader;
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
  noiseShader = loadShader("defor.glsl");
  if (gen)
  {
    gen = false;
    resetShader();
    background(0);
    hint(DISABLE_DEPTH_TEST);
    color cc = adjustB(paleta[0], random(.1, .9));
    color cc2 = adjustB(paleta[2], random(.2, .9));

    pushMatrix();
    translate(width*.5, height*.5);
    rotate(radians(round(random(360)/90)*90));
    translate(-width*.5, -height*.5);
    beginShape();
    noStroke();
    fill(cc);
    vertex(0, 0);
    vertex(width, 0);
    fill(cc2);
    vertex(width, height);
    vertex(0, height);
    fill(cc);
    vertex(0, 0);
    endShape();
    popMatrix();


    pelo(100);
    addNoise(50);


    float ww = width;
    float hh = height;
    float alto = 200;
    float ancho = 8;
    pushMatrix();
    translate(width*.5, height*.5);
    translate(-ww*.5, -hh*.5);

    float step = 30;


    for (float y=0; y<hh+alto; y+=step)
    {
      for (float x=-ancho; x<ww+ancho; x+=ancho)
      {
        float noi = noise((x/ww)*2, (y/hh)*1.6, frameCount*.2)*PI;

        pushMatrix();
        translate(x, y);
        translate(step*.5, 0);
        rotate(PI*.5+noi);

        //hoja(ancho, random(alto*.8, alto*1.2), getC());

        if (random(100) > 85)
        {
          pushMatrix();


          float size = random(ancho*.5, ancho*8);
          color coco = random(100) > 90 ? color(255) : color(0);
          color coc2 = adjustB(coco, .8);


          float aa = random(TWO_PI);
          float ss = random(30, 80);
          translate(cos(aa)*ss, sin(aa)*ss);


          if (random(100) > 70) {
            blendMode(ADD);
            float st=random(3, 8);
            for (int s=0; s<st; s++)
            {
              float dd = s/(float)st;
              float a = lerp(0, 150, dd);
              float sc = lerp(1, .1, dd);

              pushMatrix();
              scale(sc, sc);
              noStroke();
              fill(getC(), a);
              ellipse(0, 0, size*2, size*2);
              popMatrix();
            }
            blendMode(NORMAL);

            st=10;

            int it = 100;
            float tx = 0;
            float ty = 0;
            float maxg = random(8, 12);

            float off = random(TWO_PI);
            for (int s=0; s<st; s++) {
              float de = s/(float)st;
              float px =0;
              float py =0;
              float speed = 2;
              float sca = 100;
              strokeCap(ROUND);

              strokeWeight(lerp(maxg, maxg/4, de));
              stroke(255, lerp(0, 20, de));
              if (s == st-1)
              {
                stroke(255);
              }
              beginShape(LINES);

              for (int i=0; i<it; i++)
              {
                float nois = off+noise(px/sca, py/sca)*TWO_PI;
                float nx = px+cos(nois)*speed;
                float ny = py+sin(nois)*speed;
                float delta = sin((i/(float)it)*PI);

                vertex(px, py);
                vertex(nx, ny);
                px = nx;
                py = ny;
                tx = px;
                ty = py;
              }
              endShape();
              noStroke();
              fill(255);


              // ellipse(px, py, 20, 20);
            }
            blendMode(ADD);
            pushMatrix();
            translate(tx, ty);
            st = 10;
            float thiss = random(30, 50);
            for (int s=0; s<st; s++)
            {
              float dd = s/(float)st;
              float a = lerp(0, 90, dd);
              float sc = lerp(1, .1, dd);

              pushMatrix();
              scale(sc, sc);
              noStroke();
              fill(255, a);
              ellipse(0, 0, thiss, thiss);
              popMatrix();
            }
            popMatrix();
            blendMode(NORMAL);
          } else {

            if (random(100) > 80) {

              if (random(100) > 60) {
                blendMode(ADD);
              }
              float st=40;
              color coco3 =getC();
              if (random(100) > 96)
              {
                coco3 = color(0);
              }
              for (int s=0; s<st; s++)
              {
                float dd = s/(float)st;
                float a = lerp(0, 90, dd);
                float sc = lerp(1.5, 1, dd);

                pushMatrix();
                scale(sc, sc);
                stroke(coco3, a);
                noFill();
                ellipse(0, 0, size*2, size*2);
                popMatrix();
              }
              blendMode(NORMAL);
            }


            float seg = 3;
            if (random(100) > 60) {

              size = random(2, 10);
              beginShape(TRIANGLE_FAN);
              fill(coco);
              vertex(0, 0);

              for (int i=0; i<seg+1; i++)
              {
                float delta = i/(float)seg;
                float an =delta*TWO_PI;
                float extra = 0;
                float xx = cos(an)*size;
                float yy= sin(an)*size;
                noStroke();
                noFill();
                fill(coco);
                vertex(xx, yy);
              }


              endShape();
            }
          }  
          popMatrix();
        }


        popMatrix();
      }
    }




    popMatrix();
    // blendMode(ADD);
    filter(noiseShader);
    addNoise(40);
    // blendMode(NORMAL);
    // pelo(30);
    saveTheFrame();
  }
}


void  hoja(float _w, float _h, color _col)
{

  float st = 10;

  for (int s=0; s<st; s++) {
    boolean shadow = !(s==st-1);
    float des = s/(float)st;
    float sc = lerp(1.2, 1, des);
    float al = lerp(0, 2, des);

    pushMatrix();
    scale(sc, sc*.9);

    float seg = 12;
    float curve = 1;
    float angle = -20;
    float pidiv = .4;

    beginShape(QUAD_STRIP);
    if (shadow)
    {
      noStroke();
      fill(0, 0);
    } else {
      noStroke();
      fill(_col, 2);
    }
    for (int i=0; i<seg+1; i++)
    {
      float delta = i/(float)seg;
      float y = lerp(0, _h, delta)-_h*.5;
      float anglex = radians(angle);
      float x0 = cos(delta*PI)*curve;
      float rw = sin(delta*PI)*_w;
      float x1 = x0+cos(PI+anglex)*rw;
      float y1 = y+sin(PI+anglex)*rw;
      if (!shadow)
      {
        fill(_col, 2);
      }
      vertex(x0, y);
      vertex(x1, y1);
    }
    endShape();

    beginShape(QUAD_STRIP);
    if (shadow)
    {
      noStroke();

      fill(0, al);
    } else {
      noStroke();
      fill(_col);
    }
    for (int i=0; i<seg+1; i++)
    {
      float delta = i/(float)seg;
      float y = lerp(0, _h, delta)-_h*.5;
      float anglex = radians(-angle);
      float x0 = cos(delta*PI)*curve;
      float rw = sin(delta*PI)*_w;
      float x1 = x0+cos(anglex)*rw;
      float y1 = y+sin(anglex)*rw;
      if (!shadow)
      {
        fill(adjustB(_col, delta));
      }
      vertex(x0, y);
      vertex(x1, y1);
    }
    endShape();
    popMatrix();
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
  float step = 5;
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
          stroke(100, delta*_alpha);
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



void  keyPressed()
{
  if (key == 'g')
  {




    gen = true;
  }
}
