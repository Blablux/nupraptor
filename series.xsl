<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text"/>
<xsl:strip-space elements="*"/>
<xsl:template match="/">Titre;Année;Genre;Episodes;Saisons
<xsl:for-each select="videodb/tvshow">
  <xsl:sort select="year" order="descending"/>
    <xsl:value-of select="title"/>
    <xsl:text>;</xsl:text>
    <xsl:value-of select="year"/>
    <xsl:text>;</xsl:text>
    <xsl:for-each select="genre">
      <xsl:if test="not(position()=1)">/</xsl:if>
      <xsl:value-of select="."/>
    </xsl:for-each>
    <xsl:text>;</xsl:text>
    <xsl:value-of select="episode"/>
    <xsl:text>;</xsl:text>
    <xsl:for-each select="episodedetails/season">
      <xsl:sort select="." data-type="number" order="descending"/>
      <xsl:if test="position() = 1"><xsl:value-of select="."/></xsl:if>
    </xsl:for-each>
    <xsl:text>&#10;</xsl:text>
  </xsl:for-each>
</xsl:template>
</xsl:stylesheet>
