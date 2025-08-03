@echo off

echo.
echo ===== 先拉取远端最新代码 =====
git pull --ff-only
if errorlevel 1 (
    echo.
    echo 拉取时产生冲突或非 fast-forward，请先手动解决后再运行本脚本！
    pause
    exit /b
)

echo 已执行完 拉取 操作。
echo.
echo.
echo ===== 开始执行Git提交和推送 ===== 
echo.
:: 提示用户输入提交备注
set /p "user_msg=请输入本次提交的版本备注信息: "

:: 获取当前日期和时间
set year=%date:~0,4%
set month=%date:~5,2%
set day=%date:~8,2%
set hour=%time:~0,2%
:: 处理小时数可能不带前导零的情况
if "%hour:~0,1%"==" " set hour=0%hour:~1,1%
set minute=%time:~3,2%
set second=%time:~6,2%

:: 构建提交信息
set commit_msg="%user_msg% [%year%.%month%.%day% %hour%:%minute%:%second%]"

:: 执行Git命令
echo 执行 git add . ...
git add .

echo 执行 git commit -m %commit_msg% ...
git commit -m %commit_msg%

echo 执行 git push ...
git push

echo 搞定！

echo 本次提交的文件如下:
echo ----------------------
git show --name-only --pretty=format:
echo ----------------------

pause
    