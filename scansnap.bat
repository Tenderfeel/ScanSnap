@echo off
setlocal enabledelayedexpansion

rem ---------------�ݒ�----------------

rem ���[�h�ݒ�i1:�P�s�{ 2:B6�`A4�j
set MODE=1

rem �\���E���\���̃\�[�X�t�@�C����
set coverFile=IMG.bmp
set backcoverFile=IMG_001.bmp
set innerColorFile=IMG_002.bmp

rem �����y�[�W��
set pageCnt=40

rem ZIP�t�@�C���̕ۑ���
set zipSaveDir=Z:\���l��

rem -------- ���[�J�����ϐ� ---------

rem �{�̃^�C�g��
set BOOK_TITLE=

rem ���Җ�
set CIRCLE=

rem �f�B���N�g����
set dirname=

rem �h���b�v���b�g�ɓn���p�����[�^
set param=

rem iPhone�p�̏������s�����ǂ���
set iphone=

rem �t�@�C����
set COUNT=0

rem �{���t�@�C����
set countMainPage=0

rem �\���̃J���[�������s�����ǂ���
set coverColor=

rem ���J���[�����݂��邩�ǂ���
set innerColor=

rem ���\���̃J���[�������s�����ǂ���
set backcoverColor=

rem �����J�n����y�[�W�ԍ�
set startCnt=2

rem �����x�[�X�y�[�W��
set baseNum=0

rem �v�Z��̕����y�[�W��
set pageNum=0

rem ���[�v��-1�����l��ۑ�����ϐ��ł�
set x=1

rem ------------------------------------

:start
cls


rem ----- ���[�h�擾
echo.
set /p MODE=�����������܂����H�i1:�P�s�{ 2:B6�`A4�j 


rem ----- �f�B���N�g�����擾

echo.
set /p BOOK_TITLE=�^�C�g������͂��Ă�������: 
if '%BOOK_TITLE%'=='' set BOOK_TITLE=%date:~0,4%%date:~5,2%%date:~8,2%
if not '%BOOK_TITLE%'=='' set BOOK_TITLE=%BOOK_TITLE%

set /p CIRCLE=���Җ�����͂��Ă�������: 
if '%CIRCLE%'=='' set CIRCLE=''
if not '%CIRCLE%'=='' set CIRCLE=%CIRCLE%
goto exec

rem ----- �T�u���� -----

:exec

rem ---���Җ�������ꍇ
if %CIRCLE%=='' ( 
set dirname=%BOOK_TITLE%

rem ---���Җ��������ꍇ
 ) else ( 
set dirname=%BOOK_TITLE%�y%CIRCLE%�z
 ) 

rem ---�f�B���N�g�������݂���
if exist %dirname% ( 
echo �u%dirname%�v�t�H���_�����݂��܂��c
 ) else ( 
echo �u%dirname%�v�t�H���_���쐬���܂��c
mkdir %dirname%
pushd %dirname%
mkdir src
pushd %0\..
 ) 

rem ----- ScanSnapJPG�t�@�C���ړ�
:movefile

for %%i in (*.jpg) do ( 
echo %%i ���ړ����܂��c
move %%i %dirname%\src
 ) 

echo.

rem ----- �X�L���������\���t�@�C���ړ�
if exist %coverFile% ( 
echo �\���̃X�L�����f�[�^���ړ����܂��c
move %coverFile% %dirname%
 ) 

if exist %backcoverFile% ( 
echo ���\���̃X�L�����f�[�^���ړ����܂��c
move %backcoverFile% %dirname%
 ) 

if exist %innerColorFile% ( 
echo ���J���[�̃X�L�����f�[�^���ړ����܂��c
move %innerColorFile% %dirname%
 ) 


rem ---- iPhone�p
echo.
set /p iphone=iPhone�p�̏������s���܂����H(Y/N) 
if not '%iphone%'=='' set iphone=%iphone:~0,1%
if '%iphone%'=='n' goto exit

echo src�f�B���N�g���𕡐����܂�
echo d | xcopy /e %dirname%\src %dirname%\iPhone

echo.
echo Photoshop�̃A�N�V���������s���܂��c

rem --- �t�@�C�����`�F�b�N
rem http://d.hatena.ne.jp/necoyama3/20090716/1247752451
for /F "DELIMS=" %%A in ('DIR %dirname%\iPhone /B ^| find /C /V ""') do set COUNT=%%A
echo �t�@�C�����F%COUNT% 

set /a countMainPage= "COUNT - 1"

rem ---- �\������
if exist %dirname%\iPhone\1.jpg ( 
set /p coverColor=�\���̐F�������s���܂���?(Y/N) 
if not '%coverColor%'=='' set coverColor=%coverColor:~0,1%

if '%coverColor%'=='y' ( 
call :colorEdit 1
 ) else ( 
call :colorDefault 1
 ) 

 ) 

pause
goto :innerColorEdit

:colorEdit
if '%MODE%'==1 ( 
start /wait /b dropret\01_iPhone_Color_comics.exe %CD%\%dirname%\iPhone\%1.jpg
 ) else ( 
start /wait /b dropret\04_iPhone_Color_72.exe %CD%\%dirname%\iPhone\%1.jpg
 ) 
goto :eof

:colorDefault
if '%MODE%'==1 ( 
start /wait /b dropret\02_iPhone_Color_default_comics.exe %CD%\%dirname%\iPhone\%1.jpg
 ) else ( 
start /wait /b dropret\05_iPhone_Color_default_72.exe %CD%\%dirname%\iPhone\%1.jpg
 ) 
goto :eof

rem ---- ���J���[����
:innerColorEdit
if exist %dirname%\iPhone\2.jpg ( 
set /p innerColor=���J���[�͑��݂��܂���?(Y/N) 
if not '%innerColor%'=='' set innerColor=%innerColor:~0,1%

if '%innerColor%'=='y' ( 
start /wait /b dropret\06_iPhone_Color_inner_72.exe %CD%\%dirname%\iPhone\2.jpg
 ) 

pause

rem ---- ���\������
:backCoverEdit
if exist %dirname%\iPhone\999.jpg ( 
set /p backcoverColor=���\���̐F�������s���܂���?(Y/N) 
if not '%backcoverColor%'=='' set backcoverColor=%backcoverColor:~0,1%

if '%backcoverColor%'=='y' ( 
call :colorEdit 999
 ) else ( 
call :colorDefault 999
 ) 

 ) 

pause

rem ---- �{������

rem ���J���[������ꍇ�͊J�n��3�y�[�W����ɂ���
if %innerColor%==y ( 
set startCnt=3
 ) 

rem ���[�v���������
set /a roopCnt=%countMainPage% / %pageCnt%

rem ���[�v�����̗]��y�[�W��
set /a roopCntRst=%countMainPage% %% %pageCnt%

echo.
echo �{���������J�n���܂�...
echo �{���y�[�W���F%countMainPage%
echo �����y�[�W���F%pageCnt%
echo ���[�v������: %roopCnt%�i%roopCntRst%�]��j

rem ���y�[�W�����w�肳�ꂽ�����y�[�W���Ŋ������񐔕����[�v����
for /l %%j in ( 1,1,%roopCnt%) do ( 
set param=
echo -----
echo ���[�v #%%j
call :baseNumber %%j
echo -----

rem �ŏ��̃��[�v��2��ڈȍ~�ŏ����𕪂��ăp�����[�^����
if %%j==1 ( call :firstRoop %%j ) else ( call :secondRoop %%j ) 

call :dropret %param%

 ) 

rem �]�����y�[�W�̏���
set baseNum=%pageNum%
set param=
echo -----
echo �]��y�[�W
echo -----
for /l %%k in (1,1,%roopCntRst% ) do ( 
call :pageNumber %%k %%j
 ) 
call :dropret %param%

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


rem �y�[�W�ԍ��̃x�[�X�����Z�o����
:baseNumber
if not %1 == 1 ( 
set /a x=%1-1
set /a baseNum="pageCnt * x"
 ) 
goto :eof


rem �y�[�W�ԍ����Z�o���ăp�����[�^������𐶐�����
:pageNumber
if not %2 == 1 ( 
set /a pageNum="baseNum + %1"
 ) else ( 
set pageNum=%1
 ) 
echo Page %pageNum% ...
call :concat %pageNum%
goto :eof


rem �h���b�v���b�g�ɓn���p�����[�^�̌���
:concat
set /a n=n+1
set param=%param% %CD%\%dirname%\iPhone\%1.jpg
goto :eof


rem �h���b�v���b�g
:dropret
echo.
echo �h���b�v���b�g���N�����܂��B�������I���܂ł��҂���������...
if '%MODE%'=='1' ( 
start /wait /b dropret\03_iPhone_Gray_comics.exe %param%
 ) else ( 
start /wait /b dropret\07_iPhone_Gray_72.exe %param%
 ) 
pause
goto :eof

:finalPageNameChange
echo.
echo �����t�@�C����: !n!��
echo �{�������I�����܂����B�ŏI�y�[�W�̃t�@�C������ύX���܂�...
pushd %dirname%\iPhone
rename 999.jpg %COUNT%.jpg
pushd %0\..

if exist 7za.exe ( 
echo ZIP���k���܂�...
start /wait 7za.exe a %dirname%\%dirname%.zip %dirname%\iPhone
 ) 
pause

rem ZIP�t�@�C���ړ�
if not '%zipSaveDir%'=='' ( 
echo ZIP�t�@�C�����ړ����܂�...
move %dirname%\%dirname%.zip %zipSaveDir%
 ) 

rem ----- �I�� -----
:exit

exit
