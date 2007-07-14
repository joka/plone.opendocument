from zipfile import ZipFile
import os
try:
    from cStringIO import StringIO
except ImportError:
    from StringIO import StringIO


def zipIterator(zipfile):
    """
    Generator function, iterates all files in the ZipFile object.

    raises ValueError, StopIteration

    returns tuples composed of file path string and file content StringIO
    object.
    """
    if not isinstance(zipfile, ZipFile):
            raise ValueError, "zipfile must be a ZipFile object"
            
    if zipfile.testzip() is not None:
        raise ValueError, \
              "This zip file contains bad files "\
              "(according to their CRCs)."
    try:
        paths = zipfile.namelist()        
        for path in paths :
            if (not path.endswith('/')):
                filecontent =  StringIO()
                filecontent.write(zipfile.read(path))
                filecontent.seek(0)
                yield (path, filecontent)    
    except Exception,e:
        print e 
        raise StopIteration

 
