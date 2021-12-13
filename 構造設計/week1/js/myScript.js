function convertThreeVectorToEyePosX(x) {
   // 目玉のx(left): 左の限界-20px, 右の限界20px
   if (x===0) {
      return 0;
   }
   var pos = 20/(3.0/x)
   if (pos>=-20 && pos<=20) {
      return pos;
   } else {
      return 20;
   }
}
function convertThreeVectorToEyePosX(y) {
   // 目玉のy(top): 上限-20px, 下限20px
   if (y===0) {
      return 0;
   }
   var pos = 20/(3.0/y)
   if (pos>=-20 && pos<=20) {
      return pos;
   } else {
      return 20;
   }
 }
window.onload = function () {
  //パーツを取得
  let face_parts_normal = document.getElementById("face_parts_normal");
  let face_parts_scared = document.getElementById("face_parts_scared");
  let face_parts_angry = document.getElementById("face_parts_angry");
  let face_parts_happy = document.getElementById("face_parts_happy");
  let face_parts_ease = document.getElementById("face_parts_ease");
  let face_parts_eyebase = document.getElementById("face_parts_eyebase");
  let face_parts_eye = document.getElementById("face_parts_eye");        
  // マーカーを取得
  let markers = document.querySelectorAll("a-marker");
  // すべてのマーカーに対して設定を適用
  markers.forEach((marker, index)=>{
    var markerPos = new THREE.Vector3();
    var intervalId = null;
    marker.addEventListener("markerFound", (e)=>{ 
       // 表情を変える
       if (index == 0) {
         // 蝶のとき
         face_parts_normal.style.display ="none";
         face_parts_scared.style.display ="none";
         face_parts_angry.style.display ="none";
         face_parts_happy.style.display ="block";
         face_parts_ease.style.display ="none";
         face_parts_eyebase.style.display ="block";
         face_parts_eye.style.display ="block";
       } else if (index == 1) {
         // 蜂のとき
         face_parts_normal.style.display ="none";
         face_parts_scared.style.display ="block";
         face_parts_angry.style.display ="none";
         face_parts_happy.style.display ="none";
         face_parts_ease.style.display ="none";
         face_parts_eyebase.style.display ="block";
         face_parts_eye.style.display ="block";
       }
       // 0.1秒間隔でmarkerの座標を取得する
       intervalId = setInterval(()=>{
          e.target.object3D.getWorldPosition(markerPos);
          // x, yの軸は普通に数学と同じ、zは奥行き。
          // xは-3.0-3.0のあいだをとり、右端が3.0、左端が-3.0
          //console.log(marker1Pos.x);
          // 3.0=20pxとして、座標を変換する処理
          var eyeX = convertThreeVectorToEyePosX(markerPos.x);
          var eyeY = convertThreeVectorToEyePosX(markerPos.y);
          //console.log(eyeX, eyeY);
          face_parts_eye.style.top = -eyeY+"px";
          face_parts_eye.style.left = eyeX+"px";
       }, 100);
    });
    marker.addEventListener("markerLost", (e)=>{ 
       // 表情を変える
       face_parts_eye.style.top = "0px";
       face_parts_eye.style.left = "0px";
       if (index == 0) {
         // 蝶のとき
         face_parts_normal.style.display ="none";
         face_parts_scared.style.display ="none";
         face_parts_angry.style.display ="block";
         face_parts_happy.style.display ="none";
         face_parts_ease.style.display ="none";
         face_parts_eyebase.style.display ="block";
         face_parts_eye.style.display ="block";
       } else if (index == 1) {
         // 蜂のとき
         face_parts_normal.style.display ="none";
         face_parts_scared.style.display ="none";
         face_parts_angry.style.display ="none";
         face_parts_happy.style.display ="none";
         face_parts_ease.style.display ="block";
         face_parts_eyebase.style.display ="none";
         face_parts_eye.style.display ="none";
       }
       // マーカを失ったら座標取得処理を止める
       if (intervalId != null) {
          clearTimeout(intervalId);
       }
    });
  });
};