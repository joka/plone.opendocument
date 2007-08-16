from zipfile import ZipFile
import os
import tempfile
try:
    from cStringIO import StringIO
except ImportError:
    from StringIO import StringIO

HAS_PIL = True
try: 
    import PIL.Image
except ImportError:
    HAS_PIL = False


def zipIterator(zipfile):
    """
    Generator function, iterates all files in the ZipFile object.

    zipfile -- ZipFile object argument

    raises ValueError, StopIteration

    returns tuples composed of string (file path) and StringIO
           object (file content)
    """
    if not isinstance(zipfile, ZipFile):
            raise ValueError, "Zipfile argument must be a ZipFile object"
            
    if zipfile.testzip() is not None:
        raise ValueError, "This zip file contains bad files \
                           (according to their CRCs)."
    try:
        paths = zipfile.namelist()        
        for path in paths :
            if (not path.endswith('/')):
                filecontent =  StringIO()
                filecontent.write(zipfile.read(path))
                filecontent.seek(0)
                path = os.path.normpath(os.path.normcase(path))
                yield (path, filecontent)    
    except Exception, e:
        raise e  


def makeViewable((imageName, imageContent)):
    """
    Asserts that the given image file is viewable with web browsers ('PNG',
    'GIF','JPEG', 'BMP') . If it's not viewable the function tries to 
    convert it to png. A new file (NamedTemporaryFile object) and file name (which has the suffix '.png'
    is created. The old file is closed. If the image file format is not
    supported by PIL it returns none.

    imageContent -- image file like object argument, opend in binary mode if it
                 has attribute 'mode'. 
    imageName -- string argument, non empty file name of imageContent.

    raises IOError, ValueError

    returns (imageName, imageContent) tuple or None
    """
    viewable = ['PNG','GIF','JPEG']

    if not (isinstance(imageName, str) | (imageName == '')):
        raise ValueError, ("The imageName argument '%s' is no string or \
                an empty string." % (imageName))
    
    if ('mode' in (dir(imageContent))) and not ('b' in imageContent.mode):
        raise ValueError, ("The imageContent argument is no file object in \
                binary mode, the imageName argument is '%s'." % (imageName))

    try:
        imageContent.seek(0)
        image = PIL.Image.open(imageContent)
        name, e = os.path.splitext(imageName)
        format = image.format
        if format in viewable:
            imageContent.seek(0)
            return (imageName, imageContent)
        else: 
            imageName_ = name + '.png'
            imageContent_ = tempfile.NamedTemporaryFile()
            image.save(imageContent_, format='PNG', mode='RGB')
            imageContent_.seek(0)
            imageContent.close()
            return (imageName_, imageContent_)
    except IOError, e:
        if str(e) == 'cannot identify image file':
            return None
        else:
            raise 
        
    return None


