
import ddf.minim.*;
Minim minim;
AudioInput in;
PImage back = null;

void setup()
{
  size(700, 1100, P3D);

  minim = new Minim(this);

  in = minim.getLineIn();
  background(0);
}


void  draw()
{

  //  blendMode(NORMAL);

  hint(DISABLE_DEPTH_TEST);
  pushMatrix();
  translate(width*.5, height*.5);
  rotate(.07);
  scale(1.01, 1.01);
  translate(-width*.5, -height*.5);
  // tint(255,0,0,255);
  tint(255);
  if (back != null)
    image(back, 0, 0);


  float pxx = cos(frameCount*.02)*width;
  /// copy((int)pxx,0,20,height,(int)width*.5,0,20,height);

  // background(0);
  // background(0);

  popMatrix();
  hint(ENABLE_DEPTH_TEST);
  translate(0, 0, -600);
  colorMode(HSB);
  float amp =  (in.right.level()+ in.left.level())/2;

  int it = 20;
  pushMatrix();
  translate(width*.5, height*.5);
  for (int i =0; i<it; i++)
  {
    pushMatrix();
    rotateZ(frameCount*.02+TWO_PI*noise(i*2));
    rotateY(frameCount*.01+TWO_PI*noise(i*10));
    //  rotateX(TWO_PI*noise(i*2));
    float d0 = i/(float)it;
    int seg = 32;
    float ia = frameCount*.02+noise(i*30)*PI;
    float rad = lerp(width*.2, width*.8, noise(i))+amp*noise(d0, i*20)*200;
    float rad2 = rad+noise(i)*30;

    float px = 0;
    float py = 0;
    // blendMode(ADD);
    beginShape(QUAD_STRIP);
    fill(d0*255, 255, 255);
    stroke(255, 255, 255*d0);
    //noStroke();
    strokeWeight(amp*2);
    boolean pa = false;
    for (int j=0; j<seg; j++)
    {
      float del = j/(float)seg;
      float an = ia+(del*PI);
      float no = noise(i*.02, j);
      float x = cos(an)*rad;
      float y = sin(an)*rad;
      float x2 =  cos(an)*rad2+no;
      float y2 = sin(an)*rad2+no;
      float col = map(sin(del*PI+frameCount*.2), -1, 1, 0, 255);
      noStroke();
      //stroke(0);
      fill(col, 255, 255);
      vertex(x, y);
      vertex(x2, y2);

      px=x;
      py=y;
      pa = !pa;
    }
    endShape();

    pushMatrix();
    translate(px, py);

    //sphere(20);

    popMatrix();
    popMatrix();
  }
  popMatrix();

  back = get();
  // back.filter(THRESHOLD,.5);
  //back.filter(INVERT);
}
