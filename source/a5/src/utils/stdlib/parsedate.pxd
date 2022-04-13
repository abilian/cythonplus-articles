from libc.time cimport time_t, tm, mktime
from libc.stdlib cimport atoi

from libcythonplus.list cimport cyplist

from .string cimport Str


cdef time_t parsedate(Str) nogil
