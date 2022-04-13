from setuptools import setup
from setuptools.extension import Extension
from Cython.Build import cythonize


setup(
    ext_modules=cythonize(
        [
            Extension(
                name="fibonacci.fibonacci_cyp",
                language="c++",
                sources=["fibonacci/fibonacci_cyp.pyx"],
                extra_compile_args=[
                    "-std=c++17",
                    "-O3",
                    "-pthread",
                    "-Wno-deprecated-declarations",
                ],
            ),
        ],
        language_level="3str",
    )
)
