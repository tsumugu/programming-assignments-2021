class DialogManager {
  constructor (arg_messageElm)  {
    this.messageElm = arg_messageElm;
    this.timeoutId = null;
  }
  showMessage(mes) {
    // 書き換える
    this.messageElm.innerHTML = mes;
    // fadeinする
    this.messageElm.classList.remove("fadein", "fadeout");
    this.messageElm.classList.add("fadein");
    // 1.5秒後にfadeoutを付与
    // ↓timerがスタートしていなければ
    if (this.timeoutId!=null) {
      this.timeoutId = setTimeout(()=>{
        this.messageElm.classList.add("fadeout");
        this.timeoutId = null;
      }, 1500);
    }
  }
  showPermanentMessage(mes) {
    // 書き換える
    this.messageElm.innerHTML = mes;
    // fadeinする
    this.messageElm.classList.remove("fadein", "fadeout");
    this.messageElm.classList.add("fadein");
  }
  dismiss() {
    this.messageElm.classList.add("fadeout");
  }
}