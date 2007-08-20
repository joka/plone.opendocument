# coding: utf-8 
from logging import DEBUG
import zipfile    
import os
import tempfile
import shutil
from StringIO import StringIO 

 
from zope.interface import implements

from plone.transforms.interfaces import ITransform
from plone.transforms.message import PloneMessageFactory as _
from plone.transforms.transform import TransformResult  
from plone.transforms.log import log
import plone.opendocument.utils as utils

HAS_LXML = True
try: 
    from lxml import etree
except ImportError:
    HAS_LXML = False 


class OpendocumentHtmlTransform(object):
    """
    XSL transform which transforms OpenDocument files into XHTML 
    """
    implements(ITransform)
    
    inputs = ('application/vnd.oasis.opendocument.text',
              'application/vnd.oasis.opendocument.text-template',
	          'application/vnd.oasis.opendocument.text-web',
              'application/vnd.oasis.opendocument.spreadsheet',
              'application/vnd.oasis.opendocument.spreadsheet-template',
              'application/vnd.oasis.opendocument.presentation',
              'application/vnd.oasis.opendocument.presentation-template',
             )

    output = 'text/html'                                  
    
    name = u'plone.opendocument.opendocument_html_xslt.OpendocumentHtmlTransform'

    title = _(u'title_opendocument_html_xslt',
        default=u"OpenDocument to XHTML transform with XSL")
   
    description = _(u'description_markdown_transform',
        default=u"A transform which transforms OpenDocument files into XHTML \
        with XSL")

    available = False

    xsl_stylesheet = os.path.join(os.getcwd(), os.path.dirname(__file__),\
            'lib/odf2html/all-in-one.xsl')    
    
    xsl_stylesheet_param = {}
                                             
    data = tempfile.NamedTemporaryFile()
    subobjects = {}
    metadata = {}
    errors = u'' 
    
    _dataFiles = {} 
    _imageNames = {}

    def __init__(self):
        super(OpendocumentHtmlTransform, self).__init__()
        if HAS_LXML:
            self.available = True  
        self.xsl_stylesheet_param = {
                'param_track_changes':"0",#display version changes
                'param_no_css':"0", #don't make css styles
                'scale':"1", #scale font size, (non zero integer value)
                }
          
    def transform(self, data):  
        '''
        Transforms data (OpenDocument file) to XHTML. It returns an
        TransformResult object.
        '''
        if not self.available:
            log(DEBUG, "The LXML library is required to use the %s transform "
                         % (self.name))
            return None 
       
        self._prepareTrans(data)
        if not self._dataFiles: 
            return none;
        
        result = None
        
        #XSL tranformation
        try:
            etree.clearErrorLog()
            parser = etree.XMLParser(remove_comments=True, remove_blank_text=True) 
            #concatenate all xml files
            contentXML = etree.parse(self._concatDataFiles(), parser)
            contentXML.xinclude()
            #adjust file paths
            root = contentXML.getroot()
            images = root.xpath("//draw:image", {'draw' :\
                'urn:oasis:names:tc:opendocument:xmlns:drawing:1.0' })
            for i in images:
                imageName = i.get("{http://www.w3.org/1999/xlink}href")
                imageName = os.path.basename(imageName)
                if not self._imageNames.has_key(imageName):
                    self.errors = self.errors + u'''
                                 Image file '%s' does not exist. Maybe it is\
                                 not embedded in OpenDocument file?
                                 ''' % (imageName)   
                    i.set("{http://www.w3.org/1999/xlink}href", imageName) 
                    continue
                imageName = self._imageNames[imageName]
                i.set("{http://www.w3.org/1999/xlink}href", imageName) 
            #extract meta data
            self._getMetaData(contentXML)
            #xslt transformation
            stylesheetXML = etree.parse(self.xsl_stylesheet, parser)
            xslt = etree.XSLT(stylesheetXML)
            resultXML = xslt(contentXML, **self.xsl_stylesheet_param) 
            resultXML.write(self.data)
            self.data.seek(0)      
            #log non fatal errors and warnings
            if parser.error_log:
                self.errors = self.errors + u'''
                                 Parse errors which are not fatal:
                                 %s
                                 ''' % (parser.error_log)   
            if xslt.error_log:                                 
                self.errors = self.errors + u'''
                                 XSLT errors which are not fatal:
                                 %s
                                 ''' % (xslt.error_log)   
            
            for f in self._dataFiles.values():
                f.close()
            result = TransformResult(self.data, 
                                    subobjects=self.subobjects or {},
                                    metadata=self.metadata or {},
                                    errors=self.errors or None
                                    ) 
        except etree.LxmlError, e:
            log(DEBUG,\
                str(e) + ('\nlibxml error_log:\n') + str(e.error_log))
            return None
        except Exception, e:
            log(DEBUG, str(e))
            return None

        return result 

    def _prepareTrans(self, data):
        '''
        Extracts required files from data (opendocument file). They are stored
        in self.subobjects and self._dataFiles.
        ''' 
        dataZip = zipfile.ZipFile(data)
        dataIterator = utils.zipIterator(dataZip)

        try:
            for fileName, fileContent in dataIterator:
                #getting data files
                if (fileName == 'content.xml'):
                    content = tempfile.NamedTemporaryFile()
                    shutil.copyfileobj(fileContent, content)
                    content.seek(0)
                    self._dataFiles['content'] = content
                    continue
                if (fileName == 'styles.xml'):
                    styles = tempfile.NamedTemporaryFile()
                    shutil.copyfileobj(fileContent, styles)
                    styles.seek(0)
                    self._dataFiles['styles'] = styles
                    continue
                if (fileName == 'meta.xml'):
                    meta = tempfile.NamedTemporaryFile()
                    shutil.copyfileobj(fileContent, meta)
                    meta.seek(0)
                    self._dataFiles['meta'] = meta
                    continue
                #getting images 
                if ('Pictures/' in fileName):
                    imageName = os.path.basename(fileName)
                    imageContent = tempfile.NamedTemporaryFile()
                    shutil.copyfileobj(fileContent, imageContent)
                    imageContent.seek(0)
                    fileContent.close()
                    #assert that the image is viewable with web browsers
                    imageName_, imageContent = utils.makeViewable((imageName, imageContent))
                    if not imageName_:
                        self.errors = self.errors + u'''
                                         Image file '%s' could not be make viewable \
                                         with web browser.
                                         ''' % (imageName)   
                        continue  
                    #store image                    
                    self._imageNames[imageName] = imageName_ 
                    self.subobjects[imageName_] = imageContent

            data.close()
            dataZip.close()        

        except Exception, e:
            self._dataFiles = None
            self.subobjects = None
            log(DEBUG, str(e))
                    
    def _concatDataFiles(self):
        '''
        Returns XML file object that concatenates all files stored in self._dataFiles
        with xi:include.
        '''

        includeXML = lambda x: (x in self._dataFiles) and \
                        '<xi:include href="%s" />' % (self._dataFiles[x].name) 
        concat = StringIO(
              '''<?xml version='1.0' encoding='UTF-8'?>
                 <office:document xmlns:xi="http://www.w3.org/2001/XInclude"
                  xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0">
                    %s %s %s  
                 </office:document>
              ''' 
              % (
                  includeXML('meta') or ' ', 
                  includeXML('styles') or ' ', 
                  includeXML('content') or ' ', 
                )
            )                             

        return concat
    
    def _getMetaData(self, contentXML):
        '''
        Extracts all OpenDocument meta data from contentXML (ElementTree
        object) and stores it in self.metadata.
        '''
        root = contentXML.getroot()
        Elements = root.xpath("//office:meta", {'office'\
                :'urn:oasis:names:tc:opendocument:xmlns:office:1.0'})
        if not Elements:
            self.errors = self.errors + u'''
                             There is no <office:meta> element to extract \
                             meta data. 
                             '''  
        for element in Elements:
            meta = u'{urn:oasis:names:tc:opendocument:xmlns:meta:1.0}'
            dc = u'{http://purl.org/dc/elements/1.1/}'
            for m in element.iterchildren():
                #regular elements
                text = unicode(m.text).rstrip().lstrip()
                prefix = unicode(m.prefix)
                tag = unicode(m.tag)
                tag = tag.replace(meta, u'')
                tag =  tag.replace(dc, u'')
                #<meta:user-defined> elements
                if tag.endswith('user-defined'):
                    tag = unicode(m.get(\
                    '{urn:oasis:names:tc:opendocument:xmlns:meta:1.0}name'))
                #<meta:document-statistic> elements
                if tag.endswith('document-statistic'):
                    for tag_, text_ in m.items():
                        tag_ = unicode(tag_)
                        tag_ = tag_.replace(meta, u'')
                        text_ = unicode(text_).rstrip().lstrip()
                        self.metadata['meta:' + tag_] = text_
                    continue
                #skip empty elements
                if not m.text:
                    continue

                self.metadata[prefix + ':' + tag] = text


