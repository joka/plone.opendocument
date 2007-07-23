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

from plone.opendocument import opendocument_to_xhtml, utils


optionflags = doctest.REPORT_ONLY_FIRST_FAILURE | doctest.ELLIPSIS | doctest.NORMALIZE_WHITESPACE

def opendocument_to_xhtmlTearDown(self):
    tearDown()
    tempdir = (tempfile.gettempdir() + '/plone_opendocument')
    files = os.listdir(tempdir)
    os.chdir(tempdir)
    map(os.remove, files)
    os.rmdir(tempdir)

def utilsTearDown(self):
    tearDown()
    tempdir = os.path.dirname(__file__) + '/input/'
    image = tempdir + 'notViewable.png'
    image_ = tempdir + 'notViewable.tiff'
    PIL.Image.open(image).save(image_, format='TIFF')
    os.remove(image)
    
 
def test_suite():
    global optionsflags
    suite = unittest.TestSuite()
    if opendocument_to_xhtml.HAS_LXML and utils.HAS_PIL:
        suite.addTest(DocFileSuite('opendocument_to_xhtml.text',
                             package='plone.opendocument', 
                             optionflags=optionflags,
                             tearDown=opendocument_to_xhtmlTearDown,
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



