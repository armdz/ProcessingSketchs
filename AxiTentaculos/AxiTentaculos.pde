import nervoussystem.obj.*;


boolean gen = true;

void  setup()
{
  size(600, 600, P3D);
}

void draw()
{

  if (gen) {
    background(255);


    beginRecord("nervoussystem.obj.OBJExport", "filename.obj");

    lights();

    pushMatrix();
    translate(width*.5, height*.5, -900);

    gen = false;

    rotateY(radians(90));

    int total = 30;
    for (int t=0; t<total; t++) {
      pushMatrix();

      float px = 0;
      float py = 0;



      translate(px, py, -200);
      rotateY(HALF_PI);
      
      float ir = random(TWO_PI);

      int it =  40;
      float depth = 80;
      float w = random(10, 18);

      float pz = 0;
      float z = 0;
      boolean black = random(100) > 80;
      for (int i=0; i<it; i++)
      {
        float delta = i/(float)it;
        float noi = noise(ir, (t/(float)total), (i/(float)it)*100.0);
        float rw = (1.0-delta)*w;
        translate(0, 0, -depth*.5);

        float rot = lerp(noi*PI, random(TWO_PI), delta);


        rotateX(noi*PI);
        rotateZ(noi*PI);
        rotateY(noi*PI);

        translate(0, 0, -depth*.5);
        noStroke();
        fill(black ? color(255, 0, 0) : 255);
        if (!black)
        {
          stroke(0);
        }

        if (noi > .5 && !black) {

          float d2 = depth*.05;
          pushMatrix();
          translate(0, 0, -depth*.5);
          rotateX(HALF_PI);
          translate(0, -d2*.5, 0);
          stroke(0);
          cylinder(rw*1.3, rw*1.3, d2, 12);
          popMatrix();

          pushMatrix();
          translate(0, 0, depth*.5);
          rotateX(HALF_PI);
          translate(0, -d2*.5, 0);
          stroke(0);
          cylinder(rw*1.3, rw*1.3, d2, 12);
          popMatrix();

          int div = 2;
          float dside = rw*.3;
          int dt = 6;
          for (int s=0; s<dt; s++)
          {
            float del = s/(float)dt;
            float angle = del*TWO_PI;

            float x = cos(angle)*(rw-dside*.5);
            float y = sin(angle)*(rw-dside*.5);
            pushMatrix();

            translate(x, y);
            rotateX(HALF_PI);
            translate(0, -depth*.5);
            stroke(0);
            cylinder(dside, dside, depth, 8);
            popMatrix();
          }
        } else {
          pushMatrix();
          rotateX(HALF_PI);
          translate(0, -depth*.5, 0);
          stroke(0);
          cylinder(rw, rw, depth, 12);
          popMatrix();

          if (random(100) > 60 && i > it/10)
          {
            fill(255);
            stroke(0);

            rect(0, 0, 50, random(60, 120));
          }
        }
      }
      popMatrix();
    }



    popMatrix();




    endRecord();
  }
}


//thanks https://forum.processing.org/one/topic/draw-a-cone-cylinder-in-p3d.html
void cylinder(float bottom, float top, float h, int sides)
{
  pushMatrix();

  translate(0, h/2, 0);

  float angle;
  float[] x = new float[sides+1];
  float[] z = new float[sides+1];

  float[] x2 = new float[sides+1];
  float[] z2 = new float[sides+1];

  //get the x and z position on a circle for all the sides
  for (int i=0; i < x.length; i++) {
    angle = TWO_PI / (sides) * i;
    x[i] = sin(angle) * bottom;
    z[i] = cos(angle) * bottom;
  }

  for (int i=0; i < x.length; i++) {
    angle = TWO_PI / (sides) * i;
    x2[i] = sin(angle) * top;
    z2[i] = cos(angle) * top;
  }

  //draw the bottom of the cylinder
  beginShape(TRIANGLE_FAN);

  vertex(0, -h/2, 0);

  // pos.x+=sin(pos.y*.5)*1.2;
  //pos.y+=cos(pos.y*2.0)*1.2;
  for (int i=0; i < x.length; i++) {

    float xx = x[i]+sin(z[i]*.5)*1.2;
    float yy = z[i]+cos(z[i]*2.0)*1.2;



    vertex(xx, -h/2, yy);
  }

  endShape();

  //draw the center of the cylinder
  beginShape(QUAD_STRIP); 

  for (int i=0; i < x.length; i++) {


    float xx = x[i]+sin(z[i]*.5)*1.2;
    float yy = z[i]+cos(z[i]*2.0)*1.2;

    float xx2 = x2[i]+sin(z[i]*.5)*1.2;
    float yy2 = z2[i]+cos(z[i]*2.0)*1.2;


    vertex(xx, -h/2, yy);
    vertex(xx2, h/2, yy2);
  }

  endShape();

  //draw the top of the cylinder
  beginShape(TRIANGLE_FAN); 

  vertex(0, h/2, 0);

  for (int i=0; i < x.length; i++) {

    float xx2 = x2[i]+sin(z[i]*.5)*1.2;
    float yy2 = z2[i]+cos(z[i]*2.0)*1.2;

    vertex(xx2, h/2, yy2);
  }

  endShape();

  popMatrix();
}

void keyPressed()
{
  if (key == 'g')
  {
    gen = true;
  }
}
