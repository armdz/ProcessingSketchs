

color[]  paleta = {#FF6666, #880D1E, #EF2D56, #ED217C};
color getColor()
{
  int in = (int)random(paleta.length);
  return paleta[in];
}


boolean gen = false;
PShader el_shader;
PShader noiseShader;
void  setup()
{
  size(600, 600, P3D);
  pixelDensity(2);
  gen = true;
}



void  draw()
{
  el_shader = loadShader("frag.glsl", "vert.glsl");
  //noiseShader = loadShader("defor.glsl");
  if (gen)
  {
    gen = false;

    background(0);
    // hint(DISABLE_DEPTH_TEST);


    hint(ENABLE_DEPTH_TEST);

    pushMatrix();

    //17153437

    float tw = width*1.2;
    float th = height*1.2;

    translate(width*.5, height*.5);
    translate(-tw*.5, -th*.5);



    int ty = 12;
    float h = th/(float)ty;

    shader(el_shader);
    el_shader.set("neb", 0, 0, 0, 1.0);
    el_shader.set("time", frameCount);

    translate(0, -h*.5);

    for (int y=0; y<th; y+=h*.2) {

      pushMatrix();
      translate(0, y, y*.3);
      float minw = 30;
      float maxw = 60;

      float x = 0;
      float w = random(minw, maxw);

      translate(0, -h*.5);

      while (x < tw)
      {

        float curh = random(h*.6, h*1.2);
        fill(255);
        stroke(0);
        pushMatrix();
        translate(x, 0);
        translate(w*.5, h*.5);

        float d = dist(x, y, width*.5, height*.5);


        int it = (int)random(4, 6);
        for (int i=0; i<it; i++)
        {
          float delta = i/(float)it;
          float ww = map(delta, 0, 1, w, w*.1);
          float hh = map(delta, 0, 1, curh, curh*.1);
          float noi = noise(x, y, i);

          color cc = getColor();

          stroke(0);
          fill(getColor());

          ellipse(0, 0, ww, hh);

          //arc(0, 0, ww, hh, -PI, 0);
          //rect(-ww*.5, 0, ww, hh, 0, 0, 20, 20);
        }


        popMatrix();
        x+=w;
        w=random(minw, maxw);
        if (x+w > tw*.95)
        {
          w = tw-x;
        }
      }

      // resetShader();

      //      noiseShader.set("www", width);
      //    noiseShader.set("hhh", height);

      // filter(noiseShader);

      popMatrix();
    }
    popMatrix();



    resetShader();
    hint(DISABLE_DEPTH_TEST);
    pelo(30);
    addNoise(60);
    saveTheFrame();

    /*
    noFill();
     stroke(0);
     rect(0, h*.5, tw, th);
     popMatrix();*/
  }
}

void  drawRect(float _w, float _h, int _seg)
{
  pushMatrix();
  translate(0, 0);




  float h = _h/(float)_seg;
  for (int i=0; i<_seg; i++)
  {
    noFill();
    stroke(0);
    color col = i%2 == 0 ? color(0) : color(255);
    fill(col);
    rect(-_w*.5, i*h, _w, h);
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
  float step = 4;
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
