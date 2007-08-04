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
	
	
	<!--
		This template is part of the XSL DocBook Stylesheet distribution.
		See http://nwalsh.com/docbook/xsl/ for copyright and other information.
	-->
	
	<xsl:template name="length-magnitude">
		<xsl:param name="length" select="'0pt'"/>
			<xsl:choose>
				<xsl:when test="string-length($length) = 0"/>
				<xsl:when test="
					substring($length,1,1) = '-' or
					substring($length,1,1) = '0' or
					substring($length,1,1) = '1' or
					substring($length,1,1) = '2' or
					substring($length,1,1) = '3' or
					substring($length,1,1) = '4' or
					substring($length,1,1) = '5' or
					substring($length,1,1) = '6' or
					substring($length,1,1) = '7' or
					substring($length,1,1) = '8' or
					substring($length,1,1) = '9' or
					substring($length,1,1) = '.'"> 
				<xsl:value-of select="substring($length,1,1)"/>
				<xsl:call-template name="length-magnitude"> 
					<xsl:with-param name="length" select="substring($length,2)"/> 
				</xsl:call-template>
			</xsl:when> 
		</xsl:choose> 
	</xsl:template>
	
	<!--
		This template is a rewrited part of the XSL DocBook Stylesheet distribution.
		See http://nwalsh.com/docbook/xsl/ for copyright and other information.
	-->
	
	<xsl:template name="length-normalize">
		<xsl:param name="length" select="'0pt'"/>
		<xsl:param name="pixels.per.inch" select="72"/>
		<xsl:param name="unit" select="'pt'"/>
		
		<xsl:variable name="magnitude">
			<xsl:call-template name="length-magnitude">
				<xsl:with-param name="length" select="$length"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="units">
			<xsl:value-of select="substring($length, string-length($magnitude)+1)"/>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$units = '' and $magnitude=''">
				<xsl:value-of select="0"/>
				<xsl:value-of select="$unit"/>
			</xsl:when>
			<xsl:when test="$units = ''">
				<xsl:value-of select="$magnitude"/>
				<xsl:value-of select="$unit"/>
			</xsl:when>
			<xsl:when test="$units = 'em'">
				<xsl:value-of select="$magnitude * 12 * $scale"/>
				<xsl:value-of select="$unit"/>
			</xsl:when>
			<xsl:when test="$units = '%'">
				<xsl:value-of select="$magnitude * $scale"/>
				<xsl:text>%</xsl:text>
			</xsl:when>
			<xsl:when test="$units = 'px'">
				<xsl:value-of select="$magnitude div $pixels.per.inch * 72.0 * $scale"/>
				<xsl:value-of select="$unit"/>
			</xsl:when>
			<xsl:when test="$units = 'pt'">
				<xsl:value-of select="$magnitude * $scale"/>
				<xsl:value-of select="$unit"/>
			</xsl:when>
			<xsl:when test="$units = 'cm'">
				<xsl:value-of select="$magnitude * 28.45 * $scale"/>
				<xsl:value-of select="$unit"/>
			</xsl:when>
			<xsl:when test="$units = 'mm'">
				<xsl:value-of select="$magnitude * 28.45 * $scale * 10"/>
				<xsl:value-of select="$unit"/>
			</xsl:when>
             <xsl:when test="$units = 'in'">
				<xsl:value-of select="$magnitude * 2.45 * 28.45 * $scale"/>
				<xsl:value-of select="$unit"/>
			</xsl:when>  
			<!--
			<xsl:when test="$units = 'mm'">
				<xsl:value-of select="$magnitude div 25.4 * 72.0"/>
			</xsl:when>
			<xsl:when test="$units = 'in'">
				<xsl:value-of select="$magnitude * 72.0"/>
			</xsl:when>
			<xsl:when test="$units = 'pc'">
				<xsl:value-of select="$magnitude * 12.0"/>
			</xsl:when>
			<xsl:when test="$units = 'px'">
				<xsl:value-of select="$magnitude div $pixels.per.inch * 72.0"/>
			</xsl:when>
			-->
			<xsl:otherwise>
				<xsl:message>
					<xsl:text>Unrecognized unit of measure: </xsl:text>
					<xsl:value-of select="$units"/>
					<xsl:text>.</xsl:text>
				</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	
	<xsl:template name="add_id">
		<xsl:attribute name="id">
			
			<xsl:value-of select="name()"/>
			
			<xsl:text>-</xsl:text>
			
			<xsl:choose>
				<xsl:when test="@id">
					<xsl:value-of select="@id"/>
				</xsl:when>
				<xsl:when test="@draw:name">
					<xsl:text>draw:name_</xsl:text><xsl:value-of select="@draw:name"/>
				</xsl:when>
				<xsl:when test="@table:name">
					<xsl:text>table:name_</xsl:text><xsl:value-of select="@table:name"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="generate-id()"/>
				</xsl:otherwise>
		    </xsl:choose>
			
		</xsl:attribute>
	</xsl:template>
	
	
	
	<xsl:template name="find-padding-value">
		<xsl:param name="name" select="'right'"/>
		<xsl:param name="node" select="."/>
		
		<!-- find, what is style parrent to this element -->
		<xsl:variable name="parent" select="$node/@style:parent-style-name | $node/@draw:style-name"/>
		
		<xsl:choose>
			<xsl:when test="$name='top' and $node/style:graphic-properties/@fo:padding-top">
				<xsl:value-of select="$node/style:graphic-properties/@fo:padding-top"/>
			</xsl:when>
			<xsl:when test="$name='bottom' and $node/style:graphic-properties/@fo:padding-bottom">
				<xsl:value-of select="$node/style:graphic-properties/@fo:padding-bottom"/>
			</xsl:when>
			<xsl:when test="$name='left' and $node/style:graphic-properties/@fo:padding-left">
				<xsl:value-of select="$node/style:graphic-properties/@fo:padding-left"/>
			</xsl:when>
			<xsl:when test="$name='right' and $node/style:graphic-properties/@fo:padding-right">
				<xsl:value-of select="$node/style:graphic-properties/@fo:padding-right"/>
			</xsl:when>
			<xsl:when test="$parent">
				<xsl:call-template name="find-padding-value">
					<xsl:with-param name="name" select="$name"/>
					<xsl:with-param name="node" select="//style:style[@style:name=$parent]"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
		
	</xsl:template>
	
	
</xsl:stylesheet>
