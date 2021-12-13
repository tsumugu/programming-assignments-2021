import fisica.*;

color bg;
float arm_degree, arm_x, arm_y, cat_size, drop_area_wall_weight;
int catch_move_seq_no, move_dir, psec, countdown, scene_no;
boolean isArmCatching;
int N = 16,
    TIME_LIMIT_SEC = 30;
PImage[] cats = new PImage[N];
float[] px = new float[N];
float[] py= new float[N];
FBox[] catboxs = new FBox[N];
FWorld world;
PFont font;

void setup() {
  size(1300, 800);
  frameRate(30);
  colorMode(RGB, 256, 256, 256, 100);
  bg = color(255, 255, 255);
  background(bg);
  
  Fisica.init(this);
  
  init();
}

void init() {
  // 変数の初期化
  initValues();
  // キャッチしたものを貯めておく箱
  initItemBox();
  // 猫を生成
  initItem();
}

void initValues() {
  arm_degree = 35;
  arm_x = width-150;
  arm_y = 100;
  cat_size = 100;
  isArmCatching = false;
  catch_move_seq_no = 0;
  move_dir = 0;
  drop_area_wall_weight = 10;
  countdown = TIME_LIMIT_SEC;
  scene_no = 0;
  world = new FWorld();
  world.setEdges();
  world.setGravity(0, 1000);
  world.setGrabbable(false);
  font = loadFont("07NikumaruFont-48.vlw");
}

void initItemBox() {
  FBox dropAreaBoxLeft = new FBox(drop_area_wall_weight, (height/2)-drop_area_wall_weight);
  dropAreaBoxLeft.setPosition(width-(((cat_size*3)+(drop_area_wall_weight*2))), height+5-height/4);
  dropAreaBoxLeft.setStaticBody(true);
  world.add(dropAreaBoxLeft);
  FBox dropAreaBoxRight = new FBox(drop_area_wall_weight, (height/2)-drop_area_wall_weight);
  dropAreaBoxRight.setPosition(width-(drop_area_wall_weight), height+5-height/4);
  dropAreaBoxRight.setStaticBody(true);
  world.add(dropAreaBoxRight);
}

void initItem() {
  for (int i=1; i<cats.length; i++) {
    cats[i] = loadImage("cat"+i+".png");
    cats[i].resize(int(cat_size), int(cat_size));
    px[i] = random(cat_size, width-cat_size-(((cat_size*3)+(drop_area_wall_weight*2))));
    py[i] = random(cat_size, height-cat_size);
    
    FBox box = new FBox(cat_size, cat_size);
    box.setPosition(px[i], py[i]);
    box.attachImage(cats[i]);
    world.add(box);
    catboxs[i] = box;
  }
}

void draw() {
  background(bg);
  world.step();
  world.draw();
  drawArm(arm_x, arm_y);
  //
  textFont(font);
  if (countdown<5) {
    fill(255, 0, 0);
  } else {
    fill(0);
  }
  textSize(64);
  textAlign(LEFT, BASELINE);
  text("00:"+nf(countdown, 2), 50, 100);
  textFont(font);
  fill(0);
  textSize(32); 
  textAlign(CENTER, BASELINE);
  text("Press <- or ->", width/2, 85);
  //
  if (scene_no==0) {
    if (move_dir == -1) {
      moveArm("LEFT");
    } else if (move_dir == 1) {
      moveArm("RIGHT");
    }
    if (isArmCatching) {
      catchMove();
    }
    // カウントダウン処理
    int sec = second();
    if (sec != psec) {
      if (countdown<=0) {
        // すべて落とす
        world.remove(world.bottom);
        scene_no = 1;
      } else {
        countdown--;
      }
    }
    psec = second();
  } else {
    // スコア表示画面
    fill(255, 255, 255, 80);
    rect(0, 0, width, height);
    textFont(font);
    fill(0);
    textAlign(CENTER, TOP);
    textSize(52); 
    text("RESULT", width/2, (height/2)-50);
    textSize(64); 
    text(countCatchedCats()+" ひき つかまえた!", width/2, (height/2)-50+75);
    textSize(32); 
    text("Press SPACE BAR to continue", width/2, (height/2)+75+200);
  }
}

void keyPressed() {
  if (scene_no == 0) {
    if (isArmCatching) {
      return;
    }
    if (keyCode == LEFT) {
      //moveArm("LEFT");
      move_dir = -1;
    } else if (keyCode == RIGHT) {
      //moveArm("RIGHT");
      move_dir = 1;
    }
  } else {
    if (keyCode == 32) {
      init();
    }
  }
}

void keyReleased() {
  if (isArmCatching) {
    return;
  }
  if (scene_no == 0) {
    if (keyCode == LEFT || keyCode == RIGHT) {
      move_dir = 0;
      catchArm();
    }
  }
}

int countCatchedCats() {
  float xlimit = width-(((cat_size*3)+(drop_area_wall_weight*2)));
  // rect(xlimit, 0, width, height);
  // 猫をひとつづつ取り出し
  int catchct = 0;
  for (int i=1; i<catboxs.length; i++) {
    // 猫の座標取得
    float x = catboxs[i].getX();
    float centerX = x+(cat_size/2);
    //
    if (xlimit<=centerX) {
      catchct++;
    }
  }
  return catchct;
}

void drawArm(float x, float y) {
  // 上から吊るすポール？を描画
  fill(255, 255, 255);
  stroke(0, 0, 0);
  strokeWeight(2);
  rect(x-30, 0, 60, y);
  // キャッチする腕の部分を描画
  fill(255, 255, 255);
  stroke(0, 0, 0);
  strokeWeight(15);
  pushMatrix(); // 左側
  //translate(x-40, y+350);
  translate(x-40, y+90);
  rotate(radians(arm_degree));
  line(0, 0, -50, 60);
  line(-50, 60, 30, 120);
  popMatrix();
  pushMatrix(); // 右側
  //translate(x+40, y+350);
  translate(x+40, y+90);
  rotate(radians(-arm_degree));
  line(0, 0, 50, 60);
  line(50, 60, -30, 120);
  popMatrix();
  // ベースを描画
  fill(255, 255, 255);
  stroke(0, 0, 0);
  strokeWeight(2);
  rect(x-90, y, 180, 100, 50);
}

int catchCats() {
  // アームでつかめているかを判定する
  // rect(arm_x-75, arm_y+90, 150, 120);
  // アームの当たり範囲座標取得
  float armCenterX = arm_x;
  float armCenterY = arm_y+150;
  // 猫をひとつづつ取り出し
  int catchct = 0;
  for (int i=1; i<catboxs.length; i++) {
    // 猫の座標取得
    float x = catboxs[i].getX();
    float y = catboxs[i].getY();
    float centerX = x+(cat_size/2);
    float centerY = y+(cat_size/2);
    // 当たり判定する (参考: http://mslabo.sakura.ne.jp/WordPress/make/processing%E3%80%80%E9%80%86%E5%BC%95%E3%81%8D%E3%83%AA%E3%83%95%E3%82%A1%E3%83%AC%E3%83%B3%E3%82%B9/%E7%9F%A9%E5%BD%A2%E5%90%8C%E5%A3%AB%E3%81%AE%E5%BD%93%E3%81%9F%E3%82%8A%E5%88%A4%E5%AE%9A%E3%82%92%E8%A1%8C%E3%81%86%E3%81%AB%E3%81%AF/)
    if (abs(armCenterX-centerX)<(150+cat_size)/2 && abs(armCenterY-centerY)<(120+cat_size)/2) {
      catboxs[i].setPosition(armCenterX, armCenterY);
      catchct++;
    }
  }
  return catchct;
}

void moveArm(String direction) {
  if (direction == "RIGHT") {
    if (arm_x < width-150) {
      arm_x += 10.0;
    }
  } else if (direction == "LEFT") {
    if (arm_x > 150) {
      arm_x -= 10.0;
    }
  } else if (direction == "OPEN") {
    if (arm_degree < 35) {
      arm_degree += 10.0;
    }
  } else if (direction == "CLOSE") {
    if (arm_degree > 0) {
      arm_degree -= 10.0;
    }
  } else if (direction == "UP") {
    if (arm_y > 20) {
      arm_y -= 10.0;
    }
  } else if (direction == "DOWN") {
    if (arm_y < height-220) {
      arm_y += 10.0;
    }
  }
}

void catchArm() {
  catch_move_seq_no = 0;
  isArmCatching = true;
}

void catchMove() {
  float random1 = round(random(10));
  float random2 = round(random(10));
  // 下まで降りて
  if (catch_move_seq_no == 0) {
    moveArm("DOWN");
    // とりすぎ防止のために4体とったらおわる
    int catct = catchCats();
    if (catct>=4) {
      catch_move_seq_no = 1;
    }
  }
  if (catch_move_seq_no == 0 && arm_y >= height-220) {
    catch_move_seq_no = 1;
  }
  // アームを閉じて
  if (catch_move_seq_no == 1) {
    catchCats();
    moveArm("CLOSE");
  }
  if (catch_move_seq_no == 1 && arm_degree <= 0) {
    catch_move_seq_no = 2;
  }
  // 上げて
  if (catch_move_seq_no == 2) {
    if (random1!=random2) {
      catchCats();
    }
    moveArm("UP");
  }
  if (catch_move_seq_no == 2 && arm_y <= 20) {
    catch_move_seq_no = 3;
  }
  // 右に移動する
  if (catch_move_seq_no == 3) {
    if (random1!=random2) {
      catchCats();
    }
    moveArm("RIGHT");
  }
  if  (catch_move_seq_no == 3 && arm_x  >= width-150) {
    catch_move_seq_no = 4;
  }
  // アームを開く
  if (catch_move_seq_no == 4) {
    moveArm("OPEN");
  }
  if  (catch_move_seq_no == 4 && arm_degree >= 35) {
    // 上の一連の動作が終わったらisArmCatchingをfalseにして初期化
    catch_move_seq_no = 0;
    isArmCatching = false;
  }
}
