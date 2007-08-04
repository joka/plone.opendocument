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
	
	
	
	<xsl:template match="office:text">
		<xsl:comment>page begin</xsl:comment>
		<div class="page"> <!-- default page background color -->
			<div>
				<xsl:attribute name="class">
					<xsl:text>masterpage_</xsl:text>
					<xsl:value-of select="//style:master-page[1]/@style:name" />
				</xsl:attribute>
				<xsl:apply-templates />
			</div>
		</div>
		<xsl:comment>page end</xsl:comment>
	</xsl:template>
	
	
	<xsl:template match="text:p">
		<p>
			<xsl:call-template name="class"/>
			<xsl:apply-templates />
			<!-- when paragraph is empty -->
			<xsl:if test="count(node())=0"><br /></xsl:if>
		</p>
	</xsl:template>
	
	
	<xsl:template match="text:span">
		<span>
			<xsl:call-template name="class"/>
			<xsl:apply-templates />
		</span>
	</xsl:template>
	
	
	<xsl:template match="text:h">
	<!-- Heading levels go only to 6 in XHTML -->
		<xsl:variable name="level">
			<xsl:choose>
				<!-- text:outline-level is optional, default is 1 -->
				<xsl:when test="not(@text:outline-level)">1</xsl:when>
				<xsl:when test="@text:outline-level &gt; 6">6</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@text:outline-level"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:element name="{concat('h', $level)}">
			<xsl:call-template name="add_id"/>
			<xsl:call-template name="class"/>
			<a name="{generate-id()}"></a>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	
	<xsl:template match="text:tab">
		<xsl:text xml:space="preserve"> </xsl:text>
	</xsl:template>
	
	
	<xsl:template match="text:line-break">
		<br />
	</xsl:template>
	
	
	<xsl:variable name="spaces" xml:space="preserve"></xsl:variable>
	
	
	<xsl:template match="text:s">
		<xsl:choose>
			<xsl:when test="@text:c">
				<xsl:call-template name="insert-spaces">
					<xsl:with-param name="n" select="@text:c"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text> </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template name="insert-spaces">
		<xsl:param name="n"/>
		<xsl:choose>
			<xsl:when test="$n &lt;= 30">
				<xsl:value-of select="substring($spaces, 1, $n)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$spaces"/>
				<xsl:call-template name="insert-spaces">
					<xsl:with-param name="n">
						<xsl:value-of select="$n - 30"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="text:a">
		<a href="{@xlink:href}"><xsl:apply-templates/></a>
	</xsl:template>
	
	
	<!--
	<text:bookmark-start /> and <text:bookmark-end /> can
	be on non-wellformed boundaries. The quickest solution is
	to create an <a name=""></a> element.
	
	If you don't put in any content, it becomes an empty element,
	which will confuse browsers. The right solution is to insert a
	zero-width non-breaking space (Unicode 0x200b) but this won't work
	with IE, so we use this instead.
	-->
	<xsl:template match="text:bookmark-start|text:bookmark">
		<a name="{@text:name}">
			<span style="font-size: 0px">
				<xsl:text> </xsl:text>
			</span>
		</a>
	</xsl:template>
	
	
	<!--
	This template is too dangerous to leave active...
	<xsl:template match="text()">
	<xsl:if test="normalize-space(.) !=''">
	<xsl:value-of select="normalize-space(.)"/>
	</xsl:if>
	</xsl:template>
	-->
	
	
	<xsl:template match="text:note">
		<xsl:variable name="footnote-id" select="text:note-citation" />
		<a href="#footnote-{$footnote-id}">
			<xsl:call-template name="add_id"/>
			<sup><xsl:value-of select="$footnote-id" /></sup>
		</a>
	</xsl:template>
	
	
	<xsl:template match="text:note-body"/> <!-- we don't want to output these inline -->
	
	
	<xsl:template name="add-footnote-bodies">
		<xsl:apply-templates select="//text:note" mode="add-footnote-bodies"/>
	</xsl:template>
	
	
	<xsl:template match="text:note" mode="add-footnote-bodies">
		<xsl:variable name="footnote-id" select="text:note-citation" />
		<p><a name="footnote-{$footnote-id}"><sup><xsl:value-of select="$footnote-id"/></sup>:</a></p>
		<xsl:apply-templates select="text:note-body/*" />
	</xsl:template>
	
	
	<xsl:template match="text:linenumbering-configuration" />
	<xsl:template match="text:outline-style" />
	
</xsl:stylesheet>
