class Particle {
  float x, y, targetx, targety;
  float easing = 0.1;
  // easing = random(0.1, 0.15); // はじめも終わりもランダムだと微妙だった...。
  boolean fin = false;
  boolean canRemove = false;
  color cr;
  void move() {
    float dx = targetx - x;
    if(abs(dx) > 1) {
      x += dx * easing;
    }
    float dy = targety - y;
    if(abs(dy) > 1) {
      y += dy * easing;
    }
    if (dist(x, y, targetx, targety)<5) {
      //targetx = width/2+370;
      //targety = 1000;
      targetx = random(width*3);
      targety = 1500;
      easing = random(0.1, 0.2);
      fin = true;
    }
    if (fin) {
      if (dist(x, y, targetx, targety)<500) {
        canRemove = true;
      }
    }
  }
}
