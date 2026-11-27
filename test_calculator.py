import unittest
from calculator import add, subtract, multiply, divide, power, modulo

class TestCalculator(unittest.TestCase):
    def test_basic(self):
        self.assertEqual(add(2, 3), 5)
        self.assertEqual(subtract(5, 3), 2)
        self.assertEqual(multiply(4, 3), 12)
        self.assertEqual(divide(10, 4), 2.5)
    def test_power_and_modulo(self):
        self.assertEqual(power(2, 5), 32)
        self.assertEqual(modulo(10, 3), 1)
    def test_zero_errors(self):
        with self.assertRaises(ValueError):
            divide(1, 0)
        with self.assertRaises(ValueError):
            modulo(1, 0)

if __name__ == "__main__":
    unittest.main()
