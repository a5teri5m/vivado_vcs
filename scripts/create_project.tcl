
# 設定の読込み
source ../config.tcl
source ../scripts/globRecursiveDirs.tcl

# ファイルの取得 (デザイン用)
set SRCS_FILES [globRecursiveDirs $SRCS_DIRS \
    [list *.v *.vlog *.sv *.vh *.vhd *.vhdl *.ngc *.mif *.hex *.prj *.xdc *.xci *.bd.tcl]]
puts "INFO: SRCS_FILES=$SRCS_FILES"
# ファイルの取得 (シミュレーション用)
set SIMS_FILES [globRecursiveDirs $SIMS_DIRS \
    [list *.v *.vlog *.sv *.vh *.vhd *.vhdl *.mif *.hex]]
puts "INFO: SIMS_FILES=$SIMS_FILES"


# プロジェクトの作成
create_project $PROJECT_NAME . -part $PART
set prj_dir [get_property directory [current_project]]
set prj [get_projects $PROJECT_NAME]

# ボードパーツの設定
if {[info exists BOARD_PARTS]} {
	set_property "board_part" $BOARD_PARTS $prj
    puts "INFO: Set $BOARD_PARTS"
}

# プロジェクトの設定
if {[info exists PROJECT_CONFIG] && [file exist $PROJECT_CONFIG]} {
    source $PROJECT_CONFIG
    puts "INFO: Set $PROJECT_CONFIG"
} else {
	
}


# fileset sources_1 の作成
set sources sources_1
if {[string equal [get_filesets -quiet $sources] ""]} {
    create_fileset -srcset $sources
}
set sources [get_filesets $sources]
puts "INFO: fileset sources=$sources"


# fileset constrs_1 の作成
set constrs constrs_1
if {[string equal [get_filesets -quiet $constrs] ""]} {
    create_fileset -constrset $constrs
}
set constrs [get_filesets $constrs]
puts "INFO: fileset constrs=$constrs"


# fileset sim_1 の作成
set sim sim_1
if {[string equal [get_filesets -quiet $sim] ""]} {
  create_fileset -simset $sim
}
set sim [get_filesets $sim]
puts "INFO: fileset sim=$sim"


# run synth_1 の作成
set synth synth_1
if {[string equal [get_runs -quiet $synth] ""]} {
    create_run -name $synth -part $PART \
        -flow {Vivado Synthesis 2014} -strategy "Vivado Synthesis Defaults" \
        -constrset $constrs
} else {
    set_property strategy "Vivado Synthesis Defaults" [get_runs $synth]
    set_property flow "Vivado Synthesis 2014" [get_runs $synth]
}
set synth [get_runs $synth]
puts "INFO: run synth=$synth"
if {[info exists SYNTH_CONFIG] && [file exists $SYNTH_CONFIG]} {
    source $SYNTH_CONFIG    
    puts "INFO: source $SYNTH_CONFIG"
}


# run impl_1 の作成
set impl impl_1
if {[string equal [get_runs -quiet $impl] ""]} {
    create_run -name $impl -part $PART \
        -flow {Vivado Implementation 2014} -strategy "Vivado Implementation Defaults" \
        -constrset $constrs -parent_run $synth
} else {
    set_property strategy "Vivado Implementation Defaults" [get_runs $impl]
    set_property flow "Vivado Implementation 2014" [get_runs $impl]
}
set impl [get_runs $impl]
puts "INFO: run impl=$impl"
if {[info exists IMPL_CONFIG] && [file exists $IMPL_CONFIG]} {
    source $IMPL_CONFIG    
    puts "INFO: source $IMPL_CONFIG"
}


# ユーザのIPレポジトリの追加
set_property "ip_repo_paths" "[file normalize $IP_REPO_PATHS]" $sources
#puts [file normalize $IP_REPO_PATHS]

# sources の設定
set_property "design_mode" "RTL" $sources
set_property "edif_extra_search_paths" "" $sources
set_property "generic" "" $sources
set_property "include_dirs" "" $sources
set_property "lib_map_file" "" $sources
set_property "loop_count" "1000" $sources
set_property "name" "sources_1" $sources
set_property "top" $TOP_MODULE $sources
set_property "verilog_define" "" $sources
set_property "verilog_uppercase" "0" $sources



# ソースファイルの追加 
puts "INFO: Import Design Sources ..."
foreach file $SRCS_FILES {
    # Verilog 
    if {[string match *.v $file]} {
        puts "INFO: Import $file (Verilog)" 
        set file [file normalize $file]
        add_files -norecurse -fileset $sources $file
        set file_obj [get_files -of_objects $sources [list "*$file"]]
        set_property "file_type" "Verilog" $file_obj
        set_property "is_enabled" "1" $file_obj
        set_property "is_global_include" "0" $file_obj
        set_property "library" "xil_defaultlib" $file_obj
        set_property "path_mode" "RelativeFirst" $file_obj
        set_property "used_in" "synthesis implementation simulation" $file_obj
        set_property "used_in_implementation" "1" $file_obj
        set_property "used_in_simulation" "1" $file_obj
        set_property "used_in_synthesis" "1" $file_obj
        
    # Verilog Header
    } elseif {[string match *.vh $file]} {
        puts "INFO: Import $file (Verilog Header)" 
        set file [file normalize $file]
        add_files -norecurse -fileset $sources $file
        set file_obj [get_files -of_objects $sources [list "*$file"]]
        set_property "file_type" "Verilog Header" $file_obj
        set_property "is_enabled" "1" $file_obj
        set_property "is_global_include" "0" $file_obj
        set_property "library" "xil_defaultlib" $file_obj
        set_property "path_mode" "RelativeFirst" $file_obj
        set_property "used_in" "synthesis simulation" $file_obj
        set_property "used_in_simulation" "1" $file_obj
        set_property "used_in_synthesis" "1" $file_obj

    # SystemVerilog
    } elseif {[string match *.sv $file]} {
        puts "INFO: Import $file (SystemVerilog)" 
        set file [file normalize $file]
        add_files -norecurse -fileset $sources $file
        set file_obj [get_files -of_objects $sources [list "*$file"]]
        set_property "file_type" "SystemVerilog" $file_obj
        set_property "is_enabled" "1" $file_obj
        set_property "is_global_include" "0" $file_obj
        set_property "library" "xil_defaultlib" $file_obj
        set_property "path_mode" "RelativeFirst" $file_obj
        set_property "used_in" "synthesis implementation simulation" $file_obj
        set_property "used_in_implementation" "1" $file_obj
        set_property "used_in_simulation" "1" $file_obj
        set_property "used_in_synthesis" "1" $file_obj

    # VHDL
    } elseif {[string match *.vhd $file] || [string match *.vhdl $file]} {
        puts "INFO: Import $file (VHDL)" 
        set file [file normalize $file]
        add_files -norecurse -fileset $sources $file
        set file_obj [get_files -of_objects $sources [list "*$file"]]
        set_property "file_type" "VHDL" $file_obj
        set_property "is_enabled" "1" $file_obj
        set_property "is_global_include" "0" $file_obj
        set_property "library" "xil_defaultlib" $file_obj
        set_property "path_mode" "RelativeFirst" $file_obj
        set_property "used_in" "synthesis simulation" $file_obj
        set_property "used_in_simulation" "1" $file_obj
        set_property "used_in_synthesis" "1" $file_obj

    # XDC
    } elseif {[string match *.xdc $file]} {
        puts "INFO: Import $file (XDC)" 
        set file [file normalize $file]
        add_files -norecurse -fileset $constrs $file
        set file_obj [get_files -of_objects $constrs [list "*$file"]]
        set_property "file_type" "XDC" $file_obj
        set_property "is_enabled" "1" $file_obj
        set_property "is_global_include" "0" $file_obj
        set_property "library" "xil_defaultlib" $file_obj
        set_property "path_mode" "RelativeFirst" $file_obj
        set_property "processing_order" "NORMAL" $file_obj
        set_property "scoped_to_cells" "" $file_obj
        set_property "scoped_to_ref" "" $file_obj
        set_property "used_in" "synthesis implementation" $file_obj
        set_property "used_in_implementation" "1" $file_obj
        set_property "used_in_synthesis" "1" $file_obj
    
    # Memory Initialization Files
    } elseif {[string match *.mif $file]} {
        puts "INFO: Import $file (Memory Initialization Files)" 
        set file [file normalize $file]
        add_files -norecurse -fileset $sources $file
        set file_obj [get_files -of_objects $sources [list "*$file"]]
        set_property "file_type" "Memory Initialization Files" $file_obj
        set_property "is_enabled" "1" $file_obj
        set_property "is_global_include" "0" $file_obj
        set_property "library" "xil_defaultlib" $file_obj
        set_property "path_mode" "RelativeFirst" $file_obj
        set_property "used_in" "synthesis simulation" $file_obj
        set_property "used_in_simulation" "1" $file_obj
        set_property "used_in_synthesis" "1" $file_obj    
    
    # Hex Files
    } elseif {[string match *.hex $file]} {
        puts "INFO: Import $file (HEX File)" 
        set file [file normalize $file]
        add_files -norecurse -fileset $sources $file
        set file_obj [get_files -of_objects $sources [list "*$file"]]
        set_property "file_type" "Memory Initialization Files" $file_obj
        set_property "is_enabled" "1" $file_obj
        set_property "is_global_include" "0" $file_obj
        set_property "library" "xil_defaultlib" $file_obj
        set_property "path_mode" "RelativeFirst" $file_obj
        set_property "used_in" "synthesis simulation" $file_obj
        set_property "used_in_simulation" "1" $file_obj
        set_property "used_in_synthesis" "1" $file_obj    

    # NGC
    } elseif {[string match *.ngc $file]} {
        puts "INFO: Import $file (NGC)" 
        set file [file normalize $file]
        add_files -norecurse -fileset $sources $file
        set file_obj [get_files -of_objects $sources [list "*$file"]]
        set_property "file_type" "NGC" $file_obj
        set_property "is_enabled" "1" $file_obj
        set_property "is_global_include" "0" $file_obj
        set_property "library" "xil_defaultlib" $file_obj
        set_property "path_mode" "RelativeFirst" $file_obj
        set_property "used_in" "synthesis implementation" $file_obj
        set_property "used_in_implementation" "1" $file_obj
        set_property "used_in_synthesis" "1" $file_obj
    
    # XCI
    } elseif {[string match *.xci $file]} {
        puts "INFO: Import $file (XCI)" 
        set xci [regsub {^(.+?)\..*$} "[file tail $file]" {\1}]
        set file [file normalize $file]
        add_files -norecurse -copy_to "$prj_dir/$PROJECT_NAME.srcs/$sources/ip" -fileset $sources $file
        set file "$xci/$xci.xci"
        set file_obj [get_files -of_objects $sources [list "*$file"]]
        set_property "generate_synth_checkpoint" "1" $file_obj
        set_property "is_enabled" "1" $file_obj
        set_property "is_global_include" "0" $file_obj
        set_property "library" "xil_defaultlib" $file_obj
        set_property "path_mode" "RelativeFirst" $file_obj
        set_property "used_in" "synthesis implementation simulation" $file_obj
        set_property "used_in_implementation" "1" $file_obj
        set_property "used_in_simulation" "1" $file_obj
        set_property "used_in_synthesis" "1" $file_obj

    # Block Design
    } elseif {[string match *.bd.tcl $file]} {
        # ブロックデザイン名の取得 (***.bd.tclの***部分)
        set bd [regsub {^(.+?)\..*$} "[file tail $file]" {\1}]
        # Block Designの読込み
        source $file
        set bd_design [get_bd_designs $bd]
        current_bd_design $bd_design
        # ラッパーの作成
        make_wrapper -files [get_files "$prj_dir/$PROJECT_NAME.srcs/$sources/bd/$bd/$bd.bd"] -top
        # ラッパーの追加
        puts "INFO: Import $prj_dir/$PROJECT_NAME.srcs/$sources/bd/$bd/hdl/${bd}_wrapper.v (Verilog)"
        add_files -norecurse "$prj_dir/$PROJECT_NAME.srcs/$sources/bd/$bd/hdl/${bd}_wrapper.v"
        set file "$prj_dir/$PROJECT_NAME.srcs/$sources/bd/$bd/hdl/${bd}_wrapper.v"
        set file [file normalize $file]
        set file_obj [get_files -of_objects $sources [list "*$file"]]
        set_property "file_type" "Verilog" $file_obj
        set_property "is_enabled" "1" $file_obj
        set_property "is_global_include" "0" $file_obj
        set_property "library" "xil_defaultlib" $file_obj
        set_property "path_mode" "RelativeFirst" $file_obj
        set_property "used_in" "synthesis implementation simulation" $file_obj
        set_property "used_in_implementation" "1" $file_obj
        set_property "used_in_simulation" "1" $file_obj
        set_property "used_in_synthesis" "1" $file_obj
        # デザインを閉じる
        close_bd_design $bd_design
    } else {
        puts "INFO: Unsupported File $file"    
    }
}



# シミュレーションファイルの追加 
puts "INFO: Import Simulation Sources ..."
foreach file $SIMS_FILES {
    # Verilog 
    if {[string match *.v $file]} {
        puts "INFO: Import $file (Verilog)" 
        set file [file normalize $file]
        add_files -norecurse -fileset $sim $file
        set file_obj [get_files -of_objects $sources [list "*$file"]]
        set_property "file_type" "Verilog" $file_obj
        set_property "is_enabled" "1" $file_obj
        set_property "is_global_include" "0" $file_obj
        set_property "library" "xil_defaultlib" $file_obj
        set_property "path_mode" "RelativeFirst" $file_obj
        set_property "used_in" "synthesis simulation" $file_obj
        set_property "used_in_simulation" "1" $file_obj
        set_property "used_in_synthesis" "1" $file_obj

    } else {
        puts "INFO: Unsupported File $file"    
    }
}


puts "INFO: Project Created: $PROJECT_NAME"

# 合成スクリプトリストの作成
set synthScrID [open $prj_dir/synth.lst w]

# XCIファイルの取得
set XCI_FILES [globRecursive $PROJECT_NAME.srcs/sources_1/ip [list *.xci]]

# XCIの論理合成スクリプト作成
foreach file $XCI_FILES {
    set xci [regsub -nocase  {^(.+?)\..*$} "[file tail $file]" {\1}]
    set file [file normalize $file]
    generate_target all [get_files  $file]
    # out-of-context module runs
    create_ip_run [get_ips $xci]
    launch_runs -scripts_only -jobs $RUN_JOBS -verbose [get_runs "${xci}_synth_1"]
    puts "INFO: Generate synthesis scripts $prj_dir/$PROJECT_NAME.runs/${xci}_synth_1/rumme.sh"
    puts $synthScrID "$PROJECT_NAME.runs/${xci}_synth_1"

}

# 全体論理合成スクリプトの作成
launch_runs -scripts_only -jobs $RUN_JOBS -verbose $synth
puts "INFO: Generate synthesis scripts $prj_dir/$PROJECT_NAME.runs/synth_1/rumme.sh"
puts $synthScrID "$PROJECT_NAME.runs/synth_1"

close $synthScrID
puts "INFO: Generate synthesis scripts list $prj_dir/synth.lst"

# インプリ スクリプト リストの作成
set implScrID [open $prj_dir/impl.lst w]

# インプリ実行・ビットストリームの生成スクリプトの作成
launch_runs -scripts_only -verbose -jobs $RUN_JOBS -to_step write_bitstream $impl
puts "INFO: Generate implementation scripts $prj_dir/$PROJECT_NAME.runs/impl_1/rumme.sh"
puts $implScrID "$PROJECT_NAME.runs/impl_1"

close $implScrID
puts "INFO: Generate implementation scripts list $prj_dir/impl.lst"


