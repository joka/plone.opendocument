import unittest
import os
import tempfile 
import PIL.Image

from zope.component.testing import setUp, tearDown
from zope.testing import doctest
from zope.testing.doctestunit import DocFileSuite
from zope.configuration.xmlconfig import XMLConfig

from plone.transforms.tests.utils import configurationSetUp
from plone.opendocument import opendocument_to_xhtml, utils


optionflags = doctest.REPORT_ONLY_FIRST_FAILURE | doctest.ELLIPSIS | doctest.NORMALIZE_WHITESPACE

def test_suite():
   global optionsflags
   if opendocument_to_xhtml.HAS_LXML and utils.HAS_PIL:
        return unittest.TestSuite(
            [doctest.DocFileSuite('opendocument_to_xhtml.text',
                                 package='plone.opendocument', 
                                 optionflags=optionflags,
                                 tearDown=tearDown,
                                 setUp=configurationSetUp,    
                                 ),
            doctest.DocFileSuite('utils.text',
                                 package='plone.opendocument', 
                                 optionflags=optionflags,
                                 tearDown=tearDown,
                                 setUp=setUp,    
                                 )
            ])
   else:
        return unittest.TestSuite()

if __name__ == '__main__':
    unittest.main(defaultTest='test_suite')


