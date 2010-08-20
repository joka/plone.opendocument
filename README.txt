plone.opendocument Package Readme
=========================


Introduction
------------

This package provides Opendocument to HTML transformations.

The OpendocumentToXHTML transformations are based on the odf2html style sheet
(http://opendocumentfellowship.org/repos/odf2html, svn r338 2007-02-15).
The improvements and changes to the original one are tracked in 
lib/odf2html/changelog.txt.

Common OpenDocument test files (like thesis.odt, letter.odt, invoice.ods) are 
in lib/odf2html/tests/commonUseCases.


Installing plone.opendocument
-----------------------------

This package requires:

    plone.transforms (https://svn.plone.org/svn/plone/plone.transforms)
    lxml (you can use the plone.recipe.lxml egg)
    PIL
    

Limitations
-----------

This product works well with ODT and  ODS files. Not supported are footer,
header, ole objects and internal links. ODP files are supported in a 
simple way.

Embedded image files are supported except file formats that are unsupported by PIL
(http://www.pythonware.com/library/pil/handbook/). Image formats that are not
supported by common browsers (like tiff) are converted to png.

Working with big files can cause great memory consumption.
Actually ATFile and lxml don't support streaming.
You can find some XML object models in python benchmarks: at 
"XML Matters: Process XML in Python with ElementTree" by David Mertz
http://www.ibm.com/developerworks/library/x-matters28/. 

