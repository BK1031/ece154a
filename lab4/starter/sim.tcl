# Adapted from Edalize
# https://github.com/olofk/edalize/blob/4a3f3e87/edalize/modelsim.py

onerror { quit -code 1; }
vlib work
vlog +define+SIM -quiet -work work ucsbece154a_alu.v
vlog +define+SIM -quiet -work work ucsbece154a_controller.v
vlog +define+SIM -quiet -work work ucsbece154a_datapath.v
vlog +define+SIM -quiet -work work ucsbece154a_dmem.v
vlog +define+SIM -quiet -work work ucsbece154a_imem.v
vlog +define+SIM -quiet -work work ucsbece154a_riscv.v
vlog +define+SIM -quiet -work work ucsbece154a_rf.v
vlog +define+SIM -quiet -work work ucsbece154a_top.v
vlog +define+SIM -sv -quiet -work work ucsbece154a_top_tb.v
