##
##	Игра для RaspberryPi с использованием дисплея MT-12232A
##	проверка возможностей дисплея
##	ZeLDER
##


import mtdriver as mt
import time


_frameRateSec = 0.5

def setup():
	mt.lcdInit()  	# инициализация
	print("clear")
	mt.lcdClear()	# очистка экрана
	_frameRateSec = 0.5 # FPS
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
# обновление логики игры
#
def update():
	mt.mtxClearMatrix()


	mt.mtxPutPixel(0, 1, 1) 	#рисуем
	mt.mtxPutPixel(0, 2, 1)
	mt.mtxPutPixel(0, 3, 1)
	mt.mtxPutPixel(0, 4, 1)
	mt.mtxPutPixel(0, 5, 1)
	mt.mtxPutPixel(0, 6, 1)
	mt.mtxPutPixel(121, 9, 1)

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