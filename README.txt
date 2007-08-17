plone.opendocument Package Readme
=========================

Overview
--------

XSL transformations for OpenDocument files.

It requires:
    plone.transforms (https://svn.plone.org/svn/plone/plone.transforms)
    lxml (You can use the lxml  )
    PIL

The OpendocumentToXHTML transformation is based on the odf2html style sheet
(http://opendocumentfellowship.org/repos/odf2html, svn r338 2007-02-15).
The improvements to the original one are tracked in lib/odf2html/changelog.txt

Common OpenDocument test files (like thesis.odt, letter.odt, invoice.ods) are 
in lib/odf2html/tests/commonUseCases.
