import unittest
import os
import tempfile 
import PIL.Image

#from Testing import ZopeTestCase as ztc
#from base import TransformODTFunctionalTestCase
#from zope.configuration.xmlconfig import XMLConfig
from zope.component.testing import setUp, tearDown
from zope.testing import doctest
from zope.testing.doctestunit import DocFileSuite

from plone.transforms.tests.utils import configurationSetUp
from plone.opendocument import opendocument_to_xhtml, utils


optionflags = doctest.REPORT_ONLY_FIRST_FAILURE | doctest.ELLIPSIS | doctest.NORMALIZE_WHITESPACE

def opendocument_to_xhtmlTearDown(self):
    tearDown()
    #os.remove(os.path.dirname(__file__) + '/output/test_odt/10000000000000E2000000E2459CCEB9.gif')
def utilsTearDown(self):
    pass

def test_suite():
    global optionsflags
    suite = unittest.TestSuite()
    if opendocument_to_xhtml.HAS_LXML and utils.HAS_PIL:
        suite.addTest(DocFileSuite('opendocument_to_xhtml.text',
                             package='plone.opendocument', 
                             optionflags=optionflags,
                             tearDown=opendocument_to_xhtmlTearDown,
                             setUp=configurationSetUp,
                             ))
        suite.addTest(DocFileSuite('utils.text',
                             package='plone.opendocument', 
                             optionflags=optionflags,
                             tearDown=utilsTearDown, 
                             ))
         
    #     ztc.ZopeDocFileSuite(
    #       'opendocument_to_xhtml.text', package='plone.opendocument',
    #       test_class=TransformODTFunctionalTestCase,
    #       optionflags)
    return suite
   

if __name__ == "__main__":
    unittest.main(defaultTest='test_suite')



