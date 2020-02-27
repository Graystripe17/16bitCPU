entity RegisterFile is
    port(
        rd: in STD_LOGIC_VECTOR(11 downto 8);
        r1: in STD_LOGIC_VECTOR(7 downto 4);
        r2: in STD_LOGIC_VECTOR(3 downto 0);
        RegWrite: in STD_LOGIC;
        input: in STD_LOGIC_VECTOR(15 downto 0);
        toOffset: out STD_LOGIC_VECTOR(15 downto 0);
        toALU: out STD_LOGIC_VECTOR(15 downto 0);
        toMemory: out STD_LOGIC_VECTOR(15 downto 0);
        toOffset: out STD_LOGIC_VECTOR(15 downto 0);
    );

end RegisterFile;
