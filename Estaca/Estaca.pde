
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
  if (gen)
  {
    noiseShader = loadShader("defor.glsl");

    gen = false;
    background(255);


    pushMatrix();
    translate(width*.5, height*.5);
    scale(1.2, 1.2);
    float r = radians(round(random(360)/90)*90);
    rotate(r);
    translate(-width*.5, -height*.5);
    beginShape();
    fill(#6710E3);
    vertex(0, 0);
    vertex(width, 0);
    fill(#21F9FF);
    vertex(width, height);
    vertex(0, height);
    fill(#6710E3);
    vertex(0, 0);

    endShape();

    popMatrix();
    float step = 20;

    //  blendMode(ADD);
    pelo(255);
    //blendMode(NORMAL);
    addNoise(90);
    //    resetShader();
    // noiseShader.set("www", width);
    // noiseShader.set("hhh", height);
    noiseShader.set("t", frameCount);
    noiseShader.set("m", random(.002, .01));

    filter(noiseShader);

    resetShader();
    hint(DISABLE_DEPTH_TEST);

    saveTheFrame();
    hint(ENABLE_DEPTH_TEST);
  }
  //
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

void drawCircle(float _size, color _c1, color _c2)
{
  float seg = 32;
  noStroke();

  beginShape(TRIANGLE_FAN);
  fill(_c1);
  vertex(0, 0);
  for (int i=0; i<seg+1; i++)
  {
    float delta = i/(float)seg;
    float angle = delta*TWO_PI;
    float x = cos(angle)*_size;
    float y = sin(angle)*_size;
    fill(_c2);
    vertex(x, y);
  }
  //vertex(-_size*.5, -_size*.5);

  endShape();
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
      if (random(100) > 90) {
        float px =x;
        float py =y;
        float it = random(30, 300);
        float sca = random(10, 100);
        float speed = random(.9, 1.2);
        float off = random(TWO_PI);
        float gr = random(.3, 6);
        if (random(100) > 40)
        {
          fill(0);
          noStroke();
          float rad = random(3, 32);
          ellipse(x, y, rad, rad);
          if (random(100) > 30)
          {
            fill(255);
            float rr = random(.3, .6);
            ellipse(x, y, rad*rr, rad*rr);
          }
        }

        beginShape(LINES);
        for (int i=0; i<it; i++)
        {
          float noi = off+noise(px/sca, py/sca)*TWO_PI*2;
          float nx = px+cos(noi)*speed;
          float ny = py+sin(noi)*speed;
          float delta = sin((i/(float)it)*PI);
          extra++;
          strokeWeight(gr);
          color col = lerpColor(#DE2455, #42B6F2, delta);
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


void  keyPressed()
{
  if (key == 'g')
  {
    gen = true;
  }
}
