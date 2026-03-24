return {
    -- The default LuaVersion is Lua51
    LuaVersion = "Lua51";
    -- For minifying no VarNamePrefix is applied
    VarNamePrefix = "";
    -- Name Generator for Variables that look like this: IlI1lI1l
    NameGenerator = "MangledShuffled";
    -- No pretty printing
    PrettyPrint = false;
    -- Seed is generated based on current time
    Seed = 0;
    -- Obfuscation steps
    Steps = {
        {
            Name = "ConstantArray";
            Settings = {
                Treshold    = 1;
                StringsOnly = true;
            }
        },
        {
            Name = "WrapInFunction";
            Settings = {

            }
        },
    }
}