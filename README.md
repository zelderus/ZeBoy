# ZeBoy
Hard-проект. 
Последовательное создание портативной консоли.
[Справочник-описание][lnk_help].

Цель
--------
- Изучение RaspberryPi
- Изучение основ электротехники
- Применение внешних дисплеев. Работа на самом низком уровне
- Программирование микроконтроллеров

Применяемое железо
--------
- RaspberryPi 2 (написание кода, программатор)
- Кучка транзисторов, резисторов и прочего
- LCD MT-12232A
- Atmel AT89C2051

Программы под RPi
----------
Лежат в папке `src_rpi`. Предназначены для запуска с RaspberryPi2. Как правило в каждом файле указано к каким пинам подключать конкретное устройство.
- mtdriver.py (драйвер работы с дисплеем)
- statpic.py (простой пример вывода изображения на дисплей)
- fastmangame.py (игра для RaspberryPi с использованием дисплея MT-12232A)
- pr8051.py (драйвер для [программатора PR8051.1][lnk_help_pr8051] для записи программы на МK AT89C2051).

Программы под MK
----------
Лежат в папке `src_mk`. Предназначены для прошивки на микроконтроллер.
- mktolcd.asm (.hex, .bin) программа (драйвер) для МК (AT89C2051) для работы с дисплеем
- fastman.asm (.hex, .bin) игра для МК (AT89C2051) для работы с дисплеем


[lnk_help]: <http://zedk.ru/ss/zeboy/index.html>
[lnk_help_pr8051]: <http://zedk.ru/ss/zeboy/Pages/at89c2051.html>