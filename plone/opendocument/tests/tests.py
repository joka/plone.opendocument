import unittest
import os
import tempfile

#from Testing import ZopeTestCase as ztc
#from base import TransformODTFunctionalTestCase
#from zope.configuration.xmlconfig import XMLConfig
from zope.component.testing import setUp, tearDown
from zope.testing import doctest
from zope.testing.doctestunit import DocFileSuite


optionflags = doctest.REPORT_ONLY_FIRST_FAILURE | doctest.ELLIPSIS | doctest.NORMALIZE_WHITESPACE

def configurationTearDown(self):
    tearDown()
    tempdir = (tempfile.gettempdir() + '/plone_opendocument')
    files = os.listdir(tempdir)
    map(os.remove, files)
    os.rmdir(tempdir)

def test_suite():
    global optionsflags
    return unittest.TestSuite((
         DocFileSuite('opendocument_to_xhtml.text',
                             package='plone.opendocument', 
                             optionflags=optionflags,
                             tearDown=configurationTearDown
                             ),
         DocFileSuite('utils.text',
                             package='plone.opendocument', 
                             optionflags=optionflags,
                             ),
         
    #     ztc.ZopeDocFileSuite(
    #       'opendocument_to_xhtml.text', package='plone.opendocument',
    #       test_class=TransformODTFunctionalTestCase,
    #       optionflags,
    ))

if __name__ == "__main__":
    unittest.main(defaultTest='test_suite')



