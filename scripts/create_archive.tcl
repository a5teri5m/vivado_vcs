
# 設定の読込み
source ../config.tcl

# プロジェクトのオープン
open_project $PROJECT_NAME.xpr

# 日時の取得
set date [clock format [clock seconds] -format {%Y%m%d-%H%M%S}]
archive_project ${PROJECT_NAME}_${date}.xpr.zip -force -include_config_settings

puts "INFO: Create $PROJECT_DIR/${PROJECT_NAME}_${date}.xpr.zip"

