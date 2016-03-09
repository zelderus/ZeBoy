##
##	Игра для RaspberryPi с использованием дисплея MT-12232A
##	проверка возможностей дисплея
##	ZeLDER
##


import mtdriver as mt
import time


_frameRateSec = 0.2 	# FPS

def setup():
	mt.lcdInit()  	# инициализация
	print("clear")
	mt.lcdClear()	# очистка экрана
	print("inited")
	return 0


def loop():
	inGame = True
	while(inGame):
		try:
			update()
			time.sleep(_frameRateSec)
			render()
		except KeyboardInterrupt:
			inGame = False
			print("exit game")
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

	mt.mtxClearMatrix()

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


#
# рендер изображения
#
def render():
	mt.lcdDraw()
	return 0






# go
setup()
loop()