import zipfile    
import os
import tempfile
import shutil
from StringIO import StringIO   
 
from zope.interface import implements
from plone.transforms.interfaces import ITransform
from plone.transforms.message import PloneMessageFactory as _
from plone.transforms.interfaces import IMultipleOutputTransform
import plone.opendocument.utils as utils

HAS_LXML = True
try: 
    from lxml import etree
except ImportError:
    HAS_LXML = False 


class OpendocumentToXHTML:
    """
    XSL transform which transforms Opendocument into XHTML 
    """
    implements(IMultipleOutputTransform)
    
    inputs = ('application/vnd.oasis.opendocument.text',
              'application/vnd.oasis.opendocument.text-master',
              'application/vnd.oasis.opendocument.text-template',
	          'application/vnd.oasis.opendocument.text-web',
              'application/vnd.oasis.opendocument.spreadsheet',
              'application/vnd.oasis.opendocument.spreadsheet-template',
              'application/vnd.oasis.opendocument.presentation',
              'application/vnd.oasis.opendocument.presentation-template',
              'application/vnd.oasis.opendocument.chart',
              'application/vnd.oasis.opendocument.database',
             )

    output = 'text/html'                                  
    
    name = u'plone.opendocument.opendocument_to_xhtml.OpendocumentToXHTML'

    title = _(u'title_opendocument_to_xhtml',
        default=u"A transform which transforms opendocument files into HTML with XSL")
    
    xsl_stylesheet = os.path.join(os.getcwd(), os.path.dirname(__file__),\
            'lib/libopendocument/document2xhtml.xsl')    
          
    def transform(self, data):  
       
        outputStreams = {}
        outputStreams['default'] = StringIO()
        outputStreams['pictures'] = [] 
        contentXML = StringIO()

        tempdir = (tempfile.gettempdir() + '/plone_opendocument/')
        if not os.path.exists(tempdir):
            os.mkdir(tempdir)

        try:
            for d in data :
                name = d[0]
                content = d[1]
                #getting content.xml
                if (name == 'content.xml'):
                    contentXML = content
                #getting pictures 
                if (name.startswith('Pictures/')):
                    name = os.path.basename(name)
                    picture = file(tempdir + name,'w+b')
                    shutil.copyfileobj(content, picture)
                    picture.close()
                    picture_ = utils.makeViewable(picture.name)
                    #picture is not viewable with browser
                    if not picture_:
                        continue
                    #picture has been converted to be viewable
                    if not picture is picture_:
                        pass
                        #TODO:update contentXML
                    outputStreams['pictures'].append(picture_)
            #transform content.xml into XHTML
            sourceXML = etree.parse(contentXML)
            contentXML.close()
            stylesheetXML = etree.parse(self.xsl_stylesheet)
            xslt = etree.XSLT(stylesheetXML) 
            result = xslt(sourceXML)
            resultHTML = xslt.tostring(result)
            outputStreams['default'].write(resultHTML)
            outputStreams['default'].seek(0)
            #TODO: LOG(self.__name__, DEBUG, ...
            #TODO: Validate HTML
        except Exception, e:
            raise e
        
        outputStreams['pictures'] = iter(outputStreams['pictures'])
        return outputStreams

        


