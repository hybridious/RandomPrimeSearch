RandomPrimeSearch <br />

Usage:<br />
<b>RandomPrimeSearch.exe </b> <br /> 


Example:<br />
Compile using MASM and execute<br />
<b>RandomPrimeSearch.exe</b> - Will begin searching for valid prime numbers within the range specified on line 61

<b>Random-Search(k)</b><br />
Input: an integer k that determines the outer bound -1<br />
Output: a random prime number within bounds k-1<br />
1. Generate random number<br />
2. Check if random number is odd<br />
3. Use trial division to determine whether it is divisible by any factor other than 1 or itself<br />
4. Retry if not prime, Halt if prime<br />