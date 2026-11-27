"""Simple command-line calculator."""

def add(a, b):
    return a + b

def subtract(a, b):
    return a - b

def multiply(a, b):
    return a * b

def divide(a, b):
    if b == 0:
        raise ValueError("Division by zero is not allowed")
    return a / b

def main():
    print("Simple Calculator")
    a = float(input("First number: "))
    op = input("Operation (+, -, *, /): ")
    b = float(input("Second number: "))
    ops = {"+": add, "-": subtract, "*": multiply, "/": divide}
    print("Result:", ops[op](a, b))

if __name__ == "__main__":
    main()
