XSL=odf2xhtml.xsl

default: allinone

clean:
	rm -f all-in-one.xsl

allinone:
	xsltproc build/allinone.xsl build/empty.xsl > all-in-one.xsl
	
example:
	xsltproc xsl/odf2xhtml.xsl tests/text/styles_01.odt.xml