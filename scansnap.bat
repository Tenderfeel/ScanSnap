@echo off
setlocal enabledelayedexpansion

rem ---------------設定----------------

rem モード設定（1:単行本 2:B6〜A4）
set MODE=1

rem 表紙・裏表紙のソースファイル名
set coverFile=IMG.bmp
set backcoverFile=IMG_001.bmp
set innerColorFile=IMG_002.bmp
set backinnerColorFile=IMG_003.bmp

rem 分割ページ数
set pageCnt=40

rem ZIPファイルの保存先
set zipSaveDir=
rem -------- ローカル環境変数 ---------

rem 本のタイトル
set BOOK_TITLE=

rem 著者名
set CIRCLE=

rem ディレクトリ名
set dirname=

rem ドロップレットに渡すパラメータ
set param=

rem ファイル数
set COUNT=0

rem 本文ファイル数
set countMainPage=0

rem 表紙のカラー処理を行うかどうか
set coverColor=

rem 中カラーが存在するかどうか
set innerColor=0

rem 裏表紙のカラー処理を行うかどうか
set backcoverColor=0

rem 裏中カラーが存在するかどうか
set backinnerColor=0

rem 裏中カラーのページ番号を保存する変数です
set backinnerColorPageCount=

rem 処理開始するページ番号
set startCnt=2

rem 分割ベースページ数
set baseNum=0

rem 計算後の分割ページ数
set pageNum=0

rem ループ回数-1した値を保存する変数です
set x=1

rem ------------------------------------

:start
cls


rem ----- モード取得
echo.
set /p MODE=何を処理しますか？（1:単行本 2:B6〜A4） 


rem ----- ディレクトリ名取得

echo.
set /p BOOK_TITLE=タイトルを入力してください: 
if '%BOOK_TITLE%'=='' set BOOK_TITLE=%date:~0,4%%date:~5,2%%date:~8,2%
if not '%BOOK_TITLE%'=='' set BOOK_TITLE=%BOOK_TITLE%

set /p CIRCLE=著者名を入力してください: 
if '%CIRCLE%'=='' set CIRCLE=''
if not '%CIRCLE%'=='' set CIRCLE=%CIRCLE%
goto exec

rem ----- サブ処理 -----

:exec

rem ---著者名がない場合
if %CIRCLE%=='' ( 
set dirname=%BOOK_TITLE%

rem ---著者名がある場合
 ) else ( 
set dirname=[%CIRCLE%]%BOOK_TITLE%
 ) 

rem ---ディレクトリが存在する
if exist %dirname% ( 
echo 「%dirname%」フォルダが存在します…
 ) else ( 
echo 「%dirname%」フォルダを作成します…
mkdir %dirname%
pushd %dirname%
mkdir src
pushd %0\..
 ) 

rem ----- ScanSnapJPGファイル移動
:movefile

for %%i in (*.jpg) do ( 
echo %%i を移動します…
move %%i %dirname%\src
 ) 

echo.

rem ----- スキャンした表紙ファイル移動
if exist %coverFile% ( 
echo 表紙のスキャンデータを移動します…
move %coverFile% %dirname%
 ) 

if exist %backcoverFile% ( 
echo 裏表紙のスキャンデータを移動します…
move %backcoverFile% %dirname%
 ) 

if exist %innerColorFile% ( 
echo 中カラーのスキャンデータを移動します…
move %innerColorFile% %dirname%
 ) 

if exist %backinnerColorFile% ( 
echo 裏中カラーのスキャンデータを移動します…
move %backinnerColorFile% %dirname%
 ) 


echo srcディレクトリを複製します
echo d | xcopy /e %dirname%\src %dirname%\iPhone

echo.
echo Photoshopのアクションを実行します…

rem ---- 表紙処理
if exist %dirname%\iPhone\1.jpg ( 
echo 表紙を処理します
set coverColor=y
call :colorDefault 1
 ) 

pause
goto :innerColorEdit


:colorDefault
if %MODE%==1 ( 
start /wait /b dropret\02_iPhone_Color_default_comics.exe %CD%\%dirname%\iPhone\%1.jpg
 ) else ( 
start /wait /b dropret\05_iPhone_Color_default_72.exe %CD%\%dirname%\iPhone\%1.jpg
 ) 
goto :eof

rem ---- 中カラー処理
:innerColorEdit
if exist %dirname%\iPhone\2.jpg ( 
set /p innerColor=中カラーはありますか?(0/1)
if %innerColor%==1 ( 
call :colorDefault 2
pause
 ) 
 ) 


rem ---- 裏表紙処理
:backCoverEdit
if exist %dirname%\iPhone\999.jpg ( 
echo 裏表紙を処理します
set backcoverColor=1
call :colorDefault 999
 ) 

pause

rem ---- 裏中カラー処理
:backinnerCoverEdit
if exist %dirname%\iPhone\998.jpg ( 
echo 裏中カラーを処理します
set backinnerColor=1
call :colorDefault 998
pause
 ) 


rem ---- 本文処理

rem --- ファイル数チェック
rem http://d.hatena.ne.jp/necoyama3/20090716/1247752451
for /F "DELIMS=" %%A in ('DIR %dirname%\iPhone /B ^| find /C /V ""') do set COUNT=%%A
echo 総ファイル数：%COUNT% 

rem 表紙のページ分マイナスしておく
set /a countMainPage= COUNT - 1

rem 裏表紙のページ分マイナスしておく
if %backcoverColor%==1 ( 
set /a countMainPage= countMainPage - 1
 ) 

rem 裏中ページ分マイナスしておく
if %backinnerColor%==1 ( 
set /a countMainPage= countMainPage - 1
 ) 

rem 中カラーがある場合は開始を3ページからにする
if %innerColor%==1 ( 
set /a countMainPage= countMainPage - 1
set startCnt=3
 ) 
echo 本文ファイル数：%countMainPage% 

rem ループ処理する回数
set /a roopCnt=%countMainPage% / %pageCnt%

rem ループ処理の余りページ数
set /a roopCntRst=%countMainPage% %% %pageCnt%

echo.
echo 本文処理を開始します...
echo 本文ページ数：%countMainPage%

rem ループ処理不要なページ数の場合
if %roopCnt%==0 ( 
set roopCnt=1
set pageCnt=%countMainPage%
set roopCntRst=0
 ) else ( 
echo 分割ページ数：%pageCnt%
echo ループ処理回数: %roopCnt%（%roopCntRst%余り）
 ) 

::MainRoop

rem 総ページ数を指定された分割ページ数で割った回数分ループ処理
for /l %%j in ( 1,1,%roopCnt%) do ( 
set param=
echo -----
echo ループ #%%j
call :baseNumber %%j
echo -----

rem 表紙を含む最初のループと2回目以降で処理を分けてパラメータ生成
if %%j==1 ( call :firstRoop %%j ) else ( call :secondRoop %%j ) 

call :dropret %param%

 ) 

rem 余ったページの処理
if %roopCntRst% GTR 0 ( 
set baseNum=%pageNum%
set param=
echo -----
echo 余りページ
echo -----
for /l %%k in (1,1,%roopCntRst% ) do ( 
call :pageNumber %%k %%j
 ) 
call :dropret %param%

 ) 

goto :finalPageNameChange

:firstRoop
for /l %%i in ( %startCnt%,1,%pageCnt% ) do ( 
call :pageNumber %%i %1
 ) 
goto :eof

:secondRoop
for /l %%i in ( 1,1,%pageCnt% ) do ( 
call :pageNumber %%i %1
 ) 
goto :eof


rem ページ番号のベース数を算出する
:baseNumber
if not %1 == 1 ( 
set /a x=%1-1
set /a baseNum="pageCnt * x"
 ) 
goto :eof


rem ページ番号を算出してパラメータ文字列を生成する
rem %1 ページ番号 %2 ループ番号
:pageNumber
if not %2 == 1 ( 
set /a pageNum="baseNum + %1"
 ) else ( 
set pageNum=%1
 ) 
echo Page %pageNum% ...
call :concat %pageNum%
goto :eof


rem ドロップレットに渡すパラメータの結合
:concat
set /a n=n+1
set param=%param% %CD%\%dirname%\iPhone\%1.jpg
goto :eof


rem ドロップレット
:dropret
echo.
echo ドロップレットを起動します。処理が終わるまでお待ちください...
if '%MODE%'=='1' ( 
start /wait /b dropret\03_iPhone_Gray_comics.exe %param%
 ) else ( 
start /wait /b dropret\07_iPhone_Gray_72.exe %param%
 ) 
pause
goto :eof



:finalPageNameChange
echo.
echo 処理ファイル数: !n!個
echo 本文処理終了しました。

if %backinnerColor%==1 ( 
echo 裏中ページのファイル名を変更します...
pushd %dirname%\iPhone
set /a backinnerColorPageCount= COUNT - 1
rename 998.jpg %backinnerColorPageCount%.jpg
pushd %0\..
 ) 

if %backcoverColor%==1 ( 
echo 最終ページのファイル名を変更します...
pushd %dirname%\iPhone
rename 999.jpg %COUNT%.jpg
pushd %0\..
 ) 

if exist 7za.exe ( 
echo ZIP圧縮します...
start /wait 7za.exe a %dirname%\%dirname%.zip %dirname%\iPhone
 ) 

pause

rem ZIPファイル移動
if not %zipSaveDir%=='' ( 
echo ZIPファイルを移動します...
move %dirname%\%dirname%.zip %zipSaveDir%
 ) 

rem ----- 終了 -----
:exit

exit
