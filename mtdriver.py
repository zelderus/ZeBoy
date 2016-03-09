##
##	Драйвер работы с дисплеями MT-12232A и аналогичными
##	ZeLDER
##		http://www.melt.com.ru/docs/MT-12232A.pdf
##

#
#	- работа с дисплеем
#		lcdInit()	- инициализация дисплея (драйвера)
#		lcdClear()	- очистка матрицы и обновление дисплея
#		lcdDraw()	- обновление дисплея данными из матрицы
#
#	- работа с матрицой	
#		mtxClearMatrix()		- очистка матрицы (без обновления дисплея)
#		mtxPutPixel(x, y, bit)	- помещение пикселя в матрицу (без вывода на экран)
#


#
# Пример:
#	def setup():
#		lcdInit()  #инициализация
#		lcdClear() #очистка экрана
#	def loop():
#		mtxClearMatrix() 		#очистка матрицы
#		mtxPutPixel(1, 1, 1) 	#рисуем
#		#..
#		lcdDraw()				#рендер конечной картинки на экран


# ...
__mtlcd_pagesize = 8
__mtlcd_width = 122
__mtlcd_heigth = 32

__lcd_matrix = [[0 for x in range(32)] for x in range(122)] 





def _checkPixelRange(x, y):
	if (x < 0 or x >= __mtlcd_width or y < 0 or y >= __mtlcd_heigth):
		return False
	return True


#
#	Работа с дисплеем
#

# инициализация дисплея (драйвера)
def lcdInit():
	#
	__lcd_matrix = [[0 for x in range(__mtlcd_heigth)] for x in range(__mtlcd_width)] 
	return 0

# очистка матрицы и обновление дисплея
def lcdClear():
	mtxClearMatrix()
	lcdDraw()
	return 0

# обновление дисплея данными из матрицы
def lcdDraw():
	#
	return 0



#
#	Работа с матрицой
#

# очистка матрицы
def mtxClearMatrix():
	for y in range(0, __mtlcd_heigth):
		for x in range(0, __mtlcd_width):
			__lcd_matrix[x][y] = 0x00
	return 0

# помещение пикселя в матрицу (будет выведен при обновлении дисплея)
def mtxPutPixel(x, y, bit):
	if (_checkPixelRange(x, y)==False):
		return 0
	if (bit):
		__lcd_matrix[int(y / __mtlcd_pagesize)][x] |= 1 << (y % 8);
	else:
		__lcd_matrix[int(y / __mtlcd_pagesize)][x] &= 0 << (y % 8);


