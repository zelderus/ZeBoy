##
##	Вывод статической картинки RaspberryPi с использованием дисплея MT-12232A
##	простой пример
##	ZeLDER
##


import mtdriver as mt
#import mtfake as mt



def setup():
	mt.lcdInit()  	# инициализация
	mt.lcdClear()	# очистка экрана
	print("inited")
	return 0


#
# рисуем
#
def draw():

	# рисуем в матрицу
	mt.mtxPutPixel(0, 1, 1)
	mt.mtxPutPixel(0, 2, 1)
	mt.mtxPutPixel(0, 3, 1)
	mt.mtxPutPixel(0, 4, 1)
	mt.mtxPutPixel(0, 5, 1)
	mt.mtxPutPixel(0, 6, 1)

	# вывод на дисплей
	mt.lcdDraw()
	return 0







# go
setup()
draw()