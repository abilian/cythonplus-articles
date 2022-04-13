from libc.stdlib cimport free
from posix.stdlib cimport realpath

from .string cimport Str


cdef Str abspath(Str path) nogil:
    cdef Str spath
    cdef char* apath = realpath(path.bytes(), NULL)

    if apath == NULL:
        spath = Str("")
    else:
        spath = Str(apath)
    free(apath)
    return spath
