// 迷路の探索に関するクラス
class SearchMaze {
  
  int WALL_N = 0, PATH_N = 1, START_N = 2, GOAL_N = 3,  // 属性に対応する番号
      UP_N = 0, RIGHT_N = 1, DOWN_N = 2, LEFT_N = 3, // 方向に対応する番号
      X_COUNT=20, Y_COUNT=20,  // グリッドの数
      X_GRID_SIZE=30, Y_GRID_SIZE=30;  // グリッドの大きさ
  boolean is_searched = false,
          is_goaled = false,
          is_fin = false;
  ArrayList tree = new ArrayList<MazeCell>();
  int[] visited_list = new int[X_COUNT*Y_COUNT];
  MazeCell start_c;
  ArrayList route = new ArrayList<MazeCell>();
  int[] gene = new int[1];
  
  /*
    迷路を探索する。幅優先探索を使う
      参考: https://ja.gadget-info.com/difference-between-bfs
            https://algoful.com/Archive/Algorithm/BFS
  */
  void search(int[][] maze_list, MazeCell arg_start_c, MazeCell arg_goal_c) {
    // 初期化
    start_c = arg_start_c;
    is_searched = false;
    is_goaled = false;
    is_fin = false;
    tree.clear();
    //visited_list = new int[X_COUNT*Y_COUNT];
    for (int x=0; x<X_COUNT; x++) {
      for (int y=0; y<Y_COUNT; y++) {
        try {
          visited_list[toIndex(new MazeCell(x, y))] = -1;
        } catch (ArrayIndexOutOfBoundsException e) {}
      }
    }
    route.clear();
    // スタートから始める
    tree.add(start_c);

    while (tree.size()>0 && !is_goaled) {
      // キューから取り出し
      MazeCell target_c = (MazeCell)tree.get(0); // キューはFIFO
      tree.remove(0);
      // 上下左右それぞれの方向に探索
      for (int dir=0; dir<4; dir++) {
        MazeCell next_c = new MazeCell(target_c.x, target_c.y);
        if (dir==UP_N) {
          next_c.y -= 1;
        } else if (dir==RIGHT_N) {
          next_c.x += 1;
        } else if (dir==DOWN_N) {
          next_c.y += 1;
        } else if (dir==LEFT_N) {
          next_c.x -= 1;
        }
        try {
          if (visited_list[toIndex(next_c)] < 0 && (maze_list[next_c.x][next_c.y] != WALL_N)) {
            setVisited(target_c, next_c);
            if (next_c.x==arg_goal_c.x && next_c.y==arg_goal_c.y) {
              tree.clear();
              is_goaled = true;
              break;
            } else {
              // キューに追加
              tree.add(next_c);
            }
          }
        } catch (ArrayIndexOutOfBoundsException e) {} // maze_list[next_c.x][next_c.y]が範囲外だとエラーが出るので握りつぶす
      }
    }
    // 探索終わりのフラグ
    is_searched = true;
    //
    // ゴールしていたら
    if (is_goaled) {
      // ルートを出す
      try {
        int startIndex = toIndex(start_c);
        int goalIndex = toIndex(arg_goal_c);
        int beforeIndex = visited_list[goalIndex];
        route.add(arg_goal_c);  // ルートにゴールを入れる
        while (beforeIndex>=0 && beforeIndex!=startIndex) {
          // ゴールからスタートへのルートをたどる
          route.add(search_maze.toCell(beforeIndex));
          beforeIndex = search_maze.visited_list[beforeIndex];
        }
        route.add(start_c); // ルートにスタートを入れる
        route = reverseArrayList(route); // ルートがゴールからになっているので逆転させる
      } catch (ArrayIndexOutOfBoundsException e) {} // maze_list[next_c.x][next_c.y]が範囲外だとエラーが出るので握りつぶす
      // ルートを遺伝子(進む方向の配列)に変換する
      gene = new int[route.size()];
      for (int i=0; i<route.size(); i++) {
        MazeCell current_c = (MazeCell)route.get(i);
        MazeCell next_c;
        if (route.size()>i+1) {
          next_c = (MazeCell)route.get(i+1);
        } else {
          next_c = arg_goal_c;
        }
        gene[i] = toDir(current_c, next_c);
      }
      is_fin = true;
    }
  }
  
  // リストを逆転させる
  ArrayList<MazeCell> reverseArrayList(ArrayList<MazeCell> list) {
    ArrayList<MazeCell> reversed_list = new ArrayList<MazeCell>();
    for (int i=list.size()-1; i>=0; i--) {
      reversed_list.add(list.get(i));
    }
    return reversed_list;
  }
  
  // 移動した方向を調べる
  int toDir(MazeCell current_c, MazeCell next_c) {
    int diff_x = current_c.x-next_c.x;
    int diff_y = current_c.y-next_c.y;
    if (diff_x==0 && diff_y==1) {
      return UP_N;
    } else if (diff_x==-1 && diff_y==0) {
      return RIGHT_N;
    } else if (diff_x==0 && diff_y==-1) {
      return DOWN_N;
    } else if (diff_x==1 && diff_y==0) {
      return LEFT_N;
    }
    return -1;
  }
  
  // 座標からインデックスに
  int toIndex(MazeCell c) {
    return c.x+X_COUNT*c.y;
  }
  
  // インデックスから座標に
  MazeCell toCell(int index) {
    return new MazeCell(index%X_COUNT, index/X_COUNT);
  }
  
  // 探索済みかを設定
  void setVisited(MazeCell target_c, MazeCell next_c) {
    int fromIndex = toIndex(target_c);
    int toIndex = toIndex(next_c);
    visited_list[toIndex] = fromIndex;
  }
  
  void draw() {
    for (int i=0; i<route.size(); i++) {
      MazeCell c = (MazeCell)route.get(i);
      noStroke();
      fill(60, 99, 99, 50);
      ellipse(c.x*X_GRID_SIZE+X_GRID_SIZE/2, c.y*Y_GRID_SIZE+Y_GRID_SIZE/2, X_GRID_SIZE/3, Y_GRID_SIZE/3);
    }
  }
  
}
