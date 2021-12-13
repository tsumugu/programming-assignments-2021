class Countdown {
  constructor(arg_countdownTextElm, arg_countdownStatusElm, arg_restSec) {
    this.countdownTextElm = arg_countdownTextElm;
    this.arg_countdownStatusElm = arg_countdownStatusElm;
    this.defaultRestSec = arg_restSec;
    this.intervalId = null;
    this.isStartingCountdown = false;
    this.isPausing = false;
    // 残り時間を設定
    this.restSec = arg_restSec;
    this.setSec(this.restSec)
  }
  startCountdown(callback) {
    if (!this.isStartingCountdown) {
      this.intervalId = setInterval(()=>{
        this.setSec(this.restSec);
        if (this.restSec<=0) {
          this.isStartingCountdown = false;
          clearInterval(this.intervalId);
          callback();
        }
        if (!this.isPausing) {
          this.restSec-=1;
        }
      }, 1000);
      this.isStartingCountdown = true;
    }
  }
  setSec(sec) {
    this.countdownTextElm.innerHTML = sec;
  }
  resetSec() {
    this.restSec  = this.defaultRestSec
    this.setSec(this.restSec)
  }
  getIsStartingCountdown() {
    return this.isStartingCountdown;
  }
  pause() {
    this.isPausing = true;
    this.arg_countdownStatusElm.innerHTML = "【一時停止中】";
  }
  resume() {
    this.isPausing = false;
    this.arg_countdownStatusElm.innerHTML = "";
  }
}