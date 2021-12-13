int frameRate = 30;
int F = 0;
int hourCount = 11;
int minCount = 46;
int secCount = 0;
color BG;
PFont font;

void setup() {
  size(640, 640);
  colorMode(HSB, 360, 100, 100, 100);
  BG = color(0, 0, 99);
  font = loadFont("HiraginoSans-W3-36.vlw");

  background(BG);
  
  fill(0, 0, 16);
  triangle(width, 0, width+10, height+10, 0, height+10);
  
  textFont(font, 36);
  textAlign(CENTER, CENTER);
  
  fill(0, 99, 0);
  drawClock(hourCount, minCount, secCount, 200, 220, false);
  drawTextAlongCircle("Tokyo", 200, 220);
  
  fill(0, 0, 99);
  drawClock(hourCount-1, minCount, secCount, width-170, height-220, true);
  drawTextAlongCircle("NewYork", width-170, height-220);
  
  if (F>frameRate) {
    //println(" * ", hourCount, ":", minCount, ":", secCount);
    secCount++;
    F=0;
    if (secCount>59) {
      secCount = 0;
      minCount++;
      if (minCount>59) {
        minCount = 0;
        hourCount++;
      }
    }
  }
}

void drawTextAlongCircle(String text, float posX, float posY) {
  pushMatrix();
  translate(posX, posY);
  // 難しい...。ので、とりあえず決め打ち。
  //text(text, posX, posY);
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
  /*
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
  */
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
