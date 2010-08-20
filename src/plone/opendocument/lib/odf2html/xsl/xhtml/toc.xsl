<?xml version="1.0" encoding="UTF-8"?>
<!--

-->
<xsl:stylesheet
	xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
	xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0"
	xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0"
	xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
	xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
	xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
	xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0"
	xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0"
	xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0"
	xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0"
	xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0"
	xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
	xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
	xmlns:anim="urn:oasis:names:tc:opendocument:xmlns:animation:1.0"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:math="http://www.w3.org/1998/Math/MathML"
	xmlns:xforms="http://www.w3.org/2002/xforms"
	xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
	xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
	xmlns:smil="urn:oasis:names:tc:opendocument:xmlns:smil-compatible:1.0"
	xmlns:ooo="http://openoffice.org/2004/office"
	xmlns:ooow="http://openoffice.org/2004/writer"
	xmlns:oooc="http://openoffice.org/2004/calc"
	xmlns:int="http://opendocumentfellowship.org/internal"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">
	
	
	<xsl:template match="text:table-of-content">
		<xsl:apply-templates/>
	</xsl:template>
	
	
	<xsl:template match="text:table-of-content-source"/>
	
	
	<xsl:template match="text:index-body">
		<xsl:apply-templates/>
	</xsl:template>
	
	
	<!-- not reimplemented yet -->
	<!-- We don't parse the app's ToC but generate our own. -->
	<!-- ODF spec says that when unspecified the outline
             level should be considered to be 1. -->
	<!--
<xsl:template match="text:table-of-content">
  <div class="toc">
    <xsl:apply-templates select="text:index-body/text:index-title"/>
    <xsl:apply-templates select="//text:h" mode="toc"/>
  </div>
</xsl:template>

<xsl:template match="text:h" mode="toc">
  <xsl:element name="p">
    <xsl:attribute name="class">
      <xsl:text>toc_outline_level_</xsl:text>
      <xsl:choose>
        <xsl:when test="@text:outline-level">
          <xsl:value-of select="@text:outline-level"/>
        </xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <a href="#{generate-id()}"><xsl:value-of select="."/></a>
  </xsl:element>
</xsl:template>

	-->
	
	
</xsl:stylesheet>
