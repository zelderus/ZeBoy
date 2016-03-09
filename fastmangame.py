##
##	Игра для RaspberryPi с использованием дисплея MT-12232A
##	ZeLDER
##


import mtdriver as mt


def setup():
	mt.lcdInit()  	# инициализация
	mt.lcdClear()	# очистка экрана
	return 0


def loop():
	# TODO: time step !
	update()
	render()
	return 0


#
# обновление логики игры
#
def update():
	mt.mtxClearMatrix()

	mt.mtxPutPixel(1, 1, 1) 	#рисуем
	mt.mtxPutPixel(1, 2, 1)
	mt.mtxPutPixel(1, 3, 1)
	mt.mtxPutPixel(1, 4, 1)
	mt.mtxPutPixel(1, 5, 1)
	mt.mtxPutPixel(1, 6, 1)

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