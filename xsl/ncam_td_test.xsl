<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    
    <xsl:template match="asset">
        
        <xsl:variable name="resource_type" select="../../@media_type"/>
        <xsl:variable name="oer_level" select="../../@oer_level"/>
        
        
        <record xmlns="http://ns.nsdl.org/ncs/ncam_afa"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://ns.nsdl.org/ncs/ncam_afa http://ns.nsdl.org/ncs/ncam_afa/1.00/schemas/record.xsd">
            <general>
                <recordID></recordID>
                <recordDate>
                    <xsl:value-of select="@date_created"/>
                </recordDate>
                <url>
                    <xsl:value-of select="url"/>
                </url>
                <title>
                    <xsl:value-of select="asset_title"/>
                </title>
                <description>
                    <xsl:value-of select="../../resource_texts/annotation"/>
                </description>
                <xsl:for-each select="../..//hierarchy_memberships/hierarchy_membership">
                    <subject>
                        <!-- Apply template to strip top levels of heirarchy -->
                        <xsl:value-of select="/resources/resource/hierarchy_memberships/hierarchy_membership"/>
                    </subject>
                </xsl:for-each>
                <language>en-US</language>
                <xsl:if test="mime_type">
                    <xsl:for-each select="mime_type">
                        <mimeType>
                            <xsl:value-of select="."/>
                        </mimeType>
                    </xsl:for-each>
                </xsl:if>
            </general>
            <educational>                
                <xsl:if test="grade_range">
                    <xsl:for-each select="grade_range">
                        <educationLevel>
                            <!-- Apply template to convert numerical range to vocab -->
                            <xsl:value-of select="../../grade_range"/>
                        </educationLevel>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="grade_band">
                    <!-- Apply template to split numeric list into seperate tags-->
                        <educationLevel>
                            <xsl:value-of select="../../grade_band"/>
                        </educationLevel>
                </xsl:if>
                <!-- Can't find anything to key off of -->
                <audience>Learner</audience>
                <xsl:choose>
                    <xsl:when test="$resource_type = 'Video'">
                        <resourceType>Audio/Visual</resourceType>
                        <resourceType>Movie/Animation</resourceType>
                    </xsl:when>
                    <xsl:when test="$resource_type = 'Interactive'">
                        <resourceType>Instructional Material</resourceType>
                        <resourceType>Interactive Simulation</resourceType>
                    </xsl:when>
                    <xsl:otherwise>
                        <resourceType>Instructional Material</resourceType>
                        <resourceType>Tutorial</resourceType>                        
                    </xsl:otherwise>
                </xsl:choose>               
            </educational>
            <lifecycle>
                <publicationDate>
                    <xsl:value-of select="@date_created"/>
                </publicationDate>
                    <xsl:choose>
                        <xsl:when test="$oer_level = 1">
                            <rights>Download</rights>
                            <rights>http://www.teachersdomain.org/oerlicense/1/</rights>
                        </xsl:when>
                        <xsl:when test="$oer_level = 2">
                            <rights>Download and Share</rights>
                            <rights>http://www.teachersdomain.org/oerlicense/2/</rights>
                        </xsl:when>
                        <xsl:when test="$oer_level = 3">
                            <rights>Download, Share, and Remix</rights>
                            <rights>http://www.teachersdomain.org/oerlicense/3/</rights>
                        </xsl:when>
                        <xsl:otherwise>
                            <rights>Viewed Online only</rights>
                            <rights>http://www.teachersdomain.org/terms_of_use.html</rights>
                        </xsl:otherwise>
                    </xsl:choose>
                <accessRights>Free access with registration</accessRights>
                                
                <xsl:for-each select="../../producers/producer">
                    <xsl:variable name="producer" select="./name"/>
                    <xsl:variable name="thumbnail" select="./logo"></xsl:variable>
                    <contributor role="Producer" thumbnail="{$thumbnail}" ><xsl:value-of select="$producer"/></contributor>
                </xsl:for-each>
                <xsl:for-each select="../../collection/developers/developer">
                    <xsl:variable name="developer" select="./name"/>
                    <xsl:variable name="thumbnail" select="./logo"></xsl:variable>
                    <contributor role="Developer" thumbnail="{$thumbnail}" ><xsl:value-of select="$developer"/></contributor>
                </xsl:for-each>
                <xsl:for-each select="../../collection/funders/funder">
                    <xsl:variable name="funder" select="./name"/>
                    <xsl:variable name="thumbnail" select="./logo"></xsl:variable>
                    <contributor role="Funder" thumbnail="{$thumbnail}" ><xsl:value-of select="$funder"/></contributor>
                </xsl:for-each>
            </lifecycle>
            <accessForAll>
                <xsl:for-each select="access_mode/@name">
                    <accessMode><xsl:value-of select="."/></accessMode>
                </xsl:for-each>
                <xsl:if test="./@relationship != 'Primary'">
                    <xsl:variable name="adapted_asset_url"/>
                    <xsl:variable name="asset_code" select="@code"></xsl:variable>
                    <xsl:for-each select="../../assets/asset">
                        <xsl:if test="./@code = $asset_code">
                            <xsl:variable name="adapted_asset_url" select="./url"></xsl:variable>
                        </xsl:if>
                    </xsl:for-each>
                    <isAdaptationOf><xsl:value-of select="$adapted_asset_url"/></isAdaptationOf>
                </xsl:if>
                
                <adaptationType>captions</adaptationType>
                <adaptationType>audioDescription</adaptationType>
            </accessForAll>
        </record>
    </xsl:template>
    
    <xsl:template match="text()" />
</xsl:stylesheet>