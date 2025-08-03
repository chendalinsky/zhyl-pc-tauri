@echo off

echo.
echo ===== ����ȡԶ�����´��� =====
git pull --ff-only
if errorlevel 1 (
    echo.
    echo ��ȡʱ������ͻ��� fast-forward�������ֶ�����������б��ű���
    pause
    exit /b
)

echo ��ִ���� ��ȡ ������
echo.
echo.
echo ===== ��ʼִ��Git�ύ������ ===== 
echo.
:: ��ʾ�û������ύ��ע
set /p "user_msg=�����뱾���ύ�İ汾��ע��Ϣ: "

:: ��ȡ��ǰ���ں�ʱ��
set year=%date:~0,4%
set month=%date:~5,2%
set day=%date:~8,2%
set hour=%time:~0,2%
:: ����Сʱ�����ܲ���ǰ��������
if "%hour:~0,1%"==" " set hour=0%hour:~1,1%
set minute=%time:~3,2%
set second=%time:~6,2%

:: �����ύ��Ϣ
set commit_msg="%user_msg% [%year%.%month%.%day% %hour%:%minute%:%second%]"

:: ִ��Git����
echo ִ�� git add . ...
git add .

echo ִ�� git commit -m %commit_msg% ...
git commit -m %commit_msg%

echo ִ�� git push ...
git push

echo �㶨��

echo �����ύ���ļ�����:
echo ----------------------
git show --name-only --pretty=format:
echo ----------------------

pause
    