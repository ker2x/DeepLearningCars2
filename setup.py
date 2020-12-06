from setuptools import setup
from Cython.Build import cythonize

setup(
    name='DeepLearningCars2',
    version='0.1',
    packages=[''],
    url='https://github.com/ker2x/DeepLearningCars2',
    license='WTFPL',
    author='ker',
    author_email='kerdezixe+github@gmail.com',
    description='racing car with a mix of NN and genetic'
)

setup(
    ext_modules = cythonize(["simulation.pyx", "vector.pyx"],
                            annotate=True,
                            compiler_directives={'language_level':3, 'profile': False})
)
