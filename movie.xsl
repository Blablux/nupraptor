<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text"/>
<xsl:strip-space elements="*"/>
<xsl:template match="/">Titre;Année;Durée;Genre;Qualité;Date d'ajout
<xsl:for-each select="videodb/movie">
  <xsl:sort select="dateadded" order="descending"/>
    <xsl:value-of select="title"/>	
    <xsl:text>;</xsl:text>
    <xsl:value-of select="year"/>
    <xsl:text>;</xsl:text>
    <xsl:if test="runtime > 60">
      <xsl:value-of select="concat(format-number(floor(runtime div 60), '0'), 'h')"/>
    </xsl:if>
    <xsl:value-of select="concat(format-number(runtime mod 60, '00'), 'mn;')" />
    <xsl:for-each select="genre">
      <xsl:if test="not(position()=1)">/</xsl:if>
      <xsl:value-of select="."/>
    </xsl:for-each>
    <xsl:text>;</xsl:text>
    <xsl:value-of select="dateadded"/>
    <xsl:text>;</xsl:text>
    <xsl:choose>
      <xsl:when test="fileinfo/streamdetails/video/width > 1279">HD</xsl:when>
      <xsl:otherwise>SD</xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#10;</xsl:text>
  </xsl:for-each>
</xsl:template>
</xsl:stylesheet>
