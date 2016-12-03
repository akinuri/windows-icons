#clear console
cls

Write-Host ""
Write-Host " Preparing the table..."

$table          = @()
$icon_files_dir = ((Get-Item -Path ".\" -Verbose).FullName + "\icons")

# get the extracted file (folder) names
# loop them and create stats
Get-ChildItem $icon_files_dir -Directory | ForEach-Object {
    $file      = $_.Name
    $sysroot   = "C:\Windows\"
    $system32  = $windir + "System32\"
    $wow64     = $sysroot + "SYSWOW64\"
    $filepath  = ""

    if (Test-Path ($system32 + $file)) {
        $filepath = ($system32 + $file)
    }
	elseif (Test-Path ($wow64 + $file)) {
        $filepath = ($wow64 + $file)
    }
	elseif (Test-Path ($windir + $file)) {
        $filepath = ($windir + $file)
    }
	
    $size        = (Get-Item $filepath).length / 1024
    $size        = [decimal]$size
    $size        = [math]::Floor($size)
    $icon_count  = (Get-ChildItem $_.FullName).Count
    $description = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($filepath).FileDescription -replace "  +",""

    if ($description.Length -gt 47) {
        $description = $description.Substring(0, 47) + "..."
    }

    $table += ,($file, $icon_count, $size, $description)
}


# sort table by icon count
#$table = $table | Sort-Object @{Expression={$_[1]}; Ascending=$false}, @{Expression={$_[0]}; Ascending=$true}

# calculate the columns widths for pretty print
$table_col_widths     = 0,0,0,0
$table | ForEach-Object {
    $cells            = $_
    $name_str_length  = $cells[0].Length
    $icons_str_length = ([string]$cells[1]).Length
    $size_str_length  = ([string]$cells[2]).Length
    $desc_str_length  = $cells[3].Length

    if ($name_str_length -gt $table_col_widths[0]) {
        $table_col_widths[0] = $name_str_length
    }
    if ($icons_str_length -gt $table_col_widths[1]) {
        $table_col_widths[1] = $icons_str_length
    }
    if ($size_str_length -gt $table_col_widths[2]) {
        $table_col_widths[2] = $size_str_length
    }
    if ($desc_str_length -gt $table_col_widths[3]) {
        $table_col_widths[3] = $desc_str_length
    }
}

# space between the columns
$table_col_spacing = 4
$table_col_space   = ""
for ($i = 0; $i -lt $table_col_spacing; $i++) {
    $table_col_space += " "
}

# calculate the headers' offsets
$table_headers        = "Name","Icons","Size","Description"
$table_header_offsets = 0,0,0,0
for ($i = 0; $i -lt $table_headers.Count; $i++) {
    $header_length = $table_headers[$i].Length
    $col_width     = $table_col_widths[$i]
    $offset        = $col_width - $header_length
    
    if ($offset -lt 0) {
        $table_col_widths[$i] += [math]::Abs($offset)
        $offset = 0
    }

    $table_header_offsets[$i] = $offset
}

cls

# printing column headers
$header_output = ""
for ($i = 0; $i -lt $table_headers.Count; $i++) {
    $header       = $table_headers[$i]
    $header_space = ""
    for ($j = 0; $j -lt $table_header_offsets[$i]; $j++) {
        $header_space += " "
    }
    if ($i -lt ($table_headers.Count - 1)) {
        $header_output += ($header + $header_space + $table_col_space)
    } else {
        $header_output += ($header + $header_space)
    }
}
Write-Host $header_output

# horizontal line that seperates the header from body
$table_width       = $table_col_widths[0] + $table_col_widths[1] + $table_col_widths[2] + $table_col_widths[3] + (3 * $table_col_spacing)
$table_header_line = ""
for ($i = 0; $i -lt $table_width; $i++) {
    $table_header_line += "-"
}
Write-Host $table_header_line

# printing the icon files
$table | ForEach-Object {
    $row    = $_
    $cells  = $row

    $name   = $cells[0]
    $icons  = $cells[1]
    $size   = $cells[2]
    $desc   = $cells[3]

    $name_offset    = $table_col_widths[0] - $name.Length
    $icons_offset   = $table_col_widths[1] - ([string]$icons).Length
    $size_offset    = $table_col_widths[2] - ([string]$size).Length
    $desc_offset    = $table_col_widths[3] - $desc.Length

    $name_space  = ""
    $icons_space = ""
    $size_space  = ""
    $desc_space  = ""

    for ($i = 0; $i -lt $name_offset; $i++) {
        $name_space += " "
    }
    for ($i = 0; $i -lt $icons_offset; $i++) {
        $icons_space += " "
    }
    for ($i = 0; $i -lt $size_offset; $i++) {
        $size_space += " "
    }
    for ($i = 0; $i -lt $desc_offset; $i++) {
        $desc_space += " "
    }

    $name   = ($name + $name_space + $table_col_space)
    $icons  = ($icons_space + $icons + $table_col_space)
    $size   = ($size_space + $size + $table_col_space)
    $desc   = ($desc + $desc_space)

    Write-Host ($name + $icons + $size + $desc)
}

Write-Host ""