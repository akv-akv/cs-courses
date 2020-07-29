from cs50 import get_int

while True:
    num = get_int("Height: ")
    if (1 <= (num) <= 8):
        break
for i in range(1, num + 1):
    print(" " * (num - i) + "#" * i)