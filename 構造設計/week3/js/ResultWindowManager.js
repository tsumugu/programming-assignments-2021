class ResultWindowManager {
  constructor (arg_resultWrapper, arg_futatsunaElm, arg_descriptionElm, arg_okButtonElm) {
    this.resultWrapper = arg_resultWrapper;
    this.futatsunaElm = arg_futatsunaElm;
    this.descriptionElm = arg_descriptionElm;
    this.okButtonElm = arg_okButtonElm;
  }
  showResultWindow(phase, sec, callback) {
    // innerHTMLを書き換え
    if (phase<=1) {
      this.futatsunaElm.innerHTML = "笑顔の絶えない人";
      this.descriptionElm.innerHTML = phase+"ラウンド目の残り"+sec+"秒で笑ってしまった";
    } else if (phase==2) {
      this.futatsunaElm.innerHTML = "普通の人";
      this.descriptionElm.innerHTML = phase+"ラウンド目の残り"+sec+"秒で笑ってしまった";
    } else if (phase>=3) {
      this.futatsunaElm.innerHTML = "表情筋マスター";
      this.descriptionElm.innerHTML = "最後まで耐えきった";
    }
    // 表示
    this.resultWrapper.classList.remove("fadeinandzoom", "fadeoutandzoom");
    this.resultWrapper.classList.add("fadeinandzoom");
    // OKボタンを押したときの処理
    this.okButtonElm.addEventListener("click", ()=>{
      // 閉じる
      this.resultWrapper.classList.remove("fadeinandzoom", "fadeoutandzoom");
      this.resultWrapper.classList.add("fadeoutandzoom");
      // callback
      callback();
    });
  }
}