from libcythonplus.dict cimport cypdict
from libcythonplus.list cimport cyplist
from libc.stdio cimport printf
from libc.time cimport time_t

from .stdlib.string cimport Str
from .stdlib.format cimport format

from .stdlib.xml_utils cimport replace_one, replace_all
from .stdlib.xml_utils cimport escape, escaped, unescape, unescaped
from .stdlib.xml_utils cimport quoteattr, quotedattr, concate, indented
from .stdlib.strip cimport stripped
from .stdlib.regex cimport regex_t, regmatch_t, regcomp, regexec, regfree
from .stdlib.regex cimport REG_EXTENDED
from .stdlib.abspath cimport abspath
from .stdlib.startswith cimport startswith, endswith
from .stdlib.list_utils cimport IntList, sort_list, reverse_list
from .stdlib.list_utils cimport min_list, max_list, sum_list, copy_list
from .stdlib.list_utils cimport copy_slice, copy_slice_from, copy_slice_to
from .stdlib.formatdate cimport formatdate, formatlog
from .stdlib.parsedate cimport parsedate


cdef void print_str(Str s) nogil:
    printf("    %s\n", s.bytes())

cdef void demo_replace_one():
    cdef Str text
    cdef Str orig
    cdef Str pattern
    cdef Str content

    printf("--- replace_one()\n")
    text = Str("Some string abc abc")
    pattern = Str("abc")
    content = Str("ABC")
    orig = text.copy()
    replace_one(text, pattern, content)
    print_str(format("{} -> {}", orig, text))

cdef void demo_replace_all():
    cdef Str text
    cdef Str orig
    cdef Str pattern
    cdef Str content

    printf("--- replace_all()\n")
    text = Str("Some string abc abc")
    pattern = Str("abc")
    content = Str("ABC")
    orig = text.copy()
    replace_all(text, pattern, content)
    print_str(format("{} -> {}", orig, text))

cdef void demo_escape():
    cdef Str text
    cdef Str orig

    printf("--- escape()\n")
    text = Str("Some string escaped in place < & >")
    orig = text.copy()
    escape(text, NULL)
    print_str(format("{} -> {}", orig, text))

cdef void demo_escaped():
    cdef Str text
    cdef Str orig

    printf("--- escaped()\n")
    text = Str("Some string escaped < & >")
    orig = text.copy()
    text = escaped(orig, NULL)
    print_str(format("{} -> {}", orig, text))

cdef void demo_unescape():
    cdef Str text
    cdef Str orig

    printf("--- unescape()\n")
    text = Str("in place: &lt; &amp; &gt;")
    orig = text.copy()
    unescape(text, NULL)
    print_str(format("{} -> {}", orig, text))

cdef void demo_unescaped():
    cdef Str text
    cdef Str orig

    printf("--- unescaped()\n")
    text = Str("no param: &eacute;&agrave;&eacute; &lt; &amp; &gt;")
    orig = text.copy()
    text = unescaped(orig, NULL)
    print_str(format("{} -> {}", orig, text))

cdef void demo_unescaped_params():
    cdef Str text
    cdef Str orig
    cdef cypdict[Str, Str] more

    more = cypdict[Str, Str]()
    more[Str("&agrave;")] = Str("à")
    more[Str("&eacute;")] = Str("é")

    printf("--- unescaped()\n")
    text = Str("with param: &eacute;&agrave;&eacute; &lt; &amp; &gt;")
    orig = text.copy()
    text = unescaped(orig, more)
    print_str(format("{} -> {}", orig, text))

cdef void demo_quoteattr():
    cdef Str text
    cdef Str orig

    printf("--- quoteattr()\n")
    text = Str("'ééé' abc \"def\"")
    orig = text.copy()
    quoteattr(text, NULL)
    print_str(format("{} -> {}", orig, text))

cdef void demo_quotedattr():
    cdef Str text
    cdef Str orig

    printf("--- quotedattr()\n")
    text = Str(" \n\n\t\r 'abc' \"def\"")
    orig = text.copy()
    text = quotedattr(orig, NULL)
    print_str(format("{} -> {}", orig, text))

cdef void demo_concate():
    cdef cyplist[Str] strings
    cdef Str text
    cdef Str orig

    printf("--- concate()\n")
    strings = cyplist[Str]()
    strings.append(Str("aaa"))
    strings.append(Str("bbb"))
    orig = format("[{}, {}]", <Str>strings[0], <Str>strings[1])
    text = concate(strings)
    print_str(format("{} -> {}", orig, text))

cdef void demo_stripped():
    cdef Str text
    cdef Str orig

    printf("--- stripped()\n")
    orig = Str("   with blanks         ")
    text = stripped(orig)
    print_str(format("'{}' -> '{}'", orig, text))

cdef void demo_indented():
    cdef Str text
    cdef Str orig
    cdef Str space

    printf("--- indented()\n")
    space = Str("  ")
    orig = Str("aaa\nbbb\n")
    text = indented(orig, space)
    printf("%s", orig.bytes())
    printf("->\n")
    printf("%s", text.bytes())

cdef bint re_match(Str pattern, Str target) nogil:
    cdef regex_t regex
    cdef int result

    if regcomp(&regex, pattern.bytes(), REG_EXTENDED):
        with gil:
            raise ValueError(f"regcomp failed on {pattern.bytes()}")

    if not regexec(&regex, target.bytes(), 0, NULL, 0):
        return 1
    return 0

cdef void demo_regex():
    cdef Str text
    cdef Str pattern
    cdef bint result

    printf("--- use of regex lib: re_match()\n")
    text = Str("aaa abc aaa")
    pattern = Str("abc")
    result = re_match(pattern, text)
    print_str(format('re_match("{}", "{}") -> {}', text, pattern, result))
    text = Str("aaa abcxaaa")
    pattern = Str("abc\\b")
    result = re_match(pattern, text)
    print_str(format('re_match("{}", "{}") -> {}', text, pattern, result))
    text = Str("aaa abc aaa")
    pattern = Str("abc\\b")
    result = re_match(pattern, text)
    print_str(format('re_match("{}", "{}") -> {}', text, pattern, result))

cdef void demo_abspath():
    cdef Str path

    printf("--- abspath()\n")
    path = Str("./unexists")
    print_str(format('"{}" -> "{}"', path, abspath(path)))
    path = Str("./demo.sh")
    print_str(format('"{}" -> "{}"', path, abspath(path)))
    path = Str(".")
    print_str(format('"{}" -> "{}"', path, abspath(path)))
    path = Str("..")
    print_str(format('"{}" -> "{}"', path, abspath(path)))

cdef void demo_startswith():
    cdef Str text
    cdef Str pattern
    cdef bint result

    printf("--- startswith()\n")
    text = Str("abcd")
    pattern = Str("ab")
    result = startswith(text, pattern)
    print_str(format('startswith("{}", "{}") -> {}', text, pattern, result))
    text = Str("abcd")
    pattern = Str("x")
    result = startswith(text, pattern)
    print_str(format('startswith("{}", "{}") -> {}', text, pattern, result))

cdef void demo_endswith():
    cdef Str text
    cdef Str pattern
    cdef bint result

    printf("--- endswith()\n")
    text = Str("abcd")
    pattern = Str("cd")
    result = endswith(text, pattern)
    print_str(format('endswith("{}", "{}") -> {}', text, pattern, result))
    text = Str("abcd")
    pattern = Str("x")
    result = endswith(text, pattern)
    print_str(format('endswith("{}", "{}") -> {}', text, pattern, result))

cdef Str repr_list(IntList lst) nogil:
    cdef cyplist[Str] str_lst
    cdef Str sep
    cdef Str repr

    str_lst = cyplist[Str]()
    for i in lst:
        str_lst.append(format("{:d}", <int>i))
    sep = Str(", ")
    repr = format("[{}]", sep.join(str_lst))
    return repr

cdef IntList _demo_list() nogil:
    cdef IntList lst

    lst = IntList()
    lst.append(0)
    lst.append(10)
    lst.append(30)
    lst.append(21)
    lst.append(22)
    return lst

cdef void demo_sort_list():
    cdef IntList lst, lst2

    printf("--- inplace sort_list()\n")
    lst = _demo_list()
    lst2 = _demo_list()
    sort_list(lst2)
    print_str(format('{} -> {}', repr_list(lst), repr_list(lst2)))

cdef void demo_reverse_list():
    cdef IntList lst, lst2

    printf("--- inplace reverse_list()\n")
    lst = _demo_list()
    lst2 = _demo_list()
    reverse_list(lst2)
    print_str(format('{} -> {}', repr_list(lst), repr_list(lst2)))

cdef void demo_min_list():
    cdef IntList lst
    cdef int m

    printf("--- min_list()\n")
    lst = _demo_list()
    print_str(format('{} -> {}', repr_list(lst), <int> min_list(lst)))

cdef void demo_max_list():
    cdef IntList lst
    cdef int m

    printf("--- max_list()\n")
    lst = _demo_list()
    print_str(format('{} -> {}', repr_list(lst), <int> max_list(lst)))

cdef void demo_sum_list():
    cdef IntList lst
    cdef int m

    printf("--- sum_list()\n")
    lst = _demo_list()
    print_str(format('{} -> {}', repr_list(lst), <int> sum_list(lst)))

cdef void demo_copy_list():
    cdef IntList lst, lst2

    printf("--- copy_list()\n")
    lst = _demo_list()
    lst2 = copy_list(lst)
    lst2.append(999)
    print_str(format('{} -> {}', repr_list(lst), repr_list(lst2)))

cdef void demo_copy_slice():
    cdef IntList lst, lst2

    printf("--- copy_slice()\n")
    lst = _demo_list()
    lst2 = copy_slice(lst, 1, 3)
    print_str(format('copy_slice({}, 1, 3) -> {}', repr_list(lst), repr_list(lst2)))

cdef void demo_copy_slice_from():
    cdef IntList lst, lst2

    printf("--- copy_slice_from()\n")
    lst = _demo_list()
    lst2 = copy_slice_from(lst, 1)
    print_str(format('copy_slice_from({}, 1) -> {}', repr_list(lst), repr_list(lst2)))

cdef void demo_copy_slice_to():
    cdef IntList lst, lst2

    printf("--- copy_slice_to()\n")
    lst = _demo_list()
    lst2 = copy_slice_to(lst, 3)
    print_str(format('copy_slice_from({}, 3) -> {}', repr_list(lst), repr_list(lst2)))

cdef void demo_formatlog():
    cdef Str tag

    printf("--- formatlog()\n")
    tag = formatlog()
    print_str(format('-> {}', tag))

cdef void demo_parsedate():
    cdef Str date, date2
    cdef time_t t

    printf("--- parsedate()\n")
    date = Str("Tue, 22 Mar 2022 12:00:00 UTC")
    t = parsedate(date)
    date2 = formatdate(t)
    print_str(format('{} -> {}', date, t))
    print_str(format('{} -> {}', t, date2))


def main():
    demo_replace_one()
    demo_replace_all()
    demo_escape()
    demo_escaped()
    demo_unescape()
    demo_unescaped()
    demo_unescaped_params()
    demo_quoteattr()
    demo_quotedattr()
    demo_concate()
    demo_stripped()
    demo_indented()
    demo_regex()
    demo_abspath()
    demo_startswith()
    demo_endswith()
    demo_sort_list()
    demo_reverse_list()
    demo_min_list()
    demo_max_list()
    demo_sum_list()
    demo_copy_list()
    demo_copy_slice()
    demo_copy_slice_from()
    demo_copy_slice_to()
    demo_formatlog()
    demo_parsedate()
