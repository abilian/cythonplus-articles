from os.path import join, exists, abspath, dirname
from os import makedirs, chdir, getcwd
from shutil import rmtree, copytree, copy
from subprocess import run

from setuptools import setup
from setuptools.extension import Extension
from Cython.Build import cythonize

PROJECT_ROOT = abspath(dirname(__file__))


def build_libfmt():
    libfmt = join(PROJECT_ROOT, "libfmt")
    if exists(join(libfmt, "libfmt.a")):
        print("libfmt.a found")
        return
    if not exists(libfmt):
        makedirs(libfmt)
    src = "fmt-8.0.1"
    src_path = join(PROJECT_ROOT, "..", "..", "vendor", f"{src}.tar.gz")
    if not exists(src_path):
        raise ValueError(f"{src_path} not found")
    build = join(PROJECT_ROOT, "build_fmt")
    if exists(build):
        rmtree(build)
    makedirs(build)
    orig_wd = getcwd()
    chdir(build)
    run(["tar", "xzf", src_path])
    chdir(join(build, src))
    run(["cmake", "-DCMAKE_POSITION_INDEPENDENT_CODE=TRUE", "."])
    run(["make", "fmt"])
    chdir(orig_wd)
    copytree(join(build, src, "include", "fmt"), join(libfmt, "fmt"))
    copy(join(build, src, "libfmt.a"), libfmt)


build_libfmt()


def ext_pyx(*pathname):
    "return an Extension for Cython+ compilation"
    return Extension(
        name=".".join(pathname),
        language="c++",
        sources=[join(*pathname) + ".pyx"],
        extra_compile_args=[
            "-std=c++17",
            "-O3",
            "-pthread",
            "-Wno-deprecated-declarations",
        ],
        libraries=["fmt"],
        include_dirs=["libfmt"],
        library_dirs=["libfmt"],
    )


extensions = [
    ext_pyx("utils", "demo_utils"),
    ext_pyx("utils", "stdlib", "xml_utils"),
    ext_pyx("utils", "stdlib", "strip"),
    ext_pyx("utils", "stdlib", "abspath"),
    ext_pyx("utils", "stdlib", "startswith"),
    ext_pyx("utils", "stdlib", "list_utils"),
    ext_pyx("utils", "stdlib", "formatdate"),
    ext_pyx("utils", "stdlib", "parsedate"),
]

setup(
    ext_modules=cythonize(
        extensions,
        language_level="3str",
    )
)
