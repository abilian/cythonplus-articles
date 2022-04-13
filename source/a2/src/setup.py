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

setup(
    ext_modules=cythonize(
        [
            Extension(
                name="containers.containers_v1",
                language="c++",
                sources=["containers/containers_v1.pyx"],
                extra_compile_args=[
                    "-std=c++17",
                    "-O3",
                    "-Wno-deprecated-declarations",
                ],
            ),
            Extension(
                name="containers.containers_v2",
                language="c++",
                sources=["containers/containers_v2.pyx"],
                extra_compile_args=[
                    "-std=c++17",
                    "-O3",
                    "-Wno-deprecated-declarations",
                ],
                libraries=["fmt"],
                include_dirs=["libfmt"],
                library_dirs=["libfmt"],
            ),
            Extension(
                name="containers.list_sort_reverse_in_place",
                language="c++",
                sources=["containers/list_sort_reverse_in_place.pyx"],
                extra_compile_args=[
                    "-std=c++17",
                    "-O3",
                    "-Wno-deprecated-declarations",
                ],
                libraries=["fmt"],
                include_dirs=["libfmt"],
                library_dirs=["libfmt"],
            ),
        ],
        language_level="3str",
    )
)
