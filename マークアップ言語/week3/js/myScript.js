class Parallax extends Phaser.Scene {
  constructor() {
    super();
  }
  preload() {
    this.load.image('rocket1', 'asset/rocket1.png');
    this.load.image('rocket2', 'asset/rocket2.png');
    this.load.image('rocket3', 'asset/rocket3.png');
    this.load.image('sky1', 'asset/sky1.png');
    this.load.image('sky2', 'asset/sky2.png');
    this.load.image('sky3', 'asset/sky3.png');
    this.load.image('space', 'asset/space.png');
    this.load.spritesheet('player', 'asset/spritesheet.png', {
      frameWidth: 200,
      frameHeight: 200
    });
  }
  create() {
    
    this.cursors = this.input.keyboard.createCursorKeys();
    this.cameras.main.setBounds(0, 0, 2000, 600);
    const width = this.scale.width;
    const height = this.scale.height;

    // Img:　宇宙のような深い青&星
    this.add.sprite(width*0.5, height*0.5, 'space').setScrollFactor(0);

    // Img:　鮮やかめの空の青
    this.add.sprite(0, height, 'sky1').setOrigin(0, 1).setScrollFactor(2);
    // Img:　雲を描く
    this.add.sprite(800, height, 'sky2').setOrigin(0, 1).setScrollFactor(2);
    // Img:　鮮やかめの空の青
    this.add.sprite(1600, height, 'sky3').setOrigin(0, 1).setScrollFactor(2);

    // Img: ロケット本体
    this.add.sprite(0, height, 'rocket1').setOrigin(0, 1).setScrollFactor(3.5);
    // Img: ロケットの煙
    this.add.sprite(800, height, 'rocket2').setOrigin(0, 1).setScrollFactor(3.5);
     // Img: ロケットの煙
    this.add.sprite(1600, height, 'rocket3').setOrigin(0, 1).setScrollFactor(3.5);

    // Help: https://photonstorm.github.io/phaser3-docs/Phaser.Types.GameObjects.Text.html#.TextStyle
    this.add.text(400, 32, "Press ← → Key", {
      color: '#000000',
      fontSize: 32
    }).setOrigin(0.5, 0);

    //this.add.sprite(0, height, 'layer3').setOrigin(0, 1).setScrollFactor(0.45);
    //this.add.sprite(800, height, 'layer3').setOrigin(0, 1).setScrollFactor(0.45);
    //this.add.sprite(1600, height, 'layer3').setOrigin(0, 1).setScrollFactor(0.45);
    //
    this.player = this.add.sprite(1800, 400, 'player');
    this.anims.create({
      key: 'turn',
      frames: this.anims.generateFrameNumbers('player', {
        start: 3,
        end: 4
      }),
      frameRate: 4,
      repeat: -1
    });
    this.anims.create({
      key: 'up',
      frames: this.anims.generateFrameNumbers('player', {
        start: 0,
        end: 1
      }),
      frameRate: 2,
      repeat: -1
    });
    this.anims.create({
      key: 'down',
      frames: this.anims.generateFrameNumbers('player', {
        start: 0,
        end: 1
      }),
      frameRate: 2,
      repeat: -1
    });
    this.anims.create({
      key: 'right',
      frames: this.anims.generateFrameNumbers('player', {
        start: 2,
        end: 3
      }),
      frameRate: 2,
      repeat: -1
    });
    this.anims.create({
      key: 'left',
      frames: this.anims.generateFrameNumbers('player', {
        start: 4,
        end: 5
      }),
      frameRate: 2,
      repeat: -1
    });
    this.anims.create({
      key: 'wait',
      frames: this.anims.generateFrameNumbers('player', {
        start: 6,
        end: 6
      }),
      frameRate: 1,
      repeat: -1
    });
    //
  }
  update() {
    if (this.cameras.main.scrollX<1200) {
      // ロケットに関する操作
      if (this.cursors.left.isDown) {
        this.cameras.main.scrollX += 5;
      } else  if (this.cursors.right.isDown) {
        this.cameras.main.scrollX -= 5;
      }
    } else {
      // 宇宙飛行士に関する操作
      if (this.cursors.right.isDown) {
        this.player.anims.play('right', true);
        this.player.x += 5;
        //this.player.setVelocityX(200);
      } else if (this.cursors.left.isDown) {
        this.player.anims.play('left', true);
        this.player.x -= 5;
        //this.player.setVelocityX(-200);
      } else if (this.cursors.up.isDown) {
        this.player.anims.play('up', true);
        this.player.y -= 5;
      } else if (this.cursors.down.isDown) {
        this.player.anims.play('down', true);
        this.player.y += 5;
        //this.player.setVelocityY(-400);
      } else {
        this.player.anims.play('wait', true);
      }
    }
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
    autoCenter: Phaser.Scale.CENTER_BOTH
  },
  physics: {
    default: 'arcade',
    arcade: {
      gravity: {
        y: 300
      },
      debug: false
    }
  },
  scene: [Parallax]
};
let game = new Phaser.Game(config);