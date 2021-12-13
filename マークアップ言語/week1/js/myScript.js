class Main extends Phaser.Scene {
  constructor() {
    super();
  }
  preload() {
    this.load.image("bg2", "asset/bg2.png");
    this.load.image("KameBefore", "asset/KameBefore-kage.png");
    this.load.image("KameAfter", "asset/KameAfter-kage.png");
    this.load.image("EsaBefore", "asset/EsaBefore.png");
    this.load.image("EsaAfter", "asset/EsaAfter.png");
  }
  create() {
    this.add.image(400, 300, 'bg2');

    let imgA = this.add.image(200, 400, 'KameBefore').setInteractive();
    let imgAdash = this.add.image(200, 400, 'KameAfter');
    imgAdash.visible = false;
    imgAdash.scale = 1;

    let imgB = this.add.image(600, 450, 'EsaBefore').setInteractive();
    let imgBdash = this.add.image(600, 450, 'EsaAfter');
    imgBdash.visible = false;
    imgBdash.scale = 1;

    imgA.on("pointerdown", function (pointer) {
      imgA.alpha = 0;
      imgAdash.visible = true;
    });

    imgB.on("pointerdown", function (pointer) {
      imgB.alpha = 0;
      imgBdash.visible = true;
    });

    this.input.on("pointerup", function (pointer) {
      imgA.alpha = 1;
      imgAdash.visible = false;
      imgB.alpha = 1;
      imgBdash.visible = false;
    });
  }
}
let config = {
  type: Phaser.AUTO,
  parent: 'phaser-example',
  width: 800,
  height: 600,
  backgroundColor: 0x000000,
  pixelArt: true,
  scale: {
    mode: Phaser.Scale.FIT,
    auoCenter: Phaser.Scale.CENTER_BOTH
  },
  scene: [Main]
};
let game = new Phaser.Game(config);