size(600, 600);
colorMode(HSB, 360, 100, 100, 100);
background(0, 0, 0);

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
