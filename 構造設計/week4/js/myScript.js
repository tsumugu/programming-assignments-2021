// 対応している言語ごとに国コードを設定しておく。
// https://www.deepl.com/docs-api/translating-text/
// https://cloud.google.com/speech-to-text/docs/languages
var LangList = [
  {
    "name": "英語(English)",
    "shortname": "英語",
    "deepl": "EN",
    "speech": "en-US",
    "targetDafault": true
  },
  {
    "name": "日本語(Japanese)",
    "shortname": "日本語",
    "deepl": "JA",
    "speech": "ja-JP",
    "sourceDafault": true
  },
  {
    "name": "中国語(Chinese)",
    "shortname": "中国語",
    "deepl": "ZH",
    "speech": "zh"
  },
  {
    "name": "ブルガリア語(Bulgarian)",
    "shortname": "ブルガリア語",
    "deepl": "BG",
    "speech": "bg-BG"
  },
  {
    "name": "チェコ語(Czech)",
    "shortname": "チェコ語",
    "deepl": "CS",
    "speech": "cs-CZ"
  },
  {
    "name": "デンマーク語(Danish)",
    "shortname": "デンマーク語",
    "deepl": "DA",
    "speech": "da-DK"
  },
  {
    "name": "ドイツ語(German)",
    "shortname": "ドイツ語",
    "deepl": "DE",
    "speech": "de-DE"
  },
  {
    "name": "ギリシャ語(Greek)",
    "shortname": "ギリシャ語",
    "deepl": "EL",
    "speech": "el-GR"
  },
  {
    "name": "スペイン語(Spanish)",
    "shortname": "スペイン語",
    "deepl": "ES",
    "speech": "es-ES"
  },
  {
    "name": "エストニア語(Estonian)",
    "shortname": "エストニア語",
    "deepl": "ET",
    "speech": "et-EE"
  },
  {
    "name": "フィンランド語(Finnish)",
    "shortname": "フィンランド語",
    "deepl": "FI",
    "speech": "fi-FI"
  },
  {
    "name": "フランス語(French)",
    "shortname": "フランス語",
    "deepl": "FR",
    "speech": "fr-FR"
  },
  {
    "name": "ハンガリー語(Hungarian)",
    "shortname": "ハンガリー語",
    "deepl": "HU",
    "speech": "hu-HU"
  },
  {
    "name": "イタリア語(Italian)",
    "shortname": "イタリア語",
    "deepl": "IT",
    "speech": "it-IT"
  },
  {
    "name": "リトアニア語(Lithuanian)",
    "shortname": "リトアニア語",
    "deepl": "LT",
    "speech": "lt-LT"
  },
  {
    "name": "ラトビア語(Latvian)",
    "shortname": "ラトビア語",
    "deepl": "LV",
    "speech": "lv-LV"
  },
  {
    "name": "オランダ語(Dutch)",
    "shortname": "オランダ語",
    "deepl": "NL",
    "speech": "nl-NL"
  },
  {
    "name": "ポーランド語(Polish)",
    "shortname": "ポーランド語",
    "deepl": "PL",
    "speech": "pl-PL"
  },
  {
    "name": "ポルトガル語(Portuguese)",
    "shortname": "ポルトガル語",
    "deepl": "PT",
    "speech": "pt-PT"
  },
  {
    "name": "ルーマニア語(Romanian)",
    "shortname": "ルーマニア語",
    "deepl": "RO",
    "speech": "ro-RO"
  },
  {
    "name": "ロシア語(Russian)",
    "shortname": "ロシア語",
    "deepl": "RU",
    "speech": "ru-RU"
  },
  {
    "name": "スロヴァキア語(Slovak)",
    "shortname": "スロヴァキア語",
    "deepl": "SK",
    "speech": "sk-SK"
  },
  {
    "name": "スロベニア語(Slovenian)",
    "shortname": "スロベニア語",
    "deepl": "SL",
    "speech": "sl-SI"
  },
  {
    "name": "スウェーデン語(Swedish)",
    "shortname": "スウェーデン語",
    "deepl": "SV",
    "speech": "sv-SE"
  }
];

// DeepL APIを使って翻訳する関数
let translate = (sourceLang, targetLang, str)=>{
  var url = "https://api-free.deepl.com/v2/translate?auth_key=71d6d8bf-b390-ab9c-6919-cdae2539b49c:fx&text="+str+"&source_lang="+sourceLang+"&target_lang="+targetLang;
  return fetch(encodeURI(url));
}

// 音声認識に関する設定
const translateLogElm = document.getElementById("translateLog");
let recognition = null;
let mySpeechRecognition = (sourceLangObj, targetLangObj)=>{
  recognition = new webkitSpeechRecognition();
  recognition.lang = sourceLangObj.speech;
  recognition.interimResults = false;
  recognition.start();
  recognition.onresult = (e)=>{
    if (e.results[0].isFinal) {
      let aTxt = e.results[0][0].transcript;
      // 翻訳する
      translate(sourceLangObj.deepl, targetLangObj.deepl, aTxt).then((response)=>{
        response.text().then((resStr)=>{
          let resJSON = JSON.parse(resStr);
          let translatedText = resJSON.translations[0].text;
          // 結果をulに表示する
          const li = document.createElement('li');
          li.classList.add("translated-item", "focused");
          li.innerHTML = '<p class="translated-item-target-text">'+translatedText+'</p><p class="translated-item-source-text">'+aTxt+'</p><p class="translated-item-source-target-name">'+sourceLangObj.shortname+'→'+targetLangObj.shortname+'</p><p class="translated-item-time">'+new Date().toLocaleString()+'</p>';
          translateLogElm.appendChild(li);
          // 前のfocusedを消す
          const itemElmlist = document.getElementsByClassName("translated-item");
          let beforeElm = itemElmlist[itemElmlist.length-2];
          beforeElm.classList.remove("focused");
          window.scrollTo(0, translateLogElm.scrollHeight);
        });
      });
      // 停止→1秒後にスタート
      recognition.stop();
      setTimeout(()=>{
        recognition.start();
      }, 1000);
    }
  }
}

window.onload = ()=>{
  let sourceLangObj = null;
  let targetLangObj = null;
  // 言語セレクターの生成
  const sourceSelector = document.getElementById('source-selector');
  const targetSelector = document.getElementById('target-selector');
  LangList.forEach((lang, index)=>{
    const option = document.createElement('option');
    option.value = index;
    option.textContent = lang.shortname;
    if (lang.sourceDafault!=undefined) {
      option.selected = "selected";
    }
    sourceSelector.appendChild(option);

    const option2 = document.createElement('option');
    option2.value = index;
    option2.textContent = lang.shortname;
    if (lang.targetDafault!=undefined) {
      option2.selected = "selected";
    }
    targetSelector.appendChild(option2);
  });
  // selectorが変更されたときに実行される
  sourceSelector.addEventListener('change', (e) => {
    let index = parseInt(e.target.value)
    sourceLangObj = LangList[index];
    // Sourceが変更されたら音声認識を変更する
    mySpeechRecognition(sourceLangObj, targetLangObj);
  });
  targetSelector.addEventListener('change', (e) => {
    let index = parseInt(e.target.value)
    targetLangObj = LangList[index];
    mySpeechRecognition(sourceLangObj, targetLangObj);
  });
  // selectの初期値に基づいて、音声認識と翻訳のSource, Targetを設定する
  sourceLangObj = LangList[sourceSelector.selectedIndex];
  targetLangObj = LangList[targetSelector.selectedIndex];
  // 開始ボタンが押されたら音声認識を開始する
  const startButton = document.getElementById("startButton");
  isStarted = false;
  startButton.addEventListener("click", ()=>{
    if (!isStarted) {
      mySpeechRecognition(sourceLangObj, targetLangObj);
      startButton.innerHTML = '<i class="fas fa-microphone luminous-text"></i>';
      startButton.classList.add("luminous-button");
      isStarted = true;
    } else {
      recognition.stop();
      startButton.innerHTML = '<i class="fas fa-microphone-slash"></i>';
      startButton.classList.remove("luminous-button");
      isStarted = false;
    }
  });

}