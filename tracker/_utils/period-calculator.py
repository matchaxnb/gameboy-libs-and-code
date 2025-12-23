#!python
for i in range(2047, -1, -1):
    freq = 131072 / (2048 - i)
    print(f"; period = {i} -> freq = {freq}")
