
# 設定の読込み
source ../config.tcl

# プロジェクトのオープン
open_project $PROJECT_NAME.xpr

# SDK の起動
launch_sdk -workspace $PROJECT_NAME.sdk -hwspec $PROJECT_NAME.sdk/$TOP_MODULE.hdf

