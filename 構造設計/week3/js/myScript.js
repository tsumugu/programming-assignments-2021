const resultWrapper = document.getElementById("result-wrapper");
const futatsunaElm = document.getElementById("result-futatsuna");
const descriptionElm = document.getElementById("result-description");
const okButtonElm = document.getElementById("result-okbutton");
const phaseElm = document.getElementById("phase");
const secElm = document.getElementById("sec");
const message = document.getElementById("message");
const video = document.getElementById("video");
const canvas = document.getElementById("canvas");
const context = canvas.getContext("2d");
console.log(document.documentElement.clientWidth);
const w = window.innerWidth;
const h = window.innerHeight;
video.setAttribute("width", w);
video.setAttribute("height", h);
video.setAttribute("autoplay", true);
canvas.setAttribute("width", w);
canvas.setAttribute("height", h);
navigator.mediaDevices.getUserMedia({
  audio: false,
  video: {
    width: w,
    height: h,
    facingMode: "user"
  }
})
.then((stream)=>{
  video.srcObject = stream;
})
.catch((err)=>{
  window.alert(err.name+": "+err.message);
});

const tracker = new clm.tracker();
tracker.init(pModel);
tracker.start(video);
// 感情識別も開始
var classifier = new emotionClassifier();
classifier.init(emotionModel);

const phaseManager = new PhaseManager();
const smileJudger = new SmileJudger();
const dialogManager = new DialogManager(message);
const resultWindowManager = new ResultWindowManager(resultWrapper, futatsunaElm, descriptionElm, okButtonElm);
const drawManager = new DrawManager(context);
drawLoop = ()=>{
  requestAnimationFrame(drawLoop);
  let facePoint = tracker.getCurrentPosition();
  context.clearRect(0, 0, canvas.width, canvas.height);
  // 顔がないときfacePointはfalseになる
  if (facePoint) {
    if (!phaseManager.isExistIntervalId()) {
      // intervalidがなかったら
      // スタート的なメッセージを出す
      dialogManager.dismiss();
      dialogManager.showMessage("スタート");
      // カウントを開始する
      phaseManager.startCountUp();
    } else {
      // intervalidが存在したら
      // ポーズ中メッセージを消す
      dialogManager.dismiss();
      // カウントを再開する
      phaseManager.resume();
    }
    let currentSec = phaseManager.getCurrentSec();
    let pvPhaseNum = phaseManager.getPrevPhaseNum();
    let crPhaseNum = phaseManager.getPhaseNum();
    // 秒数とフェーズを表示
    var restTime = 10*crPhaseNum-currentSec;
    var restPhase = crPhaseNum;
    secElm.innerHTML = restTime;
    phaseElm.innerHTML = restPhase;
    // フェーズが変わったとき
    if (pvPhaseNum!=crPhaseNum) {
      if (crPhaseNum==1) {
        // 0->1のときはなにも表示しない
      } else if (crPhaseNum==3) {
        dialogManager.showMessage("最終ラウンド！");
      } else if (crPhaseNum==4) {
        // リザルト画面に遷移
        phaseManager.pause();
        resultWindowManager.showResultWindow(restPhase, restTime, ()=>{
          smileJudger.reset();
          phaseManager.reset();
          drawManager.reset();
        });
      } else {
        dialogManager.showMessage("難易度アップ");
      }
    }
    // いろいろなパーツを表示
    drawManager.draw(crPhaseNum, facePoint);
    // 感情を識別
    var parameters = tracker.getCurrentParameters();
    var emotion = classifier.meanPredict(parameters);
    if (!phaseManager.getIsPause()) {
      smileJudger.doWhenSmiled(emotion, ()=>{
        // もし笑ってしまったら、リザルト画面に遷移
        phaseManager.pause();
        resultWindowManager.showResultWindow(restPhase, restTime, ()=>{
          smileJudger.reset();
          phaseManager.reset();
        });
      });
    }
  } else {
    // 顔が見つからなかったとき
    // メッセージを表示
    if (!phaseManager.isExistIntervalId()) {
      dialogManager.showPermanentMessage("笑わないように耐えろ<p style=\"margin:0;padding:0;font-size: 1.5rem;\">顔を検出したらスタート</p>");
    } else {
      // 角度によって出たり消えたりするのがうっとうしいのでなくす。
      // dialogManager.showPermanentMessage("一時停止中");
    }
    // カウントを一時停止する
    phaseManager.pause();
  }
}
drawLoop();