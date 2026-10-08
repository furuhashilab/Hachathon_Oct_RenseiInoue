# 結合済みの古地図画像から Maplat 用のピクセルタイル (tiles/{mapID}/{z}/{x}/{y}.png) を作る
# 使い方: powershell -File tools/make_tiles.ps1 -Image source/rapid_fuchinobe_z16.png -OutDir tiles/rapid_fuchinobe
param([string]$Image, [string]$OutDir)
Add-Type -AssemblyName System.Drawing
$tileSize = 256
$src = [System.Drawing.Image]::FromFile((Resolve-Path $Image))
$w = $src.Width; $h = $src.Height
# Maplat の HistMap と同じ計算: maxZoom = ceil(log2(max(w,h) / 256))
$maxZoom = [math]::Ceiling([math]::Max([math]::Log($w / $tileSize, 2), [math]::Log($h / $tileSize, 2)))
for ($z = 0; $z -le $maxZoom; $z++) {
  $span = $tileSize * [math]::Pow(2, $maxZoom - $z)  # このズームで 1 タイルが覆う元画像のピクセル数
  $nx = [math]::Ceiling($w / $span); $ny = [math]::Ceiling($h / $span)
  for ($x = 0; $x -lt $nx; $x++) {
    $dir = Join-Path $OutDir "$z/$x"
    New-Item -ItemType Directory -Force $dir | Out-Null
    for ($y = 0; $y -lt $ny; $y++) {
      $bmp = New-Object System.Drawing.Bitmap -ArgumentList $tileSize, $tileSize
      $g = [System.Drawing.Graphics]::FromImage($bmp)
      $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
      $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
      $g.Clear([System.Drawing.Color]::Transparent)
      $sw = [math]::Min($span, $w - $x * $span); $sh = [math]::Min($span, $h - $y * $span)
      $dst = New-Object System.Drawing.Rectangle -ArgumentList 0, 0, ([int]($sw * $tileSize / $span)), ([int]($sh * $tileSize / $span))
      $g.DrawImage($src, $dst, [int]($x * $span), [int]($y * $span), [int]$sw, [int]$sh, [System.Drawing.GraphicsUnit]::Pixel)
      $bmp.Save((Join-Path $dir "$y.png"), [System.Drawing.Imaging.ImageFormat]::Png)
      $g.Dispose(); $bmp.Dispose()
    }
  }
}
$src.Dispose()
"width=$w height=$h maxZoom=$maxZoom"
