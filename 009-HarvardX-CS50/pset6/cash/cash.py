from cs50 import get_float
from math import floor

while True:
    dollars = get_float("Change owed: ")
    if dollars > 0:
        break

cents = round(dollars * 100)
quaters = floor(cents / 25)
cents = cents % 25
dimes = floor(cents / 10)
cents = cents % 10
nickels = floor(cents / 5)
cents = cents % 5
pennies = cents
print("{}".format(pennies + nickels + dimes + quaters))
