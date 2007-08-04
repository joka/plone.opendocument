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
		This section of the transformation handles tables.
	-->


	<xsl:template match="office:spreadsheet//table:table">
		<div>
			<xsl:call-template name="add_id"/>
			<xsl:attribute name="class">
				<xsl:text>masterpage_</xsl:text>
				<xsl:value-of select="//style:master-page[1]/@style:name" />
			</xsl:attribute>
			<xsl:call-template name="table"/>
		</div>
		<div class="page-break"/>
	</xsl:template>


	<xsl:template match="table:table" name="table">
		<table>
			<xsl:call-template name="add_id"/>
			<xsl:call-template name="class" />
			<xsl:if test="@table:name">
				<xsl:attribute name="title">
					<xsl:value-of select="@table:name" />
				</xsl:attribute>
			</xsl:if>

			<xsl:variable name="max_row_width">
				<xsl:for-each select=".//table:table-row">
					<xsl:sort select="count(.//table:table-cell[not(last()) or child::*])"
						data-type="number" order="descending" />
					<xsl:if test="position() = 1">
						<xsl:value-of select="count(.//table:table-cell[not(last()) or child::*])" />
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>

			<xsl:variable name="common_columns" select="count(.//table:table-column[not(@table:number-columns-repeated)])" />
			<xsl:variable name="repeated_columns" select="sum(.//table:table-column/@table:number-columns-repeated)" />
			<xsl:variable name="real_columns">
				<xsl:choose>
					<xsl:when test=".//table:table-column[last()]/@table:number-columns-repeated > 64">
						<xsl:value-of select="$common_columns + $repeated_columns - number(.//table:table-column[last()]/@table:number-columns-repeated) + 1" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$common_columns + $repeated_columns" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="max_columns">
				<xsl:choose>
					<xsl:when test="$max_row_width > $real_columns">
						<xsl:value-of select="$max_row_width" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$real_columns" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="column_styles">
				<xsl:for-each select=".//table:table-column">
					<xsl:call-template name="pre_scan_columns">
						<xsl:with-param name="num_cols" select="$max_columns" />
					</xsl:call-template>
				</xsl:for-each>
			</xsl:variable>

			<xsl:value-of select="$linebreak"/>

			<xsl:apply-templates select="*">
				<xsl:with-param name="num_cols" select="$max_columns" />
				<xsl:with-param name="col_styles" select="$column_styles" />
			</xsl:apply-templates>
		</table>
		<xsl:value-of select="$linebreak"/>
	</xsl:template>


	<xsl:template name="pre_scan_columns">
		<xsl:param name="num_cols" />
		<xsl:variable name="common_columns_before"
			select="count(preceding-sibling::*[not(@table:number-columns-repeated)])" />
		<xsl:variable name="repeated_columns_before"
			select="sum(preceding-sibling::*/@table:number-columns-repeated)" />
		<xsl:variable name="column_position"
			select="$common_columns_before + $repeated_columns_before" />
		<xsl:call-template name="repeat_scanned_column">
			<xsl:with-param name="column_position">
				<xsl:value-of select="$column_position" />
			</xsl:with-param>
			<xsl:with-param name="repeat">
				<xsl:call-template name="smart_repeat">
					<xsl:with-param name="value"
						select="@table:number-columns-repeated" />
					<xsl:with-param name="is_last" select="last()" />
					<xsl:with-param name="replace_last"
						select="$num_cols - $column_position" />
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="repeat_scanned_column">
		<xsl:param name="column_position" />
		<xsl:param name="offset" select="1" />
		<xsl:param name="repeat" />
		<xsl:value-of
			select="concat(string($column_position + $offset),':',string(@table:default-cell-style-name),',')" />
		<xsl:if test="$repeat > 1">
			<xsl:call-template name="repeat_scanned_column">
				<xsl:with-param name="column_position"
					select="$column_position" />
				<xsl:with-param name="offset" select="$offset + 1" />
				<xsl:with-param name="repeat" select="$repeat - 1" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>


	<xsl:template match="table:table-column-group|table:table-row-group">
		<xsl:param name="num_cols" />
		<xsl:param name="col_styles" />
		<xsl:apply-templates select="*">
			<xsl:with-param name="num_cols" select="$num_cols" />
			<xsl:with-param name="col_styles" select="$col_styles" />
			<xsl:with-param name="visibility">
				<xsl:choose>
					<xsl:when test="@table:display = 'true'">visible</xsl:when>
					<xsl:when test="@table:display = 'false'">collapse</xsl:when>
					<xsl:otherwise>_undefined</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="table:table-header-columns|table:table-columns">
		<xsl:param name="num_cols" />
		<xsl:param name="visibility" select="'_undefined'" />
		<colgroup>
			<xsl:if test="self::table:table-header-columns">
				<xsl:attribute name="class">thead</xsl:attribute>
			</xsl:if>
		<xsl:value-of select="$linebreak"/>
			<xsl:apply-templates select="*">
				<xsl:with-param name="num_cols" select="$num_cols" />
				<xsl:with-param name="visibility" select="$visibility" />
			</xsl:apply-templates>
		</colgroup> <xsl:value-of select="$linebreak"/>
	</xsl:template>

	<xsl:template match="table:table-header-rows|table:table-rows">
		<xsl:param name="num_cols" />
		<xsl:param name="col_styles" />
		<xsl:param name="visibility" select="'_undefined'" />
		<xsl:variable name="block_type">
			<xsl:choose>
				<xsl:when test="self::table:table-header-rows">thead</xsl:when>
				<xsl:otherwise>tbody</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$block_type}">
			<xsl:apply-templates select="*">
				<xsl:with-param name="num_cols" select="$num_cols" />
				<xsl:with-param name="col_styles" select="$col_styles" />
				<xsl:with-param name="visibility" select="$visibility" />
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>

	<xsl:template match="table:table-column">
		<xsl:param name="num_cols" />
		<xsl:param name="visibility" select="'_undefined'" />
		<col>
			<xsl:call-template name="class" />

			<xsl:if test="@table:number-columns-repeated">
				<xsl:variable name="common_columns_before"
					select="count(preceding-sibling::*[not(@table:number-columns-repeated)])" />
				<xsl:variable name="repeated_columns_before"
					select="sum(preceding-sibling::*/@table:number-columns-repeated)" />
				<xsl:variable name="column_position"
					select="$common_columns_before + $repeated_columns_before" />
				<xsl:attribute name="span">
					<xsl:call-template name="smart_repeat">
						<xsl:with-param name="value"
							select="@table:number-columns-repeated" />
						<xsl:with-param name="is_last" select="last()" />
						<xsl:with-param name="replace_last"
							select="$num_cols - $column_position" />
					</xsl:call-template>
				</xsl:attribute>
			</xsl:if>

			<xsl:variable name="custom_style">
				<xsl:if test="$num_cols = 1">
					<xsl:text>width:100%;</xsl:text>
				</xsl:if>
				<xsl:call-template name="column_row_visibility">
					<xsl:with-param name="visibility" select="$visibility" />
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="string($custom_style)">
				<xsl:attribute name="style">
					<xsl:value-of select="$custom_style" />
				</xsl:attribute>
			</xsl:if>
		</col>
		<xsl:value-of select="$linebreak"/>
	</xsl:template>

	<xsl:template match="table:table-row">
		<xsl:param name="num_cols" />
		<xsl:param name="col_styles" />
		<xsl:param name="visibility" select="'_undefined'" />
		<xsl:variable name="row_repeat">
			<xsl:call-template name="smart_repeat">
				<xsl:with-param name="value" select="@table:number-rows-repeated" />
				<xsl:with-param name="is_last" select="last()" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="row_style">
			<xsl:call-template name="cell_style_name">
				<xsl:with-param name="style"
								select="@table:default-cell-style-name" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:call-template name="repeat-table-row">
			<xsl:with-param name="num_cols" select="$num_cols" />
			<xsl:with-param name="col_styles" select="$col_styles" />
			<xsl:with-param name="row_style" select="$row_style" />
			<xsl:with-param name="visibility" select="$visibility" />
			<xsl:with-param name="repeat" select="$row_repeat" />
		</xsl:call-template>
	</xsl:template>


	<xsl:template name="repeat-table-row">
		<xsl:param name="num_cols" />
		<xsl:param name="col_styles" />
		<xsl:param name="row_style" select="''" />
		<xsl:param name="visibility" select="'_undefined'" />
		<xsl:param name="repeat" />
		<xsl:if test="$repeat > 0">
			<tr>
				<xsl:call-template name="class" />
				<xsl:variable name="custom_style">
					<xsl:call-template name="column_row_visibility">
						<xsl:with-param name="visibility" select="$visibility" />
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="string($custom_style)">
					<xsl:attribute name="style">
						<xsl:value-of select="$custom_style" />
					</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="$linebreak"/>
				<xsl:apply-templates select="table:table-cell">
					<xsl:with-param name="num_cols" select="$num_cols" />
					<xsl:with-param name="col_styles" select="$col_styles" />
					<xsl:with-param name="row_style" select="$row_style" />
				</xsl:apply-templates>
				<xsl:value-of select="$linebreak"/>
			</tr>
			<xsl:value-of select="$linebreak"/>
			<xsl:call-template name="repeat-table-row">
				<xsl:with-param name="num_cols" select="$num_cols" />
				<xsl:with-param name="col_styles" select="$col_styles" />
				<xsl:with-param name="row_style" select="$row_style" />
				<xsl:with-param name="visibility" select="$visibility" />
				<xsl:with-param name="repeat" select="$repeat - 1" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>


	<xsl:template match="table:table-cell">
		<xsl:param name="num_cols" />
		<xsl:param name="col_styles" />
		<xsl:param name="row_style" select="''" />

		<xsl:variable name="common_cells_before"
			select="count(preceding-sibling::*[not(@table:number-columns-repeated)])" />
		<xsl:variable name="repeated_cells_before"
			select="sum(preceding-sibling::*/@table:number-columns-repeated)" />
		<xsl:variable name="cell_position"
			select="$common_cells_before + $repeated_cells_before" />

		<xsl:variable name="cell_repeat">
			<xsl:call-template name="smart_repeat">
				<xsl:with-param name="value"
					select="@table:number-columns-repeated" />
				<xsl:with-param name="is_last" select="last()" />
				<xsl:with-param name="replace_last"
					select="$num_cols - $cell_position" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:call-template name="repeat_table_cell">
			<xsl:with-param name="col_styles" select="$col_styles" />
			<xsl:with-param name="row_style" select="$row_style" />
			<xsl:with-param name="cell_position" select="$cell_position" />
			<xsl:with-param name="repeat" select="$cell_repeat" />
		</xsl:call-template>
	</xsl:template>


	<xsl:template name="repeat_table_cell">
		<xsl:param name="col_styles" />
		<xsl:param name="row_style" select="''" />
		<xsl:param name="cell_position" />
		<xsl:param name="offset" select="1" />
		<xsl:param name="repeat" />
		<xsl:if test="$repeat > 0">
			<td>
				<xsl:choose>
					<xsl:when test="@table:style-name">
						<xsl:call-template name="class" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="cell_key" >
							<xsl:value-of select="concat(string($cell_position+$offset), ':')" />
						</xsl:variable>
						<xsl:variable name="column_style">
							<xsl:value-of select="substring-before(substring-after($col_styles, $cell_key), ',')" />
						</xsl:variable>
						<xsl:call-template name="class">
							<xsl:with-param name="prepend_style">
								<xsl:if test="string-length($row_style)">
									<xsl:value-of select="$row_style" />
									<xsl:text> </xsl:text>
								</xsl:if>
								<xsl:if test="string-length($column_style)">
									<xsl:call-template name="cell_style_name">
										<xsl:with-param name="style" select="$column_style" />
									</xsl:call-template>
								</xsl:if>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="@table:number-columns-spanned > 1">
					<xsl:attribute name="colspan">
						<xsl:value-of select="@table:number-columns-spanned" />
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="@table:number-rows-spanned > 1">
					<xsl:attribute name="rowspan">
						<xsl:value-of select="@table:number-rows-spanned" />
					</xsl:attribute>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="@table:formula">
						<xsl:attribute name="title">
							<xsl:value-of select="@table:formula" />
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="child::text:p">
<!-- temporary hack: copy cell value into TD title -->
						<xsl:attribute name="title">
							<xsl:value-of select="child::text:p" />
						</xsl:attribute>
					</xsl:when>
				</xsl:choose>
				<xsl:if test="count(node())=0">
					<br />
				</xsl:if>
				<xsl:apply-templates />
			</td>
			<xsl:call-template name="repeat_table_cell">
				<xsl:with-param name="col_styles" select="$col_styles" />
				<xsl:with-param name="row_style" select="$row_style" />
				<xsl:with-param name="cell_position" select="$cell_position" />
				<xsl:with-param name="offset" select="$offset + 1" />
				<xsl:with-param name="repeat" select="$repeat - 1" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>



	<!-- Generic templates common for several elements -->

<!-- void: possible bug here: copy of style naming algorithm -->
<!-- from "class" template in css.xml (prepend table-cell_) -->
	<xsl:template name="cell_style_name">
		<xsl:param name="style" />
		<xsl:choose>
			<xsl:when test="boolean($style)">
				<xsl:text>table-cell_</xsl:text>
				<xsl:value-of select="$style" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="''" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="smart_repeat">
	<!-- do not reproduce "endless spreadsheet" emulation -->
	<!-- in the row's last cells -->
		<xsl:param name="value" />
		<xsl:param name="is_last" />
		<xsl:param name="replace_last" select="1" />
		<xsl:choose>
			<xsl:when test="($is_last or $is_last-1) and $value > 64">
				<xsl:value-of select="$replace_last" />
			</xsl:when>
			<xsl:when test="$value > 1">
				<xsl:value-of select="$value" />
			</xsl:when>
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="column_row_visibility">
		<xsl:param name="visibility" select="'_undefined'" />
		<xsl:choose>
			<!-- negative own visibility overrides all -->
			<xsl:when test="@table:visibility and @table:visibility!='visible'">
				<xsl:text>visibility:collapse;</xsl:text>
			</xsl:when>
			<!-- visibility inherited from group defines result -->
			<xsl:when test="$visibility != '_undefined'">
				<xsl:text>visibility:</xsl:text>
				<xsl:value-of select="$visibility" />
				<xsl:text>; </xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>


</xsl:stylesheet>
