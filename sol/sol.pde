

boolean gen = false;
Sat[]  points;
boolean[]  takedPoints;


void  setup()
{
  size(600, 600);
  pixelDensity(2);
  gen = true;
}

void  draw()
{
  if (gen)
  {  
    background(0);

    /*

     color co = #180AA2;
     
     int sub = (int)random(12, 30);
     for (int i=0; i<sub; i++)
     {
     float side = height/(float)sub;
     color cuco = lerpColor(co, color(#1E0648), i/(float)sub);
     fill(cuco);
     noStroke();
     rect(0, i*side, width, side);
     }
     
     float step = 20;
     for (int x=0; x<width; x+=step)
     {
     for (int y=0; y<height; y+=step)
     {
     float side =step*.5;
     pushMatrix();
     translate(x, y);
     translate(step*.5, step*.5);
     float d = dist(width*.5, height*.5, x, y);
     float al = map(d, 0, width, 0, 100);
     
     stroke(255, al);
     line(0, -side*.5, 0, side*.5);
     line(-side*.5, 0, side*.5, 0);
     
     popMatrix();
     }
     }
     */

    pushMatrix();
    translate(width*.5, height*.5);

    float mW = width*.9;
    float mH = height*.9;
    color star = #EBF76E;
    star = #FFFFFF;
    pushMatrix();
    translate(-mW*.5, -mH*.5);

    points = new Sat[(int)random(20, 50)];
    takedPoints = new boolean[points.length];
    int hasSun = -1;

    for (int p=0; p<points.length; p++)
    {
      takedPoints[p] = false;
      points[p] = new Sat();
      points[p].rad = random(12, 50);  //  rad
      if (hasSun == -1 && (random(100) > 70 || p == points.length-1)) {
        hasSun = p;
        points[p].sun = true;
      }
      randomPos(points, p, mW, mH);
      float rad = points[p].rad;

      pushMatrix();
      translate(points[p].x, points[p].y);



      // stroke(star);
      //  ellipse(0, 0, rad, rad);






      /*
     
       
       float noi = noise(points[p].x, points[p].y, frameCount);
       
       if (noi > .3)
       {
       float ir = random(TWO_PI);
       fill(255, 100);
       arc(0, 0, rad*.8, rad*.8, ir, ir+random(PI), random(100) > 50 ? ARC : PIE);
       }*/


      popMatrix();
    }

    Sat sat = points[hasSun];
    strokeWeight(1);
    int seg = 100;
    float e_rad =width*1.2;
    for (int i=0; i<seg; i++)
    {
      float delta = i/(float)seg;
      float angle = delta*TWO_PI;

      float x0 = sat.x+cos(angle)*sat.rad;
      float y0 = sat.y+sin(angle)*sat.rad;
      float x1 = sat.x+cos(angle)*e_rad;
      float y1 = sat.y+sin(angle)*e_rad;


      stroke(255);
      line(x0, y0, x1, y1);
    }

    strokeWeight(6);
    for (int i=0; i<points.length; i++)
    {
      pushMatrix();
      translate(points[i].x, points[i].y);

      fill(255);
      stroke(0);
      ellipse(0, 0, points[i].rad, points[i].rad);

      popMatrix();
    }
    strokeWeight(1);

    for (int i=0; i<points.length; i++)
    {

      pushMatrix();
      translate(points[i].x, points[i].y);

      fill(255);
      stroke(0);
      ellipse(0, 0, points[i].rad, points[i].rad);

      int it = (int)random(3, 10);
      for (int k=0; k<it; k++)
      {
        float crad = map(k, 0, it, points[i].rad*1.1, points[i].rad*2);
        float alpha = map(k, 0, it, 40, 0);
        stroke(255, alpha);
        noFill();
        ellipse(0, 0, crad, crad);
      }

      popMatrix();
      if (i != hasSun) {
        int iSeg = 40;
        for (int j=0; j<iSeg; j++)
        {
          float s = sin((j/(float)iSeg)*PI);
          float an = (j/(float)iSeg)*PI;
          float angl = PI+atan2(sat.y-points[i].y, sat.x-points[i].x)+PI*.5;
          float d = dist(sat.x, sat.y, points[i].x, points[i].y);
          float x = points[i].x+cos(angl+an)*points[i].rad*.5;
          float y = points[i].y+sin(angl+an)*points[i].rad*.5;
          float raylon = map(d, width, 0, points[i].rad*.5, points[i].rad*.1);
          float x2 = x+cos(angl-PI*.5)*raylon*s;
          float y2 = y+sin(angl-PI*.5)*raylon*s;
          stroke(0);
          //  ellipse(x, y, 2, 2);
          line(x, y, x2, y2);
        }
      }
    }




    /*
    int randomS = (int)random(points.length);
     int first = randomS;
     int last = -1;
     int count = 0;
     takedPoints[randomS] = true;
     float maxCenterDis = 0;
     
     float segFac = .1;
     while (count < points.length-1)
     {
     float cDis = dist(points[randomS].x, points[randomS].y, width*.5, height*.5);
     maxCenterDis=max(maxCenterDis, cDis);
     
     int cc = getNearest(randomS, points);
     
     if (cc != -1)
     {
     takedPoints[cc] = true;
     PVector p0 = points[randomS];
     PVector p1 = points[cc];
     stroke(255);
     drawDashedLine(p0, p1, segFac);
     randomS = cc;
     last = cc;
     count++;
     }
     }
     drawDashedLine(points[last], points[first], segFac);*/


    popMatrix();


    popMatrix();


    PImage img = get();

    img.filter(THRESHOLD, .9);
    img.filter(BLUR, 9);

    blendMode(ADD);
    image(img, 0, 0);

    blendMode(NORMAL);

    noi(10);


    saveTheFrame();

    gen = false;
  }
}

void randomPos(Sat[] st, int _index, float _mw, float _mh)
{
  Sat  _p = st[_index];

  _p.x = random(_mw);
  _p.y = random(_mh);

  boolean check = false;
  while (!check)
  {
    int i = 0;

    boolean disok = true;

    while (i < st.length && disok) {
      if (st[i] != null) {
        float mind = _p.rad*.5+st[i].rad*.5;
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
    }
  }
}

void drawDashedLine(PVector _p0, PVector _p1, float _segFactor)
{
  float dis = dist(_p0.x, _p0.y, _p1.x, _p1.y);
  int segs = (int)map(_segFactor, 0, 1, dis*.01, dis);
  float angle = atan2(_p0.y-_p1.y, _p0.x-_p1.x)+PI;

  float px = _p0.x;
  float py = _p0.y;

  for (int i=0; i<segs; i++)
  {
    float segSize = dis/segs;
    float x = _p0.x+cos(angle)*segSize*i;
    float y = _p0.y+sin(angle)*segSize*i;

    if (i%2 == 0) {
      line(px, py, x, y);
    }
    px=x;
    py=y;
  }
}

int  getNearest(int _cur, PVector[] st)
{
  int ret = -1;
  int i = 0;
  float mindis = 9999;
  int curShort = -1;
  PVector curS = st[_cur];
  while (i < st.length && ret == -1)
  {
    if (_cur != i)
    {
      float d = dist(curS.x, curS.y, st[i].x, st[i].y);
      if (d < mindis && !takedPoints[i])
      {
        mindis = d;
        curShort = i;
      }
    }
    i++;
  }
  ret = curShort;

  return ret;
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
  if (key == 'g')
  {

    gen = true;
  }
}

///  ****


class Ray
{
  float x0;
  float y0;
  float x1;
  float y1;

  Ray()
  {
  }
}

class Sat
{
  float x;
  float y;
  float rad;
  boolean  sun;

  Ray rays[];

  Sat()
  {
    sun = false;
  }
}
