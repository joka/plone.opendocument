from zipfile import ZipFile
import os
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

    returns tuples composed of file path string and file content StringIO
           object
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


def makeViewable(imagefile):
    """
    Asserts that the given image file is viewable with web browsers ('PNG',
    'GIF','JPEG', 'BMP') . If it's not viewable the function tries to 
    convert it to png. A new file is created which has the suffix .png. The old
    file is removed.
    
    imagefile --  object argument, has to have a visible name in the file
                 system

    raises IOError

    returns path to image file or None
    """
    viewable = ['PNG','GIF','JPEG', 'BMP']

    if not isinstance(imagefile, str):
        raise ValueError, "The imagefile argument is no string."     

    if not os.path.isfile(imagefile):
        raise ValueError, ("The imagefile argument '%s' is no visble name in the \
                        file system." % (imagefile) )
    
    try:
        image = PIL.Image.open(imagefile)
        name, e = os.path.splitext(imagefile)
        format = image.format
        if format in viewable:
            return imagefile
        else: 
            name_ = name + '.png'
            image.save(name_, mode='RGB')
            os.remove(imagefile)
            return name_
    except IOError, e:
        if str(e) == 'cannot identify image file':
            return None
        else:
            raise 
        
    return None


