color bg;
int remainblockct;
float x, y, sp1, sp2, sp1dirc, sp2dirc, paddlex, beforepaddleposx, paddledirection, paddlestep, paddlespeedf, blockwidth, blockheight;
boolean[] blockflags;

final int BLOCK_ROW = 5, // ブロックの個数(横) 5
          BLOCK_COLUMN = 7, // ブロックの個数(縦) 7
          BLOCK_GAP = 5, // ブロックのすきま 7
          PADDLE_SP = 3; // パドルが移動するスピード(フレーム数) 3
final float MARGIN = 20, // ウインドウと図形との余白 20
      R = 40, // ボールの直径 40
      PADDLE_WIDTH = 100, // パドルの幅 100
      PADDLE_HEIGHT = 30, // パドルの高さ 30
      SP1_DEFAULT = 10, // 横移動のスピード 10
      SP2_DEFAULT = 10, // 縦移動のスピード 10
      ACCEL1_DEFAULT = 1.01, // 横移動の加速度 1.01
      ACCEL2_DEFAULT = 1.01; // 縦移動の加速度 1.01
final boolean DEBUG_MODE = false; // デバッグ用の表示を有効にするか

void setup() {
  size(800, 600);
  frameRate(30);
  colorMode(RGB, 256, 256, 256, 100);
  
  bg = color(255, 255, 255);
  drawBackground(bg);
  remainblockct = 0;
  x = width/2;
  y = height/2+100;
  sp1 = SP1_DEFAULT;
  sp2 = SP2_DEFAULT;
  sp1dirc = -1;
  sp2dirc = 1;
  paddlex = width/2;
  initBoxFlags();
  blockwidth = (width-(MARGIN*2))/BLOCK_COLUMN;
  blockheight = (height/2)/BLOCK_ROW;
  
  println("sp1", SP1_DEFAULT, "sp2", SP2_DEFAULT);
}

void draw() {
  drawBackground(bg);
  drawBall();
  drawBoxes();
  checkBoxEnd();
  movePaddle();
  drawPaddle();
}

void drawBackground(color bg) {
  fill(bg, 85);
  rect(0, 0, width, height);
}

void drawBall() {
  // x軸の跳ね返り
  sp1 *= ACCEL1_DEFAULT;
  x += sp1;
  if (x < R/2) {
    x = R/2;
    sp1dirc *= -1;
    sp1 = sp1dirc*SP1_DEFAULT;
  }
  if (x > width-R/2) {
    x = width-R/2;
    sp1dirc *= -1;
    sp1 = sp1dirc*SP1_DEFAULT;
  }
  // y軸の跳ね返り
  sp2 *= ACCEL2_DEFAULT;
  y += sp2;
  if (y < R/2) {
    y = R/2;
    sp2dirc *= -1;
    sp2 = sp2dirc*SP2_DEFAULT;
  }
  // 跳ね返せなかったときに玉が消えるようにしておく
  /*
  if (y > height-R/2) {
    y = height-R/2;
    sp2dirc *= -1;
    sp2 = sp2dirc*SP2_DEFAULT;
  }
  */
  // 図形描画
  strokeWeight(2);
  stroke(0, 0, 0);
  fill(255, 255, 255);
  ellipse(x, y, R, R);
}

void drawBoxes() {
  // 色について設定
  colorMode( HSB, 360, 100, 100, 100);
  stroke(0, 0, 0);
  strokeWeight(1);
  fill(255, 255, 255);
  // forでブロックを描画する処理を回す
  int ct = 0; // blockflagsの添字のためのカウンター
  remainblockct = 0; // 残っているブロックの数を一旦初期化
  for (int i=0;i<BLOCK_COLUMN;i++) {
    for (int j=0;j<BLOCK_ROW;j++) {
      // 当たり判定
      if ((y >= MARGIN+(blockheight*j)+blockheight && y < MARGIN+(blockheight*j)+(R/2)+blockheight) /* 下辺 */ || (y >= MARGIN+(blockheight*j)+blockheight && y <= MARGIN+(blockheight*j)) /* 右辺もしくは左辺 */ || (y > MARGIN+(blockheight*j) && y <= MARGIN+(blockheight*j)+(R/2)) /* 上辺 */) {
        if ((x >= MARGIN+(blockwidth*i)+(BLOCK_GAP/2)-(R/2) && x <  MARGIN+(blockwidth*i)+(BLOCK_GAP/2)) /* 斜めに攻められたときすり抜ける問題の対策 */ || (x >= MARGIN+(blockwidth*i)+(BLOCK_GAP/2) && x <= MARGIN+(blockwidth*i)+(BLOCK_GAP/2)+blockwidth-BLOCK_GAP) /* xの範囲 */ || (x > MARGIN+(blockwidth*i)+(BLOCK_GAP/2)+blockwidth-BLOCK_GAP && x <= MARGIN+(blockwidth*i)+(BLOCK_GAP/2)+blockwidth-BLOCK_GAP+(R/2)) /* 斜めに攻められたときすり抜ける問題の対策 */) {
          blockflags[ct] = false; // ブロックを消す
        }
      }
      // フラグがtrueだったらブロックを描画する
      if (blockflags[ct]) {
        fill(j*40, 100, 80);
        rect(MARGIN+(blockwidth*i)+(BLOCK_GAP/2), MARGIN+(blockheight*j), blockwidth-BLOCK_GAP, blockheight-BLOCK_GAP);
        remainblockct++; // 残っているブロックの数を加算
      }
      ct++;
    }
  }
  // RGBに戻す
  colorMode(RGB, 256, 256, 256, 100);
}

void initBoxFlags() {
  // フラグを初期化
  blockflags = new boolean[BLOCK_ROW*BLOCK_COLUMN];
  for (int i=0; i<BLOCK_ROW*BLOCK_COLUMN; i++) {
    blockflags[i] = true;
  }
}

void checkBoxEnd() {
  // ブロックが全て消えたときに復活させる。
  if (remainblockct == 0 && y > height/2+100) {
    initBoxFlags();
  }
}

void movePaddle() {
  // 玉の位置を予測して、パドルを動かす
  int f = 1; // 1フレーム後の位置を予測。
  float copy_sp1 = sp1;
  float copy_x = x;
  float copy_sp2 = sp2;
  float copy_y = y;
  copy_sp1 *= ACCEL1_DEFAULT * f;
  copy_x += copy_sp1;
  copy_sp2 *= ACCEL2_DEFAULT * f;
  copy_y += copy_sp2;
  // 玉の現在位置と、fフレーム後の位置を結んだ直線①を求める
  float a = (copy_y-y)/(copy_x-x);
  float b = ((copy_x*y)-(x*copy_y))/(copy_x-x);
  //println(x, y, copy_x, copy_y, "y="+a+"x+"+b);
  //line(x, y, copy_x, copy_y);
  // 直線①と、パドルの上辺の直線 y=height-PADDLE_HEIGHT-MARGIN の交点が移動すべき座標になる。
  float paddle_y = height-PADDLE_HEIGHT-MARGIN;
  float paddle_next_x = (paddle_y-b)/a; // 直線①をxについての形にするとx=(y-b)/aになる。このときyはパドルのy座標と同じなのでそれを代入すればOK
  //println(paddle_next_x, paddle_y);
  if (DEBUG_MODE) {
    strokeWeight(5);
    stroke(0, 0, 255);
    line(0, paddle_y, width, paddle_y);
    stroke(255, 0, 0);
    line(x, y, paddle_next_x, paddle_y);
    noStroke();
    fill(0, 255, 0);
    ellipse(copy_x, copy_y, 10, 10);
    ellipse(paddle_next_x, paddle_y, 15, 15);
    fill(0, 0, 255);
    ellipse(x, y, 10, 10);
  }
  if (paddle_next_x>=0&&paddle_next_x<=width) { // 画面外の座標になってしまうことがあるので、そのときは無視する。
    //paddlex = paddle_next_x; // これでも動くが、瞬間移動になってしまうのでsetPaddleX()で滑らかにアニメーションさせる
    setPaddleX(paddle_next_x);
  }
}

void setPaddleX(float paddle_next_x) {
  if (paddle_next_x!=beforepaddleposx) { // 移動先の座標が変わっていたら
    if (paddle_next_x<paddlex) { // 移動先の座標が現在の座標より左にあるとき
      paddledirection = -1; // パドルの座標は減っていく
      paddlestep = (paddlex-paddle_next_x)/PADDLE_SP; // PADDLE_SPフレーム後に移動先の座標に到達するには1フレームあたりどのくらい動けばいいのかを計算する
    } else { // 移動先の座標が現在の座標より右にあるとき
      paddledirection = 1; // パドルの座標は増えていく
      paddlestep = (paddle_next_x-paddlex)/PADDLE_SP; // PADDLE_SPフレーム後に移動先の座標に到達するには1フレームあたりどのくらい動けばいいのかを計算する
    }
    paddlespeedf = PADDLE_SP; // 移動回数のカウントを初期化
    //println(paddledirection, paddlestep);
  }
  if (paddlespeedf>0) { // 移動回数が0になったら終了
    paddlex += paddledirection*paddlestep; // パドルを移動させる
    paddlespeedf -= 1; // 移動回数を1回減らす
  }
  beforepaddleposx=paddle_next_x; // 変わっているかの比較のために、今回のpaddle_next_xを保存する。
}

void drawPaddle() {
  // 当たり判定
  if (y >= height-PADDLE_HEIGHT-MARGIN-(R/2) && y < height-PADDLE_HEIGHT-MARGIN) { // 上辺
    if ((x >= paddlex-(PADDLE_WIDTH/2)-(R/2) && x < paddlex-(PADDLE_WIDTH/2)) /* 斜めに攻められたときすり抜ける問題の対策 ( x = width; y = 220;で再現可能) */ || (x >= paddlex-(PADDLE_WIDTH/2) && x <= paddlex+PADDLE_WIDTH-(PADDLE_WIDTH/2)) /* 上辺 */ || (x >paddlex+PADDLE_WIDTH-(PADDLE_WIDTH/2) && x <= paddlex+PADDLE_WIDTH-(PADDLE_WIDTH/2)+(R/2)) /* 斜めに攻められたときすり抜ける問題の対策 */) {
      y = height-PADDLE_HEIGHT-MARGIN-(R/2);
      sp2dirc *= -1;
      sp2 = sp2dirc*SP2_DEFAULT;
    }
  } else if (y >= height-PADDLE_HEIGHT-MARGIN && y <= height-MARGIN) { // 右辺または左辺
    if (x >= paddlex-(PADDLE_WIDTH/2)-(R/2) && x < paddlex-(PADDLE_WIDTH/2)) { // 左辺
      x = paddlex-(PADDLE_WIDTH/2)-(R/2);
      sp1dirc *= -1;
      sp1 = sp1dirc*SP1_DEFAULT;
    } else if (x >= paddlex+PADDLE_WIDTH-(PADDLE_WIDTH/2) && x <= paddlex+PADDLE_WIDTH-(PADDLE_WIDTH/2)+(R/2)) { // 右辺
      x = paddlex-(PADDLE_WIDTH/2)+PADDLE_WIDTH+(R/2);
      sp1dirc *= -1;
      sp1 = sp1dirc*SP1_DEFAULT;
    }
  }
  // 図形を描画する
  strokeWeight(2);
  stroke(0, 0, 0);
  fill(255, 255, 255);
  rect(paddlex-(PADDLE_WIDTH/2), height-PADDLE_HEIGHT-MARGIN, PADDLE_WIDTH, PADDLE_HEIGHT);
}
