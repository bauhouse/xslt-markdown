<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="body//*">
  <xsl:element name="{name()}">
    <xsl:apply-templates select="* | @* | text()"/>
  </xsl:element>
</xsl:template>

<xsl:template match="body//@*">
  <xsl:attribute name="{name(.)}">
    <xsl:value-of select="."/>
  </xsl:attribute>
</xsl:template>

<xsl:template match="body//*[@*] | intro//*[@*]" mode="markdown">
    <xsl:copy-of select="."/>
</xsl:template><xsl:template match="h1" mode="markdown">
  <xsl:text># </xsl:text><xsl:value-of select="text()"/>
</xsl:template>

<xsl:template match="h2" mode="markdown">
  <xsl:text>## </xsl:text><xsl:value-of select="text()"/>
</xsl:template>

<xsl:template match="h3" mode="markdown">
  <xsl:text>### </xsl:text><xsl:value-of select="text()"/>
</xsl:template>

<xsl:template match="h4" mode="markdown">
  <xsl:text>#### </xsl:text><xsl:value-of select="text()"/>
</xsl:template>

<xsl:template match="h5" mode="markdown">
  <xsl:text>##### </xsl:text><xsl:value-of select="text()"/>
</xsl:template>

<xsl:template match="h6" mode="markdown">
  <xsl:text>###### </xsl:text><xsl:value-of select="text()"/>
</xsl:template>

<xsl:template match="p" mode="markdown">
  <xsl:apply-templates select="* | text()" mode="markdown"/>
</xsl:template>

<xsl:template match="ul" mode="markdown">
  <xsl:apply-templates select="*" mode="markdown"/>
</xsl:template>

<xsl:template match="ul/li/text()" mode="markdown">
  <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<xsl:template match="ul/li" mode="markdown">
  <xsl:text>* </xsl:text>
  <xsl:apply-templates select="* | text()" mode="markdown"/>
  <xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="ul/li/ul/li" mode="markdown">
  <xsl:text>
    * </xsl:text>
  <xsl:apply-templates select="* | text()" mode="markdown"/>
</xsl:template>

<xsl:template match="ul/li/ul/li/ul/li" mode="markdown">
  <xsl:text>
        * </xsl:text>
  <xsl:apply-templates select="* | text()" mode="markdown"/>
</xsl:template>

<xsl:template match="ol" mode="markdown">
  <xsl:apply-templates select="*" mode="markdown"/>
</xsl:template>

<xsl:template match="ol/li/text()" mode="markdown">
  <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<xsl:template match="ol/li" mode="markdown">
  <xsl:value-of select="position()"/>
  <xsl:text>. </xsl:text>
  <xsl:apply-templates select="* | text()" mode="markdown"/>
  <xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="ol/li/ol/li" mode="markdown">
  <xsl:text>
    </xsl:text>
  <xsl:value-of select="position()"/>
  <xsl:text>. </xsl:text><xsl:apply-templates select="* | text()" mode="markdown"/>
</xsl:template>

<xsl:template match="ol/li/ol/li/ol/li" mode="markdown">
  <xsl:text>
        </xsl:text>
  <xsl:value-of select="position()"/>
  <xsl:text>. </xsl:text><xsl:apply-templates select="* | text()" mode="markdown"/>
</xsl:template>

<xsl:template match="strong" mode="markdown">
  <xsl:text>**</xsl:text><xsl:value-of select="text()"/><xsl:text>**</xsl:text>
</xsl:template>

<xsl:template match="em" mode="markdown">
  <xsl:text>_</xsl:text><xsl:value-of select="text()"/><xsl:text>_</xsl:text>
</xsl:template>

<xsl:template match="br" mode="markdown">
  <xsl:text>  </xsl:text>
</xsl:template>

<xsl:template match="a" priority="1" mode="markdown">
  <xsl:text>[</xsl:text>
  <xsl:value-of select="text()"/>
  <xsl:text>](</xsl:text>
  <xsl:value-of select="@href"/>
  <xsl:if test="@title">
    <xsl:text> "</xsl:text>
    <xsl:value-of select="@title"/>
    <xsl:text>"</xsl:text>
  </xsl:if>
  <xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="p/code" mode="markdown">
  <xsl:text> `</xsl:text><xsl:value-of select="text()"/><xsl:text>` </xsl:text>
</xsl:template>

<xsl:template match="li/code" mode="markdown">
  <xsl:text> `</xsl:text><xsl:value-of select="text()"/><xsl:text>` </xsl:text>
</xsl:template>

<xsl:template match="blockquote" mode="markdown">
  <xsl:text>&gt; </xsl:text><xsl:apply-templates select="* | text()" mode="markdown"/>
</xsl:template>

<xsl:template match="blockquote/text()" mode="markdown">
  <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<xsl:template match="pre" mode="markdown">
  <xsl:apply-templates select="* | text()" mode="markdown"/>
</xsl:template>

<xsl:template match="pre/code" mode="markdown">
  <xsl:apply-templates select="* | text()" mode="markdown"/>
</xsl:template>
  
<xsl:template match="pre/code/text()" mode="markdown">
  <xsl:text>    </xsl:text>
  <xsl:call-template name="markdown-code-block">
    <xsl:with-param name="input" select="."/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="markdown-code-block">
  <xsl:param name="input"/>
  <xsl:param name="value">
    <xsl:choose>
      <xsl:when test="contains($input,'&#xa;')">
        <xsl:value-of select="substring-before($input,'&#xa;')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$input"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="remaining-values" select="substring-after($input,'&#xa;')"/>
  <xsl:value-of select="substring-before($input,'&#xa;')"/><xsl:text>&#xa;    </xsl:text>
  <xsl:if test="$remaining-values != ''">
    <xsl:call-template name="markdown-code-block">
      <xsl:with-param name="input" select="$remaining-values"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="img" priority="1" mode="markdown">
  <xsl:text>![</xsl:text>
  <xsl:value-of select="@alt"/>
  <xsl:text>](</xsl:text>
  <xsl:value-of select="@src"/>
  <xsl:if test="@title">
    <xsl:text> "</xsl:text>
    <xsl:value-of select="@title"/>
    <xsl:text>"</xsl:text>
  </xsl:if>
  <xsl:text>)</xsl:text>
</xsl:template>

</xsl:stylesheet>