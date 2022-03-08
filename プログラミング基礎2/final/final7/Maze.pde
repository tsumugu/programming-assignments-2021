// 迷路に関するクラス
class Maze {
  
  int WALL_N = 0, PATH_N = 1, START_N = 2, GOAL_N = 3,  // 属性に対応する番号
      UP_N = 0, RIGHT_N = 1, DOWN_N = 2, LEFT_N = 3, // 方向に対応する番号
      X_COUNT=20, Y_COUNT=20,  // グリッドの数
      X_GRID_SIZE=30, Y_GRID_SIZE=30;  // グリッドの大きさ
  int[][] maze_list = new int[X_COUNT][Y_COUNT];
  ArrayList maze_start_list = new ArrayList<MazeCell>();
  ArrayList current_wall_cells = new ArrayList<MazeCell>();
  boolean is_generated = false;
  
  // 迷路の生成処理 壁伸ばし法を使う (参考: https://algoful.com/Archive/Algorithm/MazeExtend)
  void initMaze() {
    // 外周を壁にする
    is_generated = false;
    maze_list = new int[X_COUNT][Y_COUNT];
    maze_start_list.clear();
    for (int x=0; x<X_COUNT; x++) {
      for (int y=0; y<Y_COUNT; y++) {
        if (x==0 || y==0 || x==X_COUNT-1 || y==Y_COUNT-1 || x==1&&y==1 || x==X_COUNT-2&&y==Y_COUNT-2) {
          maze_list[x][y] = WALL_N;
        } else {
          maze_list[x][y] = PATH_N;
          // 外周ではない偶数座標を壁伸ばし開始点にしておく
          if (x%2 == 0 && y%2 == 0) {
            maze_start_list.add(new MazeCell(x, y));
          }
        }
      }
    }
    // 壁を伸ばしていく
    for (int i=0; i<maze_start_list.size(); i++) {
      MazeCell c = (MazeCell)maze_start_list.get(i);
      maze_start_list.remove(i);
      if (isPath(c.x, c.y)) {
        extendWall(c.x, c.y);
        current_wall_cells.clear();
      }
    }
    // 最後に、壁伸ばし開始点も壁にする
    for (int x=0; x<X_COUNT; x++) {
      for (int y=0; y<Y_COUNT; y++) {
        if (x==0 || y==0 || x==X_COUNT-1 || y==Y_COUNT-1) {
        } else {
          if (x%2 == 0 && y%2 == 0) {
            maze_list[x][y] = WALL_N;
          }
        }
      }
    }
    // スタートとゴールを設定する
    maze_list[1][1] = START_N;
    maze_list[X_COUNT-2][Y_COUNT-2] = GOAL_N;
    // 終わった〜フラグ
    is_generated = true;
  }
  
  void extendWall(int x, int y) {
    // 伸ばす方向の決定
    ArrayList directions = new ArrayList<Integer>();
    if (isPath(x, y-1) && isNotCurrentWall(x, y-2)) {
      directions.add(UP_N);
    } else if (isPath(x+1, y) && isNotCurrentWall(x+2, y)) {
      directions.add(RIGHT_N);
    } else if (isPath(x, y+1) && isNotCurrentWall(x, y+2)) {
      directions.add(DOWN_N);
    } else if (isPath(x-1, y) && isNotCurrentWall(x-2, y)) {
      directions.add(LEFT_N);
    }
    // 伸ばしていく
    if (directions.size() > 0) {
      setWall(x, y);
      boolean is_path = false;
      int random_direction_index = floor(random(0, 3));
      if (random_direction_index == UP_N) {
        is_path = isPath(x, y-2);
        setWall(x, --y);
        setWall(x, --y);
      } else if (random_direction_index == RIGHT_N) {
        is_path = isPath(x+2, y);
        setWall(++x, y);
        setWall(++x, y);
      } else if (random_direction_index == DOWN_N) {
        is_path = isPath(x, y+2);
        setWall(x, ++y);
        setWall(x, ++y);
      } else if (random_direction_index == LEFT_N) {
        is_path = isPath(x-2, y);
        setWall(--x, y);
        setWall(--x, y);
      }
      if (is_path) {
        extendWall(x, y);
      }
    } else {
      // すべて現在拡張中の壁にぶつかる場合、バックして再開
      // StackはLIFO
      int size = current_wall_cells.size();
      if (size>0) {
        MazeCell c = (MazeCell)current_wall_cells.get(size-1);
        current_wall_cells.remove(size-1);
        extendWall(c.x, c.y);
      }
    }
  }
  
  boolean isPath(int x, int y) {
    try {
      return maze_list[x][y] == PATH_N;
    } catch (ArrayIndexOutOfBoundsException e) {
      return false;
    }
  }
  
  boolean isNotCurrentWall(int x, int y) {
    return !current_wall_cells.contains(new MazeCell(x, y));
  }
  
  void setWall(int x, int y) {
    try {
      maze_list[x][y] = WALL_N;
      if (x%2 == 0 && y%2 == 0) {
        current_wall_cells.add(new MazeCell(x, y));
      }
    } catch (ArrayIndexOutOfBoundsException e) {
    }
  }
  
  void draw() {
    // 迷路を描画する
    for (int x=0; x<X_COUNT; x++) {
      for (int y=0; y<Y_COUNT; y++) {
        if (maze_list[x][y] == WALL_N) {
          noStroke();
          fill(240, 99, 64);
          rect(x*X_GRID_SIZE, y*Y_GRID_SIZE, X_GRID_SIZE, Y_GRID_SIZE, 10, 10, 10, 10);
        } else if (maze_list[x][y] == PATH_N) {
          noStroke();
          noFill();
          rect(x*X_GRID_SIZE, y*Y_GRID_SIZE, X_GRID_SIZE, Y_GRID_SIZE);
        } else if (maze_list[x][y] == START_N) {
          noStroke();
          fill(0, 99, 99);
          ellipse(x*X_GRID_SIZE+X_GRID_SIZE/2, y*Y_GRID_SIZE+Y_GRID_SIZE/2, X_GRID_SIZE/2, Y_GRID_SIZE/2);
        } else if (maze_list[x][y] == GOAL_N) {
          noStroke();
          fill(120, 99, 99);
          ellipse(x*X_GRID_SIZE+X_GRID_SIZE/2, y*Y_GRID_SIZE+Y_GRID_SIZE/2, X_GRID_SIZE/2, Y_GRID_SIZE/2);
        }
      }
    }
  }
}
