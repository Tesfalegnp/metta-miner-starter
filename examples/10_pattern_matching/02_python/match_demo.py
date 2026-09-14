#!/usr/bin/env python3
"""Simple structural matching demo in Python."""

facts = [("PersonLikes","Soda","Alice"), ("PersonLikes","Tea","Bob")]

def find_likers(drink):
    return [s for (p,d,s) in facts if d == drink]

def main():
    print('Soda likers ->', find_likers('Soda'))

if __name__ == '__main__':
    main()
