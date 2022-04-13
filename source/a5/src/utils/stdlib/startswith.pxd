from .string cimport Str


cdef bint startswith(Str, Str) nogil
cdef bint endswith(Str, Str) nogil
