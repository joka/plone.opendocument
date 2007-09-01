plone.opendocument Package Readme
=========================


Overview
--------

This package provides  XSL transformations for OpenDocument files for Plone.
It works only with plone.transforms that substitutes PloneTransforms in Plone 3.5.

The OpendocumentToXHTML transformation is based on the odf2html style sheet
(http://opendocumentfellowship.org/repos/odf2html, svn r338 2007-02-15).
The improvements and changes to the original one are tracked in 
lib/odf2html/changelog.txt.

Common OpenDocument test files (like thesis.odt, letter.odt, invoice.ods) are 
in lib/odf2html/tests/commonUseCases.


Installing plone.opendocument
-----------------------------

This package requires:

    plone.transforms (https://svn.plone.org/svn/plone/plone.transforms)
    lxml (With buildout you can use the plone.recipe.lxml egg)
    PIL
    
It is made to be used as a normal python package within Zope 2. This 
is only supported in Zope 2.10 or later. If you are using Zope 2.8 or Zope 2.9
you can install the `pythonproducts package`_ to add python package support to
your Zope.

.. _pythonproducts package: http://dev.serverzen.com/site/projects/pythonproducts

You install it somewhere in the python path or in your zope instance directory
at lib/python. 
Now it needs to be registered in your Zope instance. This can be done by putting
a plone-opendocument-configure.zcml file in the etc/pakage-includes directory
with this content:

<include package="plone.opendocument" file="configure.zcml" />

If you are using buildout_ you can also do this by adding a zcml statement
to the instance section of your buildout: 

 [instance]
    
    zcml = plone.opendocument

To install this package with buildout you need to add this statement:

 [instance]

    eggs = plone.opendocument
    
Because there is no plone.opendocument egg uploaded at pypi you also have to
add this statement to the buildout section (assuming src/plone.opendocument
is you install path of plone.opendocument)

 [buildout]

    develop = src/plone.opendocument


.. _buildout: http://pypi.python.org/pypi/zc.buildout

