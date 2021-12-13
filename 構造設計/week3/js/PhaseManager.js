class PhaseManager {
  constructor () {
    // 1フェーズあたりの秒数 (この場合は10秒耐えられたら次の画像に移る)
    this.SecPerPhase = 10;
    this.currentSec = 0;
    this.currentPhaseNum = 0;
    this.previousPhaseNum = 0;
    this.isPause = false;
    this.intervalId = null;
  }
  // カウントアップ
  startCountUp() {
    // 毎秒実行する
    this.intervalId = setInterval(()=>{
      if (!this.isPause) {
        this.previousPhaseNum = this.currentPhaseNum;
        // 秒数に応じてフェーズを書き換えていく
        if (this.currentSec%10===0) {
          this.currentPhaseNum+=1;
        }
        this.currentSec+=1;
      }
    }, 1000);
  }
  getPhaseNum() {
    return this.currentPhaseNum;
  }
  getPrevPhaseNum() {
    return this.previousPhaseNum;
  }
  getCurrentSec() {
    return this.currentSec;
  }
  getIsPause() {
    return this.isPause;
  }
  isExistIntervalId() {
    return this.intervalId!=null;
  }
  pause() {
    this.isPause = true;
  }
  resume() {
    this.isPause = false;
  }
  reset() {
    if (this.intervalId!=null) {
      clearTimeout(this.intervalId);
    }
    this.currentSec = 0;
    this.currentPhaseNum = 0;
    this.previousPhaseNum = 0;
    this.isPause = false;
    this.intervalId = null;
  }
}