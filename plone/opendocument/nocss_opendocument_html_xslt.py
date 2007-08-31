# coding: utf-8 
from zope.interface import implements

from plone.transforms.interfaces import ITransform, IRankedTransform
from plone.transforms.message import PloneMessageFactory as _
from plone.opendocument.opendocument_html_xslt import \
        OpendocumentHtmlXsltTransform


HAS_LXML = True
try: 
    from lxml import etree
except ImportError:
    HAS_LXML = False 


class NocssOpendocumentHtmlXsltTransform(OpendocumentHtmlXsltTransform):
    """
    XSL transform which transforms OpenDocument files into XHTML but skips
    css styles.
    """
    implements(ITransform, IRankedTransform)
    
    name = u'plone.opendocument.opendocument_html_xslt.NocssOpendocumentHtmlXsltTransform'

    title = _(u'title_nocss_opendocument_html_xslt',
        default=u"OpenDocument to XHTML transform with XSL")
   
    description = _(u'description_markdown_transform',
        default=u"A transform which transforms OpenDocument files into XHTML \
        with XSL but skips css styles")

    rank = 2

    def __init__(self):
        super(NocssOpendocumentHtmlXsltTransform, self).__init__()
        if HAS_LXML:
            self.available = True  
        self.xsl_stylesheet_param['param_no_css'] = "1" #don't make css styles
          

