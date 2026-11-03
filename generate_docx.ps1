# ==============================================================================
# Wild Card Tennis - Native OpenXML .docx Document Generator
# Generates a 10-Page Comprehensive Executive Portfolio (.docx)
# ==============================================================================

param(
    [string]$OutputDir = "C:\Users\infin\Desktop\WildCard",
    [string]$DocxFilename = "Wild_Card_Tennis_Portfolio.docx"
)

$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.IO.Compression.FileSystem

$workingDir = Join-Path $OutputDir "temp_docx_build"
if (Test-Path $workingDir) {
    Remove-Item $workingDir -Recurse -Force
}

$wordDir = Join-Path $workingDir "word"
$wordRelsDir = Join-Path $wordDir "_rels"
$mediaDir = Join-Path $wordDir "media"
$baseRelsDir = Join-Path $workingDir "_rels"

New-Item -ItemType Directory -Force -Path $workingDir | Out-Null
New-Item -ItemType Directory -Force -Path $wordDir | Out-Null
New-Item -ItemType Directory -Force -Path $wordRelsDir | Out-Null
New-Item -ItemType Directory -Force -Path $mediaDir | Out-Null
New-Item -ItemType Directory -Force -Path $baseRelsDir | Out-Null

# Copy images into media directory if they exist
$imgFiles = @("logo.png", "hero.png", "banner.jpg", "event-card.png")
foreach ($img in $imgFiles) {
    $src = Join-Path $OutputDir $img
    if (Test-Path $src) {
        Copy-Item -Path $src -Destination (Join-Path $mediaDir $img) -Force
    }
}

# 1. [Content_Types].xml
$contentTypesXml = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Default Extension="png" ContentType="image/png"/>
  <Default Extension="jpeg" ContentType="image/jpeg"/>
  <Default Extension="jpg" ContentType="image/jpeg"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
  <Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/>
  <Override PartName="/word/header1.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.header+xml"/>
  <Override PartName="/word/footer1.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.footer+xml"/>
</Types>
'@
[System.IO.File]::WriteAllText((Join-Path $workingDir "[Content_Types].xml"), $contentTypesXml, [System.Text.Encoding]::UTF8)

# 2. _rels/.rels
$baseRelsXml = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>
'@
[System.IO.File]::WriteAllText((Join-Path $baseRelsDir ".rels"), $baseRelsXml, [System.Text.Encoding]::UTF8)

# 3. word/_rels/document.xml.rels
$docRelsXml = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rIdStyles" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
  <Relationship Id="rIdHeader1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/header" Target="header1.xml"/>
  <Relationship Id="rIdFooter1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/footer" Target="footer1.xml"/>
  <Relationship Id="rIdImgLogo" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/image" Target="media/logo.png"/>
  <Relationship Id="rIdImgHero" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/image" Target="media/hero.png"/>
  <Relationship Id="rIdImgBanner" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/image" Target="media/banner.jpg"/>
  <Relationship Id="rIdImgEvent" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/image" Target="media/event-card.png"/>
</Relationships>
'@
[System.IO.File]::WriteAllText((Join-Path $wordRelsDir "document.xml.rels"), $docRelsXml, [System.Text.Encoding]::UTF8)

# 4. word/header1.xml
$headerXml = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:hdr xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:p>
    <w:pPr>
      <w:pBdr>
        <w:bottom w:val="single" w:sz="6" w:space="4" w:color="0D2B1A"/>
      </w:pBdr>
      <w:tabs>
        <w:tab w:val="right" w:pos="9360"/>
      </w:tabs>
    </w:pPr>
    <w:r>
      <w:rPr>
        <w:rFonts w:ascii="Outfit" w:hAnsi="Outfit" w:cs="Outfit"/>
        <w:b/>
        <w:sz w:val="18"/>
        <w:color w:val="0D2B1A"/>
      </w:rPr>
      <w:t>WILD CARD TENNIS</w:t>
    </w:r>
    <w:r>
      <w:tab/>
    </w:r>
    <w:r>
      <w:rPr>
        <w:rFonts w:ascii="Outfit" w:hAnsi="Outfit" w:cs="Outfit"/>
        <w:sz w:val="16"/>
        <w:color w:val="1B4D2E"/>
      </w:rPr>
      <w:t>EXECUTIVE PORTFOLIO &amp; STRATEGIC DOSSIER</w:t>
    </w:r>
  </w:p>
</w:hdr>
'@
[System.IO.File]::WriteAllText((Join-Path $wordDir "header1.xml"), $headerXml, [System.Text.Encoding]::UTF8)

# 5. word/footer1.xml
$footerXml = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:ftr xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:p>
    <w:pPr>
      <w:pBdr>
        <w:top w:val="single" w:sz="4" w:space="4" w:color="CCCCCC"/>
      </w:pBdr>
      <w:tabs>
        <w:tab w:val="right" w:pos="9360"/>
      </w:tabs>
    </w:pPr>
    <w:r>
      <w:rPr>
        <w:rFonts w:ascii="Outfit" w:hAnsi="Outfit" w:cs="Outfit"/>
        <w:sz w:val="16"/>
        <w:color w:val="666666"/>
      </w:rPr>
      <w:t>Confidential &amp; Proprietary © 2026 Wild Card Tennis | www.wildcardtennis.com</w:t>
    </w:r>
    <w:r>
      <w:tab/>
    </w:r>
    <w:r>
      <w:rPr>
        <w:rFonts w:ascii="Outfit" w:hAnsi="Outfit" w:cs="Outfit"/>
        <w:b/>
        <w:sz w:val="16"/>
        <w:color w:val="0D2B1A"/>
      </w:rPr>
      <w:t>Page </w:t>
    </w:r>
    <w:fldSimple w:instr="PAGE"/>
    <w:r>
      <w:rPr>
        <w:rFonts w:ascii="Outfit" w:hAnsi="Outfit" w:cs="Outfit"/>
        <w:sz w:val="16"/>
        <w:color w:val="0D2B1A"/>
      </w:rPr>
      <w:t> of </w:t>
    </w:r>
    <w:fldSimple w:instr="NUMPAGES"/>
  </w:p>
</w:ftr>
'@
[System.IO.File]::WriteAllText((Join-Path $wordDir "footer1.xml"), $footerXml, [System.Text.Encoding]::UTF8)

# 6. word/styles.xml
$stylesXml = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:docDefaults>
    <w:rPrDefault>
      <w:rPr>
        <w:rFonts w:ascii="Outfit" w:hAnsi="Outfit" w:cs="Outfit"/>
        <w:sz w:val="21"/>
        <w:szCs w:val="21"/>
        <w:color w:val="1A2E22"/>
      </w:rPr>
    </w:rPrDefault>
    <w:pPrDefault>
      <w:pPr>
        <w:spacing w:after="140" w:line="276" w:lineRule="auto"/>
      </w:pPr>
    </w:pPrDefault>
  </w:docDefaults>

  <w:style w:type="paragraph" w:default="1" w:styleId="Normal">
    <w:name w:val="Normal"/>
  </w:style>

  <w:style w:type="paragraph" w:styleId="Heading1">
    <w:name w:val="heading 1"/>
    <w:pPr>
      <w:spacing w:before="240" w:after="120"/>
    </w:pPr>
    <w:rPr>
      <w:rFonts w:ascii="Outfit" w:hAnsi="Outfit" w:cs="Outfit"/>
      <w:b/>
      <w:sz w:val="34"/>
      <w:color w:val="0D2B1A"/>
    </w:rPr>
  </w:style>

  <w:style w:type="paragraph" w:styleId="Heading2">
    <w:name w:val="heading 2"/>
    <w:pPr>
      <w:spacing w:before="180" w:after="80"/>
    </w:pPr>
    <w:rPr>
      <w:rFonts w:ascii="Outfit" w:hAnsi="Outfit" w:cs="Outfit"/>
      <w:b/>
      <w:sz w:val="26"/>
      <w:color w:val="1B4D2E"/>
    </w:rPr>
  </w:style>

  <w:style w:type="paragraph" w:styleId="Heading3">
    <w:name w:val="heading 3"/>
    <w:pPr>
      <w:spacing w:before="120" w:after="60"/>
    </w:pPr>
    <w:rPr>
      <w:rFonts w:ascii="Outfit" w:hAnsi="Outfit" w:cs="Outfit"/>
      <w:b/>
      <w:sz w:val="22"/>
      <w:color w:val="2D6A4F"/>
    </w:rPr>
  </w:style>

  <w:style w:type="table" w:default="1" w:styleId="TableGrid">
    <w:name w:val="Table Grid"/>
    <w:tblPr>
      <w:tblBorders>
        <w:top w:val="single" w:sz="4" w:space="0" w:color="E2EDE5"/>
        <w:left w:val="single" w:sz="4" w:space="0" w:color="E2EDE5"/>
        <w:bottom w:val="single" w:sz="4" w:space="0" w:color="E2EDE5"/>
        <w:right w:val="single" w:sz="4" w:space="0" w:color="E2EDE5"/>
        <w:insideH w:val="single" w:sz="4" w:space="0" w:color="E2EDE5"/>
        <w:insideV w:val="none"/>
      </w:tblBorders>
    </w:tblPr>
  </w:style>
</w:styles>
'@
[System.IO.File]::WriteAllText((Join-Path $wordDir "styles.xml"), $stylesXml, [System.Text.Encoding]::UTF8)

# 7. Helper functions
function Escape-Xml([string]$s) {
    if ([string]::IsNullOrEmpty($s)) { return "" }
    return $s.Replace("&", "&amp;").Replace("<", "&lt;").Replace(">", "&gt;").Replace('"', "&quot;").Replace("'", "&apos;")
}

function New-P {
    param(
        [string]$Text = "",
        [string]$Color = "1A2E22",
        [int]$Size = 21,
        [bool]$Bold = $false,
        [bool]$Italic = $false,
        [string]$Align = "left",
        [int]$SpaceBefore = 0,
        [int]$SpaceAfter = 140
    )
    $t = Escape-Xml $Text
    $jc = if ($Align -ne "left") { "<w:jc w:val=""$Align""/>" } else { "" }
    $b = if ($Bold) { "<w:b/>" } else { "" }
    $i = if ($Italic) { "<w:i/>" } else { "" }
    return @"
<w:p>
  <w:pPr>
    $jc
    <w:spacing w:before="$SpaceBefore" w:after="$SpaceAfter" w:line="276" w:lineRule="auto"/>
  </w:pPr>
  <w:r>
    <w:rPr>
      <w:rFonts w:ascii="Outfit" w:hAnsi="Outfit" w:cs="Outfit"/>
      $b$i
      <w:sz w:val="$Size"/>
      <w:szCs w:val="$Size"/>
      <w:color w:val="$Color"/>
    </w:rPr>
    <w:t xml:space="preserve">$t</w:t>
  </w:r>
</w:p>
"@
}

function New-H1 {
    param([string]$Text)
    $t = Escape-Xml $Text
    return @"
<w:p>
  <w:pPr>
    <w:pStyle w:val="Heading1"/>
    <w:spacing w:before="200" w:after="80"/>
  </w:pPr>
  <w:r>
    <w:rPr>
      <w:rFonts w:ascii="Outfit" w:hAnsi="Outfit" w:cs="Outfit"/>
      <w:b/>
      <w:sz w:val="34"/>
      <w:color w:val="0D2B1A"/>
    </w:rPr>
    <w:t>$t</w:t>
  </w:r>
</w:p>
"@
}

function New-H2 {
    param([string]$Text)
    $t = Escape-Xml $Text
    return @"
<w:p>
  <w:pPr>
    <w:pStyle w:val="Heading2"/>
    <w:spacing w:before="160" w:after="60"/>
  </w:pPr>
  <w:r>
    <w:rPr>
      <w:rFonts w:ascii="Outfit" w:hAnsi="Outfit" w:cs="Outfit"/>
      <w:b/>
      <w:sz w:val="26"/>
      <w:color w:val="1B4D2E"/>
    </w:rPr>
    <w:t>$t</w:t>
  </w:r>
</w:p>
"@
}

function New-H3 {
    param([string]$Text)
    $t = Escape-Xml $Text
    return @"
<w:p>
  <w:pPr>
    <w:pStyle w:val="Heading3"/>
    <w:spacing w:before="120" w:after="40"/>
  </w:pPr>
  <w:r>
    <w:rPr>
      <w:rFonts w:ascii="Outfit" w:hAnsi="Outfit" w:cs="Outfit"/>
      <w:b/>
      <w:sz w:val="22"/>
      <w:color w:val="2D6A4F"/>
    </w:rPr>
    <w:t>$t</w:t>
  </w:r>
</w:p>
"@
}

function New-Bullet {
    param(
        [string]$BoldPrefix,
        [string]$Text
    )
    $bp = Escape-Xml $BoldPrefix
    $t = Escape-Xml $Text
    return @"
<w:p>
  <w:pPr>
    <w:ind w:left="360" w:hanging="240"/>
    <w:spacing w:before="0" w:after="80" w:line="260" w:lineRule="auto"/>
  </w:pPr>
  <w:r>
    <w:rPr>
      <w:rFonts w:ascii="Outfit" w:hAnsi="Outfit" w:cs="Outfit"/>
      <w:sz w:val="18"/>
      <w:color w:val="1B4D2E"/>
    </w:rPr>
    <w:t xml:space="preserve">▪  </w:t>
  </w:r>
  <w:r>
    <w:rPr>
      <w:rFonts w:ascii="Outfit" w:hAnsi="Outfit" w:cs="Outfit"/>
      <w:b/>
      <w:sz w:val="19"/>
      <w:color w:val="0D2B1A"/>
    </w:rPr>
    <w:t xml:space="preserve">$bp </w:t>
  </w:r>
  <w:r>
    <w:rPr>
      <w:rFonts w:ascii="Outfit" w:hAnsi="Outfit" w:cs="Outfit"/>
      <w:sz w:val="19"/>
      <w:color w:val="333333"/>
    </w:rPr>
    <w:t>$t</w:t>
  </w:r>
</w:p>
"@
}

function New-Callout {
    param(
        [string]$Title,
        [string]$Content,
        [string]$BgColor = "F4F8F4",
        [string]$BorderColor = "1B4D2E"
    )
    $titleXml = Escape-Xml $Title
    $contentXml = Escape-Xml $Content
    return @"
<w:tbl>
  <w:tblPr>
    <w:tblW w:w="9360" w:type="dxa"/>
    <w:tblBorders>
      <w:top w:val="none"/>
      <w:left w:val="single" w:sz="24" w:space="0" w:color="$BorderColor"/>
      <w:bottom w:val="none"/>
      <w:right w:val="none"/>
    </w:tblBorders>
    <w:tblCellMar>
      <w:top w:w="120" w:type="dxa"/>
      <w:left w:w="200" w:type="dxa"/>
      <w:bottom w:w="120" w:type="dxa"/>
      <w:right w:w="200" w:type="dxa"/>
    </w:tblCellMar>
  </w:tblPr>
  <w:tr>
    <w:tc>
      <w:tcPr>
        <w:tcW w:w="9360" w:type="dxa"/>
        <w:shd w:val="clear" w:color="auto" w:fill="$BgColor"/>
      </w:tcPr>
      <w:p>
        <w:pPr><w:spacing w:before="0" w:after="40"/></w:pPr>
        <w:r>
          <w:rPr>
            <w:rFonts w:ascii="Outfit" w:hAnsi="Outfit" w:cs="Outfit"/>
            <w:b/>
            <w:sz w:val="19"/>
            <w:color w:val="$BorderColor"/>
          </w:rPr>
          <w:t>$titleXml</w:t>
        </w:r>
      </w:p>
      <w:p>
        <w:pPr><w:spacing w:before="0" w:after="0"/></w:pPr>
        <w:r>
          <w:rPr>
            <w:rFonts w:ascii="Outfit" w:hAnsi="Outfit" w:cs="Outfit"/>
            <w:sz w:val="18"/>
            <w:color w:val="333333"/>
          </w:rPr>
          <w:t>$contentXml</w:t>
        </w:r>
      </w:p>
    </w:tc>
  </w:tr>
</w:tbl>
<w:p><w:pPr><w:spacing w:before="0" w:after="80"/></w:pPr></w:p>
"@
}

function New-StatGrid4 {
    param(
        [string]$n1, [string]$l1,
        [string]$n2, [string]$l2,
        [string]$n3, [string]$l3,
        [string]$n4, [string]$l4
    )
    $items = @(
        @{ Num=$n1; Label=$l1 },
        @{ Num=$n2; Label=$l2 },
        @{ Num=$n3; Label=$l3 },
        @{ Num=$n4; Label=$l4 }
    )
    $tcXml = ""
    foreach ($it in $items) {
        $num = Escape-Xml $it.Num
        $lbl = Escape-Xml $it.Label
        $tcXml += @"
      <w:tc>
        <w:tcPr>
          <w:tcW w:w="2340" w:type="dxa"/>
          <w:shd w:val="clear" w:color="auto" w:fill="F4F8F4"/>
          <w:tcBorders>
            <w:top w:val="single" w:sz="6" w:space="0" w:color="E2EDE5"/>
            <w:left w:val="single" w:sz="6" w:space="0" w:color="E2EDE5"/>
            <w:bottom w:val="single" w:sz="6" w:space="0" w:color="E2EDE5"/>
            <w:right w:val="single" w:sz="6" w:space="0" w:color="E2EDE5"/>
          </w:tcBorders>
          <w:tcMar>
            <w:top w:w="140" w:type="dxa"/>
            <w:left w:w="120" w:type="dxa"/>
            <w:bottom w:w="140" w:type="dxa"/>
            <w:right w:w="120" w:type="dxa"/>
          </w:tcMar>
        </w:tcPr>
        <w:p>
          <w:pPr>
            <w:jc w:val="center"/>
            <w:spacing w:before="0" w:after="20"/>
          </w:pPr>
          <w:r>
            <w:rPr>
              <w:rFonts w:ascii="Outfit" w:hAnsi="Outfit" w:cs="Outfit"/>
              <w:b/>
              <w:sz w:val="36"/>
              <w:color w:val="0D2B1A"/>
            </w:rPr>
            <w:t>$num</w:t>
          </w:r>
        </w:p>
        <w:p>
          <w:pPr>
            <w:jc w:val="center"/>
            <w:spacing w:before="0" w:after="0"/>
          </w:pPr>
          <w:r>
            <w:rPr>
              <w:rFonts w:ascii="Outfit" w:hAnsi="Outfit" w:cs="Outfit"/>
              <w:b/>
              <w:sz w:val="14"/>
              <w:color w:val="1B4D2E"/>
            </w:rPr>
            <w:t>$lbl</w:t>
          </w:r>
        </w:p>
      </w:tc>
"@
    }

    return @"
<w:tbl>
  <w:tblPr>
    <w:tblW w:w="9360" w:type="dxa"/>
    <w:jc w:val="center"/>
  </w:tblPr>
  <w:tr>
    $tcXml
  </w:tr>
</w:tbl>
<w:p><w:pPr><w:spacing w:before="0" w:after="120"/></w:pPr></w:p>
"@
}

function New-PageBreak {
    return @"
<w:p>
  <w:r>
    <w:br w:type="page"/>
  </w:r>
</w:p>
"@
}

# 8. Assemble Document Body
$docBody = ""

# ==============================================================================
# PAGE 1: COVER & EXECUTIVE OVERVIEW
# ==============================================================================
$docBody += New-P -Text "WILD CARD TENNIS // EXECUTIVE DOSSIER 2026" -Color "1B4D2E" -Size 20 -Bold $true -Align "center" -SpaceBefore 300 -SpaceAfter 100
$docBody += New-P -Text "EXECUTIVE PORTFOLIO & STRATEGIC DOSSIER" -Color "0D2B1A" -Size 48 -Bold $true -Align "center" -SpaceBefore 100 -SpaceAfter 100
$docBody += New-P -Text "Redefining the Tennis Experience — Elite Performance, Championship Operations & Digital Infrastructure" -Color "1B4D2E" -Size 24 -Italic $true -Align "center" -SpaceBefore 50 -SpaceAfter 240

$docBody += New-Callout -Title "EXECUTIVE SUMMARY & MISSION STATEMENT" -Content "Wild Card Tennis was founded to bridge the gap between recreational play and ATP Grand-Slam standard tournament execution. This comprehensive 10-page dossier details our operational journey, multi-surface engineering capabilities, tournament sanctioning frameworks, interactive cost engineering software, member ecosystem, and 2026–2028 international growth roadmap." -BgColor "0D2B1A" -BorderColor "DFFF00"

$docBody += New-H2 -Text "Table of Contents & Document Index"
$docBody += New-Bullet -BoldPrefix "Page 01:" -Text "Title, Executive Cover & Project Overview"
$docBody += New-Bullet -BoldPrefix "Page 02:" -Text "The Wild Card Journey, Heritage & Chronological Growth Timeline"
$docBody += New-Bullet -BoldPrefix "Page 03:" -Text "Core Competencies & 4-Pillar Skills Architecture"
$docBody += New-Bullet -BoldPrefix "Page 04:" -Text "Signature Tournaments, Sanctioned Draws & Event Operations"
$docBody += New-Bullet -BoldPrefix "Page 05:" -Text "High-Performance Coaching Clinics & Masterclass Curriculums"
$docBody += New-Bullet -BoldPrefix "Page 06:" -Text "Interactive Strategic Event Planner & Algorithmic Budgeting Engine"
$docBody += New-Bullet -BoldPrefix "Page 07:" -Text "Member Ecosystem, Digital Locker Room & State Architecture"
$docBody += New-Bullet -BoldPrefix "Page 08:" -Text "Membership Tiers, VIP Commercial Models & Sponsorships"
$docBody += New-Bullet -BoldPrefix "Page 09:" -Text "Operational Case Studies, SOPs & Quality Assurance Protocols"
$docBody += New-Bullet -BoldPrefix "Page 10:" -Text "Strategic Roadmap (2026-2028), Tech Stack & Executive Directory"

$docBody += New-Callout -Title "ORGANIZATIONAL DISPATCH & HEADQUARTERS" -Content "Headquarters: Nairobi Club Tennis Pavilion, Upper Hill, Nairobi, Kenya | Director Dispatch: rogoij@gmail.com | Phone: +254 722 102 870 | Portal: www.wildcardtennis.com" -BgColor "F4F8F4" -BorderColor "0D2B1A"

$docBody += New-PageBreak

# ==============================================================================
# PAGE 2: THE WILD CARD JOURNEY & HERITAGE
# ==============================================================================
$docBody += New-H1 -Text "The Wild Card Journey & Brand Heritage"
$docBody += New-P -Text "From Grassroots Vision to World-Class Tournament & Coaching Infrastructure" -Color "1B4D2E" -Size 20 -Bold $true -SpaceAfter 120

$docBody += New-P -Text "Wild Card Tennis was founded on the belief that every tennis player, collegiate competitor, and corporate organizer deserves an authentic professional tournament environment. In tennis terminology, a 'Wild Card' is an opportunity—a hard-earned chance to challenge top-seeded players and make a breakthrough. We adopted this name to reflect our commitment to unlocking raw potential through immaculate court logistics, certified officiating, and world-class training."

$docBody += New-StatGrid4 -n1 "50+" -l1 "Tournaments Hosted" -n2 "1,200+" -l2 "Active Competitors" -n3 "100%" -l3 "ATP Precision Standard" -n4 "98.4%" -l4 "Player Satisfaction"

$docBody += New-H2 -Text "Chronological Growth Timeline (2022 - 2026)"

$docBody += New-Bullet -BoldPrefix "2022 — Foundation & Baseline Infrastructure:" -Text "Established at Nairobi Club Tennis Pavilion to eliminate logistical bottlenecks in regional competition. Standardized court resurfacing, introduced electronic stringing calibration, and unified tournament scheduling."
$docBody += New-Bullet -BoldPrefix "2023 — Junior Circuit & Academy Expansion:" -Text "Inaugurated the Wild Card Junior Open (Under-18), integrating college scout showcases and 240fps video stroke biomechanics. Hosted 300+ junior matches across hard and clay courts."
$docBody += New-Bullet -BoldPrefix "2024 — Corporate Retreats & Pro-Am Series:" -Text "Launched bespoke corporate championships combining round-robin matchplay with luxury VIP hospitality, pro exhibition showcases, and executive networking suites."
$docBody += New-Bullet -BoldPrefix "2025 — Proprietary Digital Architecture & Cost Engine:" -Text "Engineered the interactive 4-step web planner, live pitch duration sliders, and real-time budgeting algorithms, enabling clients to configure custom tournaments and receive instant itemized quotes in seconds."
$docBody += New-Bullet -BoldPrefix "2026 — Grand Slam Warmup Series & International Masterclasses:" -Text "Partnered with touring professionals to launch specialized masterclasses in serve-and-volley tactics, red clay slide mechanics, and mental fortitude under high-pressure breakpoint scenarios."

$docBody += New-Callout -Title "CORE BRAND PHILOSOPHY" -Content "Precision is the difference between a casual hit and a championship match. We obsess over court moisture, ball temperature, string tension, and umpire rigor so players can focus purely on winning." -BgColor "F4F8F4" -BorderColor "1B4D2E"

$docBody += New-PageBreak

# ==============================================================================
# PAGE 3: SKILLS & CORE COMPETENCIES
# ==============================================================================
$docBody += New-H1 -Text "Skills & Operational Competencies"
$docBody += New-P -Text "Four Interlocking Pillars Powering Elite Tennis Execution" -Color "1B4D2E" -Size 20 -Bold $true -SpaceAfter 120

$docBody += New-P -Text "Delivering authentic tournament and masterclass experiences requires a sophisticated blend of court engineering, certified officiating, sports science biomechanics, and scalable digital software. Our team operates across four core operational pillars:"

$docBody += New-H2 -Text "Pillar 1: Tournament Architecture & Officiating"
$docBody += New-Bullet -BoldPrefix "Draw Formats & Brackets:" -Text "Single/double knockout draws, compass draws, round-robin pools, and staggered consolation ladders adhering to ITF rules."
$docBody += New-Bullet -BoldPrefix "Ranking & Seeding Math:" -Text "UTR/ITF ranking calculations, head-to-head records, and automated seed protection."
$docBody += New-Bullet -BoldPrefix "Certified Officials:" -Text "ITF White and Bronze badge chair umpires, roving line judges, and code-of-conduct marshals."
$docBody += New-Bullet -BoldPrefix "Live Scorekeeping:" -Text "Court-side digital scoreboards updating match stats directly to the web portal."

$docBody += New-H2 -Text "Pillar 2: Court Surface Engineering & Maintenance"
$docBody += New-Bullet -BoldPrefix "Championship Plexicushion Hard Courts:" -Text "Multi-layered acrylic shock-absorbing surfaces calibrated for true bounce speed (ITF Medium-Fast)."
$docBody += New-Bullet -BoldPrefix "Roland Garros Red Clay:" -Text "Daily laser-grading, calcium chloride moisture binding, and line sweeping."
$docBody += New-Bullet -BoldPrefix "Natural Lawn Grass Courts:" -Text "Precision 6mm turf cutting, sub-surface drainage, and specialized aeration."
$docBody += New-Bullet -BoldPrefix "Luminescence Standards:" -Text "750+ lux flicker-free LED arrays configured for broadcast and twilight matches."

$docBody += New-H2 -Text "Pillar 3: High-Performance Coaching & Biomechanics"
$docBody += New-Bullet -BoldPrefix "Kinetic Chain Analysis:" -Text "High-speed 240fps video tracking of serve toss, shoulder rotation, and pronation."
$docBody += New-Bullet -BoldPrefix "Footwork Geometry:" -Text "Split-step timing, open-stance load balance, and red clay slide deceleration."
$docBody += New-Bullet -BoldPrefix "Mental Fortitude Frameworks:" -Text "Pre-serve routines, breakpoint management, and emotional composure under pressure."

$docBody += New-H2 -Text "Pillar 4: Digital Platform Engineering & Software"
$docBody += New-Bullet -BoldPrefix "Dynamic Planning Wizard:" -Text "4-step interactive event architect with real-time budgetary recalculation."
$docBody += New-Bullet -BoldPrefix "Pitch Duration Engine:" -Text "Continuous 1–24 hour interactive slider with instant facility rate multiplier."
$docBody += New-Bullet -BoldPrefix "Player Locker Room:" -Text "Member dashboard persisting stats, equipment specs, and pass tokens."

$docBody += New-PageBreak

# ==============================================================================
# PAGE 4: SIGNATURE TOURNAMENTS & EVENT OPERATIONS
# ==============================================================================
$docBody += New-H1 -Text "Signature Tournaments & Event Operations"
$docBody += New-P -Text "Flagship Tournaments, Sanctioned Draws & Social Galas" -Color "1B4D2E" -Size 20 -Bold $true -SpaceAfter 120

$docBody += New-P -Text "Wild Card Tennis designs, executes, and sanctions a diverse annual calendar of competitive tournaments and exhibitions tailored for every skill level from rising junior champions to corporate executives."

$docBody += New-H2 -Text "Annual Tournament Calendar & Specifications"

# Table of events
$docBody += @"
<w:tbl>
  <w:tblPr>
    <w:tblW w:w="9360" w:type="dxa"/>
    <w:tblBorders>
      <w:top w:val="single" w:sz="6" w:space="0" w:color="0D2B1A"/>
      <w:left w:val="single" w:sz="4" w:space="0" w:color="E2EDE5"/>
      <w:bottom w:val="single" w:sz="6" w:space="0" w:color="0D2B1A"/>
      <w:right w:val="single" w:sz="4" w:space="0" w:color="E2EDE5"/>
      <w:insideH w:val="single" w:sz="4" w:space="0" w:color="E2EDE5"/>
      <w:insideV w:val="none"/>
    </w:tblBorders>
  </w:tblPr>
  <w:tr>
    <w:tc><w:tcPr><w:tcW w:w="2400" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="0D2B1A"/></w:tcPr><w:p><w:r><w:rPr><w:b/><w:sz w:val="18"/><w:color w:val="FFFFFF"/></w:rPr><w:t>Event Title</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="1600" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="0D2B1A"/></w:tcPr><w:p><w:r><w:rPr><w:b/><w:sz w:val="18"/><w:color w:val="FFFFFF"/></w:rPr><w:t>Category</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="1800" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="0D2B1A"/></w:tcPr><w:p><w:r><w:rPr><w:b/><w:sz w:val="18"/><w:color w:val="FFFFFF"/></w:rPr><w:t>Dates</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="1800" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="0D2B1A"/></w:tcPr><w:p><w:r><w:rPr><w:b/><w:sz w:val="18"/><w:color w:val="FFFFFF"/></w:rPr><w:t>Draw Size</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="1760" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="0D2B1A"/></w:tcPr><w:p><w:r><w:rPr><w:b/><w:sz w:val="18"/><w:color w:val="FFFFFF"/></w:rPr><w:t>Surface</w:t></w:r></w:p></w:tc>
  </w:tr>
  <w:tr>
    <w:tc><w:tcPr><w:tcW w:w="2400" w:type="dxa"/></w:tcPr><w:p><w:r><w:rPr><w:b/><w:sz w:val="18"/><w:color w:val="0D2B1A"/></w:rPr><w:t>Wimbledon Warmup</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="1600" w:type="dxa"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>Grand Slam Series</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="1800" w:type="dxa"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>May 15-20, 2026</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="1800" w:type="dxa"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>32 Players</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="1760" w:type="dxa"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>Lawn Grass / Hard</w:t></w:r></w:p></w:tc>
  </w:tr>
  <w:tr>
    <w:tc><w:tcPr><w:tcW w:w="2400" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="F4F8F4"/></w:tcPr><w:p><w:r><w:rPr><w:b/><w:sz w:val="18"/><w:color w:val="0D2B1A"/></w:rPr><w:t>Service &amp; Volley Clinic</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="1600" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="F4F8F4"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>Masterclass</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="1800" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="F4F8F4"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>May 25, 2026</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="1800" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="F4F8F4"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>12 Players</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="1760" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="F4F8F4"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>Plexicushion Hard</w:t></w:r></w:p></w:tc>
  </w:tr>
  <w:tr>
    <w:tc><w:tcPr><w:tcW w:w="2400" w:type="dxa"/></w:tcPr><w:p><w:r><w:rPr><w:b/><w:sz w:val="18"/><w:color w:val="0D2B1A"/></w:rPr><w:t>Sunset Doubles Gala</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="1600" w:type="dxa"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>Social Gala</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="1800" w:type="dxa"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>June 01, 2026</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="1800" w:type="dxa"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>24 Pairs (48 Pax)</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="1760" w:type="dxa"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>Championship Hard</w:t></w:r></w:p></w:tc>
  </w:tr>
  <w:tr>
    <w:tc><w:tcPr><w:tcW w:w="2400" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="F4F8F4"/></w:tcPr><w:p><w:r><w:rPr><w:b/><w:sz w:val="18"/><w:color w:val="0D2B1A"/></w:rPr><w:t>Wild Card Junior Open</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="1600" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="F4F8F4"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>Junior Circuit</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="1800" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="F4F8F4"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>June 10-14, 2026</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="1800" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="F4F8F4"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>64 Juniors (U18)</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="1760" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="F4F8F4"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>Red Clay &amp; Hard</w:t></w:r></w:p></w:tc>
  </w:tr>
  <w:tr>
    <w:tc><w:tcPr><w:tcW w:w="2400" w:type="dxa"/></w:tcPr><w:p><w:r><w:rPr><w:b/><w:sz w:val="18"/><w:color w:val="0D2B1A"/></w:rPr><w:t>Midsummer Pro-Am</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="1600" w:type="dxa"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>Pro-Am Showcase</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="1800" w:type="dxa"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>July 04, 2026</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="1800" w:type="dxa"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>16 Teams</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="1760" w:type="dxa"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>Plexicushion Hard</w:t></w:r></w:p></w:tc>
  </w:tr>
</w:tbl>
<w:p><w:pPr><w:spacing w:before="0" w:after="120"/></w:pPr></w:p>
"@

$docBody += New-H2 -Text "Detailed Operational Case Profiles"

$docBody += New-Callout -Title "WIMBLEDON WARMUP GRAND SLAM SERIES" -Content "The premier grass-court preparation camp and tournament in East Africa. Designed for touring competitors and top-division athletes adapting to low-skid surfaces. Features official ITF chair umpires, electronic stringing stations, and tailored sports nutrition suites." -BgColor "F4F8F4" -BorderColor "0D2B1A"

$docBody += New-Callout -Title "SUNSET DOUBLES GALA & EXHIBITION" -Content "Where high-stakes tennis meets premier executive networking. Fast4 format doubles matches played under 750-lux floodlights, followed by an evening cocktail gala, acoustic lounge music, and sponsor showcase suites." -BgColor "F4F8F4" -BorderColor "1B4D2E"

$docBody += New-PageBreak

# ==============================================================================
# PAGE 5: COACHING & TACTICAL CLINICS
# ==============================================================================
$docBody += New-H1 -Text "High-Performance Coaching Clinics"
$docBody += New-P -Text "Tactical Curriculums, Biomechanical Precision & Mental Conditioning" -Color "1B4D2E" -Size 20 -Bold $true -SpaceAfter 120

$docBody += New-P -Text "Led by certified ATP Master coaches and former national champions, our intensive clinics break down complex tennis stroke mechanics into repeatable, biomechanically sound muscle memory."

$docBody += New-H2 -Text "Tactical Masterclass Breakdown"

$docBody += New-Callout -Title "MASTERCLASS 01: SERVICE & VOLLEY DYNAMICS" -Content "Kinetic chain power generation from leg drive to core coiling and pronation. Developing heavy topspin kick serves (4,500+ RPM) and pinpoint slice out-wide. First-volley split-step positioning inside the service box and overhead putaways." -BgColor "F4F8F4" -BorderColor "0D2B1A"

$docBody += New-Callout -Title "MASTERCLASS 02: RED CLAY SLIDE & AGILITY INTENSIVE" -Content "Mastering the physics of sliding on Roland Garros standard red clay. Initiating slides 2 steps prior to contact, deceleration balance on the inside edge, explosive hip torque for instant baseline recovery, and heavy topspin depth control." -BgColor "F4F8F4" -BorderColor "1B4D2E"

$docBody += New-Callout -Title "MASTERCLASS 03: MENTAL FORTITUDE & MATCH TACTICS" -Content "Psychological conditioning for clutch moments. 15-second pre-point breathing routines, heart rate regulation, breakpoint percentage tennis, opponent backhand targeting, and aggressive tiebreak execution." -BgColor "F4F8F4" -BorderColor "2D6A4F"

$docBody += New-H2 -Text "Professional Gear & Equipment Standards"
$docBody += New-Bullet -BoldPrefix "Electronic Stringing Tension Lab:" -Text "Calibrated on Wilson Baiardo and Babolat Sensor Dual constant-pull machines with 0.2 lb precision. Stocked with Luxilon ALU Power, Babolat RPM Blast, and natural gut hybrids."
$docBody += New-Bullet -BoldPrefix "Championship Pressurized Balls:" -Text "Strict adherence to official rotation protocols: new cans opened every 9 games for tournaments, with masterclass training balls maintained at 14 psi pressure."

$docBody += New-PageBreak

# ==============================================================================
# PAGE 6: INTERACTIVE EVENT PLANNER & BUDGETING
# ==============================================================================
$docBody += New-H1 -Text "Interactive Event Planner & Cost Engine"
$docBody += New-P -Text "Algorithmic Budgeting, Live Duration Sliders & Bespoke Event Architecture" -Color "1B4D2E" -Size 20 -Bold $true -SpaceAfter 120

$docBody += New-P -Text "A cornerstone innovation of Wild Card Tennis is our proprietary 4-step web planning wizard. Clients can configure court requirements, pro coaching staffing tiers, on-court duration, catering, and surface logistics to receive an instant, binding tactical quotation."

$docBody += New-H2 -Text "The 4-Step Strategic Planning Wizard"
$docBody += New-Bullet -BoldPrefix "Step 1: Event Identity:" -Text "Event Title, Category (Tournament, Clinic, Exhibition, Corporate), and player capacity sizing (2 to 256 players)."
$docBody += New-Bullet -BoldPrefix "Step 2: Facilities & Staffing:" -Text "Dedicated court count (2, 4, 8 courts), coaching tier (Self-officiated, Pro Coaches, Elite ATP Staff), and the 1–24 hour interactive pitch duration slider."
$docBody += New-Bullet -BoldPrefix "Step 3: Venue & Surface:" -Text "Court surface selection (Championship Hard Court, Roland Garros Red Clay, Lawn Grass) and target scheduling date."
$docBody += New-Bullet -BoldPrefix "Step 4: Live Tactical Quote:" -Text "Instant mathematical budget calculation, proposal dispatch, and automatic synchronization to the user dashboard."

$docBody += New-H2 -Text "Mathematical Cost Calculation Architecture"

# Pricing Table
$docBody += @"
<w:tbl>
  <w:tblPr>
    <w:tblW w:w="9360" w:type="dxa"/>
    <w:tblBorders>
      <w:top w:val="single" w:sz="6" w:space="0" w:color="0D2B1A"/>
      <w:left w:val="single" w:sz="4" w:space="0" w:color="E2EDE5"/>
      <w:bottom w:val="single" w:sz="6" w:space="0" w:color="0D2B1A"/>
      <w:right w:val="single" w:sz="4" w:space="0" w:color="E2EDE5"/>
      <w:insideH w:val="single" w:sz="4" w:space="0" w:color="E2EDE5"/>
      <w:insideV w:val="none"/>
    </w:tblBorders>
  </w:tblPr>
  <w:tr>
    <w:tc><w:tcPr><w:tcW w:w="2800" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="0D2B1A"/></w:tcPr><w:p><w:r><w:rPr><w:b/><w:sz w:val="18"/><w:color w:val="FFFFFF"/></w:rPr><w:t>Parameter</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="3400" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="0D2B1A"/></w:tcPr><w:p><w:r><w:rPr><w:b/><w:sz w:val="18"/><w:color w:val="FFFFFF"/></w:rPr><w:t>Options Available</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="3160" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="0D2B1A"/></w:tcPr><w:p><w:r><w:rPr><w:b/><w:sz w:val="18"/><w:color w:val="FFFFFF"/></w:rPr><w:t>Standard Rates (KSh)</w:t></w:r></w:p></w:tc>
  </w:tr>
  <w:tr>
    <w:tc><w:tcPr><w:tcW w:w="2800" w:type="dxa"/></w:tcPr><w:p><w:r><w:rPr><w:b/><w:sz w:val="18"/><w:color w:val="0D2B1A"/></w:rPr><w:t>Dedicated Courts</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="3400" w:type="dxa"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>2 Courts / 4 Courts / 8+ Courts</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="3160" w:type="dxa"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>KSh 6,500 / 12,000 / 22,000 per hr</w:t></w:r></w:p></w:tc>
  </w:tr>
  <w:tr>
    <w:tc><w:tcPr><w:tcW w:w="2800" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="F4F8F4"/></w:tcPr><w:p><w:r><w:rPr><w:b/><w:sz w:val="18"/><w:color w:val="0D2B1A"/></w:rPr><w:t>Staffing Tier</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="3400" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="F4F8F4"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>None / Pro Staff / Elite Master Staff</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="3160" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="F4F8F4"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>KSh 0 / 45,000 / 110,000 flat</w:t></w:r></w:p></w:tc>
  </w:tr>
  <w:tr>
    <w:tc><w:tcPr><w:tcW w:w="2800" w:type="dxa"/></w:tcPr><w:p><w:r><w:rPr><w:b/><w:sz w:val="18"/><w:color w:val="0D2B1A"/></w:rPr><w:t>Catering &amp; Lounge</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="3400" w:type="dxa"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>None / Hydration Lounge / VIP Buffet</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="3160" w:type="dxa"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>KSh 0 / 2,000 / 6,000 per player</w:t></w:r></w:p></w:tc>
  </w:tr>
  <w:tr>
    <w:tc><w:tcPr><w:tcW w:w="2800" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="F4F8F4"/></w:tcPr><w:p><w:r><w:rPr><w:b/><w:sz w:val="18"/><w:color w:val="0D2B1A"/></w:rPr><w:t>Surface Prep</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="3400" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="F4F8F4"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>Hard Court / Red Clay / Lawn Grass</w:t></w:r></w:p></w:tc>
    <w:tc><w:tcPr><w:tcW w:w="3160" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="F4F8F4"/></w:tcPr><w:p><w:r><w:rPr><w:sz w:val="18"/></w:rPr><w:t>KSh 0 / 35,000 / 80,000 prep fee</w:t></w:r></w:p></w:tc>
  </w:tr>
</w:tbl>
<w:p><w:pPr><w:spacing w:before="0" w:after="120"/></w:pPr></w:p>
"@

$docBody += New-Callout -Title "LIVE ESTIMATOR EXAMPLE: 16-PLAYER FULL DAY" -Content "Formula: 4 Courts x 8 Hours (KSh 96,000) + Pro Coaching Staff (KSh 45,000) + Hydration Lounge (16 x KSh 2,000 = KSh 32,000) = KSh 173,000 Total. Submitted instantly to director approval." -BgColor "0D2B1A" -BorderColor "DFFF00"

$docBody += New-PageBreak

# ==============================================================================
# PAGE 7: MEMBER DASHBOARD & DIGITAL LOCKER ROOM
# ==============================================================================
$docBody += New-H1 -Text "Digital Locker Room & Player Portal"
$docBody += New-P -Text "Personalized Player Ecosystem, Tournament Passes & Real-Time Stats" -Color "1B4D2E" -Size 20 -Bold $true -SpaceAfter 120

$docBody += New-P -Text "Athletes and tournament organizers manage their entire tennis lifecycle through the integrated 'Locker Room' dashboard. From active tournament passes and equipment preferences to custom event proposals, every record is synchronized."

$docBody += New-H2 -Text "Player Profile & Gear Customization"
$docBody += New-Bullet -BoldPrefix "NTRP Division Rating:" -Text "Beginner (1.5–2.5), Intermediate (3.0–4.0), Advanced (4.5–5.0), and Open/Pro (5.5+)."
$docBody += New-Bullet -BoldPrefix "Dominant Hand & Stance:" -Text "Right-handed (Single/Two-handed Backhand) or Southpaw Left-handed."
$docBody += New-Bullet -BoldPrefix "Surface Preference:" -Text "Calibrates court allocations for Hard, Red Clay, or Lawn Grass."
$docBody += New-Bullet -BoldPrefix "Racket Specs & Tension:" -Text "Logs preferred racket frame models (e.g. Wilson Blade 98, Babolat Pure Aero) and string tensions."

$docBody += New-H2 -Text "Tournament Pass & Proposal Vault"
$docBody += New-Bullet -BoldPrefix "Active Digital Passes:" -Text "Unique pass ID generation (e.g. BK-1771239) with QR check-in readiness."
$docBody += New-Bullet -BoldPrefix "Proposal Tracking:" -Text "Real-time status indicators (Under Review, Confirmed, Completed)."
$docBody += New-Bullet -BoldPrefix "Pass Types:" -Text "Single passes, doubles partner allocation, and 4-player team slots."

$docBody += New-H2 -Text "Technical Data Architecture"
$docBody += New-Bullet -BoldPrefix "wildcard_bookings:" -Text "Stores active registrations with eventId, player info, division, and pass count."
$docBody += New-Bullet -BoldPrefix "wildcard_plans:" -Text "Stores tactical event proposals with facilities, hours, budget, and review status."
$docBody += New-Bullet -BoldPrefix "wildcard_tennis_prefs:" -Text "Stores racket model, dominant hand, and favorite surface to prefill future forms."

$docBody += New-PageBreak

# ==============================================================================
# PAGE 8: MEMBERSHIP TIERS & COMMERCIAL MODEL
# ==============================================================================
$docBody += New-H1 -Text "Membership Tiers & Commercial Model"
$docBody += New-P -Text "Structured Access Tiers, Corporate Sponsorships & Revenue Ecosystem" -Color "1B4D2E" -Size 20 -Bold $true -SpaceAfter 120

$docBody += New-P -Text "Wild Card Tennis operates a multi-tiered commercial model providing accessible public tournament registration while delivering high-value subscriptions and luxury corporate retreat packages."

$docBody += New-H2 -Text "Three-Tier Membership Architecture"

$docBody += New-Callout -Title "TIER 01: CLUB ASSOCIATE (KSH 0 / MONTH)" -Content "Public access tier. Public tournament registration, interactive event planning wizard access, standard racket/ball hire, and basic locker room web dashboard." -BgColor "F4F8F4" -BorderColor "1B4D2E"

$docBody += New-Callout -Title "TIER 02: ELITE COMPETITOR (KSH 12,900 / MONTH - FEATURED)" -Content "The most popular tier for league players. 15% off all tournament entries, priority court booking with complimentary floodlights, monthly pro masterclass clinic included, and free racket restringing (2x/month)." -BgColor "F4F8F4" -BorderColor "0D2B1A"

$docBody += New-Callout -Title "TIER 03: VIP GRAND SLAM (KSH 32,500 / MONTH)" -Content "Ultimate luxury executive access. Unlimited court reservations, guaranteed tournament main-draw seed, monthly 1-on-1 private ATP coach session, VIP player lounge access, and official Wild Card branded apparel kit." -BgColor "F4F8F4" -BorderColor "2D6A4F"

$docBody += New-H2 -Text "Corporate Sponsorships & Brand Integration"
$docBody += New-Bullet -BoldPrefix "Corporate Championship Buyouts:" -Text "Full-day executive retreats with 8-court buyout, live ATP umpiring, branded team gear, video highlight reels, and VIP catering."
$docBody += New-Bullet -BoldPrefix "Brand Sponsorship Packages:" -Text "Court-side windbreak banners, digital scoreboard sponsorships, tournament ball branding, and official title rights."

$docBody += New-PageBreak

# ==============================================================================
# PAGE 9: CASE STUDIES & QUALITY ASSURANCE
# ==============================================================================
$docBody += New-H1 -Text "Operational Case Studies & QA Protocols"
$docBody += New-P -Text "Proven Execution Metrics, Standard Operating Procedures & Safety Standards" -Color "1B4D2E" -Size 20 -Bold $true -SpaceAfter 120

$docBody += New-P -Text "Our reputation is built on repeatable operational excellence. Below are two highlighted event case studies demonstrating our capacity to execute high-stakes championships and corporate experiences."

$docBody += New-H2 -Text "Featured Operational Case Studies"

$docBody += New-Callout -Title "CASE STUDY 01: SILICON VALLEY CORPORATE INVITATIONAL" -Content "Client Objective: 32-player executive retreat tournament uniting tech founders and venture capital leaders. Execution: 8-court simultaneous round-robin with live online scoreboards, custom hydration lounge, and on-site sports physiotherapists. Outcome: 100% on-time match starts, zero scheduling disputes, and a 5-year annual rebooking commitment." -BgColor "F4F8F4" -BorderColor "0D2B1A"

$docBody += New-Callout -Title "CASE STUDY 02: EAST AFRICA JUNIOR OPEN CHAMPIONSHIP" -Content "Client Objective: Sanction a 5-day 64-player junior ranking tournament attracting international collegiate scouts. Execution: Dual-surface logistics (Hard & Clay), certified ITF chair umpires, 240fps video recording, and scouting dossier generation. Outcome: 4 junior athletes secured international collegiate tennis scholarship offers." -BgColor "F4F8F4" -BorderColor "1B4D2E"

$docBody += New-H2 -Text "Standard Operating Procedures (SOP) & Safety Checklist"
$docBody += New-Bullet -BoldPrefix "T-48 Hours (Pre-Event):" -Text "Surface laser-leveling, net height calibration (36 inch center, 42 inch posts), floodlight lux verification, and stringing inventory restocking."
$docBody += New-Bullet -BoldPrefix "T-0 (Match Day):" -Text "Chair umpire briefings, player check-in with digital pass scanning, live medical/physio standby, and strict 9-game ball rotation."
$docBody += New-Bullet -BoldPrefix "Post-Match Protocol:" -Text "Court sweeping, score synchronization, digital trophy ceremony, and match video package export within 3 minutes."
$docBody += New-Bullet -BoldPrefix "Medical Compliance:" -Text "Certified sports physiotherapists on-court, AED defibrillators on facility premises, and heat-index hydration protocols exceeding international federation standards."

$docBody += New-PageBreak

# ==============================================================================
# PAGE 10: ROADMAP, TECH STACK & CONTACT DIRECTORY
# ==============================================================================
$docBody += New-H1 -Text "Strategic Roadmap & Executive Directory"
$docBody += New-P -Text "Future Technology Horizons, Platform Architecture & Official Contact Information" -Color "1B4D2E" -Size 20 -Bold $true -SpaceAfter 120

$docBody += New-P -Text "As we advance into 2027 and 2028, Wild Card Tennis is expanding its physical tournament footprint across Africa and the Middle East while pioneering AI biomechanics and IoT smart court integration."

$docBody += New-H2 -Text "Strategic Technology Roadmap (2026 - 2028)"
$docBody += New-Bullet -BoldPrefix "2026 Q4 — Smart Court IoT Integration:" -Text "Deployment of multi-camera automated line-calling and ball speed radar tracking on all championship courts."
$docBody += New-Bullet -BoldPrefix "2027 Q2 — AI Video Biomechanics Mobile App:" -Text "Mobile app allowing players to upload stroke videos and receive instantaneous AI diagnostics on shoulder rotation, racket head speed, and kinetic chain efficiency."
$docBody += New-Bullet -BoldPrefix "2028 Q1 — Pan-African Championship Circuit:" -Text "Expansion of the Wild Card Grand Slam Series into South Africa, Egypt, Mauritius, and the UAE."

$docBody += New-H2 -Text "Platform Technology Stack"
$docBody += New-Bullet -BoldPrefix "Frontend Core:" -Text "Semantic HTML5, CSS3 Custom Properties (Design System Tokens), Modular ES6 JavaScript, zero-bloat native rendering."
$docBody += New-Bullet -BoldPrefix "Security & Persistence:" -Text "Firebase Auth tokenization, structured JSON schema caching, client-side session persistence, and automated PDF export engines."

$docBody += New-H2 -Text "Official Executive Directory & Dispatch"

$docBody += New-Callout -Title "HEADQUARTERS & TOURNAMENT PAVILION" -Content "Wild Card Tennis Operations Centre`nNairobi Club Tennis Pavilion, Upper Hill Road, Nairobi, Kenya`nOpen Monday – Sunday: 06:00 AM – 10:00 PM EAT" -BgColor "0D2B1A" -BorderColor "DFFF00"

$docBody += New-Callout -Title "DIRECTOR INQUIRIES & HOTLINE" -Content "Director Inquiries: rogoij@gmail.com`nDirect Phone / Hotline: +254 722 102 870`nOfficial Web Portal: www.wildcardtennis.com" -BgColor "F4F8F4" -BorderColor "1B4D2E"

$docBody += New-P -Text "© 2026 Wild Card Tennis. All Rights Reserved. Play the Wild Card Way." -Color "0D2B1A" -Size 18 -Bold $true -Align "center" -SpaceBefore 140 -SpaceAfter 40
$docBody += New-P -Text "Document Dossier Release: Version 2026.1 // Verified and Authorized by Tournament Director" -Color "666666" -Size 16 -Italic $true -Align "center" -SpaceBefore 0 -SpaceAfter 0

# 9. Write word/document.xml
$documentXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <w:body>
    $docBody
    <w:sectPr>
      <w:headerReference w:type="default" r:id="rIdHeader1"/>
      <w:footerReference w:type="default" r:id="rIdFooter1"/>
      <w:pgSz w:w="11906" w:h="16838"/>
      <w:pgMar w:top="1134" w:right="1134" w:bottom="1134" w:left="1134" w:header="720" w:footer="720" w:gutter="0"/>
      <w:cols w:space="720"/>
      <w:docGrid w:linePitch="360"/>
    </w:sectPr>
  </w:body>
</w:document>
"@

[System.IO.File]::WriteAllText((Join-Path $wordDir "document.xml"), $documentXml, [System.Text.Encoding]::UTF8)

# 10. Zip package into .docx
$targetDocx = Join-Path $OutputDir $DocxFilename
if (Test-Path $targetDocx) {
    Remove-Item $targetDocx -Force
}

[System.IO.Compression.ZipFile]::CreateFromDirectory($workingDir, $targetDocx)

# Cleanup working directory
Remove-Item $workingDir -Recurse -Force

Write-Output "SUCCESS: Generated $targetDocx ($([Math]::Round((Get-Item $targetDocx).Length / 1KB, 1)) KB)"
