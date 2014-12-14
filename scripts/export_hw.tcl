
# 設定の読込み
source ../config.tcl

# プロジェクトのオープン
open_project $PROJECT_NAME.xpr

# ハードウェアのエクスポート
file mkdir $PROJECT_NAME.sdk
file copy -force $PROJECT_NAME.runs/impl_1/$TOP_MODULE.sysdef $PROJECT_NAME.sdk/$TOP_MODULE.hdf

