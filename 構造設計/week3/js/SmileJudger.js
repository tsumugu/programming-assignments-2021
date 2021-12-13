class SmileJudger {
  constructor () {
    this.happyCount = 0;
    this.isDidCallback = false;
  }
  judgeIsHappy = (happyVal)=>{
    if (happyVal!=undefined) {
      // happyが0.3を超えていたら笑顔とみなす
      return happyVal>0.3;
    }
    return false;
  }
  doWhenSmiled(emotion, callback) {
    if (emotion != undefined && emotion[5] != undefined) {
      var isHappy = this.judgeIsHappy(emotion[5].value);
      // console.log(emotion[5].value, isHappy);
      if (isHappy) {
        if (this.happyCount>30 && !this.isDidCallback) {
          // 30f連続でhappyだったら笑ってしまったとみなしてCallbackを実行
          this.isDidCallback = true;
          this.happyCount = 0;
          callback();
        }
        this.happyCount++;
      } else {
        this.happyCount = 0;
      }
    }
  }
  reset() {
    this.isDidCallback = false;
    this.happyCount = 0;
  }
}