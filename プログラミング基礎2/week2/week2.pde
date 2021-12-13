// 破線を描画するためにDashed Linesというライブラリを使う (https://github.com/garciadelcastillo/-dashed-lines-for-processing-)
import garciadelcastillo.dashedlines.*;
import processing.svg.PGraphicsSVG;

boolean is_mouse_pressing;
color BG;
float pen_weight, eraser_weight, toolzonewidth, toolgridwidth, pen_color_h, pen_color_s, pen_color_b;
int mouse_pressed_pos_x, mouse_pressed_pos_y, pKeyCode, pC;
String toolname;
float MARGIN = 20,
      MIN_PEN_WEIGHT = 1,
      MAX_PEN_WEIGHT = 10,
      MIN_ERASER_WEIGHT = 1,
      MAX_ERASER_WEIGHT = 20;
PFont font;
DashedLines dash;
PShape icons[];
/*
0"pen(ペンツール)", 3"eraser(消しゴムツール)"
1"lasso(なげなわツール)", 4"bucket(バケツツール)"
2"dropper(スポイトツール)", 5"line(直線ツール)"
*/
String[] TOOLS = {"pen", "lasso", "dropper", "eraser", "bucket", "line"};

class lassoline { // なげなわのためのline
  int start_x, start_y, end_x, end_y;
}
ArrayList<lassoline> lasso_lines_list;

class mline { // ペンと直線のためのline
  int start_x, start_y, end_x, end_y;
  float stroke_weight;
  color stroke;
}
class mshape { // なげなわ塗りつぶしのためのshape
  float stroke_weight;
  color stroke, fill;
  ArrayList<Integer[]> pos;
}
// ArrayList shapes_list;

class mlayer { // レイヤーのため
  Object shapes_list; // shapes_listと同じ役割
  boolean isShow;
};
ArrayList<mlayer> layer_list;
ArrayList<PImage> layer_pimage_list;

int layer_number = 0;

void setup() {
  // レンダラーをデフォのJAVA2DからP2Dに変更すると高速化できるらしい (http://www.musashinodenpa.com/p5/index.php?pos=2)
  //size(800, 600, P2D);
  size(800, 600);
  frameRate(60);
  colorMode(HSB, 360, 100, 100, 100);
  BG = color(0, 0, 99);
  background(BG);
  is_mouse_pressing = false;
  pen_color_h = 99;
  pen_color_s = 0;
  pen_color_b = 0;
  pen_weight = 5;
  eraser_weight = 5;
  font = loadFont("Monospaced-48.vlw");
  mouse_pressed_pos_x = 1000000;
  mouse_pressed_pos_y = 1000000;
  lasso_lines_list = new ArrayList<lassoline>();
  //shapes_list = new ArrayList();
  layer_list = new ArrayList<mlayer>();
  layer_pimage_list = new ArrayList<PImage>();
  dash = new DashedLines(this);
  dash.pattern(10, 5);
  toolname = TOOLS[0];
  toolzonewidth = width/5;
  toolgridwidth = (toolzonewidth-MARGIN*2)/2;
  // アイコンのSVGをロードする
  icons = new PShape[TOOLS.length];
  for (int i=0;i<TOOLS.length;i++) {
    PShape p = loadShape("icons/"+TOOLS[i]+".svg");
    p.scale(0.09);
    p.disableStyle();
    icons[i] = p;
  }
  // レイヤーを一つ作る
  createNewLayer();
}

void draw() {
  background(BG);
  drawToolPalette();
  drawColorPalette();
  drawLineWeightPalette();
  drawLayerPalette();
  drawShapeList();
  if (is_mouse_pressing) {
    if (toolname=="pen") {
      drawWithPen();
    } else if (toolname=="eraser") {
      drawWithEraser();
    } else if (toolname=="lasso") {
      drawWithLasso();
    } else if (toolname=="dropper") {
      pickCanvasColor();
    }
  }
  // プレビューを描画
  if (toolname=="line") { // 直線ツールの処理
    if (mouse_pressed_pos_x!=1000000 && mouse_pressed_pos_y!=1000000) {
      stroke(color(pen_color_h, pen_color_s, pen_color_b));
      strokeWeight(pen_weight);
      line(mouseX, mouseY, mouse_pressed_pos_x, mouse_pressed_pos_y);
    }
  } else if (toolname=="lasso" || toolname=="bucket") { // なげなわツールの処理
    if (lasso_lines_list.size()>0) {
      stroke(0, 99, 0);
      strokeWeight(1);
      noFill();
      dash.beginShape();
      for (int i=0; i<lasso_lines_list.size(); i++) {
        lassoline l = lasso_lines_list.get(i);
        dash.vertex(l.start_x, l.start_y);
        dash.vertex(l.end_x, l.end_y);
      }
      if (is_mouse_pressing) {
        dash.endShape();
      } else {
        dash.endShape(CLOSE);
      }
    }
  }
}

void mousePressed() {
  checkClickArea(mouseX, mouseY); // ツール選択の当たり判定
  is_mouse_pressing = true;
  // 直線ツールの処理
  if (toolname=="line") {
    if (isInCanvas(pmouseX, pmouseY, mouseX, pmouseY, pen_weight)) {
      mouse_pressed_pos_x = mouseX;
      mouse_pressed_pos_y = mouseY;
    }
  }
  // クリックされたとき、バケツツールかつ、なげなわツールで範囲が選択された状態だったら塗りつぶす
  if (isInCanvas(pmouseX, pmouseY, mouseX, pmouseY, 1)) {
    if (lasso_lines_list.size()>0 && toolname=="bucket") {
      mshape ms = new mshape();
      ArrayList<Integer[]> pos = new ArrayList<Integer[]>();
      for (int i=0; i<lasso_lines_list.size(); i++) {
        lassoline l = lasso_lines_list.get(i);
        Integer[] p1 = {l.start_x, l.start_y};
        Integer[] p2 = {l.end_x, l.end_y};
        pos.add(p1);
        pos.add(p2);
      }
      ms.stroke_weight = 0;
      ms.stroke = color(0, 0, 0);
      ms.fill = color(pen_color_h, pen_color_s, pen_color_b);
      ms.pos = pos;
      addObjectToLayer(ms);
      //shapes_list.add(ms);
    }
    // なげなわツールの初期化処理
    lasso_lines_list = new ArrayList<lassoline>();
  }
}

void mouseReleased() {
  is_mouse_pressing = false;
  // 直線ツールの処理
  if (toolname=="line") {
    if (isInCanvas(pmouseX, pmouseY, mouseX, pmouseY, pen_weight)) {
      mline m = new mline();
      m.stroke_weight = pen_weight;
      m.stroke = color(pen_color_h, pen_color_s, pen_color_b);
      m.start_x = mouse_pressed_pos_x;
      m.start_y = mouse_pressed_pos_y;
      m.end_x = mouseX;
      m.end_y = mouseY;
      addObjectToLayer(m);
      //shapes_list.add(m);
    }
    mouse_pressed_pos_x = 1000000;
    mouse_pressed_pos_y = 1000000;
  }
}

void mouseDragged() {
  checkHSlider(mouseX, mouseY); // 色相のピッカー
  checkSBSlider(mouseX, mouseY); // 明度彩度のピッカー
  checkLineWeightSlider(mouseX, mouseY); // スライダーを動かす処理
}

void keyPressed() {
  //if((pKeyCode==CONTROL && key=='s') || (pKeyCode==83 && keyCode==CONTROL)) {
  if(((pKeyCode==CONTROL||pKeyCode==157) && key=='s') || (pKeyCode==83 && (keyCode==CONTROL||keyCode==157))) {
    // 画像を保存する
    saveImage();
  } else if(((pC>5 || (pKeyCode==CONTROL||pKeyCode==157)) && key=='z') || (pKeyCode==90 && (pC>5 || (keyCode==CONTROL||keyCode==157)))) {
    try {
      // Undo
      //shapes_list.remove(shapes_list.size()-1); // 図形をつっこむArrayListのうち、最新のものを消しているだけ
      removeObjectFromLayer(-1);
    } catch (ArrayIndexOutOfBoundsException e) {} // 例外はにぎりつぶす
    pC =0;
  } else if (keyCode==BACKSPACE) {
    // なげなわツールで選択されている状態でdeleteキーが押されたとき、その範囲を白く塗りつぶす
    if (lasso_lines_list.size()>0) {
      // lasso_lines_listをshape_listにコピーする
      mshape ms = new mshape();
      ArrayList<Integer[]> pos = new ArrayList<Integer[]>();
      for (int i=0; i<lasso_lines_list.size(); i++) {
        lassoline l = lasso_lines_list.get(i);
        Integer[] p1 = {l.start_x, l.start_y};
        Integer[] p2 = {l.end_x, l.end_y};
        pos.add(p1);
        pos.add(p2);
      }
      ms.stroke_weight = 0;
      ms.stroke = color(0, 0, 0);
      ms.fill = BG;
      ms.pos = pos;
      //shapes_list.add(ms);
      addObjectToLayer(ms);
    }
    // なげなわツールの初期化処理
    if (isInCanvas(pmouseX, pmouseY, mouseX, pmouseY, 1)) {
      lasso_lines_list = new ArrayList<lassoline>();
    }
  /* TODO: ここらへんをGUIでできるように */
  } else if (key == 'p') {
    createNewLayer();
  } else if (key == 'h') {
    toggleLayerShowHide();
  } else if (keyCode == UP) {
    if (layer_list.size()-1>layer_number) {
      layer_number++;
    }
  } else if (keyCode == DOWN) {
    // layer_number
    if (layer_number>0) {
      layer_number--;
    }
  }
  pKeyCode = keyCode;
  pC++;
}

// --------
// ここから描くことに関する処理
// --------

void drawWithPen() {
  if (isInCanvas(pmouseX, pmouseY, mouseX, pmouseY, pen_weight)) {
    mline m = new mline();
    m.stroke_weight = pen_weight;
    m.stroke = color(pen_color_h, pen_color_s, pen_color_b);
    m.start_x = pmouseX;
    m.start_y = pmouseY;
    m.end_x = mouseX;
    m.end_y = mouseY;
    //shapes_list.add(m);
    addObjectToLayer(m);
  }
}

void drawWithEraser() {
  if (isInCanvas(pmouseX, pmouseY, mouseX, pmouseY, eraser_weight)) {
    mline m = new mline();
    m.stroke_weight = eraser_weight;
    m.stroke = BG;
    m.start_x = pmouseX;
    m.start_y = pmouseY;
    m.end_x = mouseX;
    m.end_y = mouseY;
    //shapes_list.add(m);
    addObjectToLayer(m);
  }
}

void drawWithLasso() {
  if (isInCanvas(pmouseX, pmouseY, mouseX, pmouseY, eraser_weight)) {
    lassoline l = new lassoline();
    l.start_x = pmouseX;
    l.start_y = pmouseY;
    l.end_x = mouseX;
    l.end_y = mouseY;
    lasso_lines_list.add(l);
  }
}

void drawShapeList() {
  if (layer_list.size()>0) {
    // 書き出した画像を保存するリストを初期化
    layer_pimage_list = new ArrayList<PImage>();
    // レイヤーごとに画像として書き出す
    for (int i=0; i<layer_list.size(); i++) {
      mlayer layer = layer_list.get(i);
      if (layer.isShow) {
        // 描画
        ArrayList shapes_list = (ArrayList)layer.shapes_list;
        if (shapes_list.size()>0) {
          for (int j=0; j<shapes_list.size(); j++) {
            if (shapes_list.get(j).getClass().getName()==new mshape().getClass().getName()) {
              drawmShape((mshape)shapes_list.get(j));
            } else if (shapes_list.get(j).getClass().getName()==new mline().getClass().getName()) {
              drawmLine((mline)shapes_list.get(j));
            }
          }
        }
        // キャプチャ→BGと同じところは透過
        PImage img = get(int(toolzonewidth+MARGIN), int(MARGIN), int(width-toolzonewidth-MARGIN*2), int(height-MARGIN*2));
        int img_width = img.width;
        int img_height = img.height;
        PImage img_transparent = createImage(img_width, img_height, ARGB);
        for (int x=0; x<img_width; x++) {
          for (int y=0; y<img_height; y++) {
            color c = img.pixels[y*img_width+x];
            if (c==BG) {
              img_transparent.set(x, y, color(0, 0, 0, 0)); // 背景色と同じところは透過
            } else {
              img_transparent.set(x, y, c); // その他はそのまま
            }
          }
        }
        // 配列にぶちこむ
        layer_pimage_list.add(img_transparent);
        // 背景色で塗りつぶして初期化
        noStroke();
        fill(BG);
        rect(int(toolzonewidth+MARGIN), int(MARGIN), int(width-toolzonewidth-MARGIN*2), int(height-MARGIN*2));
      }
    }
    // 書き出した画像を重ねて描画する
    if (layer_pimage_list.size()>0) {
      for (int i=0; i<layer_pimage_list.size(); i++) {
        PImage img = layer_pimage_list.get(i);
        image(img, int(toolzonewidth+MARGIN), int(MARGIN), int(width-toolzonewidth-MARGIN*2), int(height-MARGIN*2));
      }
    }
    //
  }
}

void drawmShape(mshape ms) {
  if (ms.stroke_weight==0) {
    noStroke();
  } else {
    stroke(ms.stroke);
    strokeWeight(ms.stroke_weight);
  }
  fill(ms.fill);
  beginShape();
  ArrayList<Integer[]> pos = ms.pos;
  for (int j=0; j<pos.size(); j++) {
    Integer[] xy = pos.get(j);
    vertex(xy[0], xy[1]);
  }
  endShape(CLOSE);
}

void drawmLine(mline m) {
  stroke(m.stroke);
  strokeWeight(m.stroke_weight);
  line(m.start_x, m.start_y, m.end_x, m.end_y);
}

void saveImage() {
  // 右上 (width-MARGIN, MARGIN)
  // 左上 (toolzonewidth+MARGIN, MARGIN)
  // 右下 (toolzonewidth+MARGIN, height-MARGIN)
  // 左下 (width-MARGIN, height-MARGIN)
  PImage img = get(int(toolzonewidth+MARGIN), int(MARGIN), int(width-toolzonewidth-MARGIN*2), int(height-MARGIN*2));
  img.save(millis()+".png");
}

void pickCanvasColor() {
  if (isInCanvas(pmouseX, pmouseY, mouseX, pmouseY, eraser_weight)) {
    PImage img = get(0, 0, width, height);
    color c = img.get(mouseX, mouseY);
    pen_color_h = hue(c);
    pen_color_s = saturation(c);
    pen_color_b = brightness(c);
  }
}

void createNewLayer() {
  mlayer layer = new mlayer();
  layer.shapes_list = new ArrayList();
  layer.isShow = true;
  layer_list.add(layer);
}

void toggleLayerShowHide() {
  Boolean f = (Boolean)layer_list.get(layer_number).isShow;
  layer_list.get(layer_number).isShow = !f;
}

void addObjectToLayer(Object obj) {
  ArrayList a = (ArrayList)layer_list.get(layer_number).shapes_list;
  a.add(obj);
  layer_list.get(layer_number).shapes_list = a;
}

void removeObjectFromLayer(int pos) {
  if (pos == -1) {
    // ⌘+z, 最新を一つ消す
    ArrayList shapelist = (ArrayList)layer_list.get(layer_number).shapes_list;
    shapelist.remove(shapelist.size()-1);
    layer_list.get(layer_number).shapes_list = shapelist;
  }
}

Boolean isInCanvas(int px, int py, int x, int y, float weight) {
  /*
  float weight = MAX_ERASER_WEIGHT;
  point(width-MARGIN-(weight/2), MARGIN+(weight/2)); // 右上
  point(toolzonewidth+MARGIN+(weight/2), MARGIN+(weight/2)); // 左上
  point(toolzonewidth+MARGIN+(weight/2), height-MARGIN-(weight/2)); // 左下
  point(width-MARGIN-(weight/2), height-MARGIN-(weight/2)); // 右下
  */
  return x>=toolzonewidth+MARGIN+(weight/2) && x<=width-MARGIN-(weight/2) &&
  px>=toolzonewidth+MARGIN+(weight/2) && px<=width-MARGIN-(weight/2) &&
  y>=MARGIN+(weight/2) && y<=height-MARGIN-(weight/2) &&
  py>=MARGIN+(weight/2) && py<=height-MARGIN-(weight/2);
}


// --------
// ここからUIに関する処理
// --------

void drawToolPalette() {
  noStroke();
  fill(0, 0, 15);
  rect(0, 0, toolzonewidth, height);
  fill(0, 0, 28);
  rect(toolzonewidth, 0, width, MARGIN);
  rect(toolzonewidth, 0, MARGIN, height);
  rect(toolzonewidth, height-MARGIN, width-toolzonewidth, MARGIN);
  rect(width-MARGIN, 0, MARGIN, height);
  int toolct = 0;
  for (int i=0; i<2; i++) {
    for (int j=0; j<3; j++) {
      strokeWeight(3);
      stroke(0, 0, 0);
      if (TOOLS[toolct]==toolname) {
        fill(0, 0, 0);
      } else {
        fill(0, 0, 99);
      }
      rect(MARGIN+(i*toolgridwidth), MARGIN+(j*toolgridwidth), toolgridwidth, toolgridwidth);
      strokeWeight(15);
      noFill();
      if (TOOLS[toolct]==toolname) {
        stroke(0, 0, 99);
      } else {
        stroke(0, 0, 0);
      }
      shape(icons[toolct], MARGIN+(i*toolgridwidth)+8, MARGIN+(j*toolgridwidth)+8);
      toolct++;
    }
  }
}

void checkClickArea(float x, float y) {
  // ボタンの範囲内か判定
  int toolct = 0;
  for (int i=0; i<2; i++) {
    for (int j=0; j<3; j++) {
      // 左上 (MARGIN+(i*toolgridwidth), MARGIN+(j*toolgridwidth))
      // 右上 (MARGIN+(i*toolgridwidth)+toolgridwidth, MARGIN+(j*toolgridwidth))
      // 左下 (MARGIN+(i*toolgridwidth), MARGIN+(j*toolgridwidth)+toolgridwidth)
      if (x>=MARGIN+(i*toolgridwidth) && x<=MARGIN+(i*toolgridwidth)+toolgridwidth) {
        if (y>=MARGIN+(j*toolgridwidth) && y<=MARGIN+(j*toolgridwidth)+toolgridwidth) {
          // ボタン領域がクリックされていたらツール名を設定
          toolname = TOOLS[toolct];
        }
      }
      toolct++;
    }
  }
}

void drawColorPalette() {
  strokeWeight(3);
  stroke(0, 0, 0);
  fill(0, 0, 99);
  // 明度と彩度の選択部分
  for (float x=MARGIN;x<MARGIN+toolgridwidth*2;x++) {
    for (float y=MARGIN*2+(3*toolgridwidth);y<(MARGIN*2)+(3*toolgridwidth)+(toolgridwidth*2);y++) {
      float s = map(x, MARGIN, MARGIN+toolgridwidth*2, 0, 100);
      float b = map(y, (MARGIN*2)+(3*toolgridwidth)+(toolgridwidth*2), MARGIN*2+(3*toolgridwidth), 0, 100);
      strokeWeight(1);
      stroke(pen_color_h, s, b);
      point(x, y);
    }
  }
  // pen_color_s, pen_color_bをマップする
  float cx = map(pen_color_s, 0, 100, MARGIN, MARGIN+toolgridwidth*2);
  float cy = map(pen_color_b, 0, 100, (MARGIN*2)+(3*toolgridwidth)+(toolgridwidth*2), MARGIN*2+(3*toolgridwidth));
  noStroke();
  fill(0, 0, 99);
  ellipse(cx, cy, 12, 12);
  // 色相の選択部分
  for (float x=MARGIN;x<MARGIN+(toolgridwidth*2);x++) {
    float h = map(x, MARGIN, MARGIN+(toolgridwidth*2), 0, 360);
    strokeWeight(1);
    stroke(h, 99, 99);
    line(x, MARGIN*2+(5*toolgridwidth)+MARGIN/3, x, MARGIN*2+(5*toolgridwidth)+(toolgridwidth/2)+MARGIN/3);
  }
  // pen_color_hをマップする
  strokeWeight(5);
  stroke(0, 0, 99);
  float x = map(pen_color_h, 0, 360, MARGIN, MARGIN+(toolgridwidth*2));
  line(x, MARGIN*2+(5*toolgridwidth)+MARGIN/3, x, MARGIN*2+MARGIN/3+(5*toolgridwidth)+(toolgridwidth/2));
}

void checkHSlider(float mousex, float mousey) {
  // 右上 (MARGIN+(toolgridwidth*2), MARGIN*2+(5*toolgridwidth))
  // 左上 (MARGIN, MARGIN*2+(5*toolgridwidth))
  // 右下 (MARGIN, MARGIN*2+(5*toolgridwidth)+(toolgridwidth/2))
  // 左下 (MARGIN, MARGIN*2+(5*toolgridwidth)+toolgridwidth/2);
  if (mousex>=MARGIN && mousex<=MARGIN+(toolgridwidth*2)) {
    if (mousey>=MARGIN*2+MARGIN/3+(5*toolgridwidth) && mousey<=MARGIN*2+MARGIN/3+(5*toolgridwidth)+toolgridwidth/2) {
      pen_color_h = map(mousex, MARGIN, MARGIN+(toolgridwidth*2), 0, 360);
    }
  }
}

void checkSBSlider(float mousex, float mousey) {
  // 右上 (MARGIN+toolgridwidth*2, MARGIN*2+(3*toolgridwidth))
  // 左上 (MARGIN, MARGIN*2+(3*toolgridwidth))
  // 右下 (MARGIN+(toolgridwidth*2), (MARGIN*2)+(3*toolgridwidth)+(toolgridwidth*2))
  // 左下 (MARGIN, (MARGIN*2)+(3*toolgridwidth)+(toolgridwidth*2))
  if (mousex>=MARGIN && mousex<=MARGIN+toolgridwidth*2) {
    if (mousey>=MARGIN*2+(3*toolgridwidth) && mousey<=(MARGIN*2)+(3*toolgridwidth)+(toolgridwidth*2)) {
      pen_color_s = map(mousex, MARGIN, MARGIN+toolgridwidth*2, 0, 100);
      pen_color_b = map(mousey, (MARGIN*2)+(3*toolgridwidth)+(toolgridwidth*2), MARGIN*2+(3*toolgridwidth), 0, 100);
    }
  }
  
}

void drawLineWeightPalette() {
  // スライダーを描画
  drawLineWeightSlider();
}

void drawLineWeightSlider() {
  float x = MARGIN;
  float y = (MARGIN*3)+(6*toolgridwidth)+(toolgridwidth/2);
  float w = toolgridwidth*2;
  // 丸の位置はpen_weightやeraser_weightに従わせる
  float weight, min_weight, max_weight;
  if (toolname=="pen" || toolname=="line") {
    weight = pen_weight;
    min_weight = MIN_PEN_WEIGHT;
    max_weight = MAX_PEN_WEIGHT;
  } else if (toolname=="bucket" || toolname=="dropper") {
    weight = MAX_PEN_WEIGHT;
    min_weight = MIN_PEN_WEIGHT;
    max_weight = MAX_PEN_WEIGHT;
  } else if (toolname=="eraser") {
    weight = eraser_weight;
    min_weight = MIN_ERASER_WEIGHT;
    max_weight = MAX_ERASER_WEIGHT;
  } else {
    return;
  }
  if (toolname!="bucket" && toolname!="dropper") {
    float circle_pos_x = map(weight, min_weight, max_weight, x, x+w);
    strokeWeight(5);
    strokeJoin(ROUND);
    stroke(0, 0, 59, 50);
    noFill();
    line(x, y, x+w, y);
    stroke(0, 0, 59, 100);
    line(x, y, circle_pos_x, y);
    noStroke();
    fill(0, 0, 99);
    ellipse(circle_pos_x, y, 15, 15);
  }
  
  // 太さと色を示す丸を描画する
  strokeWeight(1);
  stroke(0, 0, 99);
  if (toolname=="pen" || toolname=="line" || toolname=="bucket" || toolname=="dropper") {
    fill(color(pen_color_h, pen_color_s, pen_color_b));
  } else {
    fill(0, 0, 99);
  }
  ellipse(toolzonewidth-MARGIN-100, y-(toolgridwidth/2)-5, weight, weight);
  // 文字サイズをテキストで表示する
  if (toolname!="bucket" && toolname!="dropper") {
    textFont(font, 16);
    fill(0, 0, 99);
    // str(round(weight))
    // String.format("%.1f", weight)
    text(str(round(weight))+"px", toolzonewidth-MARGIN-65, y-(toolgridwidth/2)-10);
  }
  if (toolname=="pen" || toolname=="line" || toolname=="bucket" || toolname=="dropper") {
    // 文字色をテキストで表示する
    textFont(font, 16);
    fill(0, 0, 99);
    text(hexColorCode(color(pen_color_h, pen_color_s, pen_color_b)), toolzonewidth-MARGIN-65, y-(toolgridwidth/2)+10);
  }
}

void checkLineWeightSlider(float mousex, float mousey) {
  float x = MARGIN;
  float y = (MARGIN*3)+(6*toolgridwidth)+(toolgridwidth/2);
  float w = toolgridwidth*2;
  float r = 15;
  float weight, min_weight, max_weight;
  if (toolname=="pen" || toolname=="line") {
    weight = pen_weight;
    min_weight = MIN_PEN_WEIGHT;
    max_weight = MAX_PEN_WEIGHT;
  } else if (toolname=="eraser") {
    weight = eraser_weight;
    min_weight = MIN_ERASER_WEIGHT;
    max_weight = MAX_ERASER_WEIGHT;
  } else {
    return;
  }
  float circle_pos_x = map(weight, min_weight, max_weight, x, x+w);
  if (mousex>=circle_pos_x-r && mousex<=circle_pos_x+r) {
    if (mousey>=y-r && mousey<=y+r) {
      float mapped = map(mousex, x, x+w, min_weight, max_weight);
      if (mapped>=min_weight && mapped<=max_weight) {
        if (toolname=="pen" || toolname=="line" || toolname=="bucket" || toolname=="dropper") {
          pen_weight = mapped;  
        } else if (toolname=="eraser") {
          eraser_weight = mapped;  
        }
      }
    }
  }
}

String hexColorCode(color hsb) {
  pushStyle();
  colorMode(RGB, 256, 256, 256, 100);
  color rgb = hsb;
  popStyle();
  String hexa = hex(rgb); // alphaつきのhex
  String hex = hexa.substring(0, hexa.length()-2);
  return "#"+hex;
}

void drawLayerPalette() {
  //println(layer_number);
  float x = MARGIN;
  float y = (MARGIN*5)+(6*toolgridwidth)+(toolgridwidth/2);
  noStroke();
  fill(0, 0, 99);
  // rect(x, y, );
  rect(x, y-(MARGIN/2), toolzonewidth-(MARGIN*2), height-y-(MARGIN/2));
  textFont(font, 16);
  int start = layer_list.size() - 1;
  for (int i=start; i>=0; i--) {
    if (i==layer_number) {
      strokeWeight(1);
      stroke(0, 0, 0);
      fill(0, 0, 99);
      rect(x+5, y-5+((start-i)*20), toolzonewidth-(MARGIN*3)+10, 16);
      fill(0, 0, 0);
    } else {
      fill(0, 0, 0);
    }
    text(str(i), x+10, y+10+((start-i)*20));
    mlayer layer = layer_list.get(i);
    String statusText = "h";
    if (layer.isShow) {
      statusText = "s";
    }
    text(statusText, x+10+toolgridwidth+MARGIN+10, y+10+((start-i)*20));
  }
}
