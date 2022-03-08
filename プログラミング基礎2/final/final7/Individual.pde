// 個体に関するクラス
class Individual {
  
  int WALL_N = 0, PATH_N = 1, START_N = 2, GOAL_N = 3,
      UP_N = 0, RIGHT_N = 1, DOWN_N = 2, LEFT_N = 3,
      X_COUNT=20, Y_COUNT=20,
      X_GRID_SIZE=30, Y_GRID_SIZE=30,
      gene_frame=0, old_ms;
  int[] gene = new int[0];
  float gene_score = 0,
        MOVE_SPEED = 40; //40
  MazeCell goal_c = new MazeCell(X_COUNT-2, Y_COUNT-2);
  MazeCell individual_c = new MazeCell(1, 1);
  color body_color;
  boolean is_fin_onecicle = false;

  Individual() {
    old_ms = millis();
  }
  
  // 個体に遺伝子を設定する
  void setGene(int[] arg_gene) {
    gene = arg_gene;
    // スコアを算出する
    gene_score = calcScore();
    // 初期化
    gene_frame = 0;
    individual_c.x = 1;
    individual_c.y = 1;
    is_fin_onecicle = false;
    setColor();
  }
  
  // 体の色をランダムに決める
  void setColor() {
    body_color = color(floor(random(0, 360)), 64, 99);
  }
  
  float calcScore() {
    // 動けた回数をカウント
    // 遠ざかっていたら加算
    MazeCell test_individual_c = new MazeCell(1, 1);
    int move_count = 0;
    int stay_away_from_goal_count = 0;
    float before_distance = 100000000;
    for (int i=0; i<search_maze.gene.length; i++) {
      if (gene_generator.moveIndividual(test_individual_c, gene[i])) {
        move_count++;
      }
      float dist = dist(goal_c.x, goal_c.y, test_individual_c.x, test_individual_c.y);
      if (before_distance <= dist) {
        stay_away_from_goal_count++;
      }
      before_distance = dist;
    }
    // 周囲1ブロックの範囲に通路が存在するか
    int path_count = 0;
    for (int dir=0; dir<4; dir++) {
      MazeCell around_test_individual_c = new MazeCell(test_individual_c.x, test_individual_c.y);
      if (dir==UP_N) {
        around_test_individual_c.y -= 1;
      } else if (dir==RIGHT_N) {
        around_test_individual_c.x += 1;
      } else if (dir==DOWN_N) {
        around_test_individual_c.y += 1;
      } else if (dir==LEFT_N) {
        around_test_individual_c.x -= 1;
      }
      for (int i=0; i<search_maze.route.size(); i++) {
        MazeCell c = (MazeCell)search_maze.route.get(i);
        if (c.x==around_test_individual_c.x && c.y==around_test_individual_c.y) {
          path_count++;
        }
      }
    }
    int around_path = 4-path_count;
    // ルートに合流するまでの距離と、ゴールまでの距離を計算
    float min_dist = -1;
    int min_dist_index = 0;
    for (int i=0; i<search_maze.route.size(); i++) {
      MazeCell c = (MazeCell)search_maze.route.get(i);
      float dist = dist(c.x, c.y, test_individual_c.x, test_individual_c.y);
      if (min_dist == -1) {
        min_dist = dist;
        min_dist_index = i;
      } else {
        if (dist <= min_dist) {
          min_dist = dist;
          min_dist_index = i;
        }
      }
    }
    // 1. 現在地からnear_cまでの距離
    // 2. near_cからゴールまでの数
    // 3. 壁にぶつかった回数
    // 4. 近くに通路が存在するか
    // 5. ゴールから遠ざかった回数
    // 1-5の合計が少ないほど優秀な遺伝子
    return min_dist+float(search_maze.route.size()-1)-float(min_dist_index)+float(search_maze.gene.length-1-move_count)+float(around_path)+float(stay_away_from_goal_count);
  }
  
  void draw() {
    if (gene.length <= 0) { // 遺伝子の長さが0だったらまだ生成されていないとみなして終了
      return;
    }
    if (!is_fin_onecicle) {
      if (millis()-old_ms >= MOVE_SPEED) { // スピード調節
        gene_generator.moveIndividual(individual_c, gene[gene_frame]); // 個体を動かす
        gene_frame++;
        if (gene_frame >= gene.length) {
          is_fin_onecicle = true;
        }
        old_ms = millis();
      }
    }
    if (gene_frame < gene.length) {
      drawIndividual();
    }
  }
  
  void drawIndividual() {
    // 胴体部分を描画
    noStroke();
    fill(body_color);
    ellipse(individual_c.x*X_GRID_SIZE+X_GRID_SIZE/2, individual_c.y*Y_GRID_SIZE+Y_GRID_SIZE/2, X_GRID_SIZE, Y_GRID_SIZE);
    // 進む方向によって目の向きを変える
    float eye_diff = 10;
    if (gene[gene_frame] == UP_N) {
      noStroke();
      fill(0, 0, 99);
      ellipse(individual_c.x*X_GRID_SIZE+(X_GRID_SIZE/3), individual_c.y*Y_GRID_SIZE+(Y_GRID_SIZE/3/2), X_GRID_SIZE/3, X_GRID_SIZE/3);
      ellipse(individual_c.x*X_GRID_SIZE+(X_GRID_SIZE/3)+eye_diff, individual_c.y*Y_GRID_SIZE+(Y_GRID_SIZE/3/2), X_GRID_SIZE/3, X_GRID_SIZE/3);
      noStroke();
      fill(0, 0, 0);
      ellipse(individual_c.x*X_GRID_SIZE+(X_GRID_SIZE/5)+(X_GRID_SIZE/5/2), individual_c.y*Y_GRID_SIZE+(Y_GRID_SIZE/5/2), X_GRID_SIZE/5, X_GRID_SIZE/5);
      ellipse(individual_c.x*X_GRID_SIZE+(X_GRID_SIZE/5)+(X_GRID_SIZE/5/2)+eye_diff, individual_c.y*Y_GRID_SIZE+(Y_GRID_SIZE/5/2), X_GRID_SIZE/5, X_GRID_SIZE/5);
    } else if (gene[gene_frame] == RIGHT_N) {
      noStroke();
      fill(0, 0, 99);
      ellipse(individual_c.x*X_GRID_SIZE+X_GRID_SIZE-(X_GRID_SIZE/3/2)-eye_diff, individual_c.y*Y_GRID_SIZE+Y_GRID_SIZE/2, X_GRID_SIZE/3, X_GRID_SIZE/3);
      ellipse(individual_c.x*X_GRID_SIZE+X_GRID_SIZE-(X_GRID_SIZE/3/2), individual_c.y*Y_GRID_SIZE+Y_GRID_SIZE/2, X_GRID_SIZE/3, X_GRID_SIZE/3);
      noStroke();
      fill(0, 0, 0);
      ellipse(individual_c.x*X_GRID_SIZE+X_GRID_SIZE-(X_GRID_SIZE/5/2)-eye_diff, individual_c.y*Y_GRID_SIZE+Y_GRID_SIZE/2, X_GRID_SIZE/5, X_GRID_SIZE/5);
      ellipse(individual_c.x*X_GRID_SIZE+X_GRID_SIZE-(X_GRID_SIZE/5/2), individual_c.y*Y_GRID_SIZE+Y_GRID_SIZE/2, X_GRID_SIZE/5, X_GRID_SIZE/5);
    } else if (gene[gene_frame] == DOWN_N) {
      noStroke();
      fill(0, 0, 99);
      ellipse(individual_c.x*X_GRID_SIZE+(X_GRID_SIZE/3), individual_c.y*Y_GRID_SIZE+Y_GRID_SIZE-(Y_GRID_SIZE/3/2), X_GRID_SIZE/3, X_GRID_SIZE/3);
      ellipse(individual_c.x*X_GRID_SIZE+(X_GRID_SIZE/3)+eye_diff, individual_c.y*Y_GRID_SIZE+Y_GRID_SIZE-(Y_GRID_SIZE/3/2), X_GRID_SIZE/3, X_GRID_SIZE/3);
      noStroke();
      fill(0, 0, 0);
      ellipse(individual_c.x*X_GRID_SIZE+(X_GRID_SIZE/5)+(X_GRID_SIZE/5/2), individual_c.y*Y_GRID_SIZE+Y_GRID_SIZE-(Y_GRID_SIZE/5/2), X_GRID_SIZE/5, X_GRID_SIZE/5);
      ellipse(individual_c.x*X_GRID_SIZE+(X_GRID_SIZE/5)+(X_GRID_SIZE/5/2)+eye_diff, individual_c.y*Y_GRID_SIZE+Y_GRID_SIZE-(Y_GRID_SIZE/5/2), X_GRID_SIZE/5, X_GRID_SIZE/5);
    } else if (gene[gene_frame] == LEFT_N) {
      noStroke();
      fill(0, 0, 99);
      ellipse(individual_c.x*X_GRID_SIZE+(X_GRID_SIZE/3/2), individual_c.y*Y_GRID_SIZE+Y_GRID_SIZE/2, X_GRID_SIZE/3, X_GRID_SIZE/3);
      ellipse(individual_c.x*X_GRID_SIZE+(X_GRID_SIZE/3/2)+eye_diff, individual_c.y*Y_GRID_SIZE+Y_GRID_SIZE/2, X_GRID_SIZE/3, X_GRID_SIZE/3);
      noStroke();
      fill(0, 0, 0);
      ellipse(individual_c.x*X_GRID_SIZE+(X_GRID_SIZE/5/2), individual_c.y*Y_GRID_SIZE+Y_GRID_SIZE/2, X_GRID_SIZE/5, X_GRID_SIZE/5);
      ellipse(individual_c.x*X_GRID_SIZE+(X_GRID_SIZE/5/2)+eye_diff, individual_c.y*Y_GRID_SIZE+Y_GRID_SIZE/2, X_GRID_SIZE/5, X_GRID_SIZE/5);
    }
  }
  
}
