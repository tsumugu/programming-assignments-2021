// 遺伝子の生成に関するクラス
class GeneGenerator {
  
  int WALL_N = 0, PATH_N = 1, START_N = 2, GOAL_N = 3,
      UP_N = 0, RIGHT_N = 1, DOWN_N = 2, LEFT_N = 3,
      X_COUNT=20, Y_COUNT=20,
      X_GRID_SIZE=30, Y_GRID_SIZE=30;
      
  // 壁にぶつからないようにしつつ、ランダムに遺伝子を生成
  int[] generate() {
    int[] gene = new int[search_maze.gene.length];
    MazeCell test_individual_c = new MazeCell(1, 1);
    MazeCell goal_c = new MazeCell(X_COUNT-2, Y_COUNT-2);
    for (int i=0; i<search_maze.gene.length; i++) {
      // 今いる場所からどの方向に動くことができるか
      ArrayList<Integer> can_move_dir = new ArrayList<Integer>();
      //ArrayList<Float> can_move_dist = new ArrayList<Float>();
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
        if (maze.maze_list[around_test_individual_c.x][around_test_individual_c.y] != WALL_N) {
          can_move_dir.add(dir);
          //can_move_dist.add(dist(goal_c.x, goal_c.y, around_test_individual_c.x, around_test_individual_c.y));
        }
      }
      int move_dir = can_move_dir.get(floor(random(0, can_move_dir.size())));
      /*
      float[][] sorted_can_move_list = new float[can_move_dir.size()][2];
      for (int j=0; j<sorted_can_move_list.length; j++) {
        float[] tmp = new float[2];
        tmp[0] = can_move_dist.get(j);
        tmp[1] = can_move_dir.get(j);
        sorted_can_move_list[j] = tmp;
      }
      println("------");
      for (int j=0; j<sorted_can_move_list.length; j++) {
        println(j, sorted_can_move_list[j][0], sorted_can_move_list[j][1]);
      }
      println(getRandomIndexWithWeight(sorted_can_move_list));
      println("------");
      int move_dir = getRandomIndexWithWeight(sorted_can_move_list);
      */
      gene[i] = move_dir;
      moveIndividual(test_individual_c, move_dir);
    }
    return gene;
  }
  
  //int getRandomIndexWithWeight(float[][] sorted_can_move_list) {
  //  float sum = 0.0;
  //  for (int i=0; i<sorted_can_move_list.length; i++) {
  //    sum += sorted_can_move_list[i][0];
  //  }
  //  float random = random(1.0, sum);
  //  for (int i=0; i<sorted_can_move_list.length; i++) {
  //    sum -= sorted_can_move_list[i][0];
  //    if (sum < random) {
  //      return i;
  //    }
  //  }
  //  return 0;
  //}
  
  // 完全にランダムに遺伝子を生成
  int[] generateRandom() {
    int[] gene = new int[search_maze.gene.length];
    for (int i=0; i<search_maze.gene.length; i++) {
      gene[i] = round(random(0, 3));
    }
    return gene;
  }
  
  // 個体を動かす
  boolean moveIndividual(MazeCell c, int dir) {
    if (dir==UP_N) {
      if (maze.maze_list[c.x][c.y-1] != WALL_N) {
        c.y -= 1;
        return true;
      }
    } else if (dir==RIGHT_N) {
      if (maze.maze_list[c.x+1][c.y] != WALL_N) {
        c.x += 1;
        return true;
      }
    } else if (dir==DOWN_N) {
      if (maze.maze_list[c.x][c.y+1] != WALL_N) {
        c.y += 1;
        return true;
      }
    } else if (dir==LEFT_N) {
      if (maze.maze_list[c.x-1][c.y] != WALL_N) {
        c.x -= 1;
        return true;
      }
    }
    return false;
  }
  
}
