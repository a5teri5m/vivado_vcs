
# 論理合成の設定
set_property "constrset" "$constrs" $synth
set_property "description" "Vivado Synthesis Defaults" $synth
set_property "flow" "Vivado Synthesis 2014" $synth
set_property "name" "$synth" $synth
set_property "needs_refresh" "0" $synth
set_property "srcset" "$sources" $synth
set_property "strategy" "Vivado Synthesis Defaults" $synth
set_property "incremental_checkpoint" "" $synth
set_property "steps.synth_design.tcl.pre" "" $synth
set_property "steps.synth_design.tcl.post" "" $synth
set_property "steps.synth_design.args.flatten_hierarchy" "rebuilt" $synth
set_property "steps.synth_design.args.gated_clock_conversion" "off" $synth
set_property "steps.synth_design.args.bufg" "12" $synth
set_property "steps.synth_design.args.fanout_limit" "10000" $synth
set_property "steps.synth_design.args.directive" "Default" $synth
set_property "steps.synth_design.args.fsm_extraction" "auto" $synth
set_property "steps.synth_design.args.keep_equivalent_registers" "0" $synth
set_property "steps.synth_design.args.resource_sharing" "auto" $synth
set_property "steps.synth_design.args.control_set_opt_threshold" "4" $synth
set_property "steps.synth_design.args.no_lc" "0" $synth
set_property "steps.synth_design.args.shreg_min_size" "3" $synth
set_property "steps.synth_design.args.max_bram" "-1" $synth
set_property "steps.synth_design.args.max_dsp" "-1" $synth
set_property -name {steps.synth_design.args.more options} -value {} -objects $synth
current_run -synthesis $synth

