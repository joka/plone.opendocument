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
	
	
	<!-- This section of the transformation handles lists. -->
	
	<xsl:key name="listTypes" match="text:list-style" use="@style:name"/>
    
    <!--Key for @style:list-style-name associations-->    
    <xsl:key name="stylesAssociated" match="style:style[*/@fo:margin-left]" use="@style:list-style-name"/>
    
	<xsl:template match="text:list-style">
		
		<xsl:if test="$CSS.debug=1">
			<xsl:text>/* text:list-style '</xsl:text>
			<xsl:value-of select="@style:name"/>
			<xsl:text>' begin */</xsl:text>
			<xsl:value-of select="$linebreak"/>
        </xsl:if>

		<xsl:apply-templates select="@*" mode="CSS-attr"/>
        <xsl:apply-templates/>

		<xsl:if test="$CSS.debug=1">
			<xsl:text>/* text:list-style '</xsl:text>
			<xsl:value-of select="@style:name"/>
			<xsl:text>' end */</xsl:text>
			<xsl:value-of select="$linebreak"/>
		</xsl:if>
		
	</xsl:template>
	
	
	<xsl:template match="text:list-level-style-bullet|text:list-level-style-number|text:list-level-style-image">
		
		<xsl:variable name="node" select="name()"/>
		<xsl:variable name="style-name" select="@text:style-name|../@style:name"/>
		<xsl:variable name="listLevelNode" select="."/>
		
		<xsl:if test="$CSS.debug=1">
			<xsl:text>/* </xsl:text>
			<xsl:value-of select="$node"/>
			<xsl:text> '</xsl:text>
			<xsl:value-of select="$style-name"/>
			<xsl:text>' begin */</xsl:text>
			<xsl:value-of select="$linebreak"/>
		</xsl:if>
		
        <xsl:variable name="className">
            <xsl:value-of select="$linebreak"/>
            <xsl:text>.list_</xsl:text>
            <xsl:value-of select="translate($style-name,'.','_')"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="@text:level"/>
        </xsl:variable>
        <xsl:value-of select="$className"/>
        <xsl:value-of select="$linebreak"/>
		<xsl:text>{</xsl:text>
        <xsl:value-of select="$linebreak"/>
		
		<xsl:apply-templates select="@*" mode="CSS-attr"/>
        <xsl:call-template name="computed-space-before" mode="CSS-attr"/>
              
        <xsl:value-of select="$linebreak"/>
        <xsl:text>}</xsl:text>
        <xsl:value-of select="$linebreak"/>                                           
        
        <xsl:for-each select="key('stylesAssociated',$style-name)">
            <xsl:value-of select="$className"/>
            <xsl:value-of select="concat('_', ./@style:name, $linebreak)"/> 
            <xsl:text>{</xsl:text>
            <xsl:value-of select="$linebreak"/>

            <!--Compute and emit @text:space-before-->  
            <xsl:call-template name="computed-space-before" mode="CSS-attr">
                <xsl:with-param name="associatedStyle" select="."/>
                <xsl:with-param name="listLevelNode" select="$listLevelNode"/>
            </xsl:call-template>
              
            <xsl:value-of select="$linebreak"/>
            <xsl:text>}</xsl:text>
            <xsl:value-of select="$linebreak"/>

            <!--We still have to overwrite the margin-left value of child elements. -->
            <xsl:value-of select="$className"/>
            <xsl:value-of select="concat('_', ./@style:name, ' p,h1,h2,h3,h4,h5,h6', $linebreak)"/> 
            <xsl:text>{</xsl:text> 
            <xsl:value-of select="$linebreak"/> 
            <xsl:text> margin-left: 0; </xsl:text> 
            <xsl:value-of select="$linebreak"/> 
            <xsl:text>}</xsl:text> 
            <xsl:value-of select="$linebreak"/>                                          

        </xsl:for-each>
	   
            <xsl:if test="$CSS.debug=1">
			<xsl:text>/* </xsl:text>
			<xsl:value-of select="$node"/>
			<xsl:text> '</xsl:text>
			<xsl:value-of select="$style-name"/>
			<xsl:text>' end */</xsl:text>
			<xsl:value-of select="$linebreak"/>
        </xsl:if>

	</xsl:template>
	
	
	<xsl:template match="text:list-level-style-bullet/@text:level" mode="CSS-attr">
		<xsl:text>list-style-type: </xsl:text>  
			<xsl:choose>
				<xsl:when test=". mod 3 = 1">disc</xsl:when>
				<xsl:when test=". mod 3 = 2">circle</xsl:when>
				<xsl:when test=". mod 3 = 0">square</xsl:when>
				<xsl:otherwise>disc</xsl:otherwise>
      </xsl:choose>
		<xsl:text>; </xsl:text>
  </xsl:template>
	
	
	<xsl:template match="text:list-level-style-number/@text:level" mode="CSS-attr">
		<xsl:text>list-style-type: </xsl:text>
			<xsl:choose>
                <xsl:when test="../@style:num-format='1'">decimal</xsl:when>
                <xsl:when test="../@style:num-format='I'">upper-roman</xsl:when>
                <xsl:when test="../@style:num-format='i'">lower-roman</xsl:when>
                <xsl:when test="../@style:num-format='A'">upper-alpha</xsl:when>
                <xsl:when test="../@style:num-format='a'">lower-alpha</xsl:when>
				<xsl:otherwise>decimal</xsl:otherwise>
			</xsl:choose>
		<xsl:text>; </xsl:text>
	</xsl:template> 

  <xsl:template match="text:list-level-style-image/@text:level" mode="CSS-attr">
        <xsl:text>list-style-image: </xsl:text>
        <xsl:value-of select="concat('url(',$param_baseuri,./../@xlink:href,'); ')" />
  </xsl:template>
    
    <!--
        (15.12 Start Indent)
        The text:space-before attribute specifies the space to include before the number for all
        paragraphs at this level. If a paragraph has a left margin that is greater than 0, the actual
        position of the list label box is the left margin width plus the start indent value.
        ...The start indent values for lower levels do not affect the label position.
    -->
  <xsl:template name="computed-space-before" mode="CSS-attr">
      <xsl:param name="associatedStyle" select="."/>
      <xsl:param name="listLevelNode" select="."/>
              
      <!--Get @text:space-before of preceding list level
          (!In fact we need @test:space-before + @fo:margin-left)-->
      <xsl:variable name="spaceBefore" select="$listLevelNode/*/@text:space-before[starts-with(.,'-') = False]"/>
      <xsl:variable name="level" select="$listLevelNode/@text:level"/>
      <xsl:variable name="precedingSpaceBefore" 
          select="$listLevelNode/../*[@text:level=$level - 1]/style:list-level-properties/@text:space-before"/>
      <!--Compute current space-before length-->
      <xsl:variable name="length">
          <xsl:choose>
              <xsl:when test="$precedingSpaceBefore">
                  <xsl:call-template name="subtracted-length-values" mode="CSS-attr">
                          <xsl:with-param name="length-1" select="$spaceBefore"/>
                          <xsl:with-param name="length-2" select="$precedingSpaceBefore"/>
                  </xsl:call-template>    
              </xsl:when>
              <xsl:otherwise>
                  <xsl:value-of select="$spaceBefore"/>
              </xsl:otherwise>     
          </xsl:choose>
      </xsl:variable> 
      <!--Get @fo:margin-left of associated style:style element-->
      <xsl:variable name="associatedMarginLeft" select="$associatedStyle/*/@fo:margin-left"/> 

      <!--Compute current space-before length again and emit-->
      <xsl:text>margin-left:</xsl:text>
      <xsl:choose>
          <!--If there is an associated style:style element we add whoses fo:margin-left length-->
          <xsl:when test="$associatedMarginLeft">
              <xsl:variable name="length_">
                  <xsl:call-template name="added-length-values" mode="CSS-attr">
                      <xsl:with-param name="length-1" select="$length"/>
                      <xsl:with-param name="length-2" select="$associatedMarginLeft"/>
                  </xsl:call-template>
              </xsl:variable>
              <xsl:call-template name="normalized-value" mode="CSS-attr">
                  <xsl:with-param name="length" select="$length_"/>
              </xsl:call-template>
          </xsl:when>
          <!--Otherwise not-->
          <xsl:otherwise>
              <xsl:call-template name="normalized-value" mode="CSS-attr">
                  <xsl:with-param name="length" select="$length"/>
              </xsl:call-template>
          </xsl:otherwise>
      </xsl:choose>

  </xsl:template>

  
  <xsl:template name="added-length-values" mode="CSS-attr">
      <!--adds 2 length values-->
      <xsl:param name="length-1" select="'0pt'"/>
      <xsl:param name="length-2" select="'0pt'"/>
       
  <xsl:variable name="magnitude-1">
    <xsl:call-template name="length-magnitude">
              <xsl:with-param name="length">
                  <xsl:call-template name="length-normalize">
                      <xsl:with-param name="length" select="$length-1"/>
                   </xsl:call-template>
              </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>    
  <xsl:variable name="magnitude-2">
    <xsl:call-template name="length-magnitude">
      <xsl:with-param name="length">
                  <xsl:call-template name="length-normalize">
                      <xsl:with-param name="length" select="$length-2"/>
                   </xsl:call-template>
               </xsl:with-param>   
    </xsl:call-template>
      </xsl:variable>
       <xsl:value-of select="concat($magnitude-1 + $magnitude-2, 'pt')"/>
  </xsl:template>  
     
  <xsl:template name="subtracted-length-values" mode="CSS-attr">
      <!--subtracts 2 length values and normalizes the result -->
      <xsl:param name="length-1" select="'0pt'"/>
      <xsl:param name="length-2" select="'0pt'"/>
      
      <xsl:variable name="magnitude-1">
          <xsl:call-template name="length-magnitude">
              <xsl:with-param name="length">
                  <xsl:call-template name="length-normalize">
                      <xsl:with-param name="length" select="$length-1"/>
                   </xsl:call-template>
               </xsl:with-param>
          </xsl:call-template>
      </xsl:variable>    
      <xsl:variable name="magnitude-2">
          <xsl:call-template name="length-magnitude">
              <xsl:with-param name="length">
                  <xsl:call-template name="length-normalize">
                      <xsl:with-param name="length" select="$length-2"/>
                   </xsl:call-template>
               </xsl:with-param>   
          </xsl:call-template>
      </xsl:variable>
 
      <xsl:value-of select="concat($magnitude-1 - $magnitude-2, 'pt')"/>
  </xsl:template>

	<!--
		When processing a list, you have to look at the parent style
        *and* level of nesting. If a child has an @fo:margin-left attribute,
        we also need the name of that style.
	-->
	<xsl:template match="text:list">                             
		<xsl:variable name="level" select="count(ancestor::text:list)+1"/>
		<!--
			the list class is the @text:style-name of the outermost
			<text:list> element
		-->
		<xsl:variable name="listClass">
			<xsl:choose>
				<xsl:when test="$level=1">
					<xsl:value-of select="@text:style-name"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="ancestor::text:list[last()]/@text:style-name"/>
				</xsl:otherwise>
			</xsl:choose>
        </xsl:variable>
        <!--
            the spaceBeforeClass looks after proper margin-left, if a child (paragraph or heading)                  has @fo:margin-left.
        -->
        <xsl:variable name="childStyleName" select="./text:list-item/*[1]/@text:style-name"/>  
        <xsl:variable name="spaceBeforeClass">
            <xsl:if test="key('stylesAssociated', @text:style-name)[@style:name = $childStyleName]">
                <xsl:value-of select="concat(' list_', $listClass,'_',$level,'_',$childStyleName)"/>
            </xsl:if>
        </xsl:variable>
		<!--
			Now select the <text:list-level-style-foo> element at this
			level of nesting for this list
		-->
		<xsl:variable
			name="node"
			select="key('listTypes',$listClass)/*[@text:level='$level']"/>
		<!-- emit appropriate list type and child style -->
		<xsl:choose>
			<xsl:when test="local-name($node)='list-level-style-number'">
				<ol class="list_{concat($listClass,'_',$level,$spaceBeforeClass)}">
					<xsl:apply-templates/>
				</ol>
			</xsl:when>
			<xsl:otherwise>
				<ul class="list_{concat($listClass,'_',$level,$spaceBeforeClass)}">
					<xsl:apply-templates/>
				</ul>
			</xsl:otherwise>
		</xsl:choose>    
	</xsl:template>
	
	
	<xsl:template match="text:list-item">
        <xsl:choose>
            <xsl:when test="./*[text:p] | ./*[text:h] ">
                <li class="listLevelWrapper">
                    <xsl:apply-templates/>
                </li>
            </xsl:when>
            <xsl:otherwise>
                <li>
			        <xsl:apply-templates/>
                </li>
            </xsl:otherwise>
        </xsl:choose>
	</xsl:template>


	<xsl:template match="text:list-header">
			<xsl:apply-templates/>
	</xsl:template>
	
	
</xsl:stylesheet>
