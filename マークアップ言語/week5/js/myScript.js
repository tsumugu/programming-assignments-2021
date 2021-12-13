class Main extends Phaser.Scene {
  constructor() {
    super();
  }
  preload() {
    this.load.spritesheet('player', 'asset/spritesheet_hito.png', {
      frameWidth: 200,
      frameHeight: 200
    });
    this.load.spritesheet('spritesheet_harinezumi', 'asset/spritesheet_harinezumi.png', {
      frameWidth: 200,
      frameHeight: 200
    });
    this.load.image('layer3', 'asset/layer3.png');
    this.load.image("bg", "asset/bg.png");
  }
  create() {
    this.timeCount = 0;
    const startTime = Date.now();

    this.anims.create({
      key: 'right_jump_player',
      frames: this.anims.generateFrameNumbers('player', {
        start: 8,
        end: 9
      }),
      frameRate: 2,
      repeat: -1
    });
    this.anims.create({
      key: 'right_stay_player',
      frames: this.anims.generateFrameNumbers('player', {
        start: 5,
        end: 5
      }),
      frameRate: 1,
      repeat: -1
    });
    this.anims.create({
      key: 'left_harinezumi',
      frames: this.anims.generateFrameNumbers('spritesheet_harinezumi', {
        start: 0,
        end: 1
      }),
      frameRate: 2,
      repeat: -1
    });
    this.anims.create({
      key: 'right_harinezumi',
      frames: this.anims.generateFrameNumbers('spritesheet_harinezumi', {
        start: 2,
        end: 3
      }),
      frameRate: 2,
      repeat: -1
    });

    this.add.image(400, 300, 'bg');
    const width = this.scale.width;
    const height = this.scale.height;
    this.ground = this.physics.add.staticSprite(400, height-32, 'layer3');
    this.score = new Number();
    this.scoreText = this.add.text(16, 16, 'score:'+Number(0), {
      fontSize: '32px',
      fill: '#000'
    });
    this.add.text(400, 32, "Press Space to Jump", {
      color: '#ffffff'
    }).setOrigin(0.5, 0);

    this.cursors = this.input.keyboard.createCursorKeys();
    this.player = this.physics.add.sprite(width/2, 0, 'player');
    this.player.setSize(10, 200, 1, 1);
    this.player.scale = 1.8;
    this.player.setBounce(0);
    this.player.setCollideWorldBounds(true);
    this.physics.add.collider(this.player, this.ground);

    this.harinezumis = []
    let genHarinezumi = ()=>{
      var harinezumi = this.physics.add.sprite(800, 300, 'spritesheet_harinezumi');
      harinezumi.setSize(200, 140, 1, 1);
      harinezumi.scale = 0.8;
      harinezumi.setBounce(0.8);
      harinezumi.setCollideWorldBounds(false);
      this.physics.add.collider(this.player, harinezumi);
      this.physics.add.collider(harinezumi, this.ground);
      this.harinezumis.push(harinezumi);
    };
    function getRandomNum(min=0, max=100) {
      return Math.floor( Math.random() * (max + 1 - min) ) + min
    }
    function getIntervalWithPhase() {
      var spendsec = (Date.now()-startTime)/1000;
      var intervalms = (5000/spendsec)*20
      if (intervalms>10000) {
        intervalms = 10000;
      }
      return getRandomNum(intervalms, intervalms+1000)
    }
    function doLoop(i) {
      genHarinezumi();
      setTimeout(function(){doLoop(++i)}, getIntervalWithPhase());
    }
    genHarinezumi();
    doLoop(0);
    /*
    function harinezumiloop() {
      makeHarinezumi();
      setTimeout(makeHarinezumi, (Math.random(9)+1)*1000);
    }
    harinezumiloop();
    */
    //setInterval(makeHarinezumi, 1000);
    /*
    this.timeCount = 0;
    this.harinezumiGoDirection = "left";
    this.hitoGoDirection = "right";
    this.harinezumi = this.add.sprite(800, 300, 'spritesheet_harinezumi');
    this.anims.create({
      key: 'left_harinezumi',
      frames: this.anims.generateFrameNumbers('spritesheet_harinezumi', {
        start: 0,
        end: 1
      }),
      frameRate: 2,
      repeat: -1
    });
    this.anims.create({
      key: 'right_harinezumi',
      frames: this.anims.generateFrameNumbers('spritesheet_harinezumi', {
        start: 2,
        end: 3
      }),
      frameRate: 2,
      repeat: -1
    });
    this.harinezumi.scale = 0.8;
    //this.harinezumi.setBounce(0);
    //this.harinezumi.setCollideWorldBounds(true);
    //
    this.cursors = this.input.keyboard.createCursorKeys();
    this.player = this.physics.add.sprite(0, 500, 'player');
    this.player.scale = 1.8;
    this.player.setBounce(0);
    this.player.setCollideWorldBounds(false);
    this.anims.create({
      key: 'left_jump_player',
      frames: this.anims.generateFrameNumbers('player', {
        start: 0,
        end: 1
      }),
      frameRate: 2,
      repeat: -1
    });
    this.anims.create({
      key: 'left_walk_player',
      frames: this.anims.generateFrameNumbers('player', {
        start: 2,
        end: 3
      }),
      frameRate: 2,
      repeat: -1
    });
    this.anims.create({
      key: 'left_stay_player',
      frames: this.anims.generateFrameNumbers('player', {
        start: 4,
        end: 4
      }),
      frameRate: 1,
      repeat: -1
    });
    this.anims.create({
      key: 'right_stay_player',
      frames: this.anims.generateFrameNumbers('player', {
        start: 5,
        end: 5
      }),
      frameRate: 1,
      repeat: -1
    });
    this.anims.create({
      key: 'right_walk_player',
      frames: this.anims.generateFrameNumbers('player', {
        start: 6,
        end: 7
      }),
      frameRate: 2,
      repeat: -1
    });
    this.anims.create({
      key: 'right_jump_player',
      frames: this.anims.generateFrameNumbers('player', {
        start: 8,
        end: 9
      }),
      frameRate: 2,
      repeat: -1
    });
    */
  }
  update() {
    /*
    //はりねずみに関する設定
      if (this.harinezumi.x<121) {
        // 左端に到達したら
        this.harinezumiGoDirection = "right";
      } else if (this.harinezumi.x>699) {
        // 右端に到達したら
        this.harinezumiGoDirection = "left";
      }
      // 方向に応じて動作を切り替え
      if (this.harinezumiGoDirection == "left") {
        //this.harinezumi.setVelocityX(-100);
        this.harinezumi.x -= 1;
        this.harinezumi.anims.play('left_harinezumi', true);
      } else if (this.harinezumiGoDirection == "right") {
        //this.harinezumi.setVelocityX(100);
        this.harinezumi.x += 1;
        this.harinezumi.anims.play('right_harinezumi', true);
      }
      */
    //はりねずみに関する設定
    this.harinezumis.forEach(harinezumi => {
      harinezumi.x -= 3;
      harinezumi.anims.play('left_harinezumi', true);
    });
    //this.harinezumi.x += 1;
    //this.harinezumi.anims.play('right_harinezumi', true);
    // プレイヤーに関する設定
    if (this.cursors.up.isDown) {
      // 浮いていられる時間をthis.timeCountで制限。一定時間が過ぎたら強制的に落下するように。
      if (this.timeCount<100) {
        this.player.anims.play('right_jump_player', true);
        this.player.setVelocityY(-1000);
        this.timeCount+=1;
      } else {
        this.player.anims.play('right_stay_player', true);
      }
    } else {
      this.player.anims.play('right_stay_player', true);
      this.timeCount=0;
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
  physics: {
    default: 'arcade',
    arcade: {
      gravity: {
        y: 10000
      },
      debug: false
    }
  },
  scale: {
    mode: Phaser.Scale.FIT,
    auoCenter: Phaser.Scale.CENTER_BOTH
  },
  scene: [Main]
};


let game = new Phaser.Game(config);