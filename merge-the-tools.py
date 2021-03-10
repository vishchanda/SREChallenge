#!/bin/python3
def merge_the_tools(string, k):
    # your code goes here
    if ((1<=len(string)<=(10**4)) and (1<=k<=len(string)) and ((len(string)%k)==0)):
      u = ''
      for i in range(len(string)):
          if string[i] not in u:
              u+=string[i]
          if (i >= 0) and ((i+1)%k == 0):
            print(u)
            u = ''
    else:  print("Constraints voilated !!")     
if __name__ == '__main__':
    string, k = input(), int(input())
    merge_the_tools(string, k)
