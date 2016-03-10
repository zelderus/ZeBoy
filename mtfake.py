##
##	Fake-Драйвер дисплея MT-12232A
##	Применяется только для отладки
##	ZeLDER
##



import time




#
#	Работа с дисплеем
#

# инициализация дисплея (драйвера)
def lcdInit():
	return 0

# очистка матрицы и обновление дисплея
def lcdClear():
	return 0

# обновление дисплея данными из матрицы
def lcdDraw():
	print("draw")
	return 0



#
#	Работа с матрицой
#

# очистка матрицы
def mtxClearMatrix():
	return 0

# помещение пикселя в матрицу (будет выведен при обновлении дисплея)
def mtxPutPixel(x, y, bit):
	return 0

