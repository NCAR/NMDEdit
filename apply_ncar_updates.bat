@echo off
REM #####################################################
REM # Applies NCAR-specific configurations to CatMDEdit,
REM # updating thesauri and adding our Contacts list. 
REM # Run this after installing CatMDEdit 
REM #####################################################
echo.
set /P catBase= Enter the full path to the base CatMDEdit directory (e.g. C:\Users\dw\Desktop\CatMDEdit):  
echo "We will be updating files within the  "%catBase% installation directory"
pause
@echo on
xcopy /S "Expert Mode" "%catBase%\template\genericEditor\gui\Expert Mode"
xcopy /S "NCAR Dialect" "%catBase%\template\genericEditor\gui\NCAR Dialect"
copy /Y iso19115.xml "%catBase%\repository\standards"
copy Default.theme "%catBase%"
copy /Y internat.properties "%catBase%"
copy /Y splash_es_ES_5.0_KitCSG.jpg "%catBase%\imagen\generalIcons"
xcopy .\contact "%catBase%\repository\contact"
REM copy /Y CSDGM_FormatNameCode.dat "%catBase%\repository\thesaurus"
REM copy /Y "CSDGM_FormatNameCode.MD.DC_externo.xml" "%catBase%\repository\thesaurus"
copy ResourceType.dat "%catBase%\repository\thesaurus"
copy md_ResourceTypeCode_en.xml "%catBase%\repository\thesaurus"
copy /Y catmdedit-5.0.0.jar "%catBase%\lib"
copy "%catBase%\CatMDEdit.bat %catBase%\startup.sh"
@echo off
echo "N-MD1 is now ready to use"
cd "%catBase%"
echo "To start, type startup.sh in the terminal window" 
#echo "done"
echo.
pause

