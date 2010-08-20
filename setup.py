from setuptools import setup, find_packages
import sys, os

version = '0.1'

setup(name='plone.opendocument',
      version=version,
      description="",
      packages=find_packages('src', exclude=['ez_setup']),
      package_dir = {'':'src'},
      namespace_packages=['plone'],
      long_description="""Transform from Opendocument to HTML""",
      classifiers=[
        "License :: OSI Approved :: GNU General Public License (GPL)",
        "Framework :: Plone",
        "Framework :: Zope2",
        "Framework :: Zope3",
        "Programming Language :: Python",
        "Topic :: Software Development :: Libraries :: Python Modules",
        ],
      keywords='Plone Transformation Opendocument',
      author='Plone Foundation',
      author_email='plone-developers@lists.sourceforge.net',
      url='http://svn.plone.org/svn/collective/plone.opendocument',
      license='GPL',
      include_package_data=True,
      zip_safe=False,
      install_requires=[
          'setuptools',
      ],
      )
