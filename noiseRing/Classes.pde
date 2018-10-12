class Planeta
{
}


class Particle extends PVector
{
  PVector prev;
  PVector dir;
  PVector vel;
  float   speed;
  float   fact;
  color   col;
  color   col2;
  int     life;
  int    lifeLimit;
  float lifeNorm;
  int mode;
  Particle(float _x, float _y)
  {
    set(_x, _y);
    mode = 0;
    prev = new PVector(_x, _y);
    dir = new PVector(random(TWO_PI), random(TWO_PI), random(TWO_PI));
    vel = new PVector(0.0, 0.0, 0.0);
    speed = random(.5, .9);
    col = randomColor();
    col2 = randomColor();
    fact = 1;
    life = 0;
    lifeLimit = (int)random(2000, 3000);
    lifeNorm= 0;
  }


  void  update(float _nScale)
  {
    if (life < lifeLimit) {
      float angle = noise(x/_nScale, y/_nScale)*TWO_PI*_nScale;
      dir.x = cos(angle);
      dir.y = sin(angle);
      vel.set(dir);
      vel.mult(speed);
      prev.set(x, y);
      add(vel);
      life++;
      lifeNorm = life/(float)lifeLimit;
    }
  }
}
