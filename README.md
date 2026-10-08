# 淵野辺いま・むかし

明治の **迅速測図**（1880年代）を [Maplat](https://www.maplat.jp/) に載せ、青山学院大学 相模原キャンパス周辺の土地の移り変わり（原野 → 軍都 → 学園・研究都市）をたどる Web 地図です。

- 使った新技術: **Maplat**（FOSS4G Hiroshima 2026 の発表 "Bringing Old Maps & Illustrated Maps to the Web: 10 Years of Maplat and Turning Misalignment into Innovation" で紹介）

## できること

- 明治の迅速測図 / 現在の地図（地理院タイル） / 航空写真 の切り替え
- 迅速測図の濃さを変えて、下の現在の地図を透かして比較
- 7 地点（青学相模原キャンパス、淵野辺駅、旧陸軍機甲整備学校 → キャンプ淵野辺、JAXA、市立博物館、淵野辺村、境川）について「明治の地図ではどうだったか」「その後・現在」を表示
- 年表: 1880年代 迅速測図 → 1908 淵野辺駅 → 1942 陸軍機甲整備学校 → 1945 キャンプ淵野辺 → 1974 返還 → 1989 宇宙研移転 → 1995 市立博物館 → 2003 青学相模原キャンパス

## 作り方

| 手順 | ファイル |
|---|---|
| 1. 農研機構 HABS の迅速測図タイル（z16）を 8×8 枚取得して 2048×2048px に結合 | [source/](source/README.md) |
| 2. 結合画像を Maplat 用のピクセルタイル（z0〜3）に分割 | [tools/make_tiles.ps1](tools/make_tiles.ps1) → `tiles/rapid_fuchinobe/` |
| 3. 画像の画素座標と Web メルカトル座標の対応点（GCP）を 5×5 で作成 | [tools/gcps.json](tools/gcps.json) |
| 4. `@maplat/tin` で TIN を作り、Maplat の地図定義を出力 | [tools/compile.html](tools/compile.html) → [maps/rapid_fuchinobe.json](maps/rapid_fuchinobe.json) |
| 5. `@maplat/core` で表示し、地点データを重ねる | [index.html](index.html), [pois/fuchinobe.json](pois/fuchinobe.json) |

ローカルで確認するときは静的サーバーで開きます（Node/Python が無い Windows 環境用に [tools/serve.ps1](tools/serve.ps1) を用意）。

```
powershell -ExecutionPolicy Bypass -File tools/serve.ps1
```

### メモ: 対応点について

HABS の迅速測図は、すでに位置合わせ済み（Web メルカトルに投影済み）のモザイク画像です。そのため今回の対応点は画像の格子点から計算した「ほぼ線形」なもので、Maplat の真骨頂である「歪んだ絵図をそのまま重ねる」効果は控えめです。手描きの村絵図などに差し替えれば、同じ仕組みで非線形な対応付けができます。

👉 **[成果物を開く（クリックで地図が表示されます）](https://furuhashilab.github.io/Hachathon_Oct_RenseiInoue/)**

## 出典・ライセンス

- 本リポジトリのコード・解説文・地点データ: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.ja) Rensei Inoue / 古橋研究室
- 迅速測図の画像・タイル（`source/`, `tiles/`）: 第一軍管地方二万分一迅速測図（原図 国土地理院所蔵）。出典「農研機構農業環境研究部門」[歴史的農業環境閲覧システム](https://habs.rad.naro.go.jp/)、[CC BY 2.1 JP](https://creativecommons.org/licenses/by/2.1/jp/)
- 現在の地図・航空写真: [地理院タイル](https://maps.gsi.go.jp/development/ichiran.html)
- ビューア: [MaplatCore](https://github.com/code4history/MaplatCore) / [MaplatTin](https://github.com/code4history/MaplatTin)（Apache License 2.0）、[OpenLayers](https://openlayers.org/)（BSD-2-Clause）

### 地点の解説の参考資料

- 相模原市立公文書館 企画展資料（陸軍機甲整備学校・キャンプ淵野辺）
- 相模原市「キャンプ淵野辺留保地」整備計画・利用計画
- 宇宙科学研究所 沿革（1989年 相模原へ移転）
- 相模原市立博物館 概要（1995年開館）
- 青山学院大学 相模原キャンパス（2003年開設）

本作品の制作には Claude Code を使用しました。
