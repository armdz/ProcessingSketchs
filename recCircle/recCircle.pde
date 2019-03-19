color paleta[] = {#EAC435, #345995, #E40066, #03CEA4, #FB4D3D};
//https://coolors.co/403f4c-e84855-f9dc5c-3185fc-efbcd5
color getColor()
{
  return paleta[(int)random(paleta.length)];
}

PShader shader;

boolean gen = true;

void  setup()
{
  size(600, 600, P3D);
  pixelDensity(2);
}


void  draw()
{
  shader = loadShader("defor.glsl");
  if (gen)
  {

    background(255);
    pushMatrix();
    //   translate(width*.5, height*.5);



    stroke(0);
    noFill();

    int itm = 50;

    for (int j=0; j<itm; j++) {
      int it = 20;
      float size = height*random(.3, .8);
      pushMatrix();
      translate(random(width), random(height));
      rotate(random(TWO_PI));

      for (int i=0; i<it; i++)
      {
        float delta = i/(float)it;
        float h = map(delta, 1, 0, size*.1, size);
        rotate(.2);
        leaf(h*.25, h);
      }
      popMatrix();
      addNoise(8);
    }




    popMatrix();
    filter(shader);
    PImage g = get();

    g.filter(THRESHOLD, .92);
    g.filter(BLUR, 6);

    blendMode(ADD);
    tint(255, 100);
    image(g, 0, 0);
    blendMode(NORMAL);
    pelo(25);
    addNoise(25);
    saveTheFrame();
    gen = false;
  }
}


void leaf(float _w, float _h)
{

  int seg = 64;
  pushMatrix();
  translate(0, -_h);

  int it = 10;

  for (int j=0; j<it; j++) {

    boolean sombra = j!=it-1;
    float deltas = j/(float)it;
    float alphas = map(deltas, 0, 1, 20, 0);
    float scs = map(deltas, 0, 1, 1.1, 1);

    beginShape(QUAD_STRIP);
    float px = 0;
    float py = 0;

    color co = getColor();

    for (int i=0; i<seg+1; i++)
    {
      float delta = i/(float)seg;
      float y = delta*_h;
      float x = 0;
      float a = atan2(y-py, x-px);
      float a1 = a-radians(90);
      float a2 = a+radians(90);
      float sined = sin(delta*PI);
      float hw = ((_w*.5)*sined);
      if (sombra)
      {
        hw*=scs;
      }


      float x1 = x+cos(a1)*hw;
      float y1 = y+sin(a1)*hw;
      float x2 = x+cos(a2)*hw;
      float y2 = y+sin(a2)*hw;

      noStroke();
      fill( getColor());

      if (sombra)
      {

        fill(0, alphas);
      }

      vertex(x1, y1);   
      fill( getColor());
      if (sombra)
      {

        fill(0, alphas);
      }

      vertex(x2, y2);


      px = x;
      py = y;
      if (i%2==0)
      {
        co = getColor();
      }
    }
    endShape();
  }

  popMatrix();
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

        beginShape(LINES);
        for (int i=0; i<it; i++)
        {
          float noi = off+noise(px/sca, py/sca)*TWO_PI*2;
          float nx = px+cos(noi)*speed;
          float ny = py+sin(noi)*speed;
          float delta = sin((i/(float)it)*PI);
          extra++;
          strokeWeight(.6);
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
