library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is
    port (
        CLK: in STD_LOGIC;
        instructionWriteEnable: in STD_LOGIC;
        instructionWriteAddr: in STD_LOGIC_VECTOR(15 downto 0);
        instructionWriteData: in STD_LOGIC_VECTOR(15 downto 0);
        startPC: in STD_LOGIC_VECTOR(15 downto 0);
        instructionOut: out STD_LOGIC_VECTOR(15 downto 0);
        inr: in STD_LOGIC_VECTOR(3 downto 0);
        outr: out STD_LOGIC_VECTOR(15 downto 0);
        reset: in STD_LOGIC
    );
end top;

architecture Behavioral of top is
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
            outr1toOffsetMux: out STD_LOGIC_VECTOR(15 downto 0);
            outr2toALU: out STD_LOGIC_VECTOR(15 downto 0);
            rdContent: out STD_LOGIC_VECTOR(15 downto 0);
            toMemoryADDR: out STD_LOGIC_VECTOR(9 downto 0) := "0000000000";
            toMemoryDIN: out STD_LOGIC_VECTOR(15 downto 0);
            PCoutput: out STD_LOGIC_VECTOR(15 downto 0);
            PCinput: in STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
            inr: in STD_LOGIC_VECTOR(3 downto 0);
            outr: out STD_LOGIC_VECTOR(15 downto 0);
            reset: in STD_LOGIC := '1'
         );
    end component;
    component ALU is
        port (
            CLK: in STD_LOGIC;
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
            cJalr: out STD_LOGIC;
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
            CLK: in STD_LOGIC;
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
    signal CLK_t: STD_LOGIC := '0';
    signal reset_t: STD_LOGIC;

    -- Instruction Memory Write
    signal instructionWriteEnable_t: STD_LOGIC;
    signal instructionWriteAddr_t: STD_LOGIC_VECTOR(15 downto 0);
    signal instructionWriteData_t: STD_LOGIC_VECTOR(15 downto 0);

    -- Debug
    signal inr_t: STD_LOGIC_VECTOR(3 downto 0);
    signal outr_t: STD_LOGIC_VECTOR(15 downto 0);

    -- RegisterFile in
    signal instruction_t: STD_LOGIC_VECTOR(15 downto 0);
    signal cRegWrite_t: STD_LOGIC;
    signal cLdi_t : STD_LOGIC;
    signal cJalr_t: STD_LOGIC;
    signal writeInput_t: STD_LOGIC_VECTOR(15 downto 0);
    signal PCinput_t: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    -- RegisterFile out
    signal r1toOffsetMux_t: STD_LOGIC_VECTOR(15 downto 0);
    signal registerToMemoryADDR_t: STD_LOGIC_VECTOR(9 downto 0);
    signal registerToMemoryDIN_t: STD_LOGIC_VECTOR(15 downto 0);
    signal PCoutput_t: STD_LOGIC_VECTOR(15 downto 0);
    signal rdContent_t: STD_LOGIC_VECTOR(15 downto 0);

    -- ALU in
    signal cALUOp_t: STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal A_t: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    signal B_t: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    -- ALU out
    signal isBranch_t: STD_LOGIC := '0';
    signal ALUToMemory_t: STD_LOGIC_VECTOR(9 downto 0) := "0000000000";
    signal ALUToRegMux_t: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    
    -- Memory out
    signal outMemory_t: STD_LOGIC_VECTOR(15 downto 0);

    -- SignExtension out
    signal signExtension_t: STD_LOGIC_VECTOR(15 downto 0);
    
    -- Adder out
    signal branchAdderOutput_t: STD_LOGIC_VECTOR(15 downto 0);
    signal incrementAdderOutput_t: STD_LOGIC_VECTOR(15 downto 0);

    -- ControlUnit out
    signal cOffset_t: STD_LOGIC;
    signal cMemToReg_t: STD_LOGIC;
    signal cMemWrite_t: STD_LOGIC;
    signal cMemRead_t: STD_LOGIC;

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
        outr1toOffsetMux => r1toOffsetMux_t,
        outr2toALU => B_t,
        rdContent => rdContent_t,
        toMemoryDIN => registerToMemoryDIN_t,
        toMemoryADDR => registerToMemoryADDR_t,
        PCoutput => PCoutput_t,
        PCinput => PCinput_t,
        inr => inr_t,
        outr => outr_t,
        reset => reset_t
    );

    arithmetic: ALU
    port map (
        CLK => CLK_t,
        ALUOp => cALUOp_t,
        A => A_t,
        B => B_t,
        isBranch => isBranch_t,
        outToMemory => ALUToMemory_t,
        outToRegMux => ALUToRegMux_t,
        reset => reset_t
    );

    control: ControlUnit
    port map (
        opcode => instruction_t(15 downto 12),
        cRegWrite => cRegWrite_t,
        cOffset => cOffset_t,
        cALUOp => cALUOp_t,
        cMemWrite => cMemWrite_t,
        cMemRead => cMemRead_t,
        cMemToReg => cMemToReg_t,
        cLdi => cLdi_t,
        cJalr => cJalr_t,
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
        B => rdContent_t, -- Used to be signExtension_t, PC incremented
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
        sel => isBranch_t, -- Branch under 2 conditions
        b => PCinput_t
    );

    regMux: Mux2
    port map (
        a1 => ALUToRegMux_t,
        a2 => outMemory_t,
        sel => cMemToReg_t,
        b => writeInput_t
    );

    instruction: InstructionMemory
    port map (
        CLK => CLK_t,
        PC => PCinput_t,
        writeEnable => instructionWriteEnable_t,
        writeData => instructionWriteData_t,
        outInstruction => instruction_t,
        reset => reset_t
    );

    disk: Memory
    port map(
        ADDR => registerToMemoryADDR_t, -- Delete ALUToMemory
        DIN => registerToMemoryDIN_t,
        cMemWrite => cMemWrite_t,
        cMemRead => cMemRead_t,
        outMemory => outMemory_t,
        reset => reset_t
    );

    CLK_t <= CLK;
    reset_t <= reset;
    instructionWriteEnable_t <= instructionWriteEnable;
    instructionWriteAddr_t <= instructionWriteAddr;
    instructionWriteData_t <= instructionWriteData;
    inr_t <= inr;
    outr <= outr_t;
    instructionOut <= instruction_t;

end Behavioral;
