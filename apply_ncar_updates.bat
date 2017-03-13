@echo off
REM #####################################################
REM # Applies NCAR-specific configurations to CatMDEdit,
REM # updating thesauri and adding our Contacts list. 
REM # Run this after installing CatMDEdit 
REM #####################################################
echo.
set /P catBase= Enter the full path to the base CatMDEdit directory (e.g. C:\Users\dw\Desktop\CatMDEdit):  
echo "We will be updating files within the %catBase% installation directory"
pause
@echo on
xcopy /S "Expert Mode" "%catBase%\template\genericEditor\gui\Expert Mode" /i
xcopy /S "NCAR Dialect" "%catBase%\template\genericEditor\gui\NCAR Dialect" /i
copy /Y iso19115.xml "%catBase%\repository\standards"
copy Default.theme "%catBase%"
copy /Y internat.properties "%catBase%"
copy /Y splash_es_ES_5.0_KitCSG.jpg "%catBase%\imagen\generalIcons"
xcopy .\contact "%catBase%\repository\contact"
REM copy /Y CSDGM_FormatNameCode.dat "%catBase%\repository\thesaurus"
REM copy /Y "CSDGM_FormatNameCode.MD.DC_externo.xml" "%catBase%\repository\thesaurus"
copy ResourceType.dat "%catBase%\repository\thesaurus"
copy md_ResourceTypeCode_en.xml "%catBase%\repository\thesaurus"
copy /Y catmdedit-5.0.jar "%catBase%\lib"
ren "%catBase%\CatMDEdit.bat" NMDEdit.bat
@echo off
echo "NMDEdit is now ready to use"
echo.
echo "To start, double click on the NMDEdit batch file in the install directory." 
REM echo "done"
echo.
pause

