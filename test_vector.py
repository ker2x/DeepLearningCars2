from unittest import TestCase
from vector import Vector
import timeit
from math import sqrt

class TestVector(TestCase):

    def test_init_empty(self):
        v = Vector()
        self.assertEqual(0, v.x)
        self.assertEqual(0, v.y)

    def test_init_tuple(self):
        tuple = Vector((1,2))
        self.assertEqual(1, tuple.x)
        self.assertEqual(2, tuple.y)

    def test_init_list(self):
        list = Vector([3,4])
        self.assertEqual(3, list.x)
        self.assertEqual(4, list.y)

    def test_init_fromVector(self):
        v1 = Vector(1,2)
        v2 = Vector(v1)
        self.assertEqual(1, v2.x)
        self.assertEqual(2, v2.y)

    def test_get_as_list(self):
        v1 = Vector(1,2)
        self.assertEqual(1, v1[0])
        self.assertEqual(2, v1[1])
        with self.assertRaises(TypeError):
            v1[2]
        with self.assertRaises(TypeError):
            v1[0.5]
        with self.assertRaises(TypeError):
            v1[-1]

    def test_set_as_list(self):
        v1 = Vector(1,2)
        v1[0] = 3
        self.assertEqual(3, v1.x)
        v1[1] = 4
        self.assertEqual(4, v1.y)
        with self.assertRaises(TypeError):
            v1[2] = 0

    def test_iter(self):
        t = 3
        for i in Vector(3,4):
            self.assertEqual(t, i)
            t += 1

    def test_len(self):
        v = Vector()
        self.assertEqual(2, len(v))

    def test_abs(self):
        v = Vector(1,1)
        self.assertEqual(sqrt(2), abs(v))

    def test_mul(self):
        v = Vector(2,3) * Vector(4,5)
        self.assertTrue(v.x == 8 and v.y == 15)
        with self.assertRaises(TypeError):
            v = Vector() * 1

    def test_mul2(self):
        v = Vector(2,3) * Vector(4,5)
        v *= Vector(2,2)
        self.assertTrue(v.x == 16 and v.y == 30)
        with self.assertRaises(TypeError):
            v *= 1

    def test_add(self):
        v = Vector(1,2) + Vector(3,4)
        self.assertTrue(v.x == 4 and v.y == 6)
        with self.assertRaises(TypeError):
            v = Vector() + 1

    def test_add2(self):
        v = Vector(1,2) + Vector(3,4)
        v += Vector(10,10)
        self.assertTrue(v.x == 14 and v.y == 16)
        with self.assertRaises(TypeError):
            v += 1

    def test_sub(self):
        v = Vector(1,6) - Vector(3,4)
        self.assertTrue(v.x == -2 and v.y == 2)
        with self.assertRaises(TypeError):
            v = Vector() - 1

    def test_sub2(self):
        v = Vector(1,6) - Vector(3,4)
        v -= Vector(1,2)
        self.assertTrue(v.x == -3 and v.y == 0)
        with self.assertRaises(TypeError):
            v -= 1

    def test_neg(self):
        a = Vector(-1,6)
        v = -a
        self.assertTrue(v.x == 1 and v.y == -6)

    def test_div(self):
        v = Vector(16,18) / Vector(2,3)
        self.assertTrue(v.x == 8 and v.y == 6)
        with self.assertRaises(TypeError):
            v = Vector() / 1

    def test_div2(self):
        v = Vector(16,18) / Vector(2,3)
        v /= Vector(2,2)
        self.assertTrue(v.x == 4 and v.y == 3)
        with self.assertRaises(TypeError):
            v /= 1

    def test_speed(self):
        t = timeit.Timer('v = Vector()', 'from vector import Vector').autorange()
        print("Benchmark : v = Vector() : ", t)

    def test_to_string(self):
        v = Vector(-2, .5)
        print(v)
        self.assertEqual("Vector(-2.0, 0.5)", str(v))

    def test_equality(self):
        x = Vector()
        y = Vector()
        z = Vector(1,1)
        self.assertTrue(x == y)
        self.assertFalse(x == z)
        self.assertTrue(z == z)
        self.assertTrue(y != z)
        self.assertFalse(x != x)
        self.assertTrue(x == (0,0))
        self.assertTrue(x == [0,0])
        self.assertFalse(x != (0,0))
        self.assertFalse(x != [0,0])

    def test_inplace_add(self):
        v = Vector(1,2)
        w = Vector(3,4)
        v.add(w)
        self.assertEqual(Vector(4,6), v)
        self.assertNotEqual(Vector(0,0), v)
        v.add((1,2))
        self.assertEqual(Vector(5,8), v)
        v.add([1,2])
        self.assertEqual(Vector(6,10), v)

    def test_inplace_sub(self):
        v = Vector(1,4)
        w = Vector(3,2)
        v.sub(w)
        self.assertEqual(Vector(-2,2), v)
        self.assertNotEqual(Vector(0,0), v)
        v.sub((1,2))
        self.assertEqual(Vector(-3,0), v)
        v.sub([1,2])
        self.assertEqual(Vector(-4,-2), v)

    def test_inplace_mul(self):
        v = Vector(1,4)
        w = Vector(3,2)
        v.mul(w)
        self.assertEqual(Vector(3,8), v)
        self.assertNotEqual(Vector(0,0), v)
        v.mul((2,3))
        self.assertEqual(Vector(6,24), v)
        v.mul([2,-2])
        self.assertEqual(Vector(12,-48), v)

    def test_inplace_div(self):
        v = Vector(100,200)
        w = Vector(2,50)
        v.div(w)
        self.assertEqual(Vector(50,4), v)
        self.assertNotEqual(Vector(0,0), v)
        v.div((5,2))
        self.assertEqual(Vector(10,2), v)
        v.div([2,-2])
        self.assertEqual(Vector(5,-1), v)

    def test_tuple(self):
        self.assertEqual(2, Vector(2,3)[0])
        self.assertEqual((2,3), Vector(2,3))
        self.assertEqual([2,3], Vector(2,3))

    def test_hash(self):
        v = Vector()
        w = Vector()
        z = Vector(1,2)
        self.assertEqual(hash(v), hash(w))
        self.assertNotEqual(hash(v), hash(z))