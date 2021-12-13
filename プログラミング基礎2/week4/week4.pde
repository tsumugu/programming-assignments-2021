color BG;
PShape[] figures = new PShape[11]; // 0-9, ;
float point_interval = 15;
//ArrayList points = new ArrayList<Point>();
ArrayList particles = new ArrayList<Particle>();
int OLD_S, F = 0;

void setup() {
  size(800, 800, P3D);
  frameRate(30);
  //colorMode(RGB, 256, 256, 256, 100);
  colorMode(HSB, 360, 100, 100, 100);
  blendMode(SCREEN);
  BG = color(0, 0, 0);
  background(BG);
  for (int i=0;i<=9;i++) {
    figures[i] = loadShape(i+".svg");
    figures[i].disableStyle();
  }
  //「:」だけはforで処理できないので個別に読み込む
  figures[10] = loadShape("-.svg");
  figures[10].disableStyle();
  OLD_S = second();
  
  //  pushMatrix();
  ////translate(width/2-370, height/2);
  ////scale(0.28, 0.28);
  //rotateX(-0.2748);
  //translate(width/2-435, height/2);
  //scale(0.32, 0.32);
  
  //fill(0, 0, 99);
  //ellipse(0, -600, 15, 15);
  ////ellipse(-95, 0, 15, 15);
  ////ellipse(width*3+420, 0, 15, 15);
  //popMatrix();
}

void draw() {
  int s = second();
  background(BG);
  pushMatrix();
  //translate(width/2-370, height/2);
  //scale(0.28, 0.28);
  rotateX(-0.2748);
  translate(width/2-435, height/2);
  scale(0.32, 0.32);
  //rotateX(0.2748);
  // パーティクルを表示する
  for (int i=0;i<particles.size();i++) {
    Particle p = (Particle)particles.get(i);
    //stroke(255);
    //strokeWeight(5);
    fill(p.cr);
    ellipse(p.x, p.y, 15, 15);
    p.move();
    if (p.canRemove) {
      particles.remove(i);
    }
  }
  //
  popMatrix();
  F++;
  if (s != OLD_S) {
    F = 0;
    setClockDotPos(); // 座標を設定する
  }
  OLD_S = s;
}

void setClockDotPos() {
  String h_str = nf(hour(), 2);
  String m_str = nf(minute(), 2);
  String s_str = nf(second(), 2);
  // charをintにするには癖がある https://marycore.jp/prog/c-lang/convert-or-cast-char-to-int/
  newFigure(figures[h_str.charAt(0)-'0'], 0, 0);
  newFigure(figures[h_str.charAt(1)-'0'], 300, 0);
  newFigure(figures[10], 600, 0);
  newFigure(figures[m_str.charAt(0)-'0'], 900, 0);
  newFigure(figures[m_str.charAt(1)-'0'], 1200, 0);
  newFigure(figures[10], 1500, 0);
  newFigure(figures[s_str.charAt(0)-'0'], 1800, 0);
  newFigure(figures[s_str.charAt(1)-'0'], 2100, 0);
}

void newFigure(PShape shape, float xdiff, float ydiff) {
  int children = shape.getChildCount();
  for (int i=0; i<children; i++) {
    PShape child = shape.getChild(i);
    int total = child.getVertexCount();
    for (int j=0; j<total; j++) {
      PVector v = child.getVertex(j);
      PVector nv = child.getVertex(j+1);
      if (j==total-1) {
        nv = child.getVertex(0);
      }
      // line(v.x+xdiff, v.y+ydiff, nv.x+xdiff, nv.y+ydiff);
      addPos(v.x+xdiff, v.y+ydiff);
      addPos(nv.x+xdiff, nv.y+ydiff);
      // 点と点の間を補完する。点線のコードをそのまま使える。
      float dist = dist(v.x+xdiff, v.y+ydiff, nv.x+xdiff, nv.y+ydiff);
      int dot_num = floor(dist/point_interval);
      for( int k=0; k<dot_num; k++){
        float ratio = k/float(dot_num);
        float px = lerp(v.x+xdiff, nv.x+xdiff, ratio);
        float py = lerp(v.y+ydiff, nv.y+ydiff, ratio);
        addPos( px, py );
      }
    }
  }
}

void addPos(float x, float y) {
  Particle p = new Particle();
  p.x = random(-95, width*3+420);
  p.y = random(-1440, -1500);
  p.targetx = x;
  p.targety= y;
  //p.cr = color(random(10, 50), random(99), random(99));
  p.cr = color(random(200, 240), random(99), random(50, 99));
  particles.add(p);
}
