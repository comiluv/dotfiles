import pathlib
import os
def primes(n: int):
    """Return a list of the first n primes."""
    sieve = [True] * n
    x = 0
    res = []
    for i in range(2, n):
        if sieve[i]:
            res.append(i)
            for j in range(i**2, n, i):
                sieve[j] = False
    return res
xs = primes(100)
ys = primes("spam")
print(xs)                   







