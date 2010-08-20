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
    
	<xsl:template match="@style:column-width" mode="CSS-attr">
		<xsl:text>width: </xsl:text>
		<xsl:call-template name="normalized-value"/>
	</xsl:template>
	
<!-- void: style:rel-column-width contains a value like "1*", "2*" an so on;
	it means relative column width 
	comparing to all other columns with this attribute set;
	and thus can not to be converted to a CSS length value.
	It should be converted into <col width="1*" attribute instead.
-->

	<xsl:template match="@style:horizontal-pos" mode="CSS-attr">
		<xsl:choose>
			<!-- We can't support the others until we figure out pagination. -->
			<xsl:when test=".='left'">
				<xsl:text>margin-left: 0; margin-right: auto; </xsl:text>
			</xsl:when>
			<xsl:when test=".='right'">
				<xsl:text>margin-left: auto; margin-right: 0; </xsl:text>
			</xsl:when>
			<xsl:when test=".='center'">
				<xsl:text>margin-left: auto; margin-right: auto;</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
   
	
	<xsl:template match="@style:rel-width" mode="CSS-attr">
		<xsl:text>width: </xsl:text><xsl:value-of select="."/><xsl:text>%; </xsl:text>
	</xsl:template>
	
	
	<xsl:template match="@style:row-height" mode="CSS-attr">
		<xsl:text>height: </xsl:text>
		<xsl:call-template name="normalized-value"/>
	</xsl:template>	
	
	<xsl:template match="@style:min-row-height" mode="CSS-attr">
		<xsl:text>min-height: </xsl:text>
		<xsl:call-template name="normalized-value"/>
	</xsl:template>
	
	<xsl:template match="@style:text-align-source" mode="CSS-attr">
		<xsl:if test=". = 'value-type'">
			<xsl:text>text-align: right !important; </xsl:text>
		</xsl:if>
	</xsl:template>
	
	<!-- colors -->
	
	<!--
		15.14.2 Color
		The attribute draw:fill-color specifies the color of the fill for a graphic object.
		It is used only if the draw:fill attribute has the value solid.
	-->
	<xsl:template match="@draw:fill" mode="CSS-attr">
		<xsl:if test="not(@draw:fill-color)">
			<xsl:text>background-color: transparent;</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="@draw:fill-color" mode="CSS-attr">
		
		<xsl:variable name="parent" select="../../@style:parent-style-name"/>
		
		<!-- defined default @draw:fill -->
		<xsl:variable name="default">
			<xsl:choose>
				<!-- if default @draw-fill for graphic is defined in parent style -->
				<xsl:when
					test="//style:style[@style:name=$parent]/style:graphic-properties/@draw:fill">
					<!-- use it -->
					<xsl:value-of
						select="//style:style[@style:name=$parent]/style:graphic-properties/@draw:fill" />
				</xsl:when>
				<!-- if default @draw-fill for graphic is defined -->
				<xsl:when
					test="//style:default-style[@style:family='graphic']/style:graphic-properties/@draw:fill">
					<!-- use it -->
					<xsl:value-of
						select="//style:default-style[@style:family='graphic']/style:graphic-properties/@draw:fill" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>solid</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!--
		<xsl:message>
			<xsl:text>@draw:fill-color </xsl:text>
			<xsl:text>parent:</xsl:text><xsl:value-of select="$parent"/><xsl:text> </xsl:text>
			<xsl:text>default:</xsl:text><xsl:value-of select="$default"/><xsl:text> </xsl:text>
		</xsl:message>
		-->
		
		<xsl:choose>
			<xsl:when test="../@draw:fill='solid'">
				<xsl:text>background-color: </xsl:text>
				<xsl:value-of select="../@draw:fill-color"/><xsl:text>; </xsl:text>
			</xsl:when>
			<xsl:when test="../@draw:fill='none'">
				<xsl:text>background-color: transparent;</xsl:text>
			</xsl:when>
			<!--
				OOo Issue #: 72134
				Specification at 14.2 Default Styles
				"These defaults are  used if a formatting property is neither specified
				by an automatic nor a common style."
				If you do not specify a style:default-style, the application will use its own
				defaults for properties that have no specified default. OOo.org as an
				application has a default of solid for the property draw:fill-style.
				Application defaults are things that can change from application to application
				and also from version to version, thats why we added the default styles. All
				applications creating OpenDocument files should use them and define their
				defaults for each property that has no specified default, if not, the results
				are unpredictable.
			-->
			<xsl:when test="not(../@draw:fill) and $default='solid' and ancestor::office:document-styles">
				<xsl:text>background-color: </xsl:text>
				<xsl:value-of select="../@draw:fill-color"/><xsl:text>; </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>background-color: transparent; </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	
	<xsl:template match="@draw:stroke" mode="CSS-attr">
		<xsl:if test="not(@svg:stroke-color)">
			<xsl:text>border-color: transparent;</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="@svg:stroke-color" mode="CSS-attr">
		
		<xsl:variable name="parent" select="../../@style:parent-style-name"/>
		
		<!-- defined default @draw:stroke -->
		<xsl:variable name="default">
			<xsl:choose>
				<!-- if default @draw-stroke for graphic is defined in parent style -->
				<xsl:when
					test="//style:style[@style:name=$parent]/style:graphic-properties/@draw:stroke">
					<!-- use it -->
					<xsl:value-of
						select="//style:style[@style:name=$parent]/style:graphic-properties/@draw:stroke" />
				</xsl:when>
				<!-- if default @draw-stroke for graphic is defined -->
				<xsl:when
					test="//style:default-style[@style:family='graphic']/style:graphic-properties/@draw:stroke">
					<!-- use it -->
					<xsl:value-of
						select="//style:default-style[@style:family='graphic']/style:graphic-properties/@draw:fill" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>solid</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="width">
			<xsl:choose>
				<xsl:when test="../@svg:stroke-width">
					<xsl:value-of select="../@svg:stroke-width" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>1pt</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
        </xsl:variable>                 /
		
		<xsl:choose>
			<xsl:when test="../@draw:stroke='solid'">
				<xsl:text>border-style: solid; border-width: </xsl:text>
				<xsl:value-of select="$width" />
				<xsl:text>; border-color: </xsl:text>
				<xsl:value-of select="../@svg:stroke-color"/><xsl:text>; </xsl:text>
			</xsl:when>
			<xsl:when test="../@draw:stroke='dash'">
				<xsl:text>border-style: dashed; border-width: </xsl:text>
				<xsl:value-of select="$width" />
				<xsl:text>; border-color: </xsl:text>
				<xsl:value-of select="../@svg:stroke-color"/><xsl:text>; </xsl:text>
			</xsl:when>
			<xsl:when test="../@draw:stroke='none'">
				<xsl:text>border-size: 0pt;</xsl:text>
			</xsl:when>
			<xsl:when test="not(../@draw:stroke) and $default='solid' and ancestor::office:document-styles">
				<xsl:text>border-style: solid; border-width: </xsl:text>
				<xsl:value-of select="$width" />
				<xsl:text>; border-color: </xsl:text>
				<xsl:value-of select="../@svg:stroke-color"/><xsl:text>; </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>border-color: transparent; </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	
	<!-- proportions -->

	<xsl:template match="@svg:width" mode="CSS-attr">
		<xsl:variable name="width">
			<xsl:call-template name="normalized-just-value"/>
		</xsl:variable>
		<xsl:variable name="padding-right">
			<xsl:call-template name="length-normalize">
				<xsl:with-param name="unit" select="''"/>
				<xsl:with-param name="length">
					<xsl:call-template name="find-padding-value">
						<xsl:with-param name="name" select="'right'"/>
						<xsl:with-param name="node" select=".."/>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="padding-left">
			<xsl:call-template name="length-normalize">
				<xsl:with-param name="unit" select="''"/>
				<xsl:with-param name="length">
					<xsl:call-template name="find-padding-value">
						<xsl:with-param name="name" select="'left'"/>
						<xsl:with-param name="node" select=".."/>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="width-recomputed" select="$width - $padding-left - $padding-right"/>
		<xsl:text>width: </xsl:text><xsl:value-of select="$width-recomputed"/><xsl:text>pt; </xsl:text>
	</xsl:template>
	
	<xsl:template match="@svg:height" mode="CSS-attr">
		<xsl:variable name="height">
			<xsl:call-template name="normalized-just-value"/>
		</xsl:variable>
		<xsl:variable name="padding-top">
			<xsl:call-template name="length-normalize">
				<xsl:with-param name="unit" select="''"/>
				<xsl:with-param name="length">
					<xsl:call-template name="find-padding-value">
						<xsl:with-param name="name" select="'top'"/>
						<xsl:with-param name="node" select=".."/>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="padding-bottom">
			<xsl:call-template name="length-normalize">
				<xsl:with-param name="unit" select="''"/>
				<xsl:with-param name="length">
					<xsl:call-template name="find-padding-value">
						<xsl:with-param name="name" select="'bottom'"/>
						<xsl:with-param name="node" select=".."/>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="height-recomputed" select="$height - $padding-top - $padding-bottom"/>
		<xsl:text>height: </xsl:text><xsl:value-of select="$height-recomputed"/><xsl:text>pt; </xsl:text>
	</xsl:template>
	
	
	<xsl:template match="@svg:x" mode="CSS-attr">
		<xsl:variable name="x">
			<xsl:call-template name="length-normalize">
				<xsl:with-param name="unit" select="''"/>
				<xsl:with-param name="length" select="."/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="page-layout-name" select="//style:master-page/@style:page-layout-name" />
		<xsl:variable name="margin-left">
			<xsl:call-template name="length-normalize">
				<xsl:with-param name="unit" select="''"/>
				<xsl:with-param name="length"
					select="
						//style:page-layout[@style:name=$page-layout-name]
						/style:page-layout-properties
						/@fo:margin-left"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:text>margin-left: </xsl:text>
		<xsl:value-of select="$x - $margin-left"/><xsl:text>pt; </xsl:text>
	</xsl:template>
	
	<xsl:template match="@svg:y" mode="CSS-attr">
		<xsl:variable name="y">
			<xsl:call-template name="length-normalize">
				<xsl:with-param name="unit" select="''"/>
				<xsl:with-param name="length" select="."/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="page-layout-name" select="//style:master-page/@style:page-layout-name" />
		<xsl:variable name="margin-top">
			<xsl:call-template name="length-normalize">
				<xsl:with-param name="unit" select="''"/>
				<xsl:with-param name="length"
					select="
						//style:page-layout[@style:name=$page-layout-name]
						/style:page-layout-properties
						/@fo:margin-top"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:text>margin-top: </xsl:text>
		<xsl:value-of select="$y - $margin-top"/><xsl:text>pt; </xsl:text>
	</xsl:template>
	
	
	<xsl:template match="@style:width|@style:height|@fo:width|@fo:height" mode="CSS-attr">
		<xsl:call-template name="copy-attr-normalized"/>
	</xsl:template>
	
	
	<xsl:template match="@fo:margin-top" mode="CSS-attr">
		<xsl:text>margin-top:</xsl:text>
		<xsl:call-template name="normalized-value"/>
	</xsl:template>
	
	<xsl:template match="@fo:margin-bottom" mode="CSS-attr">
		<xsl:text>margin-bottom:</xsl:text>
		<xsl:call-template name="normalized-value"/>
	</xsl:template>
	
	<xsl:template match="@fo:margin-left" mode="CSS-attr">
        <xsl:text>margin-left:</xsl:text>
        <xsl:call-template name="normalized-value"/>
	</xsl:template>
	
	<xsl:template match="@fo:margin-right" mode="CSS-attr">
		<xsl:text>margin-right:</xsl:text>
		<xsl:call-template name="normalized-value"/>
	</xsl:template>
	   	
	<!-- font -->
		
	<xsl:template
		match="
			@fo:font-name|
			@fo:font-family|
			@svg:font-family" mode="CSS-attr">
		<xsl:text>font-family: </xsl:text><xsl:value-of select="." />
		<xsl:text>; </xsl:text>
	</xsl:template>
	
	
	<xsl:template match="@style:font-name" mode="CSS-attr">
		<xsl:variable name="style_name" select="."/>
		<xsl:text>font-family: </xsl:text><xsl:value-of select="//style:font-face[@style:name=$style_name]/@svg:font-family" />
		<xsl:text>; </xsl:text>
	</xsl:template>
	
	<xsl:template
		match="
			@fo:font-variant|
			@fo:font-style|          
			@fo:font-weight"
		mode="CSS-attr">
		<xsl:call-template name="copy-attr"/>
	</xsl:template>
	
	
	<xsl:template
		match="
			@fo:color|
			@fo:background-color" mode="CSS-attr">
		<xsl:call-template name="copy-attr"/>
	</xsl:template>
	
	
	<xsl:template
		match="
			@fo:text-indent|
			@fo:font-size|
			@fo:line-height" mode="CSS-attr">
		<xsl:call-template name="copy-attr-normalized"/>
	</xsl:template>
	
	
	<xsl:template match="@fo:text-align" mode="CSS-attr">
		<xsl:value-of select="local-name()"/><xsl:text>: </xsl:text>
		<xsl:choose>
			<xsl:when test=".='start'"><xsl:text>left</xsl:text></xsl:when>
			<xsl:when test=".='end'"><xsl:text>right</xsl:text></xsl:when>
			<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
		</xsl:choose>
		<xsl:text>; </xsl:text>
	</xsl:template>	
	
	
	<!-- CSS2 only has one type of underline. We can improve this when CSS3 is better supported. -->
	<xsl:template
		match="
			@style:text-underline-style|
			@style:text-underline-type"
		mode="CSS-attr">
		<xsl:if test="not(.='none')">
			<xsl:text>text-decoration: underline;</xsl:text>
		</xsl:if>
	</xsl:template>
	
	
	
	<!-- border -->
	
	
	
	<xsl:template
		match="
			@fo:border|
			@fo:border-top|
			@fo:border-bottom|
			@fo:border-left|
			@fo:border-right"
		mode="CSS-attr">
		<xsl:call-template name="copy-attr"/>
	</xsl:template>
	
	<!-- padding -->
	
	<xsl:template
		match="
			@fo:padding|
			@fo:padding-top|
			@fo:padding-bottom|
			@fo:padding-left|
			@fo:padding-right"
		mode="CSS-attr">
		<xsl:call-template name="copy-attr-normalized"/>
	</xsl:template>	
	
	<!-- breaks -->
	
	<xsl:template match="@style:may-break-between-rows" mode="CSS-attr">
		<xsl:choose>
			<xsl:when test=". = 'true'">
				<xsl:text>page-break-inside: auto; </xsl:text>
			</xsl:when>
			<xsl:when test=". = 'false'">
				<xsl:text>page-break-inside: avoid; </xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="@fo:break-before" mode="CSS-attr">
		<xsl:choose>
			<xsl:when test=". = 'auto'">
				<xsl:text>page-break-before: auto;</xsl:text>
			</xsl:when>
			<xsl:when test=". = 'page'">
				<xsl:text>page-break-before: always;</xsl:text>
			</xsl:when>
			<xsl:when test=". = 'column'">
				<xsl:text>/* page-break-before: column; UNSUPPORTED */</xsl:text>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="@fo:break-after" mode="CSS-attr">
		<xsl:choose>
			<xsl:when test=". = 'auto'">
				<xsl:text>page-break-after: auto;</xsl:text>
			</xsl:when>
			<xsl:when test=". = 'page'">
				<xsl:text>page-break-after: always;</xsl:text>
			</xsl:when>
			<xsl:when test=". = 'column'">
				<xsl:text>/* page-break-after: column; UNSUPPORTED */</xsl:text>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="@fo:keep-with-next" mode="CSS-attr">
		<xsl:choose>
			<xsl:when test=". = 'auto'">
				<xsl:text>page-break-after: auto;</xsl:text>
			</xsl:when>
			<xsl:when test=". = 'always'">
				<xsl:text>page-break-after: avoid;</xsl:text>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="@fo:keep-together" mode="CSS-attr">
		<xsl:choose>
			<xsl:when test=". = 'auto'">
				<xsl:text>page-break-inside: auto; </xsl:text>
			</xsl:when>
			<xsl:when test=". = 'always'">
				<xsl:text>page-break-inside: avoid; </xsl:text>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="@fo:wrap-option" mode="CSS-attr">
		<xsl:choose>
			<xsl:when test=". = 'no-wrap'">
				<xsl:text>white-space: nowrap; </xsl:text>
			</xsl:when>
			<xsl:when test=". = 'wrap'">
				<xsl:text>white-space: normal; </xsl:text>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	
	<!-- Text direction -->
	<xsl:template match="@style:writing-mode" mode="CSS-attr">
  <!--propritary microsoft -->
		<!--<xsl:choose>-->
			<!--<xsl:when test=". = 'lr-tb' or . = 'lr'">-->
				<!--<xsl:text>direction: ltr; </xsl:text>-->
				<!--<xsl:text>writing-mode: lr-tb; </xsl:text>-->
			<!--</xsl:when>-->
			<!--<xsl:when test=". = 'rl-tb' or . = 'rl'">-->
				<!--<xsl:text>direction: rtl; </xsl:text>-->
				<!--<xsl:text>writing-mode: rl-tb; </xsl:text>-->
			<!--</xsl:when>-->
			<!--<xsl:when test=". = 'tb-rl' or . = 'tb'">-->
				<!--<xsl:text>direction: rtl; </xsl:text>-->
				<!--<xsl:text>writing-mode: tb-rl; </xsl:text>-->
			<!--</xsl:when>-->
			<!--<xsl:when test=". = 'tb-lr'">-->
				<!--<xsl:text>direction: ltr; </xsl:text>-->
				<!--<xsl:text>writing-mode: tb-lr; </xsl:text>-->
			<!--</xsl:when>-->
			<!--<xsl:when test=". = 'page'">-->
				<!--<xsl:text>direction: inherit; </xsl:text>-->
				<!--<xsl:text>writing-mode: inherit; </xsl:text>-->
			<!--</xsl:when>-->
			<!--<xsl:otherwise>-->
				<!--<xsl:call-template name="copy-attr" />-->
			<!--</xsl:otherwise>-->
		<!--</xsl:choose>-->
	</xsl:template>

	<xsl:template match="@style:direction" mode="CSS-attr">
		<xsl:choose>
			<xsl:when test=". = 'ltr'">
				<!-- do nothing? -->
			</xsl:when>
			<xsl:when test=". = 'ttb'">
				<!-- no CSS2 way to do it -->
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- void42: there should be no "@style..." here -->
	<!-- this is really a nested element -->
	<!-- maybe this template should be moved into another file -->
	<xsl:template match="style:background-image[@xlink:href]" mode="CSS-attr">
		<xsl:if test="../@fo:background-color != 'transparent'">
			<xsl:text>background-image: url('</xsl:text><xsl:value-of select="@xlink:href" /><xsl:text>'); </xsl:text>
			<xsl:choose>
				<!-- do not copy default value -->
				<xsl:when test="@style:repeat and @style:repeat = 'repeat'">
					<xsl:text>background-repeat: repeat;</xsl:text>
				</xsl:when>
				<xsl:when test="@style:repeat = 'no-repeat'">
					<xsl:text>background-repeat: no-repeat;</xsl:text>
				</xsl:when>
				<xsl:when test="@style:repeat = 'stretch'">
					<xsl:text>/* background-repeat: stretch; UNSUPPORTED */ </xsl:text>
				</xsl:when>
			</xsl:choose>
			<xsl:if test="@style:position">
				<xsl:text>background-position: </xsl:text><xsl:value-of select="@style:position" /><xsl:text>; </xsl:text>
			</xsl:if>
		</xsl:if>
    </xsl:template>

    <!-- others -->
    <xsl:template match="style:list-style-name" mode="CSS-attr">
    </xsl:template>
	
	<!-- Utility functions -->	
	<xsl:template name="copy-attr-normalized" mode="CSS-attr">
		<xsl:value-of select="local-name()"/><xsl:text>:</xsl:text>
		<xsl:call-template name="normalized-value"/>
	</xsl:template>

	<xsl:template name="normalized-value" mode="CSS-attr">
        <xsl:param name="length" select="."/>
		<xsl:call-template name="length-normalize">
			<xsl:with-param name="length" select="$length"/>
		</xsl:call-template>
		<xsl:text>; </xsl:text>
	</xsl:template>
    
	<xsl:template name="normalized-just-value" mode="CSS-attr">
		<xsl:call-template name="length-normalize">
			<xsl:with-param name="length" select="."/>
			<xsl:with-param name="unit" select="''"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="copy-attr" mode="CSS-attr">
		<xsl:value-of select="local-name()"/><xsl:text>:</xsl:text>
		<xsl:value-of select="." /><xsl:text>; </xsl:text>
	</xsl:template>
	
</xsl:stylesheet>
