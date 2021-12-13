class Score {
  constructor(arg_infoTextElm) {
    this.infoTextElm = arg_infoTextElm;
    this.score = 0;
  }
  plusScore(num) {
    this.score += num;
    this.infoTextElm.innerHTML = "<p class=\"info-text-hit\">Hit!</p>";
  }
  minusScore(num) {
    this.score -= num;
    this.infoTextElm.innerHTML = "<p class=\"info-text-miss\">MISS</p>";
  }
  getScore() {
    return this.score;
  }
  resetScore() {
    this.score = 0;
  }
}