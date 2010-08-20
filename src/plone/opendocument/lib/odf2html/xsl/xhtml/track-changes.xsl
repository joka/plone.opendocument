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
	
	
	<xsl:template match="text:tracked-changes">
		<xsl:comment> Document has track-changes on </xsl:comment>
	</xsl:template>
	
	
	<!-- Handle deletions -->
	<xsl:template match="text:change">
		<xsl:if test="$param_track_changes">
			<xsl:variable name="id" select="@text:change-id"/>
			<xsl:variable name="change" select="//text:changed-region[@text:id=$id]"/>
			<xsl:element name="del">
				<xsl:attribute name="datetime">
					<xsl:value-of select="$change//dc:date"/>
				</xsl:attribute>
				<xsl:apply-templates match="$change/text:deletion/*"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	
	<!-- Handle insertions -->
	<xsl:template
		match="text:p//text()[count(preceding::text:change-start) &gt; count(preceding::text:change-end)][count(following::text:change-start) &lt; count(following::text:change-end)]">
		<xsl:choose>
			<xsl:when test="$param_track_changes">
				<ins><xsl:value-of select="."/></ins>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- Don't process office:change-info -->
	<xsl:template match="office:change-info"/>
	
	
</xsl:stylesheet>
