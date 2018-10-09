class Particle extends PVector
{
  PVector prev;
  PVector dir;
  PVector vel;
  float   speed;
  float   fact;

  Particle(float _x, float _y)
  {
    set(_x, _y);
    prev = new PVector(_x, _y);
    dir = new PVector(0.0, 0.0, 0.0);
    vel = new PVector(0.0, 0.0, 0.0);
    speed = random(.2, .6);
    fact = 1;
  }

  void  update(float _nScale)
  {
    float angle = noise(x/_nScale, y/_nScale)*TWO_PI*_nScale;
    dir.x = cos(angle);
    dir.y = sin(angle);
    vel.set(dir);
    vel.mult(speed);
    prev.set(x, y);

    add(vel);
  }
}
