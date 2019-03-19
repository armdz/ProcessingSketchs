color[]  paleta = {#C4F1BE, #A2C3A4, #869D96, #525B76, #201E50};
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
    gen = false;
    background(255);
    hint(DISABLE_DEPTH_TEST);
    float ww = width;
    float hh = height;
    float alto = 100;
    float ancho = 14;
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

        hoja(ancho, random(alto*.8, alto*1.2), getC());

        if (random(100) > 70)
        {
          pushMatrix();


          float size = random(ancho*.2, ancho*.6);



          float aa = random(TWO_PI);
          float ss = random(30, 80);
          translate(cos(aa)*ss, sin(aa)*ss);


          float st=10;
          for (int s=0; s<st; s++)
          {
            float dd = s/(float)st;
            float a = lerp(0, 60, dd);
            float sc = lerp(3, 1, dd);

            pushMatrix();
            scale(sc, sc);
            fill(0, a);
            noStroke();
            ellipse(0, 0, size, size);
            popMatrix();
          }


          float seg = 64;

          color coco = getC();
          color coc2 = adjustB(coco, .8);
          beginShape(TRIANGLE_FAN);
          fill(coco);
          vertex(0, 0);

          for (int i=0; i<seg+1; i++)
          {
            float delta = i/(float)seg;
            float an =delta*TWO_PI;
            float extra = 0;
            float xx = cos(an)*size+extra;
            float yy= sin(an)*size+extra;
            noStroke();
            noFill();
            fill(coc2);
            vertex(xx, yy);
          }


          endShape();
          popMatrix();
        }


        popMatrix();
      }
    }




    popMatrix();
  }
}


void  hoja(float _w, float _h, color _col)
{

  float st = 10;

  for (int s=0; s<st; s++) {
    boolean shadow = !(s==st-1);
    float des = s/(float)st;
    float sc = lerp(1.2, 1, des);
    float al = lerp(0, 20, des);

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
      fill(0, al);
    } else {
      noStroke();
      fill(_col);
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
        fill(adjustB(_col, delta));
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
          stroke(255, delta*_alpha);
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
