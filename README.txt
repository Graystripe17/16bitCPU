# 16bitCPU

Custom 16 bit CPU and datapath in VHDL inspired by RISC-V

## Simulation

```bash
# Syntax check
ghdl -s ALU.vhd adder.vhd controlunit.vhd memory.vhd mux.vhd register.vhd signextension.vhd top.vhd instruction.vhd
# Analysis
ghdl -a ALU.vhd adder.vhd controlunit.vhd memory.vhd mux.vhd register.vhd signextension.vhd top.vhd instruction.vhd
# Test bench
ghdl -s top.vhd top_tb.vhd                   
ghdl -a top.vhd top_tb.vhd
ghdl -e t_top
ghdl -r t_top --vcd=top.vcd --stop-time=1us
open top.vcd
```

## Assembly
Hand compile your assembly code in instruction.vhd from 16 basic instructions.

## License
[MIT](https://choosealicense.com/licenses/mit/)
