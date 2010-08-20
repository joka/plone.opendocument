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
	version="1.0"
	exclude-result-prefixes="office meta config text table draw presentation dr3d chart form script style number anim dc xlink math xforms fo svg smil ooo ooow oooc int exslt #default">

	<xsl:output
		method="xml"
		indent="yes"
		omit-xml-declaration="yes"
		doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
		encoding="UTF-8"/>


	<!-- params -->
	<xsl:include href="param.xsl" />

	<!-- common functions -->
	<xsl:include href="common/common.xsl" />

	<!-- OpenDocument structure -->
	<xsl:include href="odf.xsl" />

	<!-- CSS to output -->
	<xsl:include href="css.xsl" />
	<xsl:include href="css/default.xsl" />
	<xsl:include href="css/layout.xsl" />
	<xsl:include href="css/table.xsl" />
	<xsl:include href="css/attribute.xsl" />

	<!-- XHTML output -->
	<xsl:include href="xhtml/draw.xsl" />
	<xsl:include href="xhtml/meta.xsl" />
	<xsl:include href="xhtml/presentation.xsl" />
	<xsl:include href="xhtml/spreadsheet.xsl" />
	<xsl:include href="xhtml/page.xsl" />
	<xsl:include href="xhtml/table.xsl" />
	<xsl:include href="xhtml/text.xsl" />
	<xsl:include href="xhtml/list.xsl" />
	<xsl:include href="xhtml/toc.xsl" />
	<xsl:include href="xhtml/track-changes.xsl" />


</xsl:stylesheet>
