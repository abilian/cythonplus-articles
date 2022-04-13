from .stdlib.string cimport Str
from .cypxml cimport cypXML


cdef bytes generate_simple_xml():
    cdef cypXML xml

    xml = cypXML()
    xml.init_version(Str("1.0"))
    t = xml.tag(Str("person"))
    t2 = t.tag(Str("name"))
    t2.text(Str("Bob"))
    t3 = t.tag(Str("city")).sattr("country", "33")
    t3.text(Str("Paris"))

    return xml.dump().bytes()


def main():
    print(generate_simple_xml().decode("utf8"))
