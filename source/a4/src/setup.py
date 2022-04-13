from os.path import join
from setuptools import setup
from setuptools.extension import Extension
from Cython.Build import cythonize


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
    )


extensions = [
    ext_pyx("golomb", "golomb_cyp"),
]

setup(
    ext_modules=cythonize(
        extensions,
        language_level="3str",
    )
)
