
# 設定の読込み
source ../config.tcl
source ../scripts/globRecursiveDirs.tcl


# プロジェクトのオープン
open_project $PROJECT_NAME.xpr

# XCIファイルの取得
set XCI_FILES [globRecursive $PROJECT_NAME.srcs/sources_1/ip [list *.xci]]

# 出力先の設定
set outdir [lindex $SRCS_DIRS 0]

# IPのコピー
foreach file $XCI_FILES {
    # IP名の取得 (***.xciの***部分)
    set xci [regsub -nocase  {^(.+?)\..*$} "[file tail $file]" {\1}]
    set file [file normalize $file]
    file copy -force $file "$outdir/$xci.xci"
    puts "Create $outdir/$xci.xci"
}

