import ast
from os.path import join, exists, abspath, dirname
from os import makedirs, chdir, getcwd
import re
from shutil import rmtree, copytree, copy
from subprocess import run

from setuptools import setup, find_packages
from setuptools.extension import Extension
from Cython.Build import cythonize

PROJECT_ROOT = abspath(dirname(__file__))


def read(*path):
    full_path = join(PROJECT_ROOT, *path)
    with open(full_path, "r", encoding="utf-8") as f:
        return f.read()


def read_version():
    version_re = re.compile(r"__version__\s+=\s+(.*)")
    version_string = version_re.search(read(join("cypxml", "__init__.py"))).group(1)
    return str(ast.literal_eval(version_string))


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
    src = join(*pathname) + ".pyx"
    if not exists(src):
        src = join(*pathname) + ".py"
    if not exists(src):
        raise ValueError(f"file not found: {src}")
    return Extension(
        name=".".join(pathname),
        language="c++",
        sources=[src],
        extra_compile_args=[
            "-std=c++17",
            "-O3",
            "-pthread",
            "-Wno-deprecated-declarations",
            "-Wno-unused-function",
        ],
        libraries=["fmt"],
        include_dirs=["libfmt"],
        library_dirs=["libfmt"],
    )


extensions = [
    ext_pyx("cypxml", "stdlib", "xml_utils"),
    ext_pyx("cypxml", "cypxml"),
    ext_pyx("cypxml", "test_cypxml"),
    ext_pyx("cypxml", "demo_cypxml"),
    ext_pyx("cypxml", "__init__"),
]

setup(
    name="cypxml",
    version=read_version(),
    ext_modules=cythonize(
        extensions,
        language_level="3str",
        include_path=[
            join(PROJECT_ROOT, "cypxml", "stdlib"),
            join(PROJECT_ROOT, "cypxml"),
        ],
    ),
    author="Jerome Dumonteil",
    author_email="jd@abilian.com",
    url="https://github.com/abilian/cythonplus-sandbox/tuto/a6/src",
    packages=find_packages(exclude=["tests*"]),
    license="MIT",
    description="XML library using Cython+, tutorial version",
    long_description="XML library using Cython+, tutorial version",
    classifiers=[
        "Development Status :: 3 - Alpha",
        "Topic :: Internet",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Operating System :: POSIX :: Linux",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: Implementation :: CythonPlus",
    ],
    python_requires=">=3.8, <4",
    include_package_data=True,
    zip_safe=False,
)
