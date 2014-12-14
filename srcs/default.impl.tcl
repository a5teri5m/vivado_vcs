
# インプリの設定
set_property "constrset" "$constrs" $impl
set_property "description" "Vivado Implementation Defaults" $impl
set_property "flow" "Vivado Implementation 2014" $impl
set_property "name" "$impl" $impl
set_property "needs_refresh" "0" $impl
set_property "srcset" "$sources" $impl
set_property "strategy" "Vivado Implementation Defaults" $impl
set_property "incremental_checkpoint" "" $impl
set_property "steps.opt_design.is_enabled" "1" $impl
set_property "steps.opt_design.tcl.pre" "" $impl
set_property "steps.opt_design.tcl.post" "" $impl
set_property "steps.opt_design.args.verbose" "0" $impl
set_property "steps.opt_design.args.directive" "Default" $impl
set_property -name {steps.opt_design.args.more options} -value {} -objects $impl
set_property "steps.power_opt_design.is_enabled" "0" $impl
set_property "steps.power_opt_design.tcl.pre" "" $impl
set_property "steps.power_opt_design.tcl.post" "" $impl
set_property -name {steps.power_opt_design.args.more options} -value {} -objects $impl
set_property "steps.place_design.tcl.pre" "" $impl
set_property "steps.place_design.tcl.post" "" $impl
set_property "steps.place_design.args.directive" "Default" $impl
set_property -name {steps.place_design.args.more options} -value {} -objects $impl
set_property "steps.post_place_power_opt_design.is_enabled" "0" $impl
set_property "steps.post_place_power_opt_design.tcl.pre" "" $impl
set_property "steps.post_place_power_opt_design.tcl.post" "" $impl
set_property -name {steps.post_place_power_opt_design.args.more options} -value {} -objects $impl
set_property "steps.phys_opt_design.is_enabled" "0" $impl
set_property "steps.phys_opt_design.tcl.pre" "" $impl
set_property "steps.phys_opt_design.tcl.post" "" $impl
set_property "steps.phys_opt_design.args.directive" "Default" $impl
set_property -name {steps.phys_opt_design.args.more options} -value {} -objects $impl
set_property "steps.route_design.tcl.pre" "" $impl
set_property "steps.route_design.tcl.post" "" $impl
set_property "steps.route_design.args.directive" "Default" $impl
set_property -name {steps.route_design.args.more options} -value {} -objects $impl
set_property "steps.post_route_phys_opt_design.is_enabled" "0" $impl
set_property "steps.post_route_phys_opt_design.tcl.pre" "" $impl
set_property "steps.post_route_phys_opt_design.tcl.post" "" $impl
set_property "steps.post_route_phys_opt_design.args.directive" "Default" $impl
set_property -name {steps.post_route_phys_opt_design.args.more options} -value {} -objects $impl
set_property "steps.write_bitstream.tcl.pre" "" $impl
set_property "steps.write_bitstream.tcl.post" "" $impl
set_property "steps.write_bitstream.args.raw_bitfile" "0" $impl
set_property "steps.write_bitstream.args.mask_file" "0" $impl
set_property "steps.write_bitstream.args.no_binary_bitfile" "0" $impl
set_property "steps.write_bitstream.args.bin_file" "0" $impl
set_property "steps.write_bitstream.args.logic_location_file" "0" $impl
set_property -name {steps.write_bitstream.args.more options} -value {} -objects $impl
current_run -implementation $impl


