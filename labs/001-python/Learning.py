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

# # functions
# import random
# def greeting(name, response, karma): # default values can be assigned here to!
#     karma = random.randint(1, 100)
#     greet = {1: "Hello, my name is", 2: "Ew go away!"}
#     name = str(name)
#     if karma > 50: print(greet[1] + " " + name + "!")
#     else: print(greet[2])
#
# greeting(input("Enter your name: "), "Hello", "Karma")# here you can assign values by putting it in normally, or: greeting("name", karma="Karma", response="Hello")
#
# def add(*args): # tuple
#     total = 0
#     for num in args:
#         total += num
#     return total
#
# print(add(1, 2, 3, 4, 5))
#
#
# def add(**kwargs): # dictionary
#     total = 0
#     for num in kwargs.values():
#         total += num
#     return total
#
# print(add(a=1, b=2, c=3, d=4, e=5))


# # iterables, an object/collection that can return elements one at a time, letting it be able to irterate over a loop.
# numbers = [1, 2, 3, 4, 5]
# for num in numbers:
#     print(num)
#
# # membership operators
# # in, not in

# # List Comprehension = a way to create a new list in python, more compact and readable
# numbers = [1, 2, 3, 4, 5]
# new_list = [num * 2 for num in numbers]
# print(new_list)
#
# # Match case statement(switch statement)
#
# def get_day(day):
#     match day:
#         case 1:
#             return "Monday"
#         case 2:
#             return "Tuesday"
#         case 3:
#             return "Wednesday"
#         case 4:
#             return "Thursday"
#         case 5:
#             return "Friday"
#         case 6:
#             return "Saturday"
#         case 7:
#             return "Sunday"
#         case _:
#             return "Invalid day"
#
# print(get_day(4))

# # modules are files that contain code that can be imported and used in other files, there are many already in python and you can create your own modules. use import module_name.
# print(help("modules"))

# variable scope = where a variable is accessible and can be used.
# scope resolution = Local > Enclosed > Global > Built-in

# def main():
#     # program code goes here
#
# if __name__ == "__main__":
#     main() # now you can use classes and functions from the main file. this is like a library.

# object = a bundle of related attributes and methods.
# class = a blueprint for the layout of an object.

# # classes
# class Person:
#     def __init__(self, name, age):
#         self.name = name
#         self.age = age
#
#     def greet(self):
#         print(f"Hello, my name is {self.name} and I am {self.age} years old.")
#
# person1 = Person("John", 50)
# person1.greet()
#

# class Sword:
#     def __init__(self, name, damage, durability):
#         self.name = name
#         self.damage = damage
#         self.durability = durability
#
#     def attack(self):
#         self.durability -= 1
#         return self.damage
#
#
# class Knife (Sword):
#     def __init__(self, name, damage, durability):
#         super().__init__(name, damage, durability)
#
# knife = Knife("Knife", 10, 100)
# print(knife.attack())
#
# class Axe:
#     def __init__(self, name, damage, durability, chopping_speed):
#         self.name = name
#         self.damage = damage
#         self.durability = durability
#         self.chopping_speed = chopping_speed
#
#     def attack(self):
#         self.durability -= 1
#         return self.damage
#
#     def chop(self):
#         self.durability -= 1
#         return self.chopping_speed
#
# class AxeSword(Sword, Axe):
#     def __init__(self, name, damage, durability, chopping_speed):
#         self.name = name
#         self.damage = damage
#         self.durability = durability
#         self.chopping_speed = chopping_speed
#
# AxeSword = AxeSword("AxeSword", 10, 100, 20)
# print(AxeSword.chop())

#super() = call the constructor of the parent class

# Polymorphism = to have many forms
# Inheritance = to inherit attributes and methods from a parent class
# duck typing = object must have necessary attributes/methods

# from abc import ABC, abstractmethod
#
# class Shape(ABC):
#     @abstractmethod
#     def area(self):
#         pass

# # duck typing: if it moves like a duck, swims like a duck, and quacks like a duck, then it is a duck
#
# class Animal:
#
#     def speak(self):
#         pass
#
# class Dog(Animal):
#
#     def speak(self):
#         print("Woof woof")
#
# class Cat(Animal):
#
#     def speak(self):
#         print("Meow meow")
# class car:
#
#         def speak(self):
#             print("Vroom vroom")
#
# animals = [Dog(), Cat(), car()]
#
# for animal in animals:
#     animal.speak()

# static method = a method that belongs to a class, not to an instance of a class
# instance method = best for operations of instances of classes(objects)

# class Employee:
#
#     def __init__(self, name, position):
#         self.name = name
#         self.position = position
#
#         def get_info(self):
#             return f"{self.name} is a {self.position}"
#         @staticmethod
#         def valid_position(position):
#             valid_positions = ["manager", "developer", "tester"]
#             return position in valid_positions
#
# print(Employee.valid_position("tester")) # True

# # Class Methods = Allow operations to be performed on the class itself
#
# class student:
#     count = 0
#     def __init__(self, name, age, gpa):
#         self.name = name
#         self.age = age
#         self.gpa = gpa
#         student.count += 1
#
#     def get_info(self):
#         return f"{self.name} is {self.age} years old and has a gpa of {self.gpa}"
#
#     @classmethod
#     def get_count(cls):
#         return f"There are {cls.count} students in this class"
#
# student1 = student("John", 20, 3.9)
# student2 = student("Jane", 21, 3.8)
# student3 = student("Bob", 22, 3.7)
#
# print(student.get_count())

# MAGIC METHODS
# __init__ = constructor
# __str__ = string representation
# __eq__ = equal too
# __lt__ = less than
# __gt__ = greater than

# # properties, setter, getter and deleter method
# class rectangle:
#     def __init__(self, width, height):
#         self.width = width
#         self.height = height
#
#     @property
#     def width(self):
#         return f"Width: {self.__width}cm"
#
#     property
#     def height(self):
#         return f"Height: {self.__height}cm"
#

# # decorator = a function that extends the behavior of another function, without modifying the base function.
# # pass the base function as an argument to the decorator
#
# def add_sprinkles(func):
#     def wrapper():
#         print("Adding sprinkles")
#         func()
#     return wrapper
#
# @add_sprinkles
# def get_ice_cream():
#     print("Getting ice cream")
#
# get_ice_cream()

# # multithreading = multiple threads of execution, good for multitasking
# import threading
# import time
#
#
# def laundry():
#     time.sleep(8)
#     print("Washing clothes")
#     print("Dry clothes")
#     print("Fold clothes")
#
# def cooking():
#     time.sleep(5)
#     print("Cooking food")
#     print("Serving food")
#
#
# def dishes():
#     time.sleep(3)
#     print("Cleaning dishes")
#
# chore1 = threading.Thread(target=laundry)
# chore2 = threading.Thread(target=cooking)
# chore3 = threading.Thread(target=dishes)
#
# chore1.start()
# chore2.start()
# chore3.start()
#
