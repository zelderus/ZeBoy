
#
#	Programm for write data to AT89C2051 by RaspberryPi2
#	ZeLDER
#


import RPi.GPIO as GPIO
import time



# pins
_xl1	= 9
_rst 	= 11
_p3_1 = 1
_p3_2 = 1
_p3_i3_4_5_7 = 1


_p1_0 = 1
_p1_1 = 1
_p1_2 = 1
_p1_3 = 1
_p1_4 = 1
_p1_5 = 1
_p1_6 = 1
_p1_7 = 1







#
# setup
#
def setupPins():
	##    GPIO.setmode(GPIO.BOARD)
	GPIO.setmode(GPIO.BCM)
	GPIO.setwarnings(False)
	# com
	GPIO.setup(_xl1, GPIO.OUT)
	GPIO.setup(_rst, GPIO.OUT)
	#
	GPIO.setup(_p1_0, GPIO.OUT)
	GPIO.setup(_p1_1, GPIO.OUT)
	GPIO.setup(_p1_2, GPIO.OUT)
	GPIO.setup(_p1_3, GPIO.OUT)
	GPIO.setup(_p1_4, GPIO.OUT)
	GPIO.setup(_p1_5, GPIO.OUT)
	GPIO.setup(_p1_6, GPIO.OUT)
	GPIO.setup(_p1_7, GPIO.OUT)
	#
	GPIO.setup(_p3_1, GPIO.OUT)
	GPIO.setup(_p3_2, GPIO.OUT)
	GPIO.setup(_p3_i3_4_5_7, GPIO.OUT)
	return 0


def delayMs(ms):
	time.sleep(ms/1000.0)

def delayUs(us):
	time.sleep(us/1000000.0)

def delayNs(ns):
	time.sleep(ns/1000000000.0)


def setRst(b):
	GPIO.output(_rst, GPIO.HIGH if b == 0 else GPIO.LOW) # transistor invert
def setXl1(b):
	GPIO.output(_xl1, GPIO.HIGH if b == 0 else GPIO.LOW) # transistor invert
def setPin(pin, b):
	GPIO.output(pin, GPIO.HIGH if b > 0 else GPIO.LOW)

def setData(b):
	GPIO.output(_p1_7, GPIO.HIGH if b&128>0 else GPIO.LOW)
	GPIO.output(_p1_6, GPIO.HIGH if b&64>0 else GPIO.LOW)
	GPIO.output(_p1_5, GPIO.HIGH if b&32>0 else GPIO.LOW)
	GPIO.output(_p1_4, GPIO.HIGH if b&16>0 else GPIO.LOW)
	GPIO.output(_p1_3, GPIO.HIGH if b&8>0 else GPIO.LOW)
	GPIO.output(_p1_2, GPIO.HIGH if b&4>0 else GPIO.LOW)
	GPIO.output(_p1_1, GPIO.HIGH if b&2>0 else GPIO.LOW)
	GPIO.output(_p1_0, GPIO.HIGH if b&1>0 else GPIO.LOW)
	return 0



#
# erase data
#
def erase():
	print("erasing..")
	# mode: erase
	setPin(_p3_i3_4_5_7, 1)
	# erase
	setPin(_p3_2, 0)
	delayMs(10.0)
	setPin(_p3_2, 1)
	setPin(_p3_2, 0)	# ok?
	return 0





#
# write prog to MT
#
def write(firstByte, bts):
	print("writing..")
	setRst(0)	# RST to Low
	setXl1(0)	# XL1 to Low
	
	setRst(1)	# High
	setPin(_p3_2, 1)
	
	# mode: write
	setPin(_p3_i3_4_5_7, 0)

	# set data
	setData(firstByte)
	
	setRst(1)	# 12V
	# pulse
	setPin(_p3_2, 0)
	setPin(_p3_2, 1)
	# next addr - pusle XL1
	setXl1(1)
	setXl1(0)

	for b in bts:
		# set data
		setData(b)
		# pulse
		setPin(_p3_2, 0)
		setPin(_p3_2, 1)
		# next addr - pusle XL1
		setXl1(1)
		setXl1(0)


	# power low
	setXl1(0)
	setRst(0)
	return 0






# init
setupPins()
# erase
erase()
# data to write
fb = 0xCC
bts = []
bts.append(0xBB)
# write
write(fb, bts)


print("..end")


