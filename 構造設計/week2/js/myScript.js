window.onload = function () {
  var moguraArray = [];
  let markers = document.querySelectorAll('a-nft');
  let infoTextElm = document.getElementById("info-text-wrapper");
  let dispCountdownElm = document.getElementById("disp-countdown-elm");
  let dispCountdownStatusElm = document.getElementById("disp-countdown-status-elm");
  let dispScoreElm = document.getElementById("disp-score-elm");
  let resultWrapperElm = document.getElementById("result-wrapper");
  let resultScoreElm = document.getElementById("result-score-elm");
  let resultOKButton = document.getElementById("result-ok-button");
  let scoreManager = new Score(infoTextElm);
  let countdownManager = new Countdown(dispCountdownElm, dispCountdownStatusElm, 30);
  let resultManager = new Result(resultWrapperElm, resultScoreElm, resultOKButton);
  // スコアを書き換える
  setInterval(()=>{
    dispScoreElm.innerHTML = scoreManager.getScore();
  }, 100);
  // markerを全件取得(いまのところひとつだけ)
  markers.forEach((marker, index)=>{
    // マーカーが検出されたときの処理を設定
    marker.addEventListener("markerFound", (e)=>{ 
      let aEntity = e.target.children[0];
      let aEntityObj3D = aEntity.object3D;
      // 毎回Moguraを生成すると非効率なので、moguraArrayにインスタンスを保存しておく
      if (moguraArray[index] == undefined) {
        moguraArray[index] = new Mogura(aEntityObj3D, scoreManager);
      }
      // 出たり引っ込んだりのアニメーションを開始 (リザルト画面が表示されていたときは開始しない)
      if (!resultManager.getIsShowingResultWindow()) {
        moguraArray[index].startAnim();
      }
      // カウントダウンが既に始まっているかを取得
      if (countdownManager.getIsStartingCountdown()) {
        // もし既にカウントダウンが始まっていたら再開
        countdownManager.resume();
      } else {
        // もしカウントダウンが始まっていなかったら新しく開始する
        countdownManager.startCountdown(()=>{
          // リザルトを表示する
          resultManager.dispResult(scoreManager.getScore(), ()=>{
            // リザルト画面が閉じられたとき、カウントダウンとスコアをリセットする
            countdownManager.resetSec();
            scoreManager.resetScore();
          });
        });
      }
    });
    // マーカーが検出されなくなったときの処理を設定
    marker.addEventListener("markerLost", (e)=>{ 
      // カウントダウンが既に始まっているかを取得
      if (countdownManager.getIsStartingCountdown()) {
        // もし既にカウントダウンが始まっていたら一時停止
        countdownManager.pause();
      }
      if (moguraArray[index] != undefined) {
        // もし飛び出ている状態でロストした場合は叩かれたとみなして、スコア加算処理を実行
        if (moguraArray[index].getIsExp()) {
          moguraArray[index].hit();
        }
        // アニメーションを停止する
        moguraArray[index].stopAnim();
      }
    });
  });
};