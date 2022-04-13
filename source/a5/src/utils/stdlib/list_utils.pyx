from libc.stdio cimport printf
from libcpp.algorithm cimport sort, reverse, copy

from libcythonplus.list cimport cyplist


cdef void sort_list(IntList lst) nogil:
    if lst._active_iterators == 0:
        sort(lst._elements.begin(), lst._elements.end())
    else:
        with gil:
            raise RuntimeError("Modifying a list with active iterators")

cdef void reverse_list(IntList lst) nogil:
    if lst._active_iterators == 0:
        reverse(lst._elements.begin(), lst._elements.end())
    else:
        with gil:
            raise RuntimeError("Modifying a list with active iterators")

cdef int min_list(IntList lst) nogil:
    cdef int m

    if lst.__len__() == 0:
        with gil:
            raise ValueError("min() arg is an empty sequence")
    m = lst[0]
    for e in lst:
        m = min(m, e)
    return m

cdef int max_list(IntList lst) nogil:
    cdef int m

    if lst.__len__() == 0:
        with gil:
            raise ValueError("max() arg is an empty sequence")
    m = lst[0]
    for e in lst:
        m = max(m, e)
    return m

cdef int sum_list(IntList lst) nogil:
    cdef int s, e
    s = 0
    for e in lst:
        s += e
    return s

cdef IntList copy_list(IntList lst) nogil:
    cdef IntList result = IntList()

    if lst._active_iterators == 0:
        result._elements = lst._elements
        return result
    else:
        with gil:
            raise RuntimeError("Modifying a list with active iterators")

cdef IntList copy_slice(IntList lst, size_t start, size_t end) nogil:
    cdef IntList result = IntList()

    if lst._active_iterators == 0:
        for i in range(start, end):
            result._elements.push_back(lst[i])
        return result
    else:
        with gil:
            raise RuntimeError("Modifying a list with active iterators")

cdef IntList copy_slice_from(IntList lst, size_t start) nogil:  # size_type
    return copy_slice(lst, start, lst._elements.size())

cdef IntList copy_slice_to(IntList lst, size_t end) nogil:  # size_type
    return copy_slice(lst, 0, end)
