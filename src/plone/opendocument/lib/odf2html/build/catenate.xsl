<?xml version="1.0"?>
<!--
USAGE
  unzip mydocument.odt
  xlstproc catenate.xsl content.xml > SingleFile.xml
-->
<!--
 This stylesheet converts the OpenDocument xml files content.xml
 styles.xml and meta.xml into one large xml file.
 Copyright (C) 2006 Daniel Carrera

 This file is dual-licensed.
 ===================================================
LGPL
 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public
 License along with this library; if not, write to the Free Software
 Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 ===================================================
 Apache 2.0
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->

<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
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
 xmlns:oooc="http://openoffice.org/2004/calc">

<xsl:output method="xml" omit-xml-declaration="yes"/>
<xsl:template match="/office:document-content">
 <office:document>
  <xsl:comment> From meta.xml </xsl:comment>
  <xsl:apply-templates select="document('meta.xml')"/>
  <xsl:comment> From styles.xml </xsl:comment>
  <xsl:apply-templates select="document('styles.xml')"/>
  <xsl:comment> From content.xml </xsl:comment>
  <xsl:copy>
   <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
 </office:document>
</xsl:template>

<xsl:template match="@*|node()">
 <xsl:copy>
   <xsl:apply-templates select="@*|node()"/>
 </xsl:copy>
</xsl:template>

</xsl:stylesheet>
