from setuptools import setup

setup(
   name='AMrotor',
   version='1.0',
   description='Matlab based rotordynamic toolbox',
   author='AMrotorTeam',
   author_email='foomail@foo.com',
   packages=['AMrotor'],  #same as name
   install_requires=['bar', 'greek'], #external packages as dependencies
)