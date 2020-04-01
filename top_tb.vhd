library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity t_top is
    port (
        CLK: in STD_LOGIC;
        inr: in STD_LOGIC_VECTOR(3 downto 0); -- Debug
        outvalue: out STD_LOGIC_VECTOR(15 downto 0); -- Debug
        reset: in STD_LOGIC
    );
end t_top;

architecture Behavioral of t_top is
    component RegisterFile is
        port (
            CLK: in STD_LOGIC;
            rd: in STD_LOGIC_VECTOR(11 downto 8) := "0000";
            r1: in STD_LOGIC_VECTOR(7 downto 4) := "0000";
            r2: in STD_LOGIC_VECTOR(3 downto 0) := "0000";
            cRegWrite: in STD_LOGIC := '0';
            cLdi: in STD_LOGIC;
            cJalr: in STD_LOGIC;
            writeInput: in STD_LOGIC_VECTOR(15 downto 0);
            inr: in STD_LOGIC_VECTOR(3 downto 0);
            outr1toOffsetMux: out STD_LOGIC_VECTOR(15 downto 0);
            outr2toALU: out STD_LOGIC_VECTOR(15 downto 0);
            toMemory: out STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
            outvalue: out STD_LOGIC_VECTOR(15 downto 0);
            PCoutput: out STD_LOGIC_VECTOR(15 downto 0);
            PCinput: in STD_LOGIC_VECTOR(15 downto 0);
            reset: in STD_LOGIC := '1'
         );
    end component;
    component ALU is
        port (
            ALUOp: in STD_LOGIC_VECTOR(3 downto 0) := "0000";
            A: in STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
            B: in STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
            isBranch: out STD_LOGIC := '0';
            outToMemory: out STD_LOGIC_VECTOR(9 downto 0) := "0000000000";
            outToRegMux: out STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
            reset: in STD_LOGIC := '1'
        );
    end component;
    component ControlUnit is
        port (
            opcode: in STD_LOGIC_VECTOR(15 downto 12);
            cRegWrite: out STD_LOGIC;
            cOffset: out STD_LOGIC;
            cALUOp: out STD_LOGIC_VECTOR(3 downto 0);
            cMemWrite: out STD_LOGIC;
            cMemRead: out STD_LOGIC;
            cMemToReg: out STD_LOGIC;
            cLdi: out STD_LOGIC;
            reset: in STD_LOGIC
        );
    end component;
    component SignExtension is
        port (
            input: in STD_LOGIC_VECTOR(7 downto 0);
            output: out STD_LOGIC_VECTOR(15 downto 0);
            reset: in STD_LOGIC := '0'
        );
    end component;
    component Adder is
        generic (N: natural := 16);
        port (
            A: in STD_LOGIC_VECTOR(N-1 downto 0);
            B: in STD_LOGIC_VECTOR(N-1 downto 0);
            sum: out STD_LOGIC_VECTOR(N-1 downto 0);
            Cout: out STD_LOGIC;
            reset: in STD_LOGIC := '0'
        );
    end component;
    component Mux2 is
        port (
            a1: in STD_LOGIC_VECTOR(15 downto 0);
            a2: in STD_LOGIC_VECTOR(15 downto 0);
            sel: in STD_LOGIC;
            b: out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;
    component InstructionMemory is
        port (
            PC: in STD_LOGIC_VECTOR(15 downto 0);
            writeEnable: in STD_LOGIC;
            writeData: in STD_LOGIC_VECTOR(15 downto 0);
            outInstruction: out STD_LOGIC_VECTOR(15 downto 0);
            reset: in STD_LOGIC := '0'
        );
    end component;
    component Memory is
        port (
            ADDR: in STD_LOGIC_VECTOR(9 downto 0);
            DIN: in STD_LOGIC_VECTOR(15 downto 0);
            cMemWrite: in STD_LOGIC;
            cMemRead: in STD_LOGIC;
            outMemory: out STD_LOGIC_VECTOR(15 downto 0);
            reset: in STD_LOGIC := '0'
        );
    end component;

    -- Global
    constant CLK_period: time := 1000 ns;
    signal CLK_t: STD_LOGIC := '0';
    signal reset_t: STD_LOGIC;
    signal inr_t: STD_LOGIC_VECTOR(3 downto 0);
    signal outvalue_t: STD_LOGIC_VECTOR(15 downto 0);

    -- RegisterFile in
    signal instruction_t: STD_LOGIC_VECTOR(15 downto 0);
    signal cRegWrite_t: STD_LOGIC;
    signal cLdi_t : STD_LOGIC;
    signal cJalr_t: STD_LOGIC;
    signal writeInput_t: STD_LOGIC_VECTOR(15 downto 0);
    signal PCinput_t: STD_LOGIC_VECTOR(15 downto 0);
    -- RegisterFile out
    signal r1toOffsetMux_t: STD_LOGIC_VECTOR(15 downto 0);
    signal r2toALU_t: STD_LOGIC_VECTOR(15 downto 0);
    signal registerToMemory_t: STD_LOGIC_VECTOR(15 downto 0);
    signal PCoutput_t: STD_LOGIC_VECTOR(15 downto 0);

    -- ALU in
    signal cALUOp_t: STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal A_t: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    signal B_t: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    -- ALU out
    signal isBranch_t: STD_LOGIC := '0';
    signal ALUToMemory_t: STD_LOGIC_VECTOR(9 downto 0) := "0000000000";
    signal ALUToRegMux_t: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    
    -- Memory out
    signal memoryOut_t: STD_LOGIC_VECTOR(15 downto 0);

    -- Instruction Memory Write
    signal instructionWriteEnable_t: STD_LOGIC;
    signal instructionWriteData_t: STD_LOGIC_VECTOR(15 downto 0);

    -- SignExtension out
    signal signExtension_t: STD_LOGIC_VECTOR(15 downto 0);
    
    -- Adder out
    signal branchAdderOutput_t: STD_LOGIC_VECTOR(15 downto 0);
    signal incrementAdderOutput_t: STD_LOGIC_VECTOR(15 downto 0);

    -- ControlUnit out
    signal cOffset_t: STD_LOGIC;
    signal cMemToReg_t: STD_LOGIC;

    -- Dummy Cout
    signal carry_t: STD_LOGIC;

    begin
        rf: RegisterFile
        port map (
            CLK => CLK_t,
            rd => instruction_t(11 downto 8),
            r1 => instruction_t(7 downto 4),
            r2 => instruction_t(3 downto 0),
            cRegWrite => cRegWrite_t,
            cLdi => cLdi_t,
            cJalr => cJalr_t,
            writeInput => writeInput_t,
            inr => inr_t,
            outr1toOffsetMux => r1toOffsetMux_t,
            outr2toALU => r2toALU_t,
            toMemory => registerToMemory_t,
            outvalue => memoryOut_t,
            PCoutput => PCoutput_t,
            PCinput => PCinput_t,
            reset => reset_t
        );

        arithmetic: ALU
        port map (
            ALUOp => cALUOp_t,
            A => A_t,
            B => B_t,
            isBranch => isBranch_t,
            outToMemory => ALUToMemory_t,
            outToRegMux => ALUToRegMux_t,
            reset => reset_t
        );

        sign: SignExtension
        port map (
            input => instruction_t(7 downto 0),
            output => signExtension_t,
            reset => reset_t
        );

        incrementAdder: Adder
        generic map (N => 16)
        port map (
            A => "0000000000000001",
            B => PCoutput_t,
            sum => incrementAdderOutput_t,
            Cout => carry_t,
            reset => reset_t
        );

        branchAdder: Adder
        generic map (N => 16)
        port map (
            A => PCoutput_t,
            B => signExtension_t,
            sum => branchAdderOutput_t,
            Cout => carry_t,
            reset => reset_t
        );

        offsetMux: Mux2
        port map (
            a1 => r1toOffsetMux_t,
            a2 => signExtension_t,
            sel => cOffset_t,
            b => A_t
        );

        pcMux: Mux2
        port map (
            a1 => incrementAdderOutput_t,
            a2 => branchAdderOutput_t,
            sel => isBranch_t,
            b => PCinput_t
        );

        instruction: InstructionMemory
        port map (
            PC => PCinput_t,
            writeEnable => instructionWriteEnable_t,
            writeData => instructionWriteData_t,
            outInstruction => instruction_t,
            reset => reset_t
        );

        CLK_t <= not CLK_t after CLK_period / 2;

        main: process
        begin
        
            -- LOAD

            instructionWriteEnable_t <= '1';

            -- First instruction: ld
            -- Opcode rd x6  r1 x7  filler
            -- 0001   0110   0111   0000
            PCinput_t <= "0000000000000001";
            instructionWriteData_t <= "0001011001110000";

            wait for CLK_period;
            assert instruction_t = "0001011001110000";
            assert instruction_t = "XXXXXXXXXXXXXXXX";

            -- ldi x6, 3
            -- Opcode rd x6  constant
            -- 0010   0110   00000011
            PCinput_t <= "0000000000000010";
            instructionWriteData_t <= "0010011000000011";

            wait for CLK_period;

            -- ldi x7, 5
            -- Opcode rd x7  constant
            -- 0010   0111   00000111
            PCinput_t <= "0000000000000011";
            instructionWriteData_t <= "0010011100000111";
            
            wait for CLK_period;

            -- mv x6, x8
            -- Opcode rd x6  r1 x8  filler
            -- 0100   0110   1000   0000
            PCinput_t <= "0000000000000100";
            instructionWriteData_t <= "0100011010000000";

            wait for 1 ms;

            -- EXECUTE
            PCinput_t <= "0000000000000001";
            instructionWriteEnable_t <= '0';
             
            
            report "Test Finished";
        end process main;
        
end Behavioral;
