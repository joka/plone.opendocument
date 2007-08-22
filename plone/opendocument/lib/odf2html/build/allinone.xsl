<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes" omit-xml-declaration="no" encoding="UTF-8"/>

	<xsl:template match="xsl:stylesheet">
		<xsl:copy>

			<xsl:copy-of select="@*"/>
			<xsl:copy-of select="*"/>

			<xsl:copy-of select="document('../xsl/param.xsl')/xsl:stylesheet/*" />
			<xsl:copy-of select="document('../xsl/common/common.xsl')/xsl:stylesheet/*" />
			<xsl:copy-of select="document('../xsl/odf.xsl')/xsl:stylesheet/*" />
			<xsl:copy-of select="document('../xsl/css.xsl')/xsl:stylesheet/*" />
			<xsl:copy-of select="document('../xsl/css/default.xsl')/xsl:stylesheet/*" />
			<xsl:copy-of select="document('../xsl/css/layout.xsl')/xsl:stylesheet/*" />
			<xsl:copy-of select="document('../xsl/css/table.xsl')/xsl:stylesheet/*" />
			<xsl:copy-of select="document('../xsl/css/attribute.xsl')/xsl:stylesheet/*" />
			<xsl:copy-of select="document('../xsl/xhtml/draw.xsl')/xsl:stylesheet/*" />
			<xsl:copy-of select="document('../xsl/xhtml/meta.xsl')/xsl:stylesheet/*" />
			<xsl:copy-of select="document('../xsl/xhtml/presentation.xsl')/xsl:stylesheet/*" />
			<xsl:copy-of select="document('../xsl/xhtml/spreadsheet.xsl')/xsl:stylesheet/*" />
			<xsl:copy-of select="document('../xsl/xhtml/page.xsl')/xsl:stylesheet/*" />
			<xsl:copy-of select="document('../xsl/xhtml/table.xsl')/xsl:stylesheet/*" />
			<xsl:copy-of select="document('../xsl/xhtml/text.xsl')/xsl:stylesheet/*" />
			<xsl:copy-of select="document('../xsl/xhtml/list.xsl')/xsl:stylesheet/*" />
			<xsl:copy-of select="document('../xsl/xhtml/toc.xsl')/xsl:stylesheet/*" />
			<xsl:copy-of select="document('../xsl/xhtml/track-changes.xsl')/xsl:stylesheet/*" />

		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
