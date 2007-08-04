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
	
	
	<xsl:template match="style:default-style">
		
		<xsl:value-of select="$linebreak"/>
		
		<xsl:if test="$CSS.debug=1">
			<xsl:text>/* style:default-style @style:family='</xsl:text>
			<xsl:value-of select='@style:family'/>
			<xsl:text>' begin */</xsl:text>
			<xsl:value-of select="$linebreak"/>
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="@style:family='paragraph'">
				<xsl:text>p</xsl:text>
			</xsl:when>
			<xsl:when test="@style:family='table'">
				<xsl:text>table</xsl:text>
			</xsl:when>
			<xsl:when test="@style:family='table-cell'">
				<xsl:text>td</xsl:text>
			</xsl:when>
			<xsl:when test="@style:family='table-row'">
				<xsl:text>tr</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>._</xsl:text><xsl:value-of select="@style:family"/>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:text>/* family default */</xsl:text>
		
		<xsl:value-of select="$linebreak"/>
		<xsl:text>{</xsl:text>
			<xsl:call-template name="style_default_default" mode="CSS-attr"/>
			<xsl:apply-templates/>
		<xsl:text>}</xsl:text>
		<xsl:value-of select="$linebreak"/>
		
		<xsl:if test="$CSS.debug=1">
			<xsl:text>/* style:default-style @style:family='</xsl:text>
			<xsl:value-of select='@style:family'/>
			<xsl:text>' end */</xsl:text>
			<xsl:value-of select="$linebreak"/>
		</xsl:if>
		
	</xsl:template>
	
	
	
	<xsl:template name="style_default_default" mode="CSS-attr">
	
		<xsl:if test="$CSS.debug=1">
			<xsl:text>/* default_default begin */</xsl:text>
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="@style:family='graphic'">
				<xsl:text>vertical-align: middle;</xsl:text>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
		
		<xsl:if test="$CSS.debug=1">
			<xsl:text>/* default_default end */</xsl:text>
			<xsl:value-of select="$linebreak"/>
		</xsl:if>
		
	</xsl:template>
	
    
	
	<xsl:template name="style_standard_default" mode="CSS-attr">
	
		<xsl:if test="$CSS.debug=1">
			<xsl:text>/* standard_default begin */</xsl:text>
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="name()='style:page-layout'">
				
				<xsl:text>border-left: 1px solid gray;</xsl:text>
				<xsl:text>border-right: 1px solid gray;</xsl:text>
				<xsl:text>border-top: 1px solid gray;</xsl:text>
				<xsl:text>border-bottom: 1px solid gray;</xsl:text>
				
				<xsl:if test="//office:text|//office:spreadsheet">
					<xsl:text>background-color: white;</xsl:text>
				</xsl:if>
			</xsl:when>
			<xsl:when test="@style:family='table'">
				<!--<xsl:text>border: 0pt solid black;</xsl:text>-->
				<xsl:text>padding: 0pt;</xsl:text>
				<xsl:text>margin: 0pt;</xsl:text>
			</xsl:when>
			<xsl:when test="@style:family='paragraph'">
				<!--<xsl:text>text-align: left;</xsl:text>-->
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
		
		<xsl:if test="$CSS.debug=1">
			<xsl:text>/* standard_default end */</xsl:text>
			<xsl:value-of select="$linebreak"/>
		</xsl:if>
		
	</xsl:template>
	
	
	<!-- standard styles -->
	
	
	
	<xsl:template match="style:style">
		
		<xsl:if test="$CSS.debug=1">
			<xsl:text>/* style:style @style:family='</xsl:text>
			<xsl:value-of select="@style:family"/>
			<xsl:text>' begin */</xsl:text>
		</xsl:if>
		
		<!-- classic style -->
		
		<xsl:value-of select="$linebreak"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="@style:family"/>
		<xsl:text>_</xsl:text>
		<xsl:value-of select="translate(@style:name,'.','_')"/>
		<xsl:value-of select="$linebreak"/>
		<xsl:text>{</xsl:text>
		
		<xsl:if test="$CSS.debug=1">
			<xsl:value-of select="$linebreak"/>
		</xsl:if>
		
		<xsl:call-template name="style_standard_default" mode="CSS-attr"/>
		<xsl:apply-templates select="@*" mode="CSS-attr"/>
		<xsl:apply-templates/>
		
		<xsl:text>}</xsl:text>
		<xsl:value-of select="$linebreak"/>
		
		<!-- special style for master elements -->
		<!--
			elements in master-page is affected only with styles defined
			in styles.xml, not with styles in content.xml
		-->
		<xsl:if test="ancestor::office:document-styles and @style:family='presentation'">
		
			<xsl:text>.</xsl:text>
			<xsl:value-of select="@style:family"/>
			<xsl:text>_</xsl:text>
			<xsl:value-of select="translate(@style:name,'.','_')"/>
			<xsl:text>_master</xsl:text>
			<xsl:value-of select="$linebreak"/>
			<xsl:text>{</xsl:text>
			
			<xsl:if test="$CSS.debug=1">
				<xsl:value-of select="$linebreak"/>
			</xsl:if>
			
			<xsl:call-template name="style_standard_default" mode="CSS-attr"/>
			<xsl:apply-templates select="@*" mode="CSS-attr"/>
			<xsl:apply-templates/>
			
			<xsl:text>}</xsl:text>
			<xsl:value-of select="$linebreak"/>
			
		</xsl:if>
		
		
		<xsl:if test="$CSS.debug=1">
			<xsl:text>/* style:style @style:family='</xsl:text>
			<xsl:value-of select="@style:family"/>
			<xsl:text>' end */</xsl:text>
			<xsl:value-of select="$linebreak"/>
		</xsl:if>
		
	</xsl:template>
	
	
	
	<xsl:template match="style:style" mode="CSS-attr">
		
		<xsl:if test="$CSS.debug=1">
			<xsl:text>/* style:style CSS-attr @style:family='</xsl:text>
			<xsl:value-of select="@style:family"/>
			<xsl:text>' begin */</xsl:text>
			<xsl:value-of select="$linebreak"/>
		</xsl:if>
		
		<xsl:apply-templates select="@*" mode="CSS-attr"/>
		<xsl:apply-templates/>
			
		<xsl:if test="$CSS.debug=1">
			<xsl:value-of select="$linebreak"/>
			<xsl:text>/* style:style CSS-attr @style:family='</xsl:text>
			<xsl:value-of select="@style:family"/>
			<xsl:text>' end */</xsl:text>
			<xsl:value-of select="$linebreak"/>
		</xsl:if>
		
	</xsl:template>
	
	
</xsl:stylesheet>
