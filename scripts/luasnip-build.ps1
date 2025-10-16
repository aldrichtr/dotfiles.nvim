<#
  .SYNOPSIS
    Install the jsregexp library and associated lua files
  .DESCRIPTION
    This script will:
    1. make the appropriate modifications to the makefiles
    2. ensure the msys environment has the proper libs and headers
    3. run make / make install

    1. Makefiles
      - ./Makefile : Comment out the `NEOVIM_BIN_PATH` (sed throws an error)
  .NOTES
    Currently, the script does all of the processes except the final `make` command. I believe
    it has to do with the quoting, but it may need some other paths, etc to be set.  If I
    run `c:\msys64\ucrt64.exe` and then run the commands in that bash session it works fine

    !! note that you need to set NEOVIM_BIN_PATH to /c/programs/Neovim/bin in the main makefile

#>
param(
  # directory where LuaSnip is downloaded to
  [Parameter(
    ValueFromPipeLine,
    ValueFromPipeLineByPropertyName
  )]
  [Alias('Path', 'PSPath')]
  [string]$LuaSnipPath,

  # directory where make files need to be updated
  [Parameter()]
  [string[]]$SourceDirectories,

  # The path to your MSYS installation
  [Parameter()]
  [string]$MsysDirectory,

  # The file to log output to
  [Parameter()]
  [string]$LogFile,

  # switch to skip the bash commands (at the end of the script)
  [Parameter()]
  [switch]$NoBash

)


#region functions
function Update-CompilerOption {
  param(
    #file to replace options in
    [Parameter(
      ValueFromPipeLine,
      ValueFromPipeLineByPropertyName
    )]
    [Alias('PSPath')]
    [string[]]$Path
  )
  begin {
    $find = [regex]::Escape('$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@')
    $replace = '$(CC) $^ $(LDLIBS) -o $@ $(LDFLAGS)'
  }
  process {
    foreach ($p in $Path) {
      if ($p | Test-Path) {
        $content = Get-Content $p -Raw
        $content = $content -replace $find , $replace
        $content | Set-Content $p
      } else {
        throw "Could not replace options in $p. File does not exist"
      }
    }
  }
}

function Update-NeovimPath {
  param()
  $makefile = (Join-Path $pwd 'Makefile')

  $content = Get-Content $makefile
  $new_content = [ArrayList]::new()

  $inPathVar = $false
  foreach ($line in $content) {
    if ($line -match '^NEOVIM_BIN_PATH') {$inPathVar = $true}
    if ($inPathVar) {
      $line = "### $line"
      if ($line -match '^\)$') {$inPathVar = $false}
      }
    [void]$new_content.Add($line)
  }
  [void]$new_content.Insert(1, "NEOVIM_BIN_PATH:=/c/programs/neovim/bin")
  $new_content | Set-Content $makefile

# NEOVIM_BIN_PATH:=$(or \
# 	$(shell (scoop prefix neovim | grep -q '^[A-Z]:[/\\\\]') 2>/dev/null && \
# 	echo "$$(scoop prefix neovim)/bin" | sed 's/\\\\/\\//g';), \
# 	$(shell which nvim >/dev/null && dirname "$$(which nvim)" | sed 's/^\\/\\(.\\)\\//\\U\\1:\\//';) \
  }

#endregion functions

if ([string]::IsNullOrEmpty($LogFile)) {
  $LogFile = (Join-Path $PSScriptRoot 'luasnip-build.log')
}
if ($LogFile | Test-Path) { Remove-Item $LogFile }

if ([string]::IsNullOrEmpty($LuaSnipPath)) {
  $LuaSnipPath = (Join-Path "$env:LOCALAPPDATA/nvim-data/lazy" 'LuaSnip')
}

if (-not ($LuaSnipPath | Test-Path)) {
  $message = "LuaSnip package not downloaded to $possibleLuaSnipDir"
  $message | Tee-Object $LogFile

  throw $message
}


try {
  #! Save the current location and restore it at the end of the script
  $currentPath = Get-Location | Select-Object -ExpandProperty Path
  "$(Get-Date -Format 'yyyy-MM-dd HH:MM') -- Started in $currentPath" | Tee-Object $LogFile
  Set-Location $LuaSnipPath
  "Changed location to $LuaSnipPath" | Tee-Object $LogFile
} catch {
  $message = "Could not set location in $LuaSnipPath`n$_"
  $message | Tee-Object $LogFile
  throw $message
}

if ([string]::IsNullOrEmpty($SourceDirectories)) {
  $SourceDirectories = @(
    (Join-Path $LuaSnipPath '.\deps\jsregexp\Makefile'),
    (Join-Path $LuaSnipPath '.\deps\jsregexp005\Makefile')
  )
}

if ([string]::IsNullOrEmpty($MsysDirectory)) {
  if ('C:/MSYS64' | Test-Path) {
    $MsysDirectory = 'C:/MSYS64'
  } else {
    $message = 'Could not find MSYS Installation folder'
    $message | Tee-Object $LogFile
    throw $message
  }
}

Update-NeovimPath
'Updating the makefiles' | Tee-Object $LogFile
$SourceDirectories | Update-CompilerOption

#TODO: turn the bash commands into '&' statements
$env:CHERE_INVOKING = 'yes' # Keep current Directory
$env:MSYSTEM = 'UCRT64' # https://www.msys2.org/docs/environments/

if (-not $NoBash) {

  $bashCmd = (Join-Path $MsysDirectory 'usr/bin/bash')

  $bashArgs = [System.Collections.ArrayList]::new(@('--login', '-i', '-c'))
  $thisDir = $PSScriptRoot
  $bashScript = ((Join-Path $thisDir 'luasnip-build.sh') -replace '\\', '/')

  [void]$bashArgs.Add($bashScript)
  "Running bash command: $bashCmd $($bashArgs -join ' ')" | Tee-Object $LogFile
  & $bashCmd $bashArgs

}
Set-Location $currentPath
