from cs50 import get_int
from math import floor

# Getting input from user
card = get_int("Number: ")
size = len(str(card))
card_str = str(card)
print(size)

# Checking length
if size in [13, 15,16]:
    # Convert int to array of digits
    n = []
    for i in range(size):
        n.append(card % 10);
        card = floor(card / 10);
    sumOdd = 0
    sumEven = 0
    # Calculation in accordance with Luhn's algorithm
    for i in range(1, size, 2):
        sumOdd += (n[i] * 2 % 10) + floor(n[i] * 2 / 10)
    for i in range(0, size, 2):
        sumEven += n[i]
    luhn = sumOdd + sumEven
    print(n)
    # if card number is valid (luhn), then check special parameters - length and first digits
    if ((luhn % 10) == 0):
        if ((size == 15) and (n[size - 1] == 3)) and ((n[size - 2] == 4) or (n[size - 2] == 7)):
            print("AMEX")
        elif ((size == 16) and (n[size - 1] == 5)
    and (n[size - 2] == 1 or n[size - 2] == 2 or
    n[size - 2] == 3 or n[size - 2] == 4 or n[size - 2] == 5)):
            print("MASTERCARD")
        elif (((size == 13) or (size == 16)) and (n[size - 1] == 4)):
            print("VISA")
        else:
            print("INVALID")
    else:
        print("INVALID")
else:
    print("INVALID")


