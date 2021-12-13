class DrawManager {
  constructor (arg_context) {
    this.context = arg_context;
    this.lodedResourcesArray = [];
    this.random1 = null;
    this.random2 = null;
    this.random3 = null;
  }

  draw(phase, facePoint) {
    if (this.random1==null||this.random2==null||this.random3==null) {
      this.random1 = Math.floor(Math.random()*2);
      this.random2 = Math.floor(Math.random()*2);
      this.random3 = Math.floor(Math.random()*2);
      console.log(this.random1, this.random2, this.random3);
    }
    if (phase<=1) {
      if (this.random1==0) {
        drawManager.drawMesen(facePoint);
      } else {
        drawManager.drawParipi(facePoint);
      }
    } else if (phase==2) {
      if (this.random1==0) {
        drawManager.drawMesen(facePoint);
      } else {
        drawManager.drawParipi(facePoint);
      }
      drawManager.drawKemono(facePoint);
      /*
      if (this.random2==0) {
        drawManager.drawMohikan(facePoint);
      } else {
        drawManager.drawKemono(facePoint);
      }
      */
    } else if (phase>=3) {
      drawManager.drawKemono(facePoint);
      /*
      if (this.random2==0) {
        drawManager.drawMohikan(facePoint);
      } else {
        drawManager.drawKemono(facePoint);
      }
      */
      // けもののとき(this.random2==1)はほほを表示しない
      if (this.random3==0) {
        drawManager.drawHentai(facePoint, this.random2!=1);
      } else {
        drawManager.drawPacchiri(facePoint, this.random2!=1);
      }
    }
  }
  
  reset() {
    this.random1 = null;
    this.random2 = null;
    this.random3 = null;
  }

  loadResource(filename) {
    if (this.lodedResourcesArray[filename]!=undefined) {
      return this.lodedResourcesArray[filename];
    } else {
      const img = new Image();
      img.src = "images/"+filename;
      this.lodedResourcesArray[filename] = img;
      return img;
    }
  }

  drawMesen(fPoint) {
    let scale = 1;
    let stampImg = this.loadResource("glass-mesen.png");
    if (fPoint) {
      let baseW = fPoint[0][0]-fPoint[14][0];
      let wScale = baseW/stampImg.width;
      let imgWidth = stampImg.width*scale*wScale;
      let imgHeight = stampImg.height*scale*wScale;
      let imgLeft = fPoint[14][0];
      let imgTop = fPoint[0][1]-imgHeight/2;
      this.context.drawImage(stampImg, imgLeft, imgTop, imgWidth, imgHeight);
    }
  }

  drawParipi(fPoint) {
    let scale = 1;
    let stampImg = this.loadResource("glass-paripi.png");
    if (fPoint) {
      let baseW = fPoint[0][0]-fPoint[14][0];
      let wScale = baseW/stampImg.width;
      let imgWidth = stampImg.width*scale*wScale;
      let imgHeight = stampImg.height*scale*wScale;
      let imgLeft = fPoint[14][0];
      let imgTop = fPoint[0][1]-imgHeight/2;
      this.context.drawImage(stampImg, imgLeft, imgTop, imgWidth, imgHeight);
    }
  }

  drawMohikan(fPoint) {
    let scale = 0.4;
    let stampImg = this.loadResource("hair_mohikan.png");
    if (fPoint) {
      let baseW = (fPoint[0][0]-fPoint[14][0])*1.8;
      let wScale = baseW/stampImg.width;
      let imgWidth = stampImg.width*scale*wScale;
      let imgHeight = stampImg.height*scale*wScale;
      let imgLeft = fPoint[33][0]-imgHeight/2;
      let imgTop = fPoint[33][1]-90;
      context.drawImage(stampImg, imgLeft, imgTop, imgWidth, imgHeight);
    }
  }

  drawKemono(fPoint) {
    // hair_kemomimi_l.png, hair_kemomimi_r.png, nose_kemo.png
    let scale = 0.3;
    let kemomimiL = this.loadResource("hair_kemomimi_l.png");
    let kemomimiR = this.loadResource("hair_kemomimi_r.png");
    let kemohana = this.loadResource("nose_kemo.png");
    if (fPoint) {
      let baseW = (fPoint[0][0]-fPoint[14][0])*1.8;
      // まずはケモミミを描画
      let wScaleKemomimi = baseW/kemomimiL.width;
      let kemomimiImgWidth = kemomimiL.width*scale*wScaleKemomimi;
      let kemomimiImgHeight = kemomimiL.height*scale*wScaleKemomimi;
      let kemomimiImgTop = fPoint[33][1]-90;
      let kemomimiImgLeft_L = fPoint[14][0]-kemomimiImgHeight/2;
      let kemomimiImgLeft_R = fPoint[0][0]-kemomimiImgHeight/2;
      context.drawImage(kemomimiR, kemomimiImgLeft_R, kemomimiImgTop, kemomimiImgWidth, kemomimiImgHeight);
      context.drawImage(kemomimiL, kemomimiImgLeft_L, kemomimiImgTop, kemomimiImgWidth, kemomimiImgHeight);
      // 次に鼻を描画
      let wScaleKemohana = baseW/kemohana.width;
      let kemohanaImgWidth = kemohana.width*scale*wScaleKemohana;
      let kemohanaImgHeight = kemohana.height*scale*wScaleKemohana;
      let kemohanaTop = fPoint[37][1]+10;
      let kemohanaImgLeft = fPoint[37][0]-kemohanaImgWidth/2;
      context.drawImage(kemohana, kemohanaImgLeft, kemohanaTop, kemohanaImgWidth, kemohanaImgHeight);
    }
  }

  drawHentai(fPoint, idDrawHoho) {
    // eye_hentai.png, eye_hoho.png
    let scale = 0.25;
    let scale2 = 0.15;
    let eye = this.loadResource("eye_hentai.png");
    let hoho = this.loadResource("eye_hoho.png");
    if (fPoint) {
      let baseW = (fPoint[0][0]-fPoint[14][0])*1.8;
      // まずは目を描画
      let wScaleEye = baseW/eye.width;
      let eyeImgWidth = eye.width*scale*wScaleEye;
      let eyeImgHeight = eye.height*scale*wScaleEye;
      let eyeImgTop = fPoint[0][1]-eyeImgHeight/2;
      let eyeImgLeft_L = fPoint[14][0];
      let eyeImgLeft_R = fPoint[0][0]-eyeImgWidth;
      context.drawImage(eye, eyeImgLeft_R, eyeImgTop, eyeImgWidth, eyeImgHeight);
      context.drawImage(eye, eyeImgLeft_L, eyeImgTop, eyeImgWidth, eyeImgHeight);
      // 次に頬を描画
      if (idDrawHoho) {
        let wScaleHoho = baseW/hoho.width;
        let hohoImgWidth = hoho.width*scale2*wScaleHoho;
        let hohoImgHeight = hoho.height*scale2*wScaleHoho;
        let hohoImgTop = fPoint[0][1]-hohoImgHeight/2+60;
        let hohoImgLeft_L = fPoint[14][0]-15;
        let hohoImgLeft_R = fPoint[0][0]-hohoImgWidth+15;
        context.drawImage(hoho, hohoImgLeft_L, hohoImgTop, hohoImgWidth, hohoImgHeight);
        context.drawImage(hoho, hohoImgLeft_R, hohoImgTop, hohoImgWidth, hohoImgHeight);
      }
    }
  }

  drawPacchiri(fPoint, idDrawHoho) {
    // eye_pacchiri.png, eye_hoho.png
    let scale = 0.15;
    let scale2 = 0.15;
    let eye = this.loadResource("eye_pacchiri.png");
    let hoho = this.loadResource("eye_hoho.png");
    if (fPoint) {
      let baseW = (fPoint[0][0]-fPoint[14][0])*1.8;
      // 頬を描画
      if (idDrawHoho) {
        let wScaleHoho = baseW/hoho.width;
        let hohoImgWidth = hoho.width*scale2*wScaleHoho;
        let hohoImgHeight = hoho.height*scale2*wScaleHoho;
        let hohoImgTop = fPoint[0][1]-hohoImgHeight/2+80;
        let hohoImgLeft_L = fPoint[14][0]-15;
        let hohoImgLeft_R = fPoint[0][0]-hohoImgWidth+15;
        context.drawImage(hoho, hohoImgLeft_L, hohoImgTop, hohoImgWidth, hohoImgHeight);
        context.drawImage(hoho, hohoImgLeft_R, hohoImgTop, hohoImgWidth, hohoImgHeight);
      }
      // 目を描画
      let wScaleEye = baseW/eye.width;
      let eyeImgWidth = eye.width*scale*wScaleEye;
      let eyeImgHeight = eye.height*scale*wScaleEye;
      let eyeImgTop = fPoint[0][1]-eyeImgHeight/2;
      let eyeImgLeft_L = fPoint[14][0]-30;
      let eyeImgLeft_R = fPoint[0][0]+60-(eyeImgWidth/2);
      context.drawImage(eye, eyeImgLeft_R, eyeImgTop, eyeImgWidth, eyeImgHeight);
      context.drawImage(eye, eyeImgLeft_L, eyeImgTop, eyeImgWidth, eyeImgHeight);
    }
  }
}