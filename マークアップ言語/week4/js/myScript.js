class Main extends Phaser.Scene {
  constructor() {
    super();
  }
  preload() {
    for (let i=0;i<=13;i++) {
      this.load.audio('note'+i, 'asset/'+i+'.mp3');
      //this.load.audio('note'+i, 'asset/'+i+'.wav');
    }
  }
  create() {
    var input = "";
    let labels = ["ド", "レ", "ミ", "ファ", "ソ", "ラ", "シ", "高いド", "高いレ", "高いミ", "高いファ", "高いソ", "高いラ", "高いシ"];
    let roman = ["do", "re", "mi", "fa", "so", "ra", "si", "ddo", "rre", "mmi", "ffa", "sso", "rra", "ssi"];
    var inputText = undefined;

    // 音とテキストそれぞれを配列に格納していく
    var note = [];
    var text = [];
    for (let i=0;i<=13;i++) {
      // 音
      note.push(this.sound.add('note'+i));

      // テキスト
      var tmpText = this.add.text(180, 120, labels[i], {
        font: '100px',
        color: '#ffffff'
      });
      tmpText.alpha = 0;
      text.push(tmpText);
    }

    // 8-13までの数字を1-7までの範囲にする関数
    function getIndexLimit7(num) {
      // 1-7のときそのまま返す
      if (num <= 7) {
        return num;
      }
      // 8-13のとき、1-7にする
      return num-7;
    }

    // 音を再生&テキストを表示処理
    function playSound(noteName, index) {
      // 本当は重ねたいけど、謎のノイズが出たので前に流れている音を止める
      for (let i=0;i<=13;i++) {
        text[i].alpha = 0;
        note[i].stop();
      }
      // テキスト表示
      var tmpText = text[index];
      // テキストのxの位置を音階に応じてずらしていく(index)
      var indexLimit7 = getIndexLimit7(index);
      tmpText.x = indexLimit7*100;
      // テキストのyはランダム
      tmpText.y = Math.floor(Math.random()*100);
      //
      tmpText.alpha = 0.8;
      // 新たに音を再生
      note[index].play();
      // 音が再生終了したとき、テキストを消す
      note[index].on('complete', function (event) {
        tmpText.alpha = 0;
      });
    }    

    // ローマ字入力から音階名にする
    this.input.keyboard.on('keydown', function (event) {
      var keyName = event.key;
      if (keyName == " " || keyName == "Backspace") {
        input = "";
      } else {
        // 入力されるごとにinputに足していく
        input += keyName;
        //
        // ローマ字配列(roman)の中から、inputに一致しているものがないか探す。
        var index = roman.indexOf(input);
        if (index > -1) {
          // 一致しているものがあったらその音を再生
          playSound(roman[index], index);
          // inputは初期化
          input = "";
        }
      }
      // inputの中身をテキストで表示
      if (inputText != undefined) {
        inputText.destroy();
      }
      inputText = this.add.text(0, 0, input, {
        color: '#ffffff',
        fontSize: '64px'
      })
      inputText.alpha = 0.5;
      //
    }, this);
  }
}

let config = {
  type: Phaser.AUTO,
  parent: 'phaser-example',
  width: window.innerWidth,
  height: window.innerHeight,
  backgroundColor: 0xffc8cd,
  pixelArt: true,
  scale: {
    mode: Phaser.Scale.FIT,
    autoCenter: Phaser.Scale.CENTER_BOTH
  },
  scene: [Main]
};

let game = new Phaser.Game(config);