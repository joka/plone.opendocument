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
            raise ValueError, "zipfile must be a ZipFile object"
            
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
    except Exception,e:
        print e 
        raise StopIteration


def makeViewable((imageFileName, imageFile)):
    """
    Asserts that the given image file is viewable with web browsers ('PNG',
    'GIF','JPEG', 'BMP') . If it's not viewable the function tries to 
    convert it to png. A new file (NamedTemporaryFile object) and file name (which has the suffix '.png'
    is created. The old file is closed. If the image file format is not
    supported by PIL it returns none.

    imageFile -- image file like object argument, opend in binary mode if it
                 has attribute 'mode'. 
    imageFileName -- string argument, non empty file name of imageFile.

    raises IOError, ValueError

    returns (imageFileName, imageFile) tuple or None
    """
    viewable = ['PNG','GIF','JPEG']

    if not (isinstance(imageFileName, str) | (imageFileName == '')):
        raise ValueError, ("The imageFileName argument '%s' is no string or \
                an empty string." % (imageFileName))
    
    if ('mode' in (dir(imageFile))) and not ('b' in imageFile.mode):
        raise ValueError, ("The imageFile argument is no file object in \
                binary mode, the imageName argument is '%s'." % (imageFileName))

    try:
        imageFile.seek(0)
        image = PIL.Image.open(imageFile)
        name, e = os.path.splitext(imageFileName)
        format = image.format
        if format in viewable:
            imageFile.seek(0)
            return (imageFileName, imageFile)
        else: 
            imageFileName_ = name + '.png'
            imageFile_ = tempfile.NamedTemporaryFile()
            image.save(imageFile_, format='PNG', mode='RGB')
            imageFile_.seek(0)
            imageFile.close()
            return (imageFileName_, imageFile_)
    except IOError, e:
        if str(e) == 'cannot identify image file':
            return None
        else:
            raise 
        
    return None


