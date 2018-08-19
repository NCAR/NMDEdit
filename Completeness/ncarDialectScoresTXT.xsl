<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gml="http://www.opengis.net/gml" 
    xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com" xmlns:my="http://my-functions">

  <!-- ncarDialectTotals.xsl ******************************************************************************

        From a pathname to ISO 19115 metadata xml records, creates a report XML file for totals 
        of metadata elements for all files in the WAF, each line showing total for all elements per file.

        "106.352",11,21,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,1,1,0,0,1,1,1,1,1,1,0,0...

        This can be run separately on XML folders, or from the top WAF directory for all folders. 

        Uses XSLT 2.0 collection() function with Saxon 9 syntax to get the list of *.xml files to index

        Syntax for command:
            java net.sf.saxon.Transform -s:../WAFs/labs.xml -xsl:QScores/ncarDialectTotals.xsl -o:out/Lab_scores/unidata_Level2Scores.xml WAF_BASE=../WAFs recordSetPath=unidata
            where labs.xml = 
                <collection stable="true">
                </collection>
   ****************************************************************************************************** -->
 	<xsl:output method="text" omit-xml-declaration="yes"/>
    <xsl:param name="WAF_BASE"/>
    <xsl:param name="recordSetPath"/>
    <xsl:param name="fileNamePattern" select="'*.xml'"/>
    <xsl:variable name="recordSetName" select="$recordSetPath"/>
    <xsl:param name="scoringDate" select="current-dateTime()"/>
	<xsl:variable name="rubricVersion" select="'1.35-ds'"/>

	<!-- *********************************************************************** -->
    <!--   get all XML files from a lab's WAF that have been downloaded to a     -->
    <!-- directory and the full path given as a parameter on the command line    -->
	<!-- *********************************************************************** -->
	<xsl:template match="/">
      <RecordSet recordSetName="{$recordSetName}" scoringDate="{$scoringDate}">
          <!-- get records from the file system path to the WAF -->
          <!--  for each *.xml file found in this directory...  -->
          <xsl:variable name="xmlFilesSelect">
            <xsl:choose>
              <xsl:when test="$WAF_BASE">
                <xsl:value-of select="concat($WAF_BASE, '/', $recordSetPath, '?select=', $fileNamePattern)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat($recordSetPath, '?select=', $fileNamePattern)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>"archive ident","Total Score","abstract","assetType","author","dataIdentification","datasetLanguage","landingPage","metadataContact","metadataDate","metadataRecordID","metadataStandardName","metadataStandardVersion","otherConstraints","publicationDate","publisher","resourceContact","resourceType","title","useConstraints","citationDate","credit","custodian","datasetExtent","datasetExtentDescription","endDate","keyword","originator","pi","referenceSystem","resourceProvider","spatialRepresentationType","spatialResolution","startDate","temporal","temporalResolution","themeKeyword","themeKeywordThesaurus","topicCategory","vertical","additionalInformation","alternateID","assetSize","authorIdentifier","distributionFormat","distributorContact","progress","relatedResourceDescription","relatedResource","relatedResourceName","relatedResourceType","resourceFormat","resourceVersion","softwareImplementationLanguage"
          <xsl:for-each select="collection(iri-to-uri($xmlFilesSelect))">
            <xsl:sort select="subsequence(//gmd:fileIdentifier,1,1)"/>
            <xsl:apply-templates>
              <xsl:with-param name="xmlFile" select="tokenize(document-uri(.), '/')[last()]"/>
              <xsl:with-param name="position" select="position()"/>
            </xsl:apply-templates>
          </xsl:for-each>
      </RecordSet>
    </xsl:template>
	<!-- *********************************************************************** -->

    <xsl:template match="gmd:MD_Metadata">
        <xsl:param name="xmlFile"/>
        <xsl:param name="position" select="'0'"/>
        <xsl:variable name="recordTitle" select="normalize-space(subsequence(//gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title,1,1))"/>
        <xsl:variable name="metadataDate" select="normalize-space(subsequence(/*/gmd:dateStamp/gco:Date | /*/gmd:dateStamp/gco:DateTime,1,1))"/>

    <!-- *************************************** -->
    <!--                 Level 1                 -->
    <!-- *************************************** -->

        <!-- Metadata Record Identifier -->
        <xsl:variable name="fileID" select="//gmd:MD_Metadata/gmd:fileIdentifier/gco:CharacterString"/>
		<xsl:variable name="metadataRecordIDExist">
			<xsl:choose>
				<xsl:when test="normalize-space(//gmd:MD_Metadata/gmd:fileIdentifier/gco:CharacterString) != '' ">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="metadataRecordIDCnt" select="count(//gmd:MD_Metadata/gmd:fileIdentifier/gco:CharacterString)"/>

        <!-- Abstract -->
        <xsl:variable name="abstractExist">
            <xsl:choose>
                <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="abstractCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString)"/>

        <!-- Asset Type -->
        <xsl:variable name="assetTypeExist">
            <xsl:choose>
                <xsl:when test="(//gmd:hierarchyLevel/gmd:MD_ScopeCode != '')">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="assetTypeCnt" select="count(//gmd:hierarchyLevel/gmd:MD_ScopeCode)"/>

        <!-- Author -->
        <xsl:variable name="authorExist">
            <xsl:choose> 
                <xsl:when test="(//gmd:citation//gmd:CI_RoleCode[@codeListValue = 'author'])">1</xsl:when> 
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="authorCnt" select="count(//gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty[.//gmd:role/gmd:CI_RoleCode/@codeListValue='author'])"/>

        <!-- Data Identification (if a dataset) -->
        <xsl:variable name="DataIdentificationExist">
            <xsl:choose>
                <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- Dataset Language -->  
        <xsl:variable name="datasetLanguageExist">
            <xsl:choose>
		        <xsl:when test="normalize-space(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:language/gmd:LanguageCode) != '' or normalize-space(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:language/gco:CharacterString) != '' ">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="datasetLanguageCnt" select="count(normalize-space(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:language/gmd:LanguageCode) != '' or normalize-space(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:language/gco:CharacterString) != '')"/>

         <!-- Landing Page -->
        <xsl:variable name="landingPageExist">
            <xsl:choose>
                <xsl:when test="(//gmd:dataSetURI/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="landingPageCnt" select="count(//gmd:dataSetURI/gco:CharacterString)"/>        

        <!-- Metadata Contact -->
		<xsl:variable name="metadataContactExist">
			<xsl:choose>
				<xsl:when test="normalize-space(/gmd:MD_Metadata/gmd:contact/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString) != '' or normalize-space(/gmd:MD_Metadata/gmd:contact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString) != '' or  normalize-space(/gmd:MD_Metadata/gmd:contact/gmd:CI_ResponsibleParty/gmd:positionName/gco:CharacterString) != '' ">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="metadataContactCnt" select="count(//gmd:MD_Metadata/gmd:contact)"/>

        <!-- Metadata Date -->
        <xsl:variable name="metadataDateStampCnt" select="count(normalize-space(subsequence(/*/gmd:dateStamp/gco:Date | /*/gmd:dateStamp/gco:DateTime,1,1)))"/>
 
        <!-- Metadata Standard Name -->
        <xsl:variable name="metadataStandardNameExist">
            <xsl:choose>
                <xsl:when test="(//gmd:metadataStandardName/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
		<xsl:variable name="metadataStandardNameCnt" select="count(//gmd:metadataStandardName/gco:CharacterString)"/>

        <!-- Metadata Standard Version -->
        <xsl:variable name="metadataStandardVersionExist">
            <xsl:choose>
                <xsl:when test="(//gmd:metadataStandardVersion/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
		<xsl:variable name="metadataStandardVersionCnt" select="count(//gmd:metadataStandardVersion/gco:CharacterString)"/>

	    <!-- Other Constraints -->
        <xsl:variable name="otherConstraintsExist">
            <xsl:choose>
		        <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="otherConstraintsCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints/gco:CharacterString)"/>

        <!-- Publication date --> 
        <xsl:variable name="publicationDateExist"> 
            <xsl:choose>  
                <xsl:when test="(//gmd:citation//gmd:CI_DateTypeCode[@codeListValue = 'publication'])">1</xsl:when>  
                <xsl:otherwise>0</xsl:otherwise> 
            </xsl:choose> 
        </xsl:variable> 
        <xsl:variable name="publicationDateCnt" select="count(//gmd:citation//gmd:CI_DateTypeCode[@codeListValue = 'publication'])"/> 
 
        <!-- Publisher -->
        <xsl:variable name="publisherExist">  
            <xsl:choose> 
                <xsl:when test="(//gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty[.//gmd:role/gmd:CI_RoleCode/@codeListValue = 'publisher'])">1</xsl:when> 
                <xsl:otherwise>0</xsl:otherwise> 
            </xsl:choose> 
		</xsl:variable>
        <xsl:variable name="publisherCnt" select="count(//gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty[.//gmd:role/gmd:CI_RoleCode/@codeListValue='publisher'])"/>
 
		<!-- Resource Contact (point of contact)  -->
		<xsl:variable name="resourceContactExist">
			<xsl:choose>
				<xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty)">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="resourceContactCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty)"/>

        <!-- Resource Type (DataCite) -->
        <xsl:variable name="resourceTypeExist">
            <xsl:choose>
                <xsl:when test="(//gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString='Resource Type')">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="resourceTypeCnt" select="count(//gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString='Resource Type')"/>

		<!-- Title -->
		<xsl:variable name="title" select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString"/>
		<xsl:variable name="titleCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString)"/>
		<xsl:variable name="titleExist">
			<xsl:choose>
				<xsl:when test="normalize-space(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString) != '' ">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

        <!-- Use Contraints -->
        <xsl:variable name="useConstraintsExist">
            <xsl:choose>
                <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useLimitation/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="useConstraintsCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useLimitation/gco:CharacterString)"/>
        
    <!-- *************************************** -->
    <!--                Level 2                  -->
    <!-- *************************************** -->

		<!-- Citation Date -->
		<xsl:variable name="citationDateExist">
			<xsl:choose>
				<xsl:when test="(//gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date | //gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:DateTime)">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
        <xsl:variable name="citationDateCnt" select="count(//gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date | //gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:DateTime)"/>

        <!-- Credit -->
        <xsl:variable name="creditExist">
            <xsl:choose>
                <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:credit/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
		<xsl:variable name="creditCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:credit/gco:CharacterString)"/>

        <!-- Custodian -->
        <xsl:variable name="custodianExist">
            <xsl:choose>
                <xsl:when test="(//gmd:citation//gmd:CI_RoleCode[@codeListValue = 'custodian'])">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="custodianCnt" select="count(//gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty[.//gmd:role/gmd:CI_RoleCode/@codeListValue='custodian'])"/>

        <!-- Geographic Extent  --> 
        <xsl:variable name="datasetExtentExist">
            <xsl:choose>
                <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
		<xsl:variable name="datasetExtentCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox)"/>

        <xsl:variable name="datasetExtentDescriptionExist">
            <xsl:choose>
                <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:description/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
		<xsl:variable name="datasetExtentDescriptionCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:description/gco:CharacterString)"/>

        <xsl:variable name="startDateExist">
            <xsl:choose>
                <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="startDateCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition)"/>

        <xsl:variable name="endDateExist">
            <xsl:choose>
                <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:endPosition)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="endDateCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:endPosition)"/>

		<!-- Keywords -->
		<xsl:variable name="keywordExist">
			<xsl:choose>
				<xsl:when test="(//gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString)">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="keywordCnt" select="count(//gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString)"/>

        <!-- Originator -->
        <xsl:variable name="originatorExist">
            <xsl:choose>
                <xsl:when test="(//gmd:citation//gmd:CI_RoleCode[@codeListValue = 'originator'])">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="originatorCnt" select="count(//gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty[.//gmd:role/gmd:CI_RoleCode/@codeListValue='originator'])"/>

        <!-- Principal Investigator (Science Support Contact) -->
        <xsl:variable name="piExist">
            <xsl:choose>
                <xsl:when test="(//gmd:citation//gmd:CI_RoleCode[@codeListValue = 'principalInvestigator'] or //gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue='principalInvestigator')">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="piCnt" select="count(//gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty[.//gmd:role/gmd:CI_RoleCode/@codeListValue='principalInvestigator'] and //gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue='principalInvestigator')"/>

        <!-- Reference System -->
        <xsl:variable name="referenceSystemExist">
            <xsl:choose>
                <xsl:when test="normalize-space(//gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code/gco:CharacterString) != '' or
normalize-space(//gmd:referenceSystemInfo/gmd:MD_CRS/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code/gco:CharacterString) != '' or
(normalize-space(//gmd:referenceSystemInfo/gmd:MD_CRS/gmd:projection/gmd:RS_Identifier/gmd:code/gco:CharacterString) != '' and
normalize-space(//gmd:referenceSystemInfo/gmd:MD_CRS/gmd:ellipsoid/gmd:RS_Identifier/gmd:code/gco:CharacterString) != '' and
normalize-space(//gmd:referenceSystemInfo/gmd:MD_CRS/gmd:datum/gmd:RS_Identifier/gmd:code/gco:CharacterString) != '' )">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="referenceSystemCnt" select="count(gmd:MD_Metadata/gmd:referenceSystemInfo/gmd:MD_ReferenceSystem)"/>

        <!-- Resource Provider -->
        <xsl:variable name="resourceProviderExist">
            <xsl:choose>
                <xsl:when test="(//gmd:citation//gmd:CI_RoleCode[@codeListValue = 'resourceProvider'])">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="resourceProviderCnt" select="count(//gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty[.//gmd:role/gmd:CI_RoleCode/@codeListValue='resourceProvider'])"/>

        <!-- Spatial Representation Type -->
	<!--	<xsl:variable name="spatialRepresentationTypeCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType)"/>  -->
		<xsl:variable name="spatialRepresentationTypeCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/MD_SpatialRepresentationTypeCode[@codeListValue])"/>

		<xsl:variable name="spatialRepresentationTypeExist">
			<xsl:choose>
				<xsl:when test="normalize-space(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue) != '' ">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="spatialRepresentationType_Group">
			<xsl:choose>
				<xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode[@codeListValue='grid'] and //gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode[@codeListValue='vector'])">3</xsl:when>
				<xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode[@codeListValue='grid'])">2</xsl:when>
				<xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode[@codeListValue='vector'])">1</xsl:when>
				<xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode[@codeListValue='textTable'] or //gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode[@codeListValue='tin'] or //gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode[@codeListValue='stereoModel'] or
                        //gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode[@codeListValue='video'])">0</xsl:when>
				<xsl:otherwise>
					<!-- if no spatialRepresentationTypeCode is defined, MD_SpatialRepresentation and MD_ContentInformation are studied -->
					<xsl:choose>
						<xsl:when test="(//gmd:spatialRepresentationInfo/gmd:MD_GridSpatialRepresentation/gmd:numberOfDimensions/gco:Integer or //gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:numberOfDimensions/gco:Integer or //gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:numberOfDimensions/gco:Integer) and (//gmd:spatialRepresentationInfo/gmd:MD_VectorSpatialRepresentation/gmd:topologyLevel/gmd:MD_TopologyLevelCode[@codeListValue]	or //gmd:spatialRepresentationInfo/gmd:MD_VectorSpatialRepresentation/gmd:geometricObjects/gmd:MD_GeometricObjects/gmd:geometricObjectType/gmd:MD_GeometricObjectTypeCode[@codeListValue])">3</xsl:when>
						<xsl:when test="(//gmd:spatialRepresentationInfo/gmd:MD_GridSpatialRepresentation/gmd:numberOfDimensions/gco:Integer or //gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:numberOfDimensions/gco:Integer or //gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:numberOfDimensions/gco:Integer)">2</xsl:when>
						<xsl:when test="(//gmd:spatialRepresentationInfo/gmd:MD_VectorSpatialRepresentation/gmd:topologyLevel/gmd:MD_TopologyLevelCode[@codeListValue] or //gmd:spatialRepresentationInfo/gmd:MD_VectorSpatialRepresentation/gmd:geometricObjects/gmd:MD_GeometricObjects/gmd:geometricObjectType/gmd:MD_GeometricObjectTypeCode[@codeListValue])">1</xsl:when>
						<xsl:when test="(//gmd:contentInfo/gmd:MD_CoverageDescription/gmd:attributeDescription/gco:RecordType or //gmd:contentInfo/gmd:MD_ImageDescription/gmd:attributeDescription/gco:RecordType) and (//gmd:MD_FeatureCatalogueDescription/gmd:includedWithDataset/gco:Boolean)">3</xsl:when>
						<xsl:when test="(//gmd:contentInfo/gmd:MD_CoverageDescription/gmd:attributeDescription/gco:RecordType or //gmd:contentInfo/gmd:MD_ImageDescription/gmd:attributeDescription/gco:RecordType)">2</xsl:when>
						<xsl:when test="(//gmd:MD_FeatureCatalogueDescription/gmd:includedWithDataset/gco:Boolean)">1</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="spatialRepresentationType_GroupName">
			<xsl:choose>
				<xsl:when test="$spatialRepresentationType_Group='0'">textTable, tin, stereoModel, video or undefined</xsl:when>
				<xsl:when test="$spatialRepresentationType_Group='1'">vector</xsl:when>
				<xsl:when test="$spatialRepresentationType_Group='2'">grid</xsl:when>
				<xsl:when test="$spatialRepresentationType_Group='3'">grid and vector</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:variable>

        <!-- Spatial Resolution -->
        <xsl:variable name="spatialResolutionExist">
            <xsl:choose>
                <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialResolution/gmd:MD_Resolution)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
		<xsl:variable name="spatialResolutionCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialResolution/gmd:MD_Resolution)"/>

        <!-- Temporal Extent -->
        <xsl:variable name="temporalExist">
            <xsl:choose>
                <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
		<xsl:variable name="temporalCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent)"/>

        <!-- Time Interval -->
        <xsl:variable name="temporalResolutionExist">
            <xsl:choose> 
                <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:timeInterval)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="temporalResolutionCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:timeInterval)"/>

        <!-- Theme, aka GCMD keywords-->
		<xsl:variable name="themeKeywordExist">
			<xsl:choose>
				<xsl:when test="(//gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:type/gmd:MD_KeywordTypeCode[@codeListValue='theme'])">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="themeKeywordCnt" select="count(//gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:type/gmd:MD_KeywordTypeCode[@codeListValue='theme'])"/>

		<xsl:variable name="themeKeywordThesaurusExist">
			<xsl:choose>
				<xsl:when test="(//gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:type/gmd:MD_KeywordTypeCode[@codeListValue='theme']/ancestor::node()/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString)">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="themeKeywordThesaurusCnt" select="count(//gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:type/gmd:MD_KeywordTypeCode[@codeListValue='theme']/ancestor::node()/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString)"/>

		<!-- Topic Category -->
		<xsl:variable name="topicCategoryExist">
			<xsl:choose>
				<xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:topicCategory/gmd:MD_TopicCategoryCode)">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="topicCategoryCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:topicCategory/gmd:MD_TopicCategoryCode)"/>

        <!-- Vertical Extent -->
        <xsl:variable name="verticalExist">
            <xsl:choose>
                <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
		<xsl:variable name="verticalCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent)"/>

    <!-- *************************************** -->
    <!--                Level 3                  -->
    <!-- *************************************** -->

        <!-- Additional Information -->
        <xsl:variable name="additionalInformationExist">
            <xsl:choose>
                <xsl:when test="contains(//gmd:metadataExtensionInfo/gmd:MD_MetadataExtensionInformation/gmd:extensionOnLineResource/gmd:CI_OnlineResource/gmd:name/gco:CharacterString, 'Documentation') or (//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:supplementalInformation/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="additionalInformationCnt" select="count((//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:supplementalInformation/gco:CharacterString) or starts-with(//gmd:metadataExtensionInfo/gmd:MD_MetadataExtensionInformation/gmd:extensionOnLineResource/gmd:name/gco:CharacterString, 'Documentation'))"/>

        <!-- Alternate Identifier -->
        <xsl:variable name="alternateID" select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:alternateTitle/gco:CharacterString"/>
        <xsl:variable name="alternateIDExist">
            <xsl:choose>
                <xsl:when test="(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:alternateTitle/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="alternateIDCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:alternateTitle/gco:CharacterString)"/>

        <!-- Asset Size -->
        <xsl:variable name="assetSizeExist">
            <xsl:choose>
                <xsl:when test="(//gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:transferSize)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="assetSizeCnt" select="count(//gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:transferSize)"/>

        <!-- Author Identifier -->
        <xsl:variable name="authorIdentifierExist">
            <xsl:choose>
                <xsl:when test="(//gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:individualName/gmx:Anchor)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="authorIdentifierCnt" select="count(//gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:individualName/gmx:Anchor)"/>

		<!-- Distributor -->
		<xsl:variable name="distributorContactExist">
			<xsl:choose>
				<xsl:when test="normalize-space(//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString) != '' or   
normalize-space(//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString) != '' or 
normalize-space(//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:positionName/gco:CharacterString) != '' or  
normalize-space(//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:formatDistributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString) != '' or  
normalize-space(//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:formatDistributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString) != '' or  
normalize-space(//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:formatDistributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:positionName/gco:CharacterString) != '' or 
//gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="distributorContactCnt">
			<xsl:choose>
				<xsl:when test="$distributorContactExist = 1 "><xsl:value-of select="count(//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty | //gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty)"/></xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

        <!-- Distribution Format -->
        <xsl:variable name="distributionFormatExist">
            <xsl:choose>
                <xsl:when test="(//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorFormat/gmd:MD_Format/gmd:name/gco:CharacterString) != '' or (//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString) != '' or  (//gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata/srv:operationName/gco:CharacterString) != '' ">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="distributionFormatCnt" select="count(//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorFormat/gmd:MD_Format/gmd:name/gco:CharacterString) + count(//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString) + count(//gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata/srv:operationName/gco:CharacterString)"/>

        <!-- Progress -->
        <xsl:variable name="progressExist">
            <xsl:choose>
                <xsl:when test="//gmd:MD_DataIdentification/gmd:status/gmd:MD_ProgressCode/@codeListValue">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="progressCnt" select="count(//gmd:MD_DataIdentification/gmd:status/gmd:MD_ProgressCode/@codeListValue)"/>

        <!-- Related Resource -->
        <xsl:variable name="relatedResourceExist">
            <xsl:choose>
                <xsl:when test="(//gmd:metadataExtensionInfo/gmd:MD_MetadataExtensionInformation/gmd:extensionOnLineResource/gmd:CI_OnlineResource/gmd:linkage)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="relatedResourceCnt" select="count(//gmd:metadataExtensionInfo/gmd:MD_MetadataExtensionInformation/gmd:extensionOnLineResource/gmd:CI_OnlineResource/gmd:linkage)"/>

        <!-- Related Resource Description -->
        <xsl:variable name="relatedResourceDescriptionExist">
            <xsl:choose>
                <xsl:when test="(//gmd:metadataExtensionInfo/gmd:MD_MetadataExtensionInformation/gmd:extensionOnLineResource/gmd:CI_OnlineResource/gmd:description/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="relatedResourceDescriptionCnt" select="count(//gmd:metadataExtensionInfo/gmd:MD_MetadataExtensionInformation/gmd:extensionOnLineResource/gmd:description/gco:CharacterString)"/>

        <!-- Related Resource Name -->
        <xsl:variable name="relatedResourceNameExist">
            <xsl:choose>
                <xsl:when test="(//gmd:metadataExtensionInfo/gmd:MD_MetadataExtensionInformation/gmd:extensionOnLineResource/gmd:CI_OnlineResource/gmd:name/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="relatedResourceNameCnt" select="count(//gmd:metadataExtensionInfo/gmd:MD_MetadataExtensionInformation/gmd:extensionOnLineResource/gmd:CI_OnlineResource/gmd:name/gco:CharacterString)"/>

        <!-- Related Resource Type -->
        <xsl:variable name="relatedResourceTypeExist">
            <xsl:choose>
                <xsl:when test="(//gmd:metadataExtensionInfo/gmd:MD_MetadataExtensionInformation/gmd:extensionOnLineResource/gmd:CI_OnlineResource/gmd:function/gmd:CI_OnLineFunctionCode/@codeListValue)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="relatedResourceTypeCnt" select="count(//gmd:metadataExtensionInfo/gmd:MD_MetadataExtensionInformation/gmd:extensionOnLineResource/gmd:CI_OnlineResource/gmd:function/gmd:CI_OnLineFunctionCode/@codeListValue)"/>

        <!-- Resource Format -->
        <xsl:variable name="resourceFormatExist">
            <xsl:choose>
                <xsl:when test="(/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceFormat/gmd:MD_Format/gmd:name/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="resourceFormatCnt" select="count(/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceFormat/gmd:MD_Format/gmd:name/gco:CharacterString)"/>

        <!-- Resource Version -->
        <xsl:variable name="resourceVersionExist">
            <xsl:choose>
                <xsl:when test="normalize-space(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:edition/gco:CharacterString) != '' ">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="resourceVersionCnt" select="count(//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:edition/gco:CharacterString)"/>

        <!-- Software Implementation Language -->
        <xsl:variable name="softwareImplementationLanguage">
            <xsl:choose>
                <xsl:when test="(/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:environmentDescription/gco:CharacterString)">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="softwareImplementationLanguageCnt" select="count(/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:environmentDescription/gco:CharacterString)"/>

        <!-- Levels Scores -->
        <xsl:variable name="level1Score" select="$abstractExist + $assetTypeExist + $authorExist + $DataIdentificationExist + $datasetLanguageExist + $metadataRecordIDExist + $landingPageExist + $metadataContactExist + $metadataDateStampCnt + $metadataStandardNameExist + $metadataStandardVersionExist + $otherConstraintsExist + $publicationDateExist + $publisherExist + $resourceContactExist + $resourceTypeExist + $titleExist + $useConstraintsExist"/>
        <xsl:variable name="level1Max">18</xsl:variable>
        <xsl:variable name="level1Total" select="$abstractCnt + $assetTypeCnt + $authorCnt + $DataIdentificationExist + $datasetLanguageCnt + $metadataRecordIDCnt + $landingPageCnt + $metadataContactCnt + $metadataDateStampCnt + $metadataStandardNameCnt + $metadataStandardVersionCnt + $otherConstraintsCnt + $publicationDateCnt + $publisherCnt + $resourceContactCnt + $resourceTypeCnt + $titleCnt + $useConstraintsCnt"/>

        <xsl:variable name="level2Score" select="$citationDateExist + $creditExist + $custodianExist + $datasetExtentExist + $datasetExtentDescriptionExist + $startDateExist + $endDateExist + $keywordExist + $originatorExist + $piExist + $referenceSystemExist + $resourceProviderExist + $spatialRepresentationTypeExist + $spatialResolutionExist + $temporalExist + $temporalResolutionExist + $themeKeywordExist + $themeKeywordThesaurusExist + $topicCategoryExist + $verticalExist"/>
        <xsl:variable name="level2Max">20</xsl:variable>
        <xsl:variable name="level2Total" select="$citationDateCnt + $creditCnt + $custodianCnt + $datasetExtentCnt + $datasetExtentDescriptionCnt + $startDateCnt + $endDateCnt + $keywordCnt + $originatorCnt + $piCnt + $referenceSystemCnt + $resourceProviderCnt + $spatialRepresentationTypeCnt + $spatialResolutionCnt + $temporalCnt + $temporalResolutionCnt + $themeKeywordCnt + $themeKeywordThesaurusCnt + $topicCategoryCnt + $verticalCnt"/>

        <xsl:variable name="level3Score" select="$additionalInformationExist + $alternateIDExist + $assetSizeExist + $authorIdentifierExist + $distributorContactExist + $distributionFormatExist + $progressExist + $relatedResourceExist + $relatedResourceDescriptionExist + $relatedResourceNameExist + $relatedResourceTypeExist + $resourceFormatExist + $resourceVersionExist + $softwareImplementationLanguage"/>
        <xsl:variable name="level3Max">14</xsl:variable>
        <xsl:variable name="level3Total" select="$additionalInformationCnt + $alternateIDCnt + $assetSizeCnt + $authorIdentifierCnt + $distributorContactCnt + $distributionFormatCnt + $progressCnt + $relatedResourceCnt + $relatedResourceDescriptionCnt + $relatedResourceNameCnt + $relatedResourceTypeCnt + $resourceFormatCnt + $resourceVersionCnt + $softwareImplementationLanguageCnt"/>

        <xsl:variable name="levelsScore" select="$level1Score + $level2Score + $level3Score"/>
        <xsl:variable name="levelsMax" select="$level1Max + $level2Max + $level3Max"/>
        <xsl:variable name="levelsTotal" select="$level1Total + $level2Total + $level3Total"/>

        <!-- For EOL datasets, use the archive ident in place of fileIdentifier as first item on output line  -->
        <xsl:choose>
            <xsl:when test="starts-with($fileID, 'edu.ucar.eol')">
"<xsl:value-of select="//gmd:alternateTitle/gco:CharacterString"/>",</xsl:when>
            <xsl:otherwise><!--  print out scores for each element to a line in XML file for this dataset  --> 
"<xsl:value-of select="$fileID"/>",</xsl:otherwise>
        </xsl:choose><xsl:value-of select="format-number($levelsScore, '00')"/>,<xsl:value-of select="$abstractExist"/>,<xsl:value-of select="$assetTypeExist"/>,<xsl:value-of
 select="$authorExist"/>,<xsl:value-of select="$DataIdentificationExist"/>,<xsl:value-of select="$datasetLanguageExist"/>,<xsl:value-of select="$landingPageExist"/>,<xsl:value-of
 select="$metadataContactExist"/>,<xsl:value-of select="$metadataDateStampCnt"/>,<xsl:value-of select="$metadataRecordIDExist"/>,<xsl:value-of
 select="$metadataStandardNameExist"/>,<xsl:value-of select="$metadataStandardVersionExist"/>,<xsl:value-of select="$otherConstraintsExist"/>,<xsl:value-of
 select="$publicationDateExist"/>,<xsl:value-of select="$publisherExist"/>,<xsl:value-of select="$resourceContactExist"/>,<xsl:value-of select="$resourceTypeExist"/>,<xsl:value-of
 select="$titleExist"/>,<xsl:value-of select="$useConstraintsExist"/>,<xsl:value-of select="$citationDateExist"/>,<xsl:value-of select="$creditExist"/>,<xsl:value-of
 select="$custodianExist"/>,<xsl:value-of select="$datasetExtentExist"/>,<xsl:value-of select="$datasetExtentDescriptionExist"/>,<xsl:value-of select="$endDateExist"/>,<xsl:value-of
 select="$keywordExist"/>,<xsl:value-of select="$originatorExist"/>,<xsl:value-of select="$piExist"/>,<xsl:value-of select="$referenceSystemExist"/>,<xsl:value-of
 select="$resourceProviderExist"/>,<xsl:value-of select="$spatialRepresentationTypeExist"/>,<xsl:value-of select="$spatialResolutionExist"/>,<xsl:value-of
 select="$startDateExist"/>,<xsl:value-of select="$temporalExist"/>,<xsl:value-of select="$temporalResolutionExist"/>,<xsl:value-of select="$themeKeywordExist"/>,<xsl:value-of
 select="$themeKeywordThesaurusExist"/>,<xsl:value-of select="$topicCategoryExist"/>,<xsl:value-of select="$verticalExist"/>,<xsl:value-of
 select="$additionalInformationExist"/>,<xsl:value-of select="$alternateIDExist"/>,<xsl:value-of select="$assetSizeExist"/>,<xsl:value-of select="$authorIdentifierExist"/>,<xsl:value-of
 select="$distributionFormatExist"/>,<xsl:value-of select="$distributorContactExist"/>,<xsl:value-of select="$progressExist"/>,<xsl:value-of
 select="$relatedResourceDescriptionExist"/>,<xsl:value-of select="$relatedResourceExist"/>,<xsl:value-of select="$relatedResourceNameExist"/>,<xsl:value-of
 select="$relatedResourceTypeExist"/>,<xsl:value-of select="$resourceFormatExist"/>,<xsl:value-of select="$resourceVersionExist"/>,<xsl:value-of select="$softwareImplementationLanguage"/>
	</xsl:template>
</xsl:stylesheet>
