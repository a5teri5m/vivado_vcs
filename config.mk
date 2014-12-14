
# プロジェクトの設定
# (相対パスで指定する場合はPROJECT_DIRを起点に書く)
PROJECT_NAME	:= test
PROJECT_DIR		:= project
SRCS_DIRS		:= ../srcs ../submodule/test_hdl/hdl 
TOP_MODULE		:= top
PART			:= xc7a35tcpg236-1
#BOARD_PARTS		:= xilinx.com:kintex7:kc705:1.0
PROJECT_CONFIG  := ../srcs/default.project.tcl
SYNTH_CONFIG    := ../srcs/default.synth.tcl
IMPL_CONFIG     := ../srcs/default.impl.tcl
IP_REPO_PATHS	:= ../submodule/test_ip
RUN_JOBS        := 8

# Vivadoの設定
VIVADO_PATH		:= /usr/local/Xilinx/Vivado/2014.2
VIVADO_SETTINGS := $(VIVADO_PATH)/settings64.sh
VIVADO_LICENSE	:= 

