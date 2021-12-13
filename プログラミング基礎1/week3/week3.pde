void setup() {
  size(100, 100);
  colorMode(RGB, 256, 256, 256, 100);
  background(255, 255, 255);
  String[] loadedXLines = split(loadStrings("data.txt")[0], " / ");
  int size = 100;
  for (int x=0;x<size;x++) {
    String[] loadedYLines = split(loadedXLines[x], " ");
    for (int y=0;y<size;y++) {
      String[] rgbStrings = splitTokens(loadedYLines[y],",");
      stroke(float(rgbStrings[0]), float(rgbStrings[1]), float(rgbStrings[2]));
      point(x, y);
      println("xy("+x+", "+y+")", "RGB("+rgbStrings[0]+", "+rgbStrings[1]+", "+rgbStrings[2]+")");
    }
  }
}
