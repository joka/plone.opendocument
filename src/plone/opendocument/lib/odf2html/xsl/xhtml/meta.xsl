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


	<xsl:template match="office:meta">
		<xsl:comment>office:metadata begin</xsl:comment>
		<xsl:apply-templates select="dc:title"/>
		<xsl:apply-templates select="dc:creator"/>
		<xsl:apply-templates select="dc:date"/>
		<xsl:apply-templates select="dc:language"/>
		<xsl:apply-templates select="dc:description"/>
		<xsl:apply-templates select="meta:keyword"/>
		<xsl:apply-templates select="meta:generator"/>
		<xsl:apply-templates select="meta:document-statistic"/>
		<meta http-equiv="Content-Type" content="application/xhtml+xml;charset=utf-8" />
		<xsl:comment>office:metadata end</xsl:comment>
	</xsl:template>


	<xsl:template match="dc:title">
		<title><xsl:apply-templates/></title>
		<meta name="DC.title" content="{current()}" />
	</xsl:template>

	<xsl:template match="dc:language">
		<meta http-equiv="content-language" content="{current()}" />
		<meta name="DC.language" content="{current()}" />
	</xsl:template>

	<xsl:template match="dc:creator">
		<meta name="author" content="{current()}" />
		<meta name="DC.creator" content="{current()}" />
	</xsl:template>

	<xsl:template match="dc:description">
		<meta name="description" content="{current()}" />
	</xsl:template>

	<xsl:template match="dc:date">
		<meta name="revised" content="{current()}" />
		<meta name="DC.date" content="{current()}" />
	</xsl:template>

	<xsl:template match="meta:keyword">
		<meta name="keywords" content="{current()}" />
	</xsl:template>

	<xsl:template match="meta:generator">
		<meta name="generator" content="{current()}" />
	</xsl:template>

	<xsl:template match="meta:document-statistic">
		<meta name="meta:page-count" content="{@meta:page-count}"/>
		<meta name="meta:word-count" content="{@meta:word-count}"/>
		<meta name="meta:image-count" content="{@meta:image-count}"/>
		<meta name="meta:table-count" content="{@meta:table-count}"/>
		<meta name="meta:object-count" content="{@meta:object-count}"/>
		<meta name="meta:character-count" content="{@meta:character-count}"/>
		<meta name="meta:paragraph-count" content="{@meta:paragraph-count}"/>
	</xsl:template>

</xsl:stylesheet>
