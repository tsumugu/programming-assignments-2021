class Mogura {
  constructor(arg_aEntityObj3D, arg_scoreManager) {
    this.aEntityObj3D = arg_aEntityObj3D;
    this.scoreManager = arg_scoreManager;
    this.isExp = false;
    this.isFin = false;
    this.intervalId = null;
    this.beforeIntervalId = null;
  }
  // public
  startAnim() {
    // ランダムな秒数ごとに拡大/縮小を切り替える
    let callback = ()=>{
      if (this.isExp && !this.isFin) {
        this.scoreManager.minusScore(1);
      }
      this.isExp = !this.isExp;
      if (!this.isFin) {
        this.randomDoCallback(callback);
      }
    } 
    this.isFin = false;
    this.randomDoCallback(callback);
    // 100msごとにframe()を実行
    this.intervalId = setInterval(()=>{
      this.frame(this.aEntityObj3D, this.isExp);
    }, 100);
  }
  stopAnim() {
    this.isFin = true;
    if (this.intervalId != null) {
      clearTimeout(this.intervalId);
    }
  }
  hit() {
    this.scoreManager.plusScore(1);
  }
  getIsExp() {
    return this.isExp;
  }
  // private
  randRange(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
  }
  randomDoCallback(callback) {
    if (this.beforeIntervalId!=null) {
      clearTimeout(this.beforeIntervalId);
    }
    if (!this.isFin) {
      this.beforeIntervalId = setTimeout(callback, this.randRange(1000, 5000));
    }
  }
  frame(entity, isExp) {
    var scale = entity.scale.x;
    if (!isExp && scale>=0) {
      scale-=0.5;
    } else if (isExp && scale<=1.2) {
      scale+=0.1;
    }
    entity.scale.set(scale, scale, scale);
  }
}