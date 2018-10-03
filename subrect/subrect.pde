color paleta[] = {#277958, #FCC03D, #17FA9D}; 
color getColor()
{
  return paleta[(int)random(paleta.length)];
}

boolean  gen = false;


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
    color back = getColor();
    background(back);


    pushMatrix();
    translate(width*.5, height*.5);

    int cit = (int)random(10, 20);

    for (int i=0; i<cit; i++)
    {
      noFill();
      float rad = map(i, 0, cit, width*.1, width);
      colorMode(HSB);
      color co = color(hue(back), saturation(back), (i/(float)cit)*255);
      stroke(co);
      colorMode(RGB);
      ellipse(0, 0, rad, rad);
    }


    popMatrix();


    int it = 8;
    float rot = 0;
    for (int i=0; i<it; i++) {

      float wscal = map(i, 0, it, .5, .02);
      float posx = map(i, 0, it, width, -width*.25);

      posx =0;

      float tW = width*wscal;
      float tH = height*wscal;

      pushMatrix();
      translate(width*.5, height*.5);
      rotate(rot);
      translate(-tW*.5, -tH*.5);

      float h = 0;
      float minh = 5;
      float maxh = 10;
      while (h < tH)
      {
        float modh = random(minh, maxh);
        float minw = 10;
        float maxw = 100;

        float modw = random(minw, maxw);
        float w = -modw*random(.4, 1);

        while (w < tW)
        {

          color color1 = getColor();
          color color2 = getColor();
          noStroke();
          float round = 0;

          float st = 30;
          for (float s=0; s<st; s++)
          {
            float del = s/st;
            float a = map(del, 0, 1, 20, 0);
            float sc = map(del, 0, 1, 1, 1.6);
            noStroke();
            fill(0, a);
            pushMatrix();
            //  rotateY(random(PI*.02));
            translate(w, h);
            scale(sc, sc);
            rect(0, 0, modw, modh, 0, round, 0, round);
            popMatrix();
          }
          float z = -100;
          //pushMatrix();
          //ranslate(w, h);


          //          popMatrix();



          //rect(w, h, modw, modh, 0, round, 0, round);
          noStroke();
          beginShape();
          fill(color1);
          vertex(w, h);
          fill(color2);
          vertex(w+modw, h);
          vertex(w+modw, h+modh);
          fill(color1);
          vertex(w, h+modh);
          vertex(w, h);
          endShape();
          /*
        float step = 1.0;
           for (float i=0; i<modw; i+=step)
           {
           float delta = i/(float)modw;
           color c = lerpColor(color1, color2, delta);
           fill(c);
           float round = 10;
           rect(w+i, h, step, modh);
           }*/

          w+=modw;
        }

        h+=modh;
      }
      rot+=HALF_PI;

      popMatrix();
    }
    addNoise(30);
    saveTheFrame();
    gen = false;
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
      float n = noise(x, y, red(c)+x*y+frameCount);
      img.set(x, y, color(0, n*_alpha));
    }
  }
  img.updatePixels();
  image(img, 0, 0);
}

void  keyPressed()
{
  if (key == 'g')
  {
    gen = true;
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
