from setuptools import setup
from setuptools.extension import Extension
from Cython.Build import cythonize


setup(
    ext_modules=cythonize(
        [
            Extension(
                name="helloworld.helloworld",
                language="c++",
                sources=["helloworld/helloworld.pyx"],
                extra_compile_args=[
                    "-std=c++17",
                    "-O3",
                    "-Wno-deprecated-declarations",
                ],
            ),
        ],
        language_level="3str",
    )
)
