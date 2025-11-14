# PowerShell Script to Copy Airtable Migration Files to Windows Directory
# Run this from PowerShell

Write-Host "Copying Airtable migration files..." -ForegroundColor Cyan

# Create directory if it doesn't exist
$targetDir = "C:\AI FILES\AIRTABLE FIX"
if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    Write-Host "Created directory: $targetDir" -ForegroundColor Green
}

# Source files from WSL
$sourceDir = "\\wsl$\Ubuntu\home\user\Bpo"

# List of files to copy
$files = @(
    "COMPLETE-AIRTABLE-TO-SHEETS-MIGRATION-GUIDE.md",
    "airtable-to-sheets-analysis.md",
    "airtable-to-sheets-comparison.md",
    "sheets-solution-1-direct-tools.json",
    "sheets-solution-2-hybrid-code.json",
    "sheets-solution-3-apps-script.json",
    "contact-agent-solution-1.json",
    "contact-agent-solution-2.json",
    "contact-agent-solution-3.json",
    "contact-solutions-comparison.md",
    "workflow-mindmap.md",
    "workflow-mindmap-visual.md"
)

# Copy each file
$successCount = 0
$failCount = 0

foreach ($file in $files) {
    $source = Join-Path $sourceDir $file
    $destination = Join-Path $targetDir $file

    try {
        if (Test-Path $source) {
            Copy-Item -Path $source -Destination $destination -Force
            Write-Host "✓ Copied: $file" -ForegroundColor Green
            $successCount++
        } else {
            Write-Host "✗ Not found: $file" -ForegroundColor Yellow
            $failCount++
        }
    } catch {
        Write-Host "✗ Error copying $file : $_" -ForegroundColor Red
        $failCount++
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  Successfully copied: $successCount files" -ForegroundColor Green
Write-Host "  Failed: $failCount files" -ForegroundColor $(if ($failCount -gt 0) { "Red" } else { "Green" })
Write-Host "  Target directory: $targetDir" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Open the folder
$openFolder = Read-Host "Open the folder now? (Y/N)"
if ($openFolder -eq "Y" -or $openFolder -eq "y") {
    explorer.exe $targetDir
}
