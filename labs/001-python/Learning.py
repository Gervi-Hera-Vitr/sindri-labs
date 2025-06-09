# # Printing
# print("Hello World")
#
# # Variables
# # integer
# age = 19
# # string
# name = "John Doe"
# # boolean
# tall = True
# # float
# gpa = 3.99
# print(name)
# print(age)
# print(tall)
# print(gpa)
# print("My name is " + name + " and I am " + str(age) + " years old" + " and me being tall is " + str(tall) + " and my gpa is " + str(gpa) + " out of 4.0")
# # if statements
# if age > 18:
#     print("You are an adult")
# else:
#     print("You are not an adult")
#
# if tall:
#     print("You are tall")
# else:
#     print("You are not tall")
#
# # typecasting
# print(type(age))
# print(type(name))
# print(type(tall))
# print(type(gpa))
# gpa = str(gpa)
# print(type(gpa))
# age = float(age)
# print(type(age))
# # input
# name = input("Enter your name: ")
# age = int(input("Enter your age: "))
# print("My name is " + name + " and I am " + str(age) + " years old")
# print("lets see the pythagorean theorem")
# length = float(input("Enter the length: "))
# width = float(input("Enter the width: "))
# third_side_length = ((length ** 2) + (width ** 2)) ** 0.5
# print("The third side length is " + str(third_side_length))
# area = length * width / 2
# print("The area is " + str(area))
# # arithmetic operators
# #adds
# print("3 + 2 = " + str(3 + 2))
# #subtracts
# print("3 - 2 = " + str(3 - 2))
# #multiplies
# print("3 * 2 = " + str(3 * 2))
# #divides
# print("3 / 2 = " + str(3 / 2))
# print("3 // 2 = " + str(3 // 2))
# print("3 % 2 = " + str(3 % 2))
# print("3 ** 2 = " + str(3 ** 2))
#
# # logical operators
# print("3 > 2 = " + str(3 > 2))
# print("3 < 2 = " + str(3 < 2))
# print("3 >= 2 = " + str(3 >= 2))
# print("3 <= 2 = " + str(3 <= 2))
# print("3 == 2 = " + str(3 == 2))
# print("3 != 2 = " + str(3 != 2))
#
# # More math
# import math
# x = 3.2
# y = 2
# z = 1
#
# print(round(x))
# print(abs(x))
# print(pow(x, y))
# print(max(x, y, z))
# print(min(x, y, z))
#
# print (math.floor(x))
# print (math.ceil(x))
# print (math.sqrt(x))
# print (math.pi)
# print (math.e)
#
# # conditional expressions
# a = 10
# b = 20
# c = 30
# temp = 80
# print("a is the largest number" if a > b and a > c else "a is not the largest number")
# if a % 2 == 0: print("a is an even number")
#
# weather = "HOT" if temp > 70 else "BREEZY"
# print(weather)
# string methods
# name =  input("Enter your name: ")
# print(name)
# print(name.upper())
# print(name.lower())
# print(name.find("o"))
# print(name.replace("o", "a"))
# print(name.split(" "))
# print(name.find("a"))

# # Indexing
# credit_card_number = "1234-5678-9012-3456"
# print(credit_card_number[0])
# print(credit_card_number[1])
# print(credit_card_number[2])
# print(credit_card_number[3])
# last_digit = credit_card_number[-4:]
# print(last_digit)

# # format specifiers
# price = 10
# quantity = 5
# print("The price is %d and the quantity is %d" % (price, quantity))
# print(f"the price is ${price:^10.2f}")

# #Loops
# # while loops
# age = 0
# while age < 18:
#     print("You are not an adult")
#     age += 1
#
# else:
#     print("You are an adult")
#
# # for loops
# fruits = ["apple", "banana", "cherry"]
# for fruit in fruits:
#     print(fruit)
#
# # enumerate
# for index, fruit in enumerate(fruits):
#     print(index, fruit)
#
# # range
# for i in range(10):
#     print(i)

# nested loops
# loops inside of loops
# for i in range(3):
#     for j in range(3):
#         print(i, j)

# break and continue
# for i in range(10):
#     if i == 5:
#         break
#     print(i)
# for i in range(10):
#     if i == 5:
#         continue
#     print(i)
# # infinite loop
# while True:
#     print("Hello world")

# list = [] Ordered and changeable, allows duplicates
# set = () Unordered and unchangeable, no duplicates, but add and remove are allowed
# tuple = {} Ordered and unchangeable, duplicates are allowed.
# print(help()) # for helping with changing list, sets, or tuples, or dictionaries.

#2d list
# list1 = [1, 2, 3]
# list2 = [4, 5, 6]
# list3 = [7, 8, 9]
# 2d_List = [list1, list2, list3]
# print(2d_List)

# # dictionaries = {key: value} pairs
# dictionary = {"name": "John", "age": 30, "city": "New York"}
# print(dictionary)
# print(dictionary["name"])
# print(dictionary.get("name"))
# print(dictionary.keys())
# print(dictionary.values())
# dictionary["name"] = "Jane"
# print(dictionary)

# # random numbers
# import random
# print(random.randint(1, 10))

# functions
import random
def greeting(name, response, karma):
    karma = random.randint(1, 100)
    greet = {1: "Hello, my name is", 2: "Ew go away!"}
    name = input("Enter your name: ")
    if karma > 50: print(greet[1] + " " + name + "!")
    else: print(greet[2])

greeting(input("Enter your name: "), "Hello", "Karma")







