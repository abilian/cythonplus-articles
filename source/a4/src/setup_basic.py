from os.path import join
from setuptools import setup
from setuptools.extension import Extension
from Cython.Build import cythonize


def ext_simple(*pathname):
    "return an Extension for basic Cython compilation"
    return Extension(
        name=".".join(pathname),
        language="c",
        sources=[join(*pathname) + ".py"],
        extra_compile_args=[
            "-O3",
            "-Wno-deprecated-declarations",
        ],
    )


extensions = [
    ext_simple("golomb", "golomb_basic"),
]

setup(
    ext_modules=cythonize(
        extensions,
        language_level="3str",
    ),
)
