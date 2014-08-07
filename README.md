ScanSnap自炊用バッチ
========================

３年ぶりに自炊ブームがきたよ2014  
http://tenderfeel.xsrv.jp/memo/1358/



Photoshopドロップレットを解凍してbatと同じ階層に入れてください  
https://dl.dropboxusercontent.com/u/414239/dropret.zip


7-Zipのコマンドライン版をbatと同じ階層に入れてください。  
http://sevenzip.sourceforge.jp/


# ディレクトリ構造

~~~
ScanSnap
│  .gitignore
│  7za.exe
│  LICENSE
│  README.md
│  scansnap.bat
│
└─dropret
        01_iPhone_Color_comics.exe
        02_iPhone_Color_default_comics.exe
        03_iPhone_Gray_comics.exe
        04_iPhone_Color_72.exe
        05_iPhone_Color_default_72.exe
        06_iPhone_Color_inner_72.exe
        07_iPhone_Gray_72.exe
        jisui.atn
~~~

表紙: 1.jpg  
裏表紙: 999.jpg  
中カラー: 2.jpg  
本文: 2ないし3.jpg～  

# 設定
batファイルの冒頭に設定があるので適当に書き換えてください