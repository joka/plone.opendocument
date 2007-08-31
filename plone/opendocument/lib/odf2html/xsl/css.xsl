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



	<xsl:template match="office:document-content/office:automatic-styles"/>


	<xsl:template name="document-styles">
		<xsl:if test="not($param_no_css)">
		<style type="text/css">
			<xsl:call-template name="document-styles-css"/>
		</style>
		</xsl:if>
	</xsl:template>

	<xsl:template name="document-styles-css">
		/* office:document-styles begin */
    /*better plone support */
		/*html
		{
			font-family: Verdana, SunSans-Regular, Sans-Serif;
			font-size: <xsl:value-of select="$scale * 14" />pt;
		}
		@media print
		{
			html
			{
			}
		}
			@media screen
		{
			html
			{
				background-color: <xsl:value-of select="$style.background-color" />;
				margin: 1.5em;
				position: absolute;
			}
			body
			{
				position: absolute;
			}
		} */

        ul 
        {
            /*Reset some browser default styles */
            margin:0;
        }

        ul ul 
        {
            /*Reset some browser default styles */
            padding:0;
        }

        /*List items that are just list level wrapper don't need list marker */
        .listLevelWrapper
        {
            list-style-type:none;
        }

        table
        {
             /*Testfile letter.odt looks better without borders*/
		  /* border: thin solid gray;  */
			border-collapse: collapse;
			empty-cells: show;
			font-size: 10pt;
			table-layout: fixed;
		}
		td
		{
			/*order: thin solid gray;*/
			vertical-align: bottom;
		}
		.cell_string
		{
			text-align: left;
		}
		.cell_time
		{
			text-align: right;
		}
		p
		{
			margin-top: 0;
			margin-bottom: 0;
		}
		.page-break
		{
			margin: 1em;
		}
		
		.page_table {border: 0;}
		.page_table tr {border: 0;}
		.page_table td {border: 0; padding-right:3em; vertical-align:top;}
		
		.page
    { 
     /*  better plone support */
     /*
			background-color: white;
			border-left: 1px solid black;
			border-right: 2px solid black;
			border-top: 1px solid black; */
			border-bottom: 1px solid black;
			font-family: Verdana, SunSans-Regular, Sans-Serif;
			font-size: <xsl:value-of select="$scale * 14" />pt;
		}
		
		<xsl:if test="//office:spreadsheet">
			<xsl:text>
       /* testfile invoice.ods looks better without*/
      /*
        td p
		{
			max-height: 2.5ex;
			overflow: hidden;
		}
		td p:hover
		{
			max-height: none;
        }  */
    	    </xsl:text>
		</xsl:if>

		<xsl:apply-templates select="//office:document-styles/*"/>
		/* office:document-styles end */
		/* office:automatic-styles begin */
		<xsl:apply-templates select="//office:document-content/office:automatic-styles/*"/>

		/* office:automatic-styles end */
	</xsl:template>


	<xsl:template match="office:styles">
		<xsl:text>/* office:styles begin */</xsl:text>
		<xsl:value-of select="$linebreak"/>
		<xsl:apply-templates />
		<xsl:text>/* office:styles end */</xsl:text>
	</xsl:template>


	<xsl:template match="office:automatic-styles">
		<xsl:text>/* office:automatic-styles begin */</xsl:text>
		<xsl:apply-templates />
		<xsl:text>/* office:automatic-styles end */</xsl:text>
	</xsl:template>


	<xsl:template match="office:master-styles">
		<xsl:text>/* office:master-styles begin */</xsl:text>
		<xsl:apply-templates />
		<xsl:text>/* office:master-styles end */</xsl:text>
	</xsl:template>




	<!-- styles -->


	<!-- default styles -->


	<xsl:template match="@*" mode="CSS-attr" />


	<!-- properties to inherit -->


	<xsl:template match="
		style:drawing-page-properties|
		style:page-layout-properties|
		style:paragraph-properties|
		style:text-properties|
		style:graphic-properties|
		style:table-properties|
		style:table-column-properties|
		style:table-cell-properties|
		style:table-row-properties">

		<xsl:if test="$CSS.debug=1">
			<xsl:value-of select="$linebreak"/>
			<xsl:text>/* </xsl:text>
			<xsl:value-of select="name()"/>
			<xsl:text> begin */</xsl:text>
		</xsl:if>

		<xsl:apply-templates mode="CSS-attr" select="@*" />
		<xsl:apply-templates mode="CSS-attr" select="*" />

		<xsl:if test="$CSS.debug=1">
			<xsl:text>/* </xsl:text>
			<xsl:value-of select="name()"/>
			<xsl:text> end */</xsl:text>
			<xsl:value-of select="$linebreak"/>
		</xsl:if>

	</xsl:template>


	<xsl:template match="@style:parent-style-name" mode="CSS-attr">
		<xsl:variable name="style-name" select="."/>

		<xsl:if test="$CSS.debug=1">
			<xsl:text>/* @style:parent-style-name '</xsl:text>
			<xsl:value-of select="$style-name"/>
			<xsl:text>' begin */</xsl:text>
			<xsl:value-of select="$linebreak"/>
		</xsl:if>

		<xsl:apply-templates
					select="//style:style[@style:name=$style-name]"
					mode="CSS-attr"/>

		<xsl:if test="$CSS.debug=1">
			<xsl:text>/* @style:parent-style-name '</xsl:text>
			<xsl:value-of select="$style-name"/>
			<xsl:text>' end */</xsl:text>
			<xsl:value-of select="$linebreak"/>
		</xsl:if>

	</xsl:template>

	<!-- same as parent -->
	<!--
	<xsl:template match="@draw:style-name" mode="CSS-attr">
		<xsl:variable name="style-name" select="." />
			<xsl:text>/* @draw:style-name begin */</xsl:text>
			<xsl:apply-templates select="//style:style[@style:name=$style-name]" mode="CSS-attr" />
			<xsl:text>/* @draw:style-name end */</xsl:text>
	</xsl:template>
	-->

	<!-- apply styles -->

	<xsl:template name="class">
		<xsl:param name="prepend_style" select="''" />
		<xsl:variable name="class">

			<xsl:if test="$prepend_style != ''">
				<xsl:value-of select="$prepend_style"/><xsl:text> </xsl:text>
			</xsl:if>

			<!-- order by priority -->

			<xsl:if test="@draw:master-page-name">
				<xsl:text>masterpage_</xsl:text>
				<xsl:value-of select="@draw:master-page-name"/>
				<xsl:text> </xsl:text>
			</xsl:if>
			
			<xsl:if test="name()='presentation:notes' and ../@draw:master-page-name">
				<xsl:text>masterpage_</xsl:text>
				<xsl:value-of select="../@draw:master-page-name"/>
				<xsl:text>_notes </xsl:text>
			</xsl:if>
			
			<!-- default of family -->
			<xsl:choose>
				<xsl:when test="name()='draw:frame'">
					<xsl:text>_graphic </xsl:text>
				</xsl:when>
				<xsl:when test="name()='table:table-cell' and @office:value-type='string'">
					<xsl:text>cell_string </xsl:text>
				</xsl:when>
				<xsl:when test="name()='table:table-cell' and @office:value-type='time'">
					<xsl:text>cell_time </xsl:text>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>

			<xsl:choose>
				<xsl:when test="name()='text:span'">
					<xsl:if test="@text:style-name">
						<xsl:text>text_</xsl:text><xsl:value-of select="@text:style-name"/><xsl:text> </xsl:text>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="@text:style-name">
						<xsl:text>paragraph_</xsl:text><xsl:value-of select="@text:style-name"/><xsl:text> </xsl:text>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:if test="@table:style-name">
				<xsl:choose>
					<xsl:when test="name()='table:table-column'">
						<xsl:text>table-column_</xsl:text>
					</xsl:when>
					<xsl:when test="name()='table:table-row'">
						<xsl:text>table-row_</xsl:text>
					</xsl:when>
					<xsl:when test="name()='table:table-cell'">
						<xsl:text>table-cell_</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>table_</xsl:text>
<!-- void42: possible bug here -->
<!-- due to different style naming with "class" template above -->
					</xsl:otherwise>
				</xsl:choose>
				<xsl:value-of select="@table:style-name"/>
				<xsl:text> </xsl:text>
			</xsl:if>

			<xsl:if test="@presentation:style-name">
				<xsl:text>presentation_</xsl:text>
				<xsl:value-of select="@presentation:style-name"/>
				<xsl:if test="ancestor::style:master-page">
					<xsl:text>_master</xsl:text>
				</xsl:if>
				<xsl:text> </xsl:text>
			</xsl:if>

			<!--
				The draw:text-style-name attribute specifies a style for the drawing shape that
				is used to format the text that can be added to this shape.
				The value of this attribute is the name of a <style:style> element with a family
				value of paragraph.
			-->
			<xsl:if test="@draw:text-style-name">
				<xsl:text>paragraph_</xsl:text>
				<xsl:value-of select="@draw:text-style-name"/>
				<xsl:text> </xsl:text>
			</xsl:if>

			<xsl:if test="@draw:style-name">
				<xsl:choose>
					<xsl:when test="local-name()='page'">
						<xsl:text>drawing-page_</xsl:text>
					</xsl:when>
					<xsl:when test="local-name()='notes'">
						<xsl:text>drawing-page_</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>graphic_</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:value-of select="@draw:style-name"/>
				<xsl:text> </xsl:text>
			</xsl:if>

		</xsl:variable>

		<xsl:if test="$class != ''">
			<xsl:attribute name="class">
				<xsl:value-of select="translate($class,'.','_')" />
			</xsl:attribute>
		</xsl:if>

	</xsl:template>


	<!-- not implemented -->

	<xsl:template match="number:number-style"/>

	<xsl:template match="number:currency-style"/>

	<xsl:template match="number:time-style"/>


</xsl:stylesheet>
