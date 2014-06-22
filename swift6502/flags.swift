import Foundation;

class Flags
{
    // Public
    
    init()
    {
        self.FLAG_CARRY = false;
        self.FLAG_ZERO = true;
        self.FLAG_INTERRUPT_DISABLE = true;
        self.FLAG_DECIMAL_MODE = false;
        self.FLAG_BREAK = true;
        self.FLAG_UNUSED = true;
        self.FLAG_OVERFLOW = false;
        self.FLAG_SIGN = false;
        assert(getRegister() == 0x36);
    }
    
    func getRegister() -> UInt8
    {
        return self.REG_STATUS;
    }
    
    func setRegister(value: UInt8)
    {
        self.REG_STATUS = value;
        self.FLAG_UNUSED = true;
    }
    
    var FLAG_CARRY: Bool
    {
        get         { return getFlagAt(0); }
        set (value) { modifyFlagAt(0, withValue: value); }
    }
    
    var FLAG_ZERO: Bool
    {
        get         { return getFlagAt(1); }
        set (value) { modifyFlagAt(1, withValue: value); }
    }
    
    var FLAG_INTERRUPT_DISABLE: Bool
    {
        get         { return getFlagAt(2); }
        set (value) { modifyFlagAt(2, withValue: value); }
    }
    
    var FLAG_DECIMAL_MODE: Bool
    {
        get         { return getFlagAt(3); }
        set (value) { modifyFlagAt(3, withValue: value); }
    }
    
    var FLAG_BREAK: Bool
    {
        get         { return getFlagAt(4); }
        set (value) { modifyFlagAt(4, withValue: value); }
    }
    
    var FLAG_UNUSED: Bool
    {
        get         { return getFlagAt(5); }
        set (value) { modifyFlagAt(5, withValue: value); }
    }
    
    var FLAG_OVERFLOW: Bool
    {
        get         { return getFlagAt(6); }
        set (value) { modifyFlagAt(6, withValue: value); }
    }
    
    var FLAG_SIGN: Bool
    {
        get         { return getFlagAt(7); }
        set (value) { modifyFlagAt(7, withValue: value); }
    }
    
    // Private
    
    var REG_STATUS: UInt8 = 0x0;
    
    func getFlagAt(position: UInt8) -> Bool
    {
        assert(position < 8);
        return ((self.REG_STATUS >> position) & 1) == 1;
    }
    
    func setFlagAt(position: UInt8)
    {
        assert(position < 8);
        self.REG_STATUS |= 1 << position;
    }
    
    func clearFlagAt(position: UInt8)
    {
        assert(position < 8);
        self.REG_STATUS &= ~(1 << position);
    }
    
    func modifyFlagAt(position: UInt8, withValue value: Bool)
    {
        assert(position < 8);
        (value ? self.setFlagAt : self.clearFlagAt)(position);
    }
}

func executeCLC(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    cpu.flags!.FLAG_CARRY = false;
    return (false, 0);
}

func executeCLD(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    cpu.flags!.FLAG_DECIMAL_MODE = false;
    return (false, 0);
}

func executeCLI(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    cpu.flags!.FLAG_INTERRUPT_DISABLE = false;
    return (false, 0);
}

func executeCLV(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    cpu.flags!.FLAG_OVERFLOW = false;
    return (false, 0);
}

func executeSEC(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    cpu.flags!.FLAG_CARRY = true;
    return (false, 0);
}

func executeSED(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    cpu.flags!.FLAG_DECIMAL_MODE = true;
    return (false, 0);
}

func executeSEI(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    cpu.flags!.FLAG_INTERRUPT_DISABLE = true;
    return (false, 0);
}