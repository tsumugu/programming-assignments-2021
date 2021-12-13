class Result {
  constructor(arg_resultWrapperElm, arg_resultScoreElm, arg_resultOKButton) {
    this.resultWrapperElm = arg_resultWrapperElm;
    this.resultScoreElm = arg_resultScoreElm;
    this.resultOKButton = arg_resultOKButton;
    this.isShowingResultWindow = false;
  }
  dispResult(score, callback) {
    // スコアウインドウを表示する
    this.resultWrapperElm.classList.remove("resultWrapperFadeIn", "resultWrapperFadeOut");
    this.resultWrapperElm.classList.add("resultWrapperFadeIn");
    this.isShowingResultWindow = true;
    // スコアを書き換える
    this.resultScoreElm.innerHTML = score;
    // OKボタンが押されたとき
    this.resultOKButton.addEventListener("click", ()=>{
      // スコアウインドウを閉じる
      this.resultWrapperElm.classList.remove("resultWrapperFadeIn", "resultWrapperFadeOut");
      this.resultWrapperElm.classList.add("resultWrapperFadeOut");
      this.isShowingResultWindow = false;
      // callback
      callback();
    });
  }
  getIsShowingResultWindow() {
    return this.isShowingResultWindow;
  }
}