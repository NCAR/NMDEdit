@echo off
REM #####################################################
REM # Applies NCAR-specific configurations to CatMDEdit,
REM # updating thesauri and adding our Contacts list. 
REM # Run this after installing CatMDEdit 
REM #####################################################
echo.
set /P catBase= Enter the full path to the base CatMDEdit directory (e.g. /Users/dw/Applications/CatMDEdit):  
echo "We will be updating files within the  "%catBase% installation directory"
pause
@echo on
xcopy /S "Expert Mode" "%catBase%/template/genericEditor/gui/Expert Mode"
xcopy /S "NCAR Dialect" "%catBase%/template/genericEditor/gui/NCAR Dialect"
copy /Y iso19115.xml "%catBase%/repository/standards"
copy Default.theme "%catBase%"
copy /Y internat.properties "%catBase%"
copy /Y splash_es_ES_5.0_KitCSG.jpg "%catBase%/imagen/generalIcons"
copy "contact/*.rdf" "%catBase%/repository/contact"
copy /Y CSDGM_FormatNameCode.dat "%catBase%/repository/thesaurus"
copy /Y "CSDGM_FormatNameCode.MD.DC_externo.xml" "%catBase%/repository/thesaurus"
copy ResourceType.dat "%catBase%/repository/thesaurus"
copy md_ResourceTypeCode_en.xml "%catBase%/repository/thesaurus"
@echo off
echo "done"
echo.
pause

