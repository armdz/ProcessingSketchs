

boolean gen = false;
PVector[]  points;
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


    pushMatrix();
    translate(width*.5, height*.5);

    float mW = width*.5;
    float mH = height*.5;
    color star = #EBF76E;
    star = #FFFFFF;
    pushMatrix();
    translate(-mW*.5, -mH*.5);

    points = new PVector[(int)random(10, 30)];
    takedPoints = new boolean[points.length];


    for (int p=0; p<points.length; p++)
    {
      takedPoints[p] = false;
      points[p] = new PVector();
      points[p].z = random(12, 50);  //  rad
      randomPos(points, p, mW, mH);
      float rad = points[p].z;

      pushMatrix();
      translate(points[p].x, points[p].y);

      int it = (int)random(3, 10);
      for (int i=0; i<it; i++)
      {
        float crad = map(i, 0, it, rad*1.1, rad*2);
        float alpha = map(i, 0, it, 100, 0);
        stroke(star, alpha);
        noFill();
        ellipse(0, 0, crad, crad);
      }


      stroke(star);
      ellipse(0, 0, rad, rad);

      float noi = noise(points[p].x, points[p].y, frameCount);

      if (noi > .3)
      {
        float ir = random(TWO_PI);
        fill(255, 100);
        arc(0, 0, rad*.8, rad*.8, ir, ir+random(PI), random(100) > 50 ? ARC : PIE);
      }


      popMatrix();
    }

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
    drawDashedLine(points[last], points[first], segFac);
    popMatrix();

    pushMatrix();
    float round = 20;
    noFill();
    stroke(255);
    int it = (int)random(3, 6);
    float maxw = 0;
    for (int i=0; i<it; i++) {
      float sc = map(i, 0, it, 1, 1.2);
      pushMatrix();
      scale(sc, sc);
      float mW2 =maxCenterDis*1.2;
      rect(-mW2*.5, -mW2*.5, mW2, mW2, round, 0, round, 0);
      popMatrix();
    }

    it = points.length;
    pushMatrix();
    translate(maxCenterDis*-.5, (maxCenterDis*1.2)*.5);
    float side = maxCenterDis/(float)it;
    float hei = side*.5;
    for (int i=0; i<it; i++)
    {
      float fil = noise(i, frameCount);
      fill(100, 100*fil);
      if (i == 0) {
        rect(side*i, -hei*2, side, side*.5, round, 0, 0, 0);
      } else if (i == it-1)
      {
        rect(side*i, -hei*2, side, side*.5, 0, 0, round, 0);
        ellipse(side*i+side*1.5, -hei*1.5, side*.25, side*.25);
      } else {
        rect(side*i, -hei*2, side, side*.5);
      }
    }
    popMatrix();


    popMatrix();

    popMatrix();

    PImage img = get();

    img.filter(BLUR, 9);

    blendMode(ADD);
    image(img, 0, 0);

    blendMode(NORMAL);

    noi(30);


    saveTheFrame();

    gen = false;
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
