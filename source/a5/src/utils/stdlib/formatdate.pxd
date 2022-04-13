from libc.time cimport time_t, tm, gmtime_r, time

from .string cimport Str
from .format cimport format


cdef Str day_string(int) nogil
cdef Str month_string(int) nogil
cdef Str formatdate(time_t) nogil
cdef Str formatnow() nogil
cdef Str formatlog() nogil
