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
	
	<!-- working example -->
	<!--
	<xsl:template match="draw:ellipse">
		<svg
			xmlns="http://www.w3.org/2000/svg"
			version="1.1">
			<ellipse style="fill:yellow">
				<xsl:attribute name="cx"><xsl:value-of select="@svg:x" /></xsl:attribute>
				<xsl:attribute name="cy"><xsl:value-of select="@svg:y" /></xsl:attribute>
				<xsl:attribute name="rx"><xsl:value-of select="@svg:rx | @svg:width" /></xsl:attribute>
				<xsl:attribute name="ry"><xsl:value-of select="@svg:ry | @svg:height" /></xsl:attribute>
			</ellipse>
		</svg>
	</xsl:template>
	-->
	
	
	<xsl:template match="draw:rect">
		<div>
			<xsl:call-template name="add_id"/>
			<xsl:call-template name="class"/>
			<xsl:attribute name="style">
				<!-- only for debug -->
				<!--<xsl:text>border: 1px solid #888; </xsl:text>-->
				<xsl:choose>
					<xsl:when test="//office:presentation">
						<xsl:text>position: absolute; </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>position: relative; </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<!-- positioning -->
				<xsl:apply-templates select="@*" mode="CSS-attr"/>
			</xsl:attribute>
			<xsl:apply-templates />
		</div>
	</xsl:template>
	
	
	
	<xsl:template match="draw:page">
		<xsl:choose>
			<xsl:when test="presentation:notes and $presentation.page.display=1 and $presentation.notes.display=1">
				<table class="page_table">
					<tr>
						<td>
							<div class="page">
								<div>
									<xsl:call-template name="add_id"/>
									<xsl:call-template name="class"/>
									<xsl:call-template name="master-page"/>
									<xsl:apply-templates />
								</div>
							</div>
						</td>
						<td>
							<div class="page">
								<xsl:apply-templates select="presentation:notes" mode="notes" />
							</div>
						</td>
					</tr>
				</table>
			</xsl:when>
			<xsl:when test="$presentation.page.display=1">
				<div class="page">
					<div>
						<xsl:call-template name="add_id"/>
						<xsl:call-template name="class"/>
						<xsl:call-template name="master-page"/>
						<xsl:apply-templates />
					</div>
				</div>
			</xsl:when>
			<xsl:when test="presentation:notes and $presentation.notes.display=1">
				<div class="page">
					<xsl:apply-templates select="presentation:notes" mode="notes" />
				</div>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
		<div class="page-break"/>
	</xsl:template>
	
	
	<xsl:template match="draw:frame">
		<div>
			<xsl:call-template name="add_id"/>
			<xsl:call-template name="class"/>
			<!--
			<xsl:attribute name="class">
				<xsl:text>text_</xsl:text><xsl:value-of select="@draw:text-style-name"/><xsl:text> </xsl:text>
				<xsl:text>presentation_</xsl:text><xsl:value-of select="@presentation:style-name"/><xsl:text>
			</xsl:attribute>
			-->
			<xsl:attribute name="style">
				<!-- only for debug -->
				<!--<xsl:text>border: 1px solid #888; </xsl:text>-->
				<xsl:choose>
					<xsl:when test="//office:presentation">
						<xsl:text>position: absolute; </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>position: relative; </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<!-- positioning -->
				<xsl:apply-templates select="@*" mode="CSS-attr"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<!-- ignoring displaying of text that is in background objects -->
	<xsl:template match="style:master-page//draw:text-box"/>
	
	<xsl:template match="draw:text-box">
		<div>
			<xsl:call-template name="add_id"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	
	<xsl:template match="draw:frame/draw:image">
		<xsl:element name="img">
			<xsl:attribute name="style">
				<!-- Default behaviour -->
				<xsl:text>width: 100%; height: 100%; </xsl:text>
				<xsl:if test="not(../@text:anchor-type='character')">
				<xsl:text>display: block; </xsl:text>
				</xsl:if>
			</xsl:attribute>
		
			<xsl:attribute name="alt">
				<xsl:value-of select="../svg:desc" />
			</xsl:attribute>
			<xsl:attribute name="src">
				<xsl:value-of select="concat($param_baseuri,@xlink:href)" />
			</xsl:attribute>
		</xsl:element>
	</xsl:template>
	
	
	<!-- elements we don't want to carry over into the document -->
	<xsl:template match="svg:desc" />
	
	
	<xsl:template match="draw:layer-set"/>
	
	
</xsl:stylesheet>
