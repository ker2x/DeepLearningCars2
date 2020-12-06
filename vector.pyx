#cython: language_level=3, c_api_binop_methods=True

cimport cython
from libc.stdint cimport int64_t, uint64_t
from cpython.sequence cimport PySequence_Check
from libc.math cimport sqrt

cdef inline int _extract(object o, double *x, double *y) except -1:
    cdef int64_t l
    if isinstance(o, Vector):
        x[0] = (<Vector> o).x
        y[0] = (<Vector> o).y
        return 1

    if not PySequence_Check(o):
        return 0
    if len(o) != 2:
        raise TypeError("Tuple was not of length 2")

    x[0] = <double?> o[0]
    y[0] = <double?> o[1]
    return 1


@cython.freelist(512)
cdef class Vector:

    cdef public double x,y
    cdef public Py_ssize_t len
    cdef public int iterator

    def __cinit__(self, *args):
        """Usage :
            Vector() -> create a (0,0) vector
            Vector(vector) -> make a new vector from an existing vector
            Vector((1,2)) -> vector from tuple of length 2
            Vector(1,2) -> vector.x = 1 ; vector.y = 2
        """
        if len(args) == 2:
            self.x = <double?> args[0]
            self.y = <double?> args[1]
            return
        elif len(args) == 1:
            if _extract(args[0], &self.x, &self.y):
                return
        elif len(args) == 0:
            self.x = .0
            self.y = .0
            return
        raise TypeError(
            "Expected a vector object or tuple, or x and y parameters"
        )

    cdef object stringify(self):
        return f"Vector({self.x!r}, {self.y!r})"

    def __str__(self):
        """Construct a concise string representation."""
        return self.stringify()

    def __repr__(self):
        """Construct a precise string representation."""
        return self.stringify()

    def __init__(self, *args):
        pass

    def __len__(self):
        return 2

    def __getitem__(self, item):
        if item == 0:
            return self.x
        elif item == 1:
            return self.y
        else:
            raise TypeError("Vector is always of length 2, only [0] and [1] are valid, but [%d] was provided" % item )

    def __setitem__(self, key, value):
        if key == 0:
            self.x = <double?>value
        elif key == 1:
            self.y = <double?>value
        else:
            raise TypeError("Vector is always of length 2, only [0] and [1] are valid, but [%d] was provided" % key)

    def __iter__(self):
        self.iterator = 0
        return self

    def __next__(self):
        if self.iterator <= 1:
            self.iterator += 1
            return self[self.iterator - 1]
        else:
            raise StopIteration

    def __hash__(self):
        cdef uint64_t hash, h2, mask = 0xffffffff, shift = 32
        hash = (<uint64_t *> &self.x)[0]
        h2 = (<uint64_t *> &self.y)[0]
        hash = hash ^ (h2 << shift) | (h2 >> shift & mask)
        return hash

    def __abs__(self):
        """return distance from (0,0) : sqrt(x²+y²)"""
        return sqrt(self.x * self.x + self.y * self.y)

    def __mul__(self, other):
        """
        Element wise multiplication of 2 vectors (Hadamard product)
        :param other: Vector
        :return: Vector
        """
        if isinstance(other, Vector):
            return Vector(self.x * other.x , self.y * other.y)
        else:
            raise TypeError("__mul__ -> Vector = Vector * Vector ; but got %s instead" % type(other))

    def __add__(self, other):
        """
        Element wise addition of 2 vectors
        :param other: Vector
        :return: Vector
        """
        if isinstance(other, Vector):
            return Vector(self.x + other.x, self.y + other.y)
        else:
            raise TypeError("__add__ -> Vector = Vector + Vector : but got %s instead" % type(other))

    def __sub__(self, other):
        """
        Element wise subtraction of 2 vectors
        :param other: Vector
        :return: Vector
        """
        if isinstance(other, Vector):
            return Vector(self.x - other.x, self.y - other.y)
        else:
            raise TypeError("__sub__ -> Vector = Vector - Vector : but got %s instead" % type(other))

    def __neg__(self):
        """
        -vector do an elementwise negation of the Vector
        :return: Vector
        """
        return Vector(- self.x, - self.y)

    def __truediv__(self, other):
        """
        Elementwise division of 2 vector
        :param other: Vector
        :return: Vector
        """
        if isinstance(other, Vector):
            return Vector(self.x / other.x , self.y / other.y)
        else:
            raise TypeError("__truediv__ -> Vector = Vector / Vector ; but got %s instead" % type(other))

    def __eq__(self, other):
        cdef double x2, y2
        cdef bint res
        if not _extract(other, &x2, &y2):
            return NotImplemented
        res = self.x == x2 and self.y == y2
        return res

    def add(self, other):
        """
        in-place addition
        :param other: Vector to add to self
        """
        self.x += other[0]
        self.y += other[1]

    def sub(self, other):
        """
        in-place subtraction
        :param other: Vector to sub to self
        """
        self.x -= other[0]
        self.y -= other[1]

    def mul(self, other):
        """
        in-place multiplication
        :param other: Vector to mul to self
        """
        self.x *= other[0]
        self.y *= other[1]

    def div(self, other):
        """
        in-place division
        :param other: Vector to div to self
        """
        self.x /= other[0]
        self.y /= other[1]

