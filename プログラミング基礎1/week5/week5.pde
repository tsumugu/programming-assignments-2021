int scene = 0;
int F = 0;
int sceneF = 0;
int scene2F = 0;
int scene2F2 = 0;
int sceneF3 = 80;
PFont font;

void setup() {
  size(720, 480);
  colorMode(RGB, 256, 256, 256, 100);
  frameRate(30);
  font = loadFont("HiraginoSans-W3-36.vlw");
}

void draw() {
  if (scene == 0) {
    if (F==1) {
      sceneF = 0;
      scene2F = 0;
      scene2F2 = 0;
      sceneF3 = 80;
    }
    // シーン0: テーブルの上にiMacがあって、その画面にズームしていく
    background(color(255, 255, 255));
    pushMatrix();
    if (F>80) {
      if (sceneF<80) {
        sceneF++;
      } else {
        //sceneF = 0;
        F = 0;
        scene = 1;
      }
    }
    scale(1+sceneF*0.03);
    translate(-sceneF*2.84, -sceneF*0.5);
    drawTableAndiMac();
    popMatrix();
    //
  } else if (scene == 1) {
    // シーン1: 起動中みたいなローディング画面
    if (F==1) {
      sceneF = 0;
    }
    background(44);
    // 背景塗り
    fill(0, 0, 0, F*5);
    rectMode(CORNER);
    rect(0, 0, width, height);
    // プログレスバー(地の部分)
    pushMatrix();
    if (F*5>100) {
      if (sceneF<20) {
        sceneF++;
      } else {
        if (scene2F*5<100) {
          scene2F++;
        }
        noStroke();
        fill(255, 255, 255, scene2F*5);
        drawApple();
      }
      translate(width/2, (height/2)+sceneF*5);
    } else {
      translate(width/2, height/2);
    }
    //fill(255, 0, 0, F*5);
    stroke(122, 122, 122, F*5);
    fill(44, 44, 44, F*5);
    drawProgressBase();
    if (scene2F*5>=100) {
      if (scene2F2<100) {
        scene2F2++;
      } else {
        scene2F = 0;
        scene2F2 = 0;
        F = 0;
        scene = 2;
      }
      stroke(122, 122, 122);
      fill(235, 235, 235);
      drawProgressLine(scene2F2);
    }
    popMatrix();
    //
  } else if (scene == 2) {
    // デスクトップを表示
    background(85, 112, 48);
    noStroke();
    //
    
    float interval = 50;
    if (F<interval) {
    } else if (F<interval*2) {
      drawWindow(200, 100, 800/2, 600/2, "lesson1", color(255, 255, 255), true);
    } else if (F<interval*3) {
      drawWindow(200, 100, 800/2, 600/2, "lesson1", color(255, 255, 255), false);
      drawWindow(150, 150, 600/2, 600/2, "lesson2", color(0, 0, 0), true);
    } else if (F<interval*4+110) {
      drawWindow(200, 100, 800/2, 600/2, "lesson1", color(255, 255, 255), false);
      drawWindow(150, 150, 600/2, 600/2, "lesson2", color(0, 0, 0), false);
      drawWindow(50, 50, 640/2, 640/2, "lesson4", color(255, 255, 255), true);
    } else if (F<interval*4+120) {
      background(0);
    } else if (F<interval*4+130) {
      scene = 3;
      F = 0;
    }
    // 上部のバー
    noStroke();
    fill(57, 82, 23);
    rect(0, 0, width, 30);
    // アップルボタンを押したときのメニュー
      float textHeight = 50;
      float startFrame = interval*4;
      if (F>startFrame+60 && F<startFrame+100) {
        // 背景色
        fill(96, 121, 63);
        rect(5, 0, 60, 30, 5);
        // メニュー
        fill(165, 185, 141);
        rect(5, 30, 205, 215, 5);
        // テキストを選択したときの背景
        if (F>startFrame+80) {
          fill(30, 122, 229);
          rect(10, textHeight+135, 195, 23, 5);
        }
        // テキスト
        fill(0, 0, 0);
        stroke(154, 174, 130);
        textFont(font, 12);
        textAlign(LEFT, BASELINE);
        text("About This Mac", 15, textHeight);
        line(15, textHeight+10, 200, textHeight+10);
        text("System Preferences...", 15, textHeight+30);
        text("App Store...", 15, textHeight+50);
        line(15, textHeight+60, 200, textHeight+60);
        text("Recent Items", 15, textHeight+80);
        line(15, textHeight+90, 200, textHeight+90);
        text("Sleep", 15, textHeight+110);
        text("Restart...", 15, textHeight+130);
        // 選択されてるときはテキストを白に
        if (F>startFrame+80) {
          fill(255);
        }
        text("Shut Down...", 15, textHeight+150);
        fill(0, 0, 0);
        line(15, textHeight+160, 200, textHeight+160);
        text("Lock Screen...", 15, textHeight+180);
      }
    // 左上のリンゴマーク
    noStroke();
    fill(255);
    pushMatrix();
    scale(0.7);
    translate(13, -260);
    ellipseMode(CENTER);
    rotate(PI/6);
    ellipse(168, 216, 5, 10);
    ellipse(175, 230, 20, 20);
    popMatrix();
    //
  } else if (scene == 3)  {
    //background(44);
    background(color(255, 255, 255));
    pushMatrix();
    if (F>50) {
      if (sceneF3>0) {
        sceneF3--;
      } else {
        F = 0;
        //sceneF3 = 80;
        scene = 0;
      }
    }
    scale(1+sceneF3*0.03);
    translate(-sceneF3*2.84, -sceneF3*0.5);
    drawTableAndiMac();
    popMatrix();
  }
  F++;
}



// テーブルの上にiMacがあるシーン
void drawTableAndiMac() {
  // テーブル
  noStroke();
  fill(201, 160, 99);
  rectMode(CORNER);
  rect(0, height/2, width, height/2);
  // テーブルの木目をfor文で描く
  // TODO; 配列に計算結果を保持しておいて、そこから描画すれば出来ると思う。
  /*
  for (int i=0; i<11; i++) {
   stroke(255, 0, 0);
   strokeWeight(2);
   float yPos = height/2+(i+1)*20;
   line(0, yPos, width, yPos);
   //ランダムに背景色と同じ線を引くことでとぎれとぎれにする
   stroke(255, 255, 0);
   for (int j=0; j<random(2, 5); j++) {
   line(random(0, width), yPos, random(0, width), yPos);
   }
   }
   */
  // iMac
  pushMatrix();
  translate(180, 10);
  // 足の部分
  pushMatrix();
  translate(115, 240);
  // 足の塗り
  noStroke();
  fill(220, 221, 221);
  beginShape();
  curveVertex(0, 0);
  curveVertex(0, 0);
  curveVertex(0, 30);
  curveVertex(0, 75);
  curveVertex(125, 75);
  curveVertex(125, 30);
  curveVertex(125, 0);
  curveVertex(125, 0);
  endShape();
  // 影
  stroke(159, 160, 160, 80);
  strokeWeight(10);
  strokeCap(SQUARE);
  line(-3, 40, 128, 40);
  line(0, 10, 125, 10);
  // 足の枠線
  stroke(0, 0, 0);
  strokeWeight(3);
  noFill();
  beginShape();
  curveVertex(0, 0);
  curveVertex(0, 0);
  curveVertex(0, 30);
  curveVertex(0, 75);
  curveVertex(125, 75);
  curveVertex(125, 30);
  curveVertex(125, 0);
  curveVertex(125, 0);
  endShape();
  popMatrix();
  // 画面シルバー部分
  noStroke();
  fill(239);
  rect(0, 0, 350, 250, 20);
  // 画面ベゼル
  noStroke();
  fill(0);
  rect(0, 0, 350, 200, 20, 20, 0, 0);
  // 画面液晶
  noStroke();
  fill(44);
  rect(20, 20, 310, 160, 0, 0, 0, 0);
  // 画面枠線
  stroke(0, 0, 0);
  strokeWeight(3);
  noFill();
  rect(0, 0, 350, 250, 20);
  // リンゴマーク
  pushMatrix();
  translate(140, -58);
  ellipseMode(CENTER);
  noStroke();
  fill(0, 0, 0);
  rotate(PI/6);
  ellipse(168, 216, 5, 10);
  ellipse(175, 230, 20, 20);
  popMatrix();
  popMatrix();
  // キーボード
  drawKeyboard();
  popMatrix();
}

void drawApple() {
  pushMatrix();
  scale(3);
  translate(85, -220);
  ellipseMode(CENTER);
  rotate(PI/6);
  ellipse(168, 216, 5, 10);
  ellipse(175, 230, 20, 20);
  popMatrix();
}

void drawProgressBase() {
  rectMode(CENTER);
  rect(0, -60, width/2, 10, 5);
}

void drawProgressLine(float value) {
  rectMode(CORNER);
  rect(-width/4, -65, (width/2/100)*value*1.2, 10, 5);
}

float calcShearXRadAtline5(int index) {
  return (-10+(index*20/12))*PI/180;
}

void drawKeyboard() {
  pushMatrix();
  translate(250, 350);
  scale(1.3);
  // 枠
  stroke(0, 0, 0);
  strokeWeight(2);
  //fill(239);
  fill(220, 221, 221);
  //quad(-5, 0, -20, 70, 185, 70, 170, 0);
  quad(-5, -4.4, -20, 65.6, 185, 65.6, 170, -4.4);
  // キー
  stroke(0, 0, 0);
  strokeWeight(1);
  //fill(255, 0, 0);
  fill(255, 255, 255);
  // 上から0行目
  for (int i=0; i<13; i++) {
    // shearXで段階的に台形に変形
    pushMatrix();
    shearX((-10+(i*20/12))*PI/180);
    rect(0.51+i*12.25, 3, 9.45, 4);
    popMatrix();
  }
  // 上から0行目の指紋センサー部分
  pushMatrix();
  shearX(10*PI/180);
  rect(159.76, 3, 4.5, 4);
  popMatrix();
  // 上から1行目
  // 上から1行目の1キー
  pushMatrix();
  shearX(-10*PI/180);
  rect(0.51, 9.57, 12.01, 7.5);
  popMatrix();
  for (int i=0; i<13; i++) {
    pushMatrix();
    shearX((-10+(i*20/12))*PI/180);
    rect(15.58+i*11.66, 9.57, 8.61, 7.5);
    popMatrix();
  }
  // 上から2行目
  for (int i=0; i<13; i++) {
    pushMatrix();
    shearX((-10+(i*20/12))*PI/180);
    rect(0.5+i*11.54, 20.4, 8.61, 7.5);
    popMatrix();
  }
  // 上から3行目
  // 上から3行目のctrlキー
  pushMatrix();
  shearX(-10*PI/180);
  rect(0.51, 31.4, 12.01, 7.5);
  popMatrix();
  for (int i=0; i<12; i++) {
    pushMatrix();
    shearX((-10+(i*20/14))*PI/180);
    rect(14.96+11.59*i, 31.4, 8.61, 7.5);
    popMatrix();
  }
  // 上から4行目
  // 上から4行目 左shiftキー
  pushMatrix();
  shearX(-10*PI/180);
  rect(0.51, 42.73, 17.39, 7.5);
  popMatrix();
  for (int i=0; i<11; i++) {
    pushMatrix();
    shearX((-10+(i*20/12))*PI/180);
    rect(20.78+i*11.49, 42.73, 8.61, 7.5);
    popMatrix();
  }
  // 上から4行目 右shiftキー
  pushMatrix();
  shearX(10*PI/180);
  rect(147.13, 42.73, 17.39, 7.5);
  popMatrix();

  // 上から5行目
  pushMatrix();
  shearX(calcShearXRadAtline5(0));
  rect(0.5, 53.63, 8.61, 7.5);
  popMatrix();
  pushMatrix();
  shearX(calcShearXRadAtline5(1));
  popMatrix();
  pushMatrix();
  shearX(calcShearXRadAtline5(2));
  rect(11.32, 53.63, 8.61, 7.5);
  popMatrix();
  pushMatrix();
  shearX(calcShearXRadAtline5(3));
  rect(22.14, 53.63, 12.89, 7.5);
  popMatrix();
  pushMatrix();
  shearX(calcShearXRadAtline5(4));
  rect(37.24, 53.63, 10.12, 7.5);
  popMatrix();
  pushMatrix();
  shearX(calcShearXRadAtline5(5));
  rect(49.57, 53.63, 44.22, 7.5);
  popMatrix();
  pushMatrix();
  shearX(calcShearXRadAtline5(6));
  rect(96.01, 53.55, 10.12, 7.5);
  popMatrix();
  pushMatrix();
  shearX(calcShearXRadAtline5(7));
  rect(108.34, 53.63, 12.89, 7.5);
  popMatrix();
  pushMatrix();
  shearX(calcShearXRadAtline5(8));
  rect(123.44, 53.63, 8.61, 7.5);
  popMatrix();
  pushMatrix();
  shearX(calcShearXRadAtline5(9));
  rect(145.18, 53.63, 8.61, 3.5);
  popMatrix();
  pushMatrix();
  shearX(calcShearXRadAtline5(10));
  rect(134.44, 57.63, 8.61, 3.5);
  popMatrix();
  pushMatrix();
  shearX(calcShearXRadAtline5(10));
  rect(145.18, 57.63, 8.61, 3.5);
  popMatrix();
  pushMatrix();
  shearX(calcShearXRadAtline5(11));
  rect(155.91, 57.63, 8.61, 3.5);
  popMatrix();
  // Enter
  pushMatrix();
  shearX(10*PI/180);
  beginShape();
  vertex(150.52, 20.4);
  vertex(150.52, 20.4);
  vertex(150.52, 27.9);
  vertex(153.73, 27.9);
  vertex(153.73, 39.4);
  vertex(164.13, 39.4);
  vertex(164.13, 20.4);
  vertex(150.52, 20.4);
  vertex(150.52, 20.4);
  endShape();
  popMatrix();
}

// ウインドウを描画する関数
// drawWindow(150, 150, 600/2, 600/2, "lesson2", color(0, 0, 0));
void drawWindow(float x, float y, float w, float h, String lessonname, color bgcolor, boolean isActive) {
  noStroke();  
  // 影
  fill(0, 0, 0, 10);
  rect(x+5, y+5, w, h+25, 10);
  // ウインドウ本体
  fill(bgcolor);
  rect(x, y+25, w, h, 0, 0, 10, 10);
  // バー部分
  if (isActive) {
    fill(217);
  } else {
    fill(246);
  }
  rect(x, y, w, 25, 10, 10, 0, 0);
  // ウインドウタイトル
  if (isActive) {
    fill(0, 0, 0);
  } else {
    fill(168, 169, 166);
  }
  textFont(font, 14);
  textAlign(CENTER, CENTER);
  text(lessonname, x+(w/2), y+13);
  // 赤い閉じるボタン
  stroke(189);
  strokeWeight(1);
  if (isActive) {
    fill(255, 95, 86);
  } else {
    fill(213, 213, 212);
  }
  ellipse(x+15, y+13, 12, 12);
  // 黄色のマイナスボタン
  stroke(189);
  if (isActive) {
    fill(254, 188, 46);
  } else {
    fill(213, 213, 212);
  }
  ellipse(x+33, y+13, 12, 12);
  // 緑のフルスクリーンボタン(processingの実行画面にはなし)
  stroke(189);
  //fill(41, 201, 64);
  fill(213, 213, 212);
  ellipse(x+51, y+13, 12, 12);

  // プログラムを描画
  if (lessonname == "lesson1") {
    pushMatrix();
    translate(x, y+25);
    scale(0.5);
    drawLesson1();
    popMatrix();
  } else if (lessonname == "lesson2") {
    pushMatrix();
    translate(x+45, y+100);
    scale(0.28);
    drawLesson2();
    popMatrix();
  } else if (lessonname == "lesson4") {
    pushMatrix();
    translate(x, y+130);
    scale(0.44);
    drawLesson4();
    popMatrix();
  }
}

void drawLesson1() {
  // 筐体部分
  fill(255, 0, 0);
  rect(225.5, 54, 349, 492);

  // 広告部分
  fill(255, 255, 255);
  rect(254.2, 296, 140, 91);
  fill(0, 128, 0);
  noStroke();
  triangle(394.2, 296, 394.2, 387, 274.2, 387);
  fill(0, 77, 128);
  triangle(394.2, 341.5, 394.2, 387, 344.2, 387);

  // 取り出し口
  stroke(0, 0, 0);
  fill(0, 0, 0);
  rect(290.5, 408.2, 200, 73);
  // 取り出し口の影
  fill(125, 124, 124, 50);
  rect(290.5, 408.2, 200, 40);
  // 金額表示部分
  fill(0, 0, 0);
  rect(409.2, 286.5, 48, 17);
  // 金額表示部分の下の謎の四角
  fill(255, 0, 0);
  rect(409.2, 310.8, 48, 38);
  // お金取り出し部分
  fill(0, 0, 0);
  rect(509.2, 466.2, 34, 34, 10);
  fill(71, 71, 71, 70);
  rect(509.2, 466.2, 34, 34, 10);
  // お金入れる&返金レバー(左側の四角部分)
  fill(0, 0, 0);
  rect(509.2, 291, 34, 25, 5);
  // お金入れる&返金レバー(右側の丸部分)
  ellipse(540, 298, 34, 36);
  // お金入れる&返金レバー(硬貨投入口のオレンジ部分)
  fill(255, 127, 80);
  ellipse(541, 295, 22, 22);
  // お金入れる&返金レバー(硬貨投入口の銀色部分)
  noStroke();
  fill(161, 161, 161);
  ellipse(541, 295, 17, 17);
  // お金入れる&返金レバー(硬貨投入口の口部分)
  stroke(0, 0, 0);
  fill(0, 0, 0);
  rect(536, 294, 10, 2);
  // お金入れる&返金レバー(返金レバーの軸部分)
  noStroke();
  fill(255, 127, 80);
  ellipse(515, 308, 8, 8);
  // お金入れる&返金レバー(返金レバーの棒部分)
  rect(515, 304, 10, 4);
  // お金入れる&返金レバー(返金レバーの棒部分②)
  stroke(255, 127, 80);
  strokeWeight(3);
  strokeCap(ROUND);
  line(525, 304, 528, 300);
  strokeWeight(1);
  strokeCap(SQUARE);
  stroke(0, 0, 0);
  // お札入れるところ
  fill(255, 127, 80);
  rect(465.2, 303.5, 37, 26.3);
  // お札入れるところの中
  fill(0, 255, 0);
  rect(465.2, 318.5, 37, 5);
  //お札入れるところの蓋
  fill(71, 71, 71, 70);
  rect(465.2, 303.5, 37, 26.3);

  // 商品部分の背景
  fill(255, 255, 255);
  rect(253.7, 75, 280.4, 193.6);
  // 1段目
  rect(262.9, 129.2, 262, 10.3);
  // 2段目
  rect(262.9, 194, 262, 10.3);
  // 3段目
  rect(262.9, 258.3, 262, 10.3);

  //ボタン部分
  strokeWeight(0.5);
  fill(0, 0, 255);
  // ボタン1段目
  for (int i=0; i<12; i++) {
    float button1_x_diff = i*21.3;
    ellipse(277.4+button1_x_diff, 134.3, 6.5, 2.3);
  }
  // ボタン2段目
  for (int i=0; i<12; i++) {
    float button2_x_diff = i*21.3;
    ellipse(277.4+button2_x_diff, 199.2, 6.5, 2.3);
  }
  // ボタン3段目
  for (int i=0; i<12; i++) {
    float button3_x_diff = i*21.3;
    ellipse(277.4+button3_x_diff, 263.5, 6.5, 2.3);
  }
  strokeWeight(1);
  fill(255, 255, 255);

  // 商品1段目(一番上の段)
  int[][][] item1_colors = {
    {
      {0, 0, 0}, 
      {255, 0, 0}, 
      {255, 0, 0}
    }, 
    {
      {0, 0, 0}, 
      {255, 0, 0}, 
      {255, 0, 0}
    }, 
    {
      {0, 0, 0}, 
      {255, 0, 0}, 
      {255, 0, 0}
    }, 
    {
      {0, 0, 0}, 
      {255, 0, 0}, 
      {255, 0, 0}
    }, 
    {
      {255, 0, 0}
    }, 
    {
      {255, 0, 0}
    }, 
    {
      {0, 0, 0}
    }, 
    {
      {0, 0, 0}
    }, 
    {
      {163, 3, 165}
    }, 
    {
      {163, 3, 165}
    }, 
    {
      {255, 160, 16}
    }, 
    {
      {255, 160, 16}
    }
  };
  for (int i=0; i<4; i++) {
    float item1_x_diff = i*21.3;
    fill(item1_colors[i][0][0], item1_colors[i][0][1], item1_colors[i][0][2]);
    triangle(277.4+item1_x_diff, 90, 284.4+item1_x_diff, 100, 270.4+item1_x_diff, 100);
    rect(270.4+item1_x_diff, 100, 14, 29);
    fill(item1_colors[i][1][0], item1_colors[i][1][1], item1_colors[i][1][2]);
    rect(274.95+item1_x_diff, 90, 5, 3);
    fill(item1_colors[i][2][0], item1_colors[i][2][1], item1_colors[i][2][2]);
    rect(270.4+item1_x_diff, 100, 14, 9);
  }
  for (int i=4; i<12; i++) {
    float item1_x_diff = i*21.3;
    fill(item1_colors[i][0][0], item1_colors[i][0][1], item1_colors[i][0][2]);
    rect(270.4+item1_x_diff, 100, 14, 28.6);
  }
  // 商品2段目
  int[][][] item2_colors = {
    {
      {175, 223, 228}, 
      {255, 255, 255}, 
      {0, 0, 255}
    }, 
    {
      {175, 223, 228}, 
      {255, 255, 255}, 
      {0, 0, 255}
    }, 
    {
      {255, 255, 0}, 
      {255, 255, 255}, 
      {255, 160, 16}
    }, 
    {
      {255, 255, 0}, 
      {255, 255, 255}, 
      {255, 160, 16}
    }, 
    {
      {230, 247, 246}, 
      {0, 255, 0}, 
      {255, 255, 255}
    }, 
    {
      {230, 247, 246}, 
      {0, 255, 0}, 
      {255, 255, 255}
    }, 
    {
      {140, 100, 80}, 
      {255, 255, 255}, 
      {0, 255, 0}
    }, 
    {
      {140, 100, 80}, 
      {255, 255, 255}, 
      {0, 255, 0}
    }, 
    {
      {140, 100, 80}, 
      {255, 255, 255}, 
      {0, 255, 0}
    }, 
    {
      {140, 100, 80}, 
      {255, 255, 255}, 
      {0, 255, 0}
    }, 
    {
      {194, 142, 116}, 
      {255, 255, 255}, 
      {255, 255, 255}
    }, 
    {
      {194, 142, 116}, 
      {255, 255, 255}, 
      {255, 255, 255}
    }
  };
  for (int i=0; i<12; i++) {
    float item2_x_diff = i*21.3;
    float item2_y_diff = 65.6;
    fill(item2_colors[i][0][0], item2_colors[i][0][1], item2_colors[i][0][2]);
    triangle(277.4+item2_x_diff, 90+item2_y_diff, 284.4+item2_x_diff, 100+item2_y_diff, 270.4+item2_x_diff, 100+item2_y_diff);
    rect(270.4+item2_x_diff, 100+item2_y_diff, 14, 29);
    fill(item2_colors[i][1][0], item2_colors[i][1][1], item2_colors[i][1][2]);
    rect(274.95+item2_x_diff, 90+item2_y_diff, 5, 3);
    fill(item2_colors[i][2][0], item2_colors[i][2][1], item2_colors[i][2][2]);
    rect(270.4+item2_x_diff, 100+item2_y_diff, 14, 9);
  }
  // 商品3段目
  int[][] item3_colors = {
    {0, 0, 0}, 
    {0, 0, 0}, 
    {17, 17, 136}, 
    {17, 17, 136}, 
    {201, 174, 93}, 
    {201, 174, 93}, 
    {184, 136, 59}, 
    {184, 136, 59}, 
    {255, 245, 214}, 
    {255, 245, 214}, 
    {95, 199, 147}, 
    {95, 199, 147}, 
  };
  for (int i=0; i<12; i++) {
    float item3_x_diff = i*21.3;
    float item3_y_diff = 75.4;
    fill(item3_colors[i][0], item3_colors[i][1], item3_colors[i][2]);
    rect(270.4+item3_x_diff, 154+item3_y_diff, 14, 28.6);
  }
}

void drawLesson2() {
  colorMode(HSB, 360, 100, 100, 100);  
  // 小さい円の半径
  float radiusMin = 60;
  float radiusMax = 500;
  // 図形のx, y
  float centerX = width/2;
  float centerY = height/2;
  // 何重の円か
  int circleNum = 40;
  // 円の一周あたりの点の個数
  int objNum = 30;

  // circleNumのぶんループして円を重ねる。
  for (int n=0; n<circleNum; n++) {
    // 半径は、radiusMin〜radiusMaxの範囲内ですこしずつ変える
    float radius = (n*((radiusMax-radiusMin)/circleNum))+radiusMin;
    //
    float firstStartX = 0;
    float firstStartY = 0;
    float[] startPosListX = {};
    float[] startPosListY = {};
    // まずは線を描く
    strokeWeight(2);
    //stroke(n*(360/circleNum), 99, 99);
    stroke(0, 0, 99);
    fill(0, 0, 0, 0);
    beginShape();
    // 円に沿ってobjNum個ぶんの座標を取得、それらをcurveVertexで繋いでいく。
    for (int i=0; i<objNum; i++) {
      float radian = i*(PI*2/objNum);
      // この計算でラジアンから座標をとれる。
      float startX = radius * sin(radian);
      // 真円だとつまらないのでランダムに。
      startX = startX+random((1+i)*2);
      //startX = startX+random(100);
      float startY= radius * cos(radian);
      // 真円だとつまらないのでランダムに。
      startY= startY+random((1+i)*2);
      //startY= startY+random(100);
      // あとから点を打つので座標は保存。
      startPosListX = append(startPosListX, startX+centerX);
      startPosListY = append(startPosListY, startY+centerY);
      // 最初と最後は2度curveVertexを呼ぶ必要があるのでその処理
      if (i==0) {
        curveVertex(startX+centerX, startY+centerY);
        curveVertex(startX+centerX, startY+centerY);
        firstStartX = startX+centerX;
        firstStartY = startY+centerY;
      } else if  (i==objNum-1) {
        curveVertex(startX+centerX, startY+centerY);
        curveVertex(firstStartX, firstStartY);
        curveVertex(firstStartX, firstStartY);
      } else {
        curveVertex(startX+centerX, startY+centerY);
      }
    }
    endShape();
    // 先程保存した座標に点を打つ
    for (int j=0; j<objNum; j++) {
      fill(0, 0, 99);
      stroke(j*(360/objNum), 99, 99);
      ellipse(startPosListX[j], startPosListY[j], 5, 5);
    }
    //
  }
  colorMode(RGB, 256, 256, 256, 100);
}
void drawLesson4() {
  colorMode(HSB, 360, 100, 100, 100);
  int hourCount = 11;
  int minCount = 46;
  int secCount = 0;
  fill(0, 0, 16);
  //triangle(725, 0, 725, 488, 0, 488);
  triangle(725, -240, 725, 488, 0, 488);

  textFont(font, 36);
  textAlign(CENTER, CENTER);

  fill(0, 99, 0);
  drawClock(hourCount, minCount, secCount, 200, 0, false);
  drawTextAlongCircle("Tokyo", 200, 0);

  fill(0, 0, 99);
  drawClock(hourCount-1, minCount, secCount, width-170, height-220, true);
  drawTextAlongCircle("NewYork", width-170, height-220);
  colorMode(RGB, 256, 256, 256, 100);
}
void drawTextAlongCircle(String text, float posX, float posY) {
  pushMatrix();
  translate(posX, posY);
  if (text == "Tokyo") {
    int radius = 165;
    for (int i=0; i<5; i++) {
      float radian = PI+(PI/7)-(360/38*(i+1)*PI/180);
      float X = radius * sin(radian);
      float Y = radius * cos(radian);
      //
      textFont(font, 36);
      stroke(0, 0, 99);
      textAlign(CENTER, CENTER);
      text(text.substring(i, i+1), X, Y);
    }
  } else {
    int radius = 165;
    for (int i=0; i<7; i++) {
      float radian = (360/38*(i+1)*PI/180)-(PI/5);
      float X = radius * sin(radian);
      float Y = radius * cos(radian);
      //
      textFont(font, 36);
      stroke(0, 0, 99);
      textAlign(CENTER, CENTER);
      text(text.substring(i, i+1), X, Y);
    }
  }
  popMatrix();
}

void drawClock(int hourCount, int minCount, int secCount, float posX, float posY, Boolean isNight) {
  drawClockFace(posX, posY, isNight);
  drawSecNeedle(secCount, posX, posY);
  drawMinuteNeedle(minCount, posX, posY, isNight);
  drawHourNeedle(hourCount, posX, posY, isNight);
}

void drawHourNeedle(int time, float posX, float posY, Boolean isNight) {
  pushMatrix();
  translate(posX, posY);
  int radius = 50;
  float radian = PI-(360/12*(time)*PI/180);
  float X = radius * sin(radian);
  float Y = radius * cos(radian);
  //ellipse(X, Y, 10, 10);
  strokeWeight(3);
  strokeCap(ROUND);
  if (isNight) {
    stroke(0, 0, 99);
  } else {
    stroke(0, 99, 0);
  }
  line(0, 0, X, Y);
  popMatrix();
}

void drawMinuteNeedle(int time, float posX, float posY, Boolean isNight) {
  pushMatrix();
  translate(posX, posY);
  int radius = 80;
  float radian = PI-(360/60*(time)*PI/180);
  float X = radius * sin(radian);
  float Y = radius * cos(radian);
  //ellipse(X, Y, 10, 10);
  strokeWeight(3);
  strokeCap(ROUND);
  if (isNight) {
    stroke(0, 0, 99);
  } else {
    stroke(0, 99, 0);
  }
  line(0, 0, X, Y);
  popMatrix();
}

void drawSecNeedle(int time, float posX, float posY) {
  pushMatrix();
  translate(posX, posY);
  int radius = 80;
  float radian = PI-(360/60*(time)*PI/180);
  float X = radius * sin(radian);
  float Y = radius * cos(radian);
  //ellipse(X, Y, 10, 10);
  strokeWeight(1);
  strokeCap(ROUND);
  stroke(39, 100, 100);
  line(0, 0, X, Y);
  popMatrix();
}

void drawClockFace(float posX, float posY, Boolean isNight) {
  pushMatrix();
  translate(posX, posY);
  strokeWeight(1);
  if (isNight) {
    fill(0, 99, 0);
  } else {
    fill(0, 0, 99);
    stroke(0, 99, 0);
  }
  ellipse(0, 0, 280, 280);
  if (isNight) {
    fill(0, 0, 99);
  } else {
    fill(0, 99, 0);
  }
  ellipse(0, 0, 10, 10);
  int radius = 105;
  for (int i=0; i<12; i++) {
    //float radian = i*(PI*2/12);
    float radian = PI-(360/12*(i+1)*PI/180);
    float X = radius * sin(radian);
    float Y = radius * cos(radian);
    //
    textFont(font, 36);
    if (isNight) {
      stroke(0, 99, 0);
    } else {
      stroke(0, 0, 99);
    }
    textAlign(CENTER, CENTER);
    text(i+1, X, Y);
    //ellipse(X, Y, 10, 10);
  }
  popMatrix();
}
