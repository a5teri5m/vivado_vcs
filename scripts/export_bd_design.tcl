
# 設定の読込み
source ../config.tcl
source ../scripts/globRecursiveDirs.tcl


# プロジェクトのオープン
open_project $PROJECT_NAME.xpr

# BDファイルの取得 
set BD_FILES [globRecursive $PROJECT_NAME.srcs/sources_1/bd [list *.bd]]

# 出力先の設定
set outdir [lindex $SRCS_DIRS 0]

# Block Designを開いて出力
foreach file $BD_FILES {
    # ブロックデザイン名の取得 (***.bdの***部分)
    set bd [regsub -nocase  {^(.+?)\..*$} "[file tail $file]" {\1}]
    set file [file normalize $file]
    # ブロックデザインのオープン
    open_bd_design $file
    # デザインの変更
    current_bd_design [get_bd_designs $bd]
    # Tcl 書き出し
    write_bd_tcl -force $outdir/$bd.bd.tcl
	close_bd_design [get_bd_designs $bd]
    puts "Create $outdir/$bd.bd.tcl"
}

