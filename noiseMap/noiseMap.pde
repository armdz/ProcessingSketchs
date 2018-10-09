int   particleCount  = 100;
int   nSystems = 30;
float noiseScale = 300;
float baseAlpha = 30;
Particle[][] particles = new Particle[nSystems][particleCount];
boolean save = false;

void  setup()
{
  size(800, 800);
  pixelDensity(2);
  for (int i=0; i<nSystems; i++)
  {
    float rad = width*.5;


    for (int j=0; j<particleCount; j++)
    {
      float delta = j/(float)particleCount;
      float angle = delta*TWO_PI;
      float x = width*.5+cos(angle)*rad;
      float y = height*.5+sin(angle)*rad;

      x = width*.5+map(delta, 0, 1, -rad*.5, rad*.5);
      y = height*.5+map(i, 0, nSystems, -rad*.5, rad*.5);

      particles[i][j] = new Particle(x, y);
    }
  }
  background(255);
  smooth(8);
  float amm = 10;
  float www = width*.8;
  float step = www/amm;

  pushMatrix();
  translate(width*.5, height*.5);
  translate(-www*.5, -www*.5);
  for (float x=0; x<www; x+=step)
  {
    for (float y=0; y<www; y+=step)
    {
      float step2 = step*.2;
      stroke(0, baseAlpha);
      noFill();
      rect(x, y, step, step);
      if (random(100) > 60) {
        ellipse(x, y, step2, step2);
      } else {
        if (random(100) > 80) {
          float stepl = 10;
          pushMatrix();
          translate(x, y);
          translate(step*.5, step*.5);
          scale(.9, .9);
          translate(-step*.5, -step*.5);

          for (int j=0; j<step; j+=stepl)
          {
            line(j, 0, step, step-j);
            if (j > 0)
              line(0, j, step-j, step);
          }
          popMatrix();
        }
      }
    }
  }
  popMatrix();
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


void  draw()
{


  for (int i=0; i<nSystems; i++)
  {
    for (int j=0; j<particleCount; j++)
    {
      Particle par = particles[i][j];
      par.update(noiseScale);
      float rad = 2;
      stroke(0, baseAlpha);
      strokeWeight(.1);
      line(par.prev.x, par.prev.y, par.x, par.y);
      //noStroke();
      //fill(0);
      //ellipse(particles[i][j].x, particles[i][j].y, rad, rad);
    }
  }
  if (save)
  {
    save = false;
    noi(10);
    saveTheFrame();
  }
}

void  keyPressed()
{
  if (key == 's')
  {
    save =true;
  }
}
