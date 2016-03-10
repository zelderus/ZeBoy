##
##	Игра для RaspberryPi с использованием дисплея MT-12232A
##	проверка возможностей дисплея
##	ZeLDER
##


#import mtdriver as mt
import mtfake as mt
import time
import datetime as dt

import curses
window = curses.initscr()
window.nodelay(1)




_frameRateSec = 1.0/3 	# FPS

def setup():
	mt.lcdInit()  	# инициализация
	print("clear")
	mt.lcdClear()	# очистка экрана
	print("inited")
	return 0


_lastTime = 0.0

def start():
	global _lastTime, _L
	_lastTime = dt.datetime.now()
	loop() #go
	return 0


def loop():
	global _lastTime
	inGame = True
	while(inGame):
		try:
			mt.mtxClearMatrix()
			update()
			mt.lcdDraw()
			# timer fps
			now = dt.datetime.now()
			delta = (now -_lastTime).total_seconds()
			d = _frameRateSec - delta
			if (d > 0.0):
				time.sleep(d)
			_lastTime = dt.datetime.now()
		except KeyboardInterrupt:
			inGame = False
			print("\nexit game")
	return 0


#
# data
#

_xpos = 0
_ch = 0

def input_thread(n):
	while(True):
		derp = input()
		print("itrhread: " + str(derp))
		n.append(derp)



#
# обновление логики игры
#
def update():
	global _xpos, window


	_ch = int(window.getch())
	if (_ch == 97):
		_xpos = _xpos - 1
	if (_ch == 115):
		_xpos = _xpos + 1
	#print(str(_ch))
	



	mt.mtxPutPixel(0, 1, 1) 	#рисуем
	mt.mtxPutPixel(0, 2, 1)
	mt.mtxPutPixel(0, 3, 1)
	mt.mtxPutPixel(0, 4, 1)
	mt.mtxPutPixel(0, 5, 1)
	mt.mtxPutPixel(0, 6, 1)

	#_xpos = _xpos + 1
	if _xpos > 122:
		_xpos = 0
	if _xpos < 0:
		_xpos = 122
	mt.mtxPutPixel(_xpos, 9, 1)
		

	return 0






if __name__ == "__main__" :
	# go
	setup()
	start()