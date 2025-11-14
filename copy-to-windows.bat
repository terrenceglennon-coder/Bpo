@echo off
REM Copy Airtable Migration Files to Windows Directory
REM Run this from Windows Command Prompt or PowerShell

echo Copying Airtable migration files...

REM Create directory if it doesn't exist
if not exist "C:\AI FILES\AIRTABLE FIX" mkdir "C:\AI FILES\AIRTABLE FIX"

REM Copy all migration files
copy "\\wsl$\Ubuntu\home\user\Bpo\COMPLETE-AIRTABLE-TO-SHEETS-MIGRATION-GUIDE.md" "C:\AI FILES\AIRTABLE FIX\"
copy "\\wsl$\Ubuntu\home\user\Bpo\airtable-to-sheets-analysis.md" "C:\AI FILES\AIRTABLE FIX\"
copy "\\wsl$\Ubuntu\home\user\Bpo\airtable-to-sheets-comparison.md" "C:\AI FILES\AIRTABLE FIX\"
copy "\\wsl$\Ubuntu\home\user\Bpo\sheets-solution-1-direct-tools.json" "C:\AI FILES\AIRTABLE FIX\"
copy "\\wsl$\Ubuntu\home\user\Bpo\sheets-solution-2-hybrid-code.json" "C:\AI FILES\AIRTABLE FIX\"
copy "\\wsl$\Ubuntu\home\user\Bpo\sheets-solution-3-apps-script.json" "C:\AI FILES\AIRTABLE FIX\"
copy "\\wsl$\Ubuntu\home\user\Bpo\contact-agent-solution-1.json" "C:\AI FILES\AIRTABLE FIX\"
copy "\\wsl$\Ubuntu\home\user\Bpo\contact-agent-solution-2.json" "C:\AI FILES\AIRTABLE FIX\"
copy "\\wsl$\Ubuntu\home\user\Bpo\contact-agent-solution-3.json" "C:\AI FILES\AIRTABLE FIX\"
copy "\\wsl$\Ubuntu\home\user\Bpo\contact-solutions-comparison.md" "C:\AI FILES\AIRTABLE FIX\"
copy "\\wsl$\Ubuntu\home\user\Bpo\workflow-mindmap.md" "C:\AI FILES\AIRTABLE FIX\"
copy "\\wsl$\Ubuntu\home\user\Bpo\workflow-mindmap-visual.md" "C:\AI FILES\AIRTABLE FIX\"

echo.
echo Files copied successfully to C:\AI FILES\AIRTABLE FIX\
echo.
pause
