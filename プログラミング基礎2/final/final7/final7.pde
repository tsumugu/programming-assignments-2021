import garciadelcastillo.dashedlines.*;

color BG;
Maze maze;
SearchMaze search_maze;
GA ga;
GeneGenerator gene_generator;
ArrayList<Individual> good_individuals; // 評価の高い個体群
int X_COUNT=20, Y_COUNT=20, 
  X_GRID_SIZE=30, Y_GRID_SIZE=30, 
  INDIVIDUAL_COUNT = 50, // 1世代あたりの個体数 50
  gen_count = 0;
float best_score = 10000;
int[] best_gene = new int[0];
int old_sec = 0;
int passed_sec = 0;
int generation = 0;
float score = 0;
String score_diff_text = "";
color diff_status_text_color = color(0, 0, 50);
PFont kanjiFont;
PFont numberFont;
PFont arrowFont;
ArrayList<Float> score_graph;
DashedLines dash;

void settings() {
  size(600, 800);
}

void setup() {
  frameRate(30);
  colorMode(HSB, 360, 100, 100, 100);
  BG = color(0, 0, 0);
  background(BG);
  kanjiFont = loadFont("genshin-regular-32pt.vlw");
  numberFont = loadFont("Helvetica-48-number.vlw");
  arrowFont = loadFont("Helvetica-48-arrows.vlw");
  
  maze = new Maze();
  search_maze = new SearchMaze();
  ga = new GA();
  gene_generator = new GeneGenerator();
  dash = new DashedLines(this);
  
  good_individuals = new ArrayList<Individual>();
  score_graph = new ArrayList<Float>();
  
  init();
}

void init() {
  maze.initMaze(); // 迷路の生成
  search_maze.search(maze.maze_list, new MazeCell(1, 1), new MazeCell(X_COUNT-2, Y_COUNT-2)); // 迷路を探索する
  if (search_maze.route.size()<=0) { // ルートの数が0だったらときは再生成する
    init();
  }
  // 個体を生成する
  for (int i=0; i<INDIVIDUAL_COUNT; i++) {
    // 良い
    Individual good_individual = new Individual();
    good_individual.setGene(gene_generator.generateRandom()); // 遺伝子を生成する
    good_individuals.add(good_individual);
  }
}

void updateInfo(int arg_generation, float arg_score, String arg_score_diff_text, color arg_diff_status_text_color) {
  generation = arg_generation;
  score = arg_score;
  score_diff_text = arg_score_diff_text;
  diff_status_text_color = arg_diff_status_text_color;
  score_graph.add(arg_score);
}

void initNextIndividuals() {
  gen_count++;

  // 評価の高い個体群は評価を高くしていく
  // スコアでソートする
  ArrayList<Individual> sorted_good_indivisuals = ga.sortIndividualsByScore(good_individuals, false);
  ArrayList<Individual> new_good_individuals = new ArrayList<Individual>();
  // ベストスコアを保存する
  Individual best_individual = sorted_good_indivisuals.get(0);
  //print(gen_count, best_individual.gene_score, "");
  String diff_status = "";
  color diff_status_text_color = color(0, 0, 50);
  if (best_score < best_individual.gene_score) {
    // スコアが上がってしまった
    diff_status = "↑";
    diff_status_text_color = color(240, 99, 99);
    best_score = best_individual.gene_score;
    // このとき、ベストな個体を復元させてみる
    Individual individual = new Individual();
    individual.setGene(best_gene);
    new_good_individuals.add(individual);
  } else if (best_score == best_individual.gene_score) {
    // スコアは変わらなかった
    diff_status = "→";
  } else if (best_score > best_individual.gene_score) {
    // スコアが下がった！
    diff_status = "↓";
    diff_status_text_color = color(0, 99, 99);
    best_score = best_individual.gene_score;
    best_gene = best_individual.gene;
  }
  updateInfo(gen_count, best_individual.gene_score, diff_status, diff_status_text_color);
  // 交叉する
  // 最上位個体 - それ以外の1個体
  Individual good_individual1 = sorted_good_indivisuals.get(0);
  int[] good_gene1 = good_individual1.gene;
  int random2 = floor(random(1, sorted_good_indivisuals.size()-1));
  Individual good_individual2 = sorted_good_indivisuals.get(random2);
  int[] good_gene2 = good_individual2.gene;
  // 半分は交叉の結果、もう半分はランダム
  // まずは交叉の結果
  ArrayList crossovered_individuals = ga.crossover(INDIVIDUAL_COUNT, good_gene1, good_gene2);
  //crossovered_individuals = ga.sortIndividualsByScore(crossovered_individuals, false);
  int crossovered_individuals_size = crossovered_individuals.size();
  for (int i=0; i<crossovered_individuals_size/3*2; i++) {
    Individual ind = (Individual)crossovered_individuals.get(i);
    new_good_individuals.add(ind);
  }
  // もう半分のランダムのほう
  for (int i=crossovered_individuals_size/3*2; i<crossovered_individuals_size; i++) {
    Individual individual = new Individual();
    individual.setGene(gene_generator.generate());
    new_good_individuals.add(individual);
  }
  // 突然変異させる
  new_good_individuals = ga.mutation(new_good_individuals);

  good_individuals = new_good_individuals;
}

// 重みを考慮して抽選する関数
int getRandomIndex(ArrayList<Individual> arg_individuals) {
  float sum = 0;
  for (int i=0; i<arg_individuals.size(); i++) {
    sum += arg_individuals.get(i).gene_score;
  }
  float[] normalized_scores = new float[arg_individuals.size()];
  for (int i=0; i<normalized_scores.length; i++) {
    normalized_scores[i] = arg_individuals.get(i).gene_score / sum;
  }
  normalized_scores = reverse(normalized_scores);
  float random = random(1);
  float n_sum = 0;
  int index = 0;
  for (int i=0; i<normalized_scores.length; i++) {
    n_sum += normalized_scores[i];
    if (n_sum >= random) {
      break;
    }
    index++;
  }
  return index;
}

void draw() {
  int s = second();
  if (old_sec!=s) {
    passed_sec++;
    old_sec = s;
  }
  background(BG);
  maze.draw(); // 迷路を描画する
  search_maze.draw(); // ルートを描画する
  // 個体をそれぞれ処理する
  int good_individuals_count = good_individuals.size();
  int fin_count = 0;
  for (int i=0; i<good_individuals_count; i++) {
    Individual individual = good_individuals.get(i);
    individual.draw(); // 描画する
    // 遺伝子の端までたどり着いたらis_fin_onecicleがtrueになる
    if (individual.is_fin_onecicle) {
      fin_count++;
    }
    // すべて終わったら次の世代に進む
    if (fin_count==good_individuals_count) {
      initNextIndividuals();
    }
  }
  // グラフなどを描画する
  drawInfo();
}

// 秒を時:分:秒に変換する関数
String secToClock(int arg_sec) {
  int hour = arg_sec / 3600;
  int min = arg_sec % 3600 / 60;
  int sec = arg_sec % 60;
  return nf(hour, 2)+":"+nf(min, 2)+":"+nf(sec, 2);
}

void drawInfo() {
  textAlign(LEFT, TOP);
  // 世代について
  fill(0, 0, 99);
  textFont(numberFont);
  textSize(42);
  String gen_text = Integer.valueOf(generation).toString();
  text(gen_text, 10, 610);
  textFont(kanjiFont);
  textSize(24);
  text("世代", 12+(String.valueOf(gen_text).length()*24), 620);
  // ベストスコアについて
  textFont(kanjiFont);
  textSize(16);
  text("ベストスコア", 10, 620+33);
  textFont(numberFont);
  textSize(30);
  text(String.format("%.1f", score), 10, 620+52);
  fill(diff_status_text_color);
  textFont(arrowFont);
  textSize(18);
  text(score_diff_text, 76, 620+55+4);
  // 経過時間について
  fill(0, 0, 99);
  textFont(kanjiFont);
  textSize(16);
  text("経過時間", 10, 620+33+55);
  textFont(numberFont);
  textSize(30);
  text(secToClock(passed_sec), 10, 620+33+55+18);
  // グラフを描画する
  // ArrayListはソートしにくいなど面倒なので配列にする
  float[] scores = new float[score_graph.size()];
  for (int i=0; i<score_graph.size(); i++) {
    scores[i] = score_graph.get(i);
  }
  if (scores.length > 0) {
    // まずは左側の目盛りを描画する
    float highscore = reverse(sort(scores))[0];
    float step = 180.0 / highscore;
    noStroke();
    fill(0, 0, 99);
    float[] reversed_scores = reverse(scores);
    int list_length = reversed_scores.length;
    // 左側をどのくらい空けるか計算
    int gen_length = String.valueOf(gen_text).length();
    float base_x = 60+20+30+30;
    if (gen_length > 3) {
      base_x += (gen_length-2)*15;
    } else if (gen_length == 3) {
      base_x += 10;
    }
    noStroke();
    fill(0, 0, 99);
    textFont(numberFont);
    textSize(15);
    float per10 = highscore / 10.0;
    float now_score = highscore;
    while (now_score >= -1) {
      text(String.format("%.1f", now_score), base_x, 780-now_score*step);
      noFill();
      strokeWeight(1);
      stroke(0, 0, 55);
      dash.line(base_x+35, 780-now_score*step+6, 800, 780-now_score*step+6);
      now_score = ((float)round((now_score-per10)*10))/10;
    }
    // グラフを描画
    for (int i=0; i<list_length; i++) {
      fill(0, 0, 99);
      noStroke();
      ellipse(base_x+35+i*15, 780-reversed_scores[i]*step+6, 6, 6);
      if (i>0) {
        noFill();
        stroke(0, 0, 99);
        strokeWeight(2);
        line(base_x+35+(i-1)*15, 780-reversed_scores[i-1]*step+6, base_x+35+i*15, 780-reversed_scores[i]*step+6);
      }
      //fill(0, 0, 99);
      //textFont(numberFont);
      //textSize(10);
      //text(list_length-i+1, base_x+37+i*15, 790-reversed_scores[i]*step);
    }
  }
}
