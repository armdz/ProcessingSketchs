color[] paleta = {#FF0335, #105FE3};

int   nSystems =70;
float noiseScale = 300;
float baseAlpha = 20;
int  particleCount = 1000;
PVector[]  emitters = new PVector[nSystems];
Particle[][] particles = new Particle[nSystems][particleCount];
boolean save = false;
float www = 0;
float area = 0;
float areah = 0;
color randomColor()
{
  return paleta[(int)random(paleta.length)];
}

void  setup()
{
  size(800, 800);
  pixelDensity(2);


  background(0);
  smooth(8);
  float amm = 20;
  float www = width*.2;
  float step = www/amm;

  area = width*.3;
  areah = height*.7;
  strokeWeight(.5);

  float ss = 5;
  for (int i=0; i<area; i+=ss)
  {
    float px = map(i, 0, area, width*.5-area*.5, width*.5+area*.5);
    float py0 = height*.5-areah*.5;
    float py1 = height*.5+areah*.5;
    stroke(paleta[0], baseAlpha*8);
    //   line(px, py0, px, py1);
  }

  for (int j=0; j<nSystems; j++)
  {
    emitters[j] = new PVector(0, 0);
    emitters[j].set(random(area), random(areah));
    emitters[j].z = random(100, 200);
    randomPos(emitters, j, area, areah);
  }

  for (int j=0; j<nSystems; j++)
  {

    float rad = map(j, 0, nSystems, width*.1, width*.3);
    int mode = random(100) > 30 ? 1 : 0;
    mode = 1;
    for (int i=0; i<particleCount; i++)
    {
      float angle = random(TWO_PI);
      float x = emitters[j].x+cos(angle)*emitters[j].z*.5;
      float y = emitters[j].y+sin(angle)*emitters[j].z*.5;
      particles[j][i] = new Particle(x, y);
      particles[j][i].mode = mode;

      stroke(paleta[0], baseAlpha*.2);
      if ((int)x % (int)ss == 0) {



        float px = (width*.5-area*.5)+x;
        float py = (height*.5-areah*.5)+y;

        if (py > height*.5)
        {
          line(px, py, px, height*.5 );
        } else {
          line(px, py, px, height*.5);
        }

        //  float dy = constrain( height*.5-areah*.5+y+areah,y, height*.5-areah*.5);
        //line(width*.5-area*.5+x, height*.5-areah*.5+y, width*.5-area*.5+x, dy);
      }
    }
  }

  for (int j=0; j<nSystems; j++)
  {


    for (int i=0; i<particleCount; i++)
    {
      float x = particles[j][i].x;
      float y = particles[j][i].y;
      strokeWeight(1);

      stroke(paleta[0]);
      if ((int)x % (int)ss == 0) {



        float px = (width*.5-area*.5)+x;
        float py = (height*.5-areah*.5)+y;
        float dy = getmoreyforx(j, i, x, y);

        line(px, py, px, dy);

        /* if (py > height*.5)
         {
         
         } else {
         line(px, py, px, height*.5);
         }*/

        //  float dy = constrain( height*.5-areah*.5+y+areah,y, height*.5-areah*.5);
        //line(width*.5-area*.5+x, height*.5-areah*.5+y, width*.5-area*.5+x, dy);
      }
    }
  }
  fill(0, 120);
  rect(0, 0, width, height);
  strokeWeight(2);

  pushMatrix();
  translate(width*.5, height*.5);
  translate(-area*.5, -areah*.5);
  for (int j=0; j<nSystems; j++)
  {
    fill(0);
    stroke(paleta[0]);
    ellipse(emitters[j].x, emitters[j].y, emitters[j].z, emitters[j].z);
    if (random(100) > 80) {
      float a = random(TWO_PI);
      arc(emitters[j].x, emitters[j].y, emitters[j].z*.8, emitters[j].z*.8, a, a+PI);
    }
  }

  popMatrix();


  pushMatrix();
  translate(width*.5, height*.5);
  translate(-area, -area);
  int  rx = 0;
  int  ry = 0;
  int index = 0;
  /*
  for (float x=0; x<www; x+=step)
   {
   for (float y=0; y<www; y+=step)
   {
   
   
   particles[index] = new Particle(width*.5-www*.5+x, height*.5-www*.5+y);
   
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
   index++;
   }
   }*/
  popMatrix();
  //baseAlpha = 20;
}

float getmoreyforx(int jj, int ii, float _x, float _y)
{
  float ret =_y;

  for (int j=0; j<nSystems; j++)
  {


    for (int i=0; i<particleCount; i++)
    {
      if (j != jj && i != ii) {
        Particle par = particles[j][i];
        if (dist(par.x, 0, _x, 0) < 1)
        {
          ret = max(par.y, ret);
        }
      }
    }
  }


  return ret;
}


void  draw()
{
  pushMatrix();
  translate(width*.5, height*.5);
  translate(-area*.5, -areah*.5);

  for (int j=0; j<nSystems; j++)
  {

    for (int i=0; i<particleCount; i++)
    {
      Particle par = particles[j][i];
      par.update(noiseScale);
      float rad = 8;

      if (par.mode == 0)
      {
        stroke(0);
      } else {
        //  blendMode(ADD);
        //stroke(lerpColor(par.col, par.col2, par.lifeNorm), baseAlpha);
      }

      stroke(paleta[0], baseAlpha);
      strokeWeight(.5);
      line(par.prev.x, par.prev.y, par.x, par.y);
      //  blendMode(NORMAL);
    }

    //noStroke();
    //fill(0);
    //ellipse(particles[i][j].x, particles[i][j].y, rad, rad);
  }
  popMatrix();




  if (save)
  {
    save = false;
    /*
    PImage img = get();
     img.filter(THRESHOLD, .8);
     img.filter(BLUR, 9);
     blendMode(ADD);
     image(img, 0, 0);
     blendMode(NORMAL);*/
    noi(20);
    saveTheFrame();
  }
}

void randomPos(PVector[] st, int _index, float _mw, float _mh)
{
  PVector  _p = st[_index];

  _p.x = random(_mw);
  _p.y = random(_mh);

  boolean check = false;
  while (!check)
  {
    int i = 0;

    boolean disok = true;

    while (i < st.length && disok) {
      if (st[i] != null) {
        float mind = _p.z*.5+st[i].z*.5;
        float di = dist(_p.x, _p.y, st[i].x, st[i].y);
        if (_index != i && di < mind)
        {
          disok = false;
        }
      }
      i++;
    }
    if (disok) {
      check = true;
    } else {
      _p.x = random(_mw);
      _p.y = random(_mh);
      _p.z*=.9;
    }
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
  if (key == 's')
  {
    save =true;
  }
}
