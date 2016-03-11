# kytimer

モトジムカーナ用光電管計測ソフト

====

type1 PC計測型

ハード構成  
PC-マイコン-光電センサ2台  

特徴  
PC側でタイム計測  
スタートとゴールが別  
同時に複数台コースイン可能  

使用ソース  
PC側(Processing) Server/Processing/Processing.pde  
マイコン側(Arduino) Arduino/kytimer.ino  

====

type2 LED表示型

ハード構成
マイコン-光電センサ1台

特徴
LEDでタイム表示
PC無しで動作

使用ソース
STM32Nucleo Nucleo/led/main.cpp
https://developer.mbed.org/users/okazbb/code/KYTIMER2/  

====

type3 ストップウォッチ型

ハード構成  
ストップウォッチ-マイコン-光電センサ1台  

特徴  
ストップウォッチでタイム計測するために安定  
マイコンはディレイタイマ・リレーとしての動作のみ  

使用ソース  
STM32Nucleo Nucleo/stopwatch/main.cpp  
https://developer.mbed.org/users/okazbb/code/KYTIMER3/  

