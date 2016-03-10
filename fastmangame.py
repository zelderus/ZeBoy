##
##	Игра для RaspberryPi с использованием дисплея MT-12232A
##	проверка возможностей дисплея
##	ZeLDER
##


#import mtdriver as mt
import mtfake as mt
import time
import datetime as dt


_frameRateSec = 1.0/3 	# FPS

def setup():
	mt.lcdInit()  	# инициализация
	print("clear")
	mt.lcdClear()	# очистка экрана
	print("inited")
	return 0


_lastTime = 0.0

def start():
	global _lastTime
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

#
# обновление логики игры
#
def update():
	global _xpos


	mt.mtxPutPixel(0, 1, 1) 	#рисуем
	mt.mtxPutPixel(0, 2, 1)
	mt.mtxPutPixel(0, 3, 1)
	mt.mtxPutPixel(0, 4, 1)
	mt.mtxPutPixel(0, 5, 1)
	mt.mtxPutPixel(0, 6, 1)

	_xpos = _xpos + 1
	if _xpos > 122:
		_xpos = 0
	mt.mtxPutPixel(_xpos, 9, 1)
		

	return 0







# go
setup()
start()