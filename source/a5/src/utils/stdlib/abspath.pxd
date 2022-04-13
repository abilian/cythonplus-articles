from libc.stdlib cimport free
from posix.stdlib cimport realpath

from .string cimport Str


cdef Str abspath(Str) nogil
