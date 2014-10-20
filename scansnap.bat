@echo off
setlocal enabledelayedexpansion

rem ---------------�ݒ�----------------

rem ���[�h�ݒ�i1:�P�s�{ 2:B6�`A4�j
set MODE=1

rem �\���E���\���̃\�[�X�t�@�C����
set coverFile=IMG.bmp
set backcoverFile=IMG_001.bmp
set innerColorFile=IMG_002.bmp
set backinnerColorFile=IMG_003.bmp

rem �����y�[�W��
set pageCnt=40

rem ZIP�t�@�C���̕ۑ���
set zipSaveDir=
rem -------- ���[�J�����ϐ� ---------

rem �{�̃^�C�g��
set BOOK_TITLE=

rem ���Җ�
set CIRCLE=

rem �f�B���N�g����
set dirname=

rem �h���b�v���b�g�ɓn���p�����[�^
set param=

rem �t�@�C����
set COUNT=0

rem �{���t�@�C����
set countMainPage=0

rem �\���̃J���[�������s�����ǂ���
set coverColor=

rem ���J���[�����݂��邩�ǂ���
set innerColor=0

rem ���\���̃J���[�������s�����ǂ���
set backcoverColor=0

rem �����J���[�����݂��邩�ǂ���
set backinnerColor=0

rem �����J���[�̃y�[�W�ԍ���ۑ�����ϐ��ł�
set backinnerColorPageCount=

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

rem ---���Җ����Ȃ��ꍇ
if %CIRCLE%=='' ( 
set dirname=%BOOK_TITLE%

rem ---���Җ�������ꍇ
 ) else ( 
set dirname=[%CIRCLE%]%BOOK_TITLE%
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

if exist %backinnerColorFile% ( 
echo �����J���[�̃X�L�����f�[�^���ړ����܂��c
move %backinnerColorFile% %dirname%
 ) 


echo src�f�B���N�g���𕡐����܂�
echo d | xcopy /e %dirname%\src %dirname%\iPhone

echo.
echo Photoshop�̃A�N�V���������s���܂��c

rem ---- �\������
if exist %dirname%\iPhone\1.jpg ( 
echo �\�����������܂�
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

rem ---- ���J���[����
:innerColorEdit
if exist %dirname%\iPhone\2.jpg ( 
set /p innerColor=���J���[�͂���܂���?(0/1)
if %innerColor%==1 ( 
call :colorDefault 2
pause
 ) 
 ) 


rem ---- ���\������
:backCoverEdit
if exist %dirname%\iPhone\999.jpg ( 
echo ���\�����������܂�
set backcoverColor=1
call :colorDefault 999
 ) 

pause

rem ---- �����J���[����
:backinnerCoverEdit
if exist %dirname%\iPhone\998.jpg ( 
echo �����J���[���������܂�
set backinnerColor=1
call :colorDefault 998
pause
 ) 


rem ---- �{������

rem --- �t�@�C�����`�F�b�N
rem http://d.hatena.ne.jp/necoyama3/20090716/1247752451
for /F "DELIMS=" %%A in ('DIR %dirname%\iPhone /B ^| find /C /V ""') do set COUNT=%%A
echo ���t�@�C�����F%COUNT% 

rem �\���̃y�[�W���}�C�i�X���Ă���
set /a countMainPage= COUNT - 1

rem ���\���̃y�[�W���}�C�i�X���Ă���
if %backcoverColor%==1 ( 
set /a countMainPage= countMainPage - 1
 ) 

rem �����y�[�W���}�C�i�X���Ă���
if %backinnerColor%==1 ( 
set /a countMainPage= countMainPage - 1
 ) 

rem ���J���[������ꍇ�͊J�n��3�y�[�W����ɂ���
if %innerColor%==1 ( 
set /a countMainPage= countMainPage - 1
set startCnt=3
 ) 
echo �{���t�@�C�����F%countMainPage% 

rem ���[�v���������
set /a roopCnt=%countMainPage% / %pageCnt%

rem ���[�v�����̗]��y�[�W��
set /a roopCntRst=%countMainPage% %% %pageCnt%

echo.
echo �{���������J�n���܂�...
echo �{���y�[�W���F%countMainPage%

rem ���[�v�����s�v�ȃy�[�W���̏ꍇ
if %roopCnt%==0 ( 
set roopCnt=1
set pageCnt=%countMainPage%
set roopCntRst=0
 ) else ( 
echo �����y�[�W���F%pageCnt%
echo ���[�v������: %roopCnt%�i%roopCntRst%�]��j
 ) 

::MainRoop

rem ���y�[�W�����w�肳�ꂽ�����y�[�W���Ŋ������񐔕����[�v����
for /l %%j in ( 1,1,%roopCnt%) do ( 
set param=
echo -----
echo ���[�v #%%j
call :baseNumber %%j
echo -----

rem �\�����܂ލŏ��̃��[�v��2��ڈȍ~�ŏ����𕪂��ăp�����[�^����
if %%j==1 ( call :firstRoop %%j ) else ( call :secondRoop %%j ) 

call :dropret %param%

 ) 

rem �]�����y�[�W�̏���
if %roopCntRst% GTR 0 ( 
set baseNum=%pageNum%
set param=
echo -----
echo �]��y�[�W
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


rem �y�[�W�ԍ��̃x�[�X�����Z�o����
:baseNumber
if not %1 == 1 ( 
set /a x=%1-1
set /a baseNum="pageCnt * x"
 ) 
goto :eof


rem �y�[�W�ԍ����Z�o���ăp�����[�^������𐶐�����
rem %1 �y�[�W�ԍ� %2 ���[�v�ԍ�
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
echo �{�������I�����܂����B

if %backinnerColor%==1 ( 
echo �����y�[�W�̃t�@�C������ύX���܂�...
pushd %dirname%\iPhone
set /a backinnerColorPageCount= COUNT - 1
rename 998.jpg %backinnerColorPageCount%.jpg
pushd %0\..
 ) 

if %backcoverColor%==1 ( 
echo �ŏI�y�[�W�̃t�@�C������ύX���܂�...
pushd %dirname%\iPhone
rename 999.jpg %COUNT%.jpg
pushd %0\..
 ) 

if exist 7za.exe ( 
echo ZIP���k���܂�...
start /wait 7za.exe a %dirname%\%dirname%.zip %dirname%\iPhone
 ) 

pause

rem ZIP�t�@�C���ړ�
if not %zipSaveDir%=='' ( 
echo ZIP�t�@�C�����ړ����܂�...
move %dirname%\%dirname%.zip %zipSaveDir%
 ) 

rem ----- �I�� -----
:exit

exit
