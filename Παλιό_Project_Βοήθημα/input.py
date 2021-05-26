import math 
import panda as pd
from function import * 
from os import path as example 

class class_ex():
	def __init__(self,name,year,id):
		self.name = name
		self.year = year
		self.id = id

	def def_example(var):
		if var == 100: 
			print("The number is 100") 
		#comment
		count=10
		for count in range(100):
			print("For statement with 90 loops")

#main function
def main():
	print("Compiler Testing:\n") 

	#list dictionary
	list1 = { Country1 : "GREECE" , Country2 : "CYPRUS"}
	list2 = dict1( [ (Town1, "Athens") , (Town2, "Thessalloniki"), (Town3, "Patra") , (Town4, "Chania") ] )
	list3 = dict2( Athens= "Town1" , Thessalloniki= "Town2" , Patra= "Town3" , Chania= "Town4" )

	#create an object
	obj = class_ex("CEID", 2020, 11111111) 

	#function call
	def_example(100)

	#arithmetic expressions
	num1 = 100
	num2 = 10
	plus = num1+num2
	mul = num1*num2

	var1 = 10
	var2 = 15
	#lambda calculus 
	lambda_exx = lambda vari : def_example(var1)
	lambda_ex = lambda variable : var2+var1
	lambda_ex1 = lambda variable1 : lambda variable2 : var1*var2

