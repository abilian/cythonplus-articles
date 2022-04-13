from libcpp.algorithm cimport sort, reverse, copy

from libcythonplus.list cimport cyplist

# define a specialized type: list of int XXXX
ctypedef cyplist[int] IntList


cdef void sort_list(IntList) nogil
cdef void reverse_list(IntList) nogil
cdef int min_list(IntList) nogil
cdef int max_list(IntList) nogil
cdef int sum_list(IntList) nogil
cdef IntList copy_list(IntList) nogil
cdef IntList copy_slice(IntList, size_t, size_t) nogil
cdef IntList copy_slice_from(IntList, size_t) nogil
cdef IntList copy_slice_to(IntList, size_t) nogil
