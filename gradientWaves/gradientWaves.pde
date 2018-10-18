color[] paleta = {#1DF4E2, #FF5495, #FFD23F, #35FF69, #7494EA};
int prev = -1;

color randomColor()
{
  int in = (int)random(paleta.length);
  while (in == prev)
  {
    in = (int)random(paleta.length);
  }
  prev = in;
  return paleta[in];
}

color adjustB(color _co, float _s, float _b)
{
  colorMode(HSB);
  return color(hue(_co), saturation(_co), _b*255);
}

boolean generate = true;

void  setup()
{
  size(800, 800, P3D);
  pixelDensity(2);
}

void  draw()
{
  if (generate)
  {
    generate = false;
    background(255);

    color cob = adjustB(randomColor(), .9, 1.2);
    color cob2 = adjustB(randomColor(), .9, 1.2);
    float rot =radians(round(random(360)/90)*90);
    float www = width*2;
    float hhh = height*2;

    noStroke();
    pushMatrix();
    translate(width*.5, height*.5);
    rotate(random(TWO_PI));
    translate(-www*.5, -hhh*.5);
    beginShape();
    fill(cob);
    vertex(0, 0);
    vertex(www, 0);
    fill(cob2);
    vertex(www, hhh);
    vertex(0, hhh);
    fill(cob);
    vertex(0, 0);
    endShape();
    popMatrix();

    float w = width*1.5;
    float he = width*1.5;
    float maxy = 0;

    float rot2 = random(TWO_PI);
    pushMatrix();
    translate(width*.5, height*.5);
    rotate(rot2);

    int am = (int)random(12, 40);
    float maxAmp = random(20, 30);
    float h = w/(float)am;


    pushMatrix();
    translate(-w*.5, -(h)*am*.5);
    translate(0, maxAmp*.5);



    for (int i=0; i<am; i++)
    {
      pushMatrix();
      translate(0, i*h);

      float step = 1;

      color co = randomColor();
      color co2 = adjustB(co, 1.0, random(.4, .6));

      int it = 50;
      float extra = random(30, 120);
      float mu = random(5, 15);
      float side = h*.5;
      float amp = random(maxAmp*.25, maxAmp);


      if (random(100) > 60)
      {
        blendMode(random(100) > 50 ? INVERT : NORMAL);
        color cococ =  (randomColor());
        float rr = random(50, 240);
        float xxx = random(width);

        float angle = -rot2;

        for (int k=0; k<it; k++) {
          float r3 = map(k, 0, it, rr, rr*1.2);
          float a = map(k, 0, it, 100, 0);
          float amk = k*6;
          float x = xxx+cos(angle)*amk;
          float y = sin(angle)*amk;
          fill(cococ, a);
          ellipse(xxx, 0, r3, r3);
        }
        blendMode(NORMAL);
      }



      for (int s=0; s<it; s++) {
        float deltas = s/(float)it;
        float ss = map(deltas, 0, 1, 1.1, 1);
        float alpha = map(deltas, 0, 1, 0, 20);

        boolean sombra = !(s == it-1);
        if (s == it-1)
          ss = 1.0;

        pushMatrix();
        translate(w*.5, h*.25);
        scale(1, ss);
        translate(-w*.5, -h*.25);


        beginShape(QUAD_STRIP);
        noStroke();



        for (int j=0; j<w+1; j+=step)
        {
          float x = j;
          float y = h*.2;

          float scale = 300;
          float delta = j/(float)w;

          float mo = random(-.2, .2);

          float side2 = side*1.5+sin(extra+delta*mu)*amp;
          float side3 = side*1.5+cos(extra+delta*mu)*amp;



          float x0 = x+cos(-HALF_PI)*side2;
          float y0 = y+sin(-HALF_PI)*side2;


          float x1 = x+cos(HALF_PI)*h;
          float y1 = y+sin(HALF_PI)*h;
          if (i == am-1)
          {
            y1 = y+sin(HALF_PI)*side3;
          }

          maxy = max(maxy, i*h*.5+y1);

          if (!sombra) {
            fill(co);
            vertex(x0, y0);
            fill(255);
            vertex(x1, y1);
          } else {
            fill(co, alpha);
            vertex(x0, y0);
            fill(co2, alpha);
            vertex(x1, y1);
          }
        }
        endShape();

        popMatrix();
      }


      popMatrix();
    }

    popMatrix();





    popMatrix();




    pelo(10);
    noi(40);
    /*
    pushMatrix();
     translate(width*.5, height*.5);
     
     noFill();
     stroke(255);
     strokeCap(RECT);
     strokeWeight(2);
     blendMode(ADD);
     float hh = he*.8;
     
     stroke(255);
     rect(-w*.5, -hh*.5, w, hh);
     blendMode(NORMAL);
     
     popMatrix();
     */

    saveTheFrame();
  }
}

void noi(float _alpha)
{
  PImage img = createImage(width, height, ARGB);
  img.loadPixels();
  float step = 1;
  int extra = 0;
  for (int x=0; x<width; x+=step)
  {
    for (int y=0; y<height; y+=step)
    {
      float noi = noise(x, y, extra);
      extra+=random(2);
      img.set(x, y, color(0, noi*_alpha));
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
      if (random(100) > 85) {
        float px =x;
        float py =y;
        float it = random(5, 20);
        float sca = random(200, 300);
        float speed = random(.4, .9);
        float off = random(TWO_PI);
        beginShape(LINES);
        for (int i=0; i<it; i++)
        {
          float noi = off+noise(px/sca, py/sca)*TWO_PI;
          float nx = px+cos(noi)*speed;
          float ny = py+sin(noi)*speed;
          extra++;
          strokeWeight(.8);
          stroke(255, _alpha);
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
    generate = true;
  }
}
