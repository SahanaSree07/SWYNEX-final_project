@echo off
cd /d "%~dp0"
echo ===== Spam Check: setup and launch =====

python --version >nul 2>&1
if errorlevel 1 goto nopython

echo Installing libraries - this can take several minutes the first time...
python -m pip install -r requirements.txt
if errorlevel 1 goto installfail

if exist data\spam.csv goto havedata
echo Downloading the dataset...
python download_data.py
:havedata
if not exist data\spam.csv goto nodata

if exist spam_model.joblib goto havemodel
echo Training the Naive Bayes model...
python spam_classifier.py train --data data/spam.csv
:havemodel
if not exist spam_model.joblib goto nomodel

if exist evaluation_results.json goto haveeval
echo Running the evaluation - a few minutes, it also downloads the pretrained model...
python evaluate.py
:haveeval

echo Starting the app. Your browser will open. Press Ctrl+C in this window to stop.
python server.py
pause
exit /b 0

:nopython
echo Python was not found. Install Python 3.10 or newer from python.org and tick Add Python to PATH, then run this file again.
pause
exit /b 1
:installfail
echo Installing the libraries failed. Check your internet connection and try again.
pause
exit /b 1
:nodata
echo Could not get the dataset. Check your internet connection, or download spam.csv from Kaggle into the data folder.
pause
exit /b 1
:nomodel
echo Training the model failed. Scroll up to read the error message.
pause
exit /b 1
