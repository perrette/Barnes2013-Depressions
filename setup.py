from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
import numpy
import os

# If the user set GDAL_PREFIX, use it. Otherwise check some standard locations.
prefix = ""
try:
    prefix = os.environ['GDAL_PREFIX']
except:
    print "Environment variable GDAL_PREFIX not set. Trying known locations..."
    prefixes = ["/usr/", "/usr/local/", "/opt/local/", "/sw/"]

    for path in prefixes:
        print "Checking '%s'..." % path
        try:
            os.stat(path + "include/gdal/gdal_priv.h")
            prefix = path
            print "Found GDAL in '%s'" % prefix
            break
        except:
            pass

if prefix == "":
    print "Could not find GDAL. Stopping..."
    import sys
    sys.exit(1)


# If the user set NO_OPENMP, proceed with these options. Otherwise add options GCC uses.
# libraries=['gsl', 'gslcblas']
libraries=['gdal']
extra_compile_args=["-O3", "--std=c++11", "-ffast-math", "-Wall"]
try:
    os.environ['NO_OPENMP']
except:
    libraries.append('gomp')
    extra_compile_args.append('-fopenmp')

# Define the extension
extension = Extension("priority_flood",
                      sources=["python/priority_flood.pyx",
                               # "src/data_io.cpp",
                               ],
                      # include_dirs=[numpy.get_include(), 'src'],
                      include_dirs=[numpy.get_include(), 'src', prefix + '/include/gdal', prefix + '/include'],
                      library_dirs=[prefix + "/lib"],
                      libraries=libraries,
                      extra_compile_args=extra_compile_args,
                      language="c++")

setup(
    name = "priority_flood",                       # "drainage basin generator"
    description = "Barnes Priority Flood",
    long_description = """ """,
    author = "Barnes",
    author_email = "",
    url = "",
    classifiers=[
          ],
    cmdclass = {'build_ext': build_ext},
    ext_modules = [extension]
    )
