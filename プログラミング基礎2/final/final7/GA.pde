import java.util.Random;

// 遺伝的アルゴリズムに関するクラス
class GA {
  
  // スコアでソートする
  ArrayList<Individual> sortIndividualsByScore(ArrayList<Individual> arg_indivisuals, boolean is_reverse) { 
    String[] score_list = new String[arg_indivisuals.size()];
    for (int i=0; i<arg_indivisuals.size(); i++) {
      Individual individual = arg_indivisuals.get(i);
      score_list[i] = individual.gene_score+"/"+i;
    }
    String[] reversed_score_list;
    if (is_reverse) {
      reversed_score_list = reverse(sort(score_list));
    } else {
      reversed_score_list = sort(score_list); // 降順に
    }
    ArrayList<Individual> res_indivisuals = new ArrayList<Individual>();
    for (int i=0; i<reversed_score_list.length; i++) {
      String[] splited = reversed_score_list[i].split("/");
      Individual individual = arg_indivisuals.get(int(splited[1]));
      res_indivisuals.add(individual);
    }
    return res_indivisuals;
  }
  
  // 交叉する
  ArrayList<Individual> crossover(int individual_count, int[] arg_gene1, int[] arg_gene2) {
     // 個体を生成
    ArrayList<Individual> new_individials_crossover = new ArrayList<Individual>();
    int gene_length = arg_gene1.length;
    for (int i=0; i<individual_count; i++) {
      // 2点交叉を使う
      // 参考: https://phithon.hatenablog.jp/entry/20101015/1287127959
      Random rand = new Random();
      int less = rand.nextInt(gene_length-1) + 1;
      int more = rand.nextInt(gene_length-2) + 1;
      if (more < less) {
        int tmp = less;
        less = more;
        more = tmp;
      } else {
        ++more;
      }
      
      int[] new_gene = new int[gene_length];
      for (int j=0; j<less; j++) {
        new_gene[j] = arg_gene1[j];
      }
      for (int k=less; k<more; k++) {
        new_gene[k] = arg_gene2[k];
      }
      for (int l=more; l<gene_length; l++) {
        new_gene[l] = arg_gene1[l];
      }
      // 個体を生成
      Individual individual = new Individual();
      individual.setGene(new_gene);
      new_individials_crossover.add(individual);
    }
    return new_individials_crossover;
  }
    
  // 突然変異
  ArrayList<Individual> mutation(ArrayList<Individual> individuals) {
    ArrayList<Individual> new_individuals = new ArrayList<Individual>();
    for (int i=0; i<individuals.size(); i++) {
      Individual individual = individuals.get(i);
      // 全個体を突然変異させるのはやりすぎなので確率
      int random1 = round(random(10));
      int random2 = round(random(10));
      if (random1 == random2) {
        int[] gene = individual.gene;
        // 挿入
        for (int j=0; j<10; j++) {
          gene[floor(random(gene.length))] = round(random(0, 3));
        }
        individual.setGene(gene);
      }
      new_individuals.add(individual);
    }
    return new_individuals;
  }
  
}
