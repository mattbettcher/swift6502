import Foundation;

func executeAND(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    let (address, crossedPage) = getAddress(cpu, instr.addrMode);
    assert(address != nil);
    cpu.REG_ACC = cpu.REG_ACC & cpu.memory[Int(address!)];

    let shouldIncrementTime = crossedPage && instr.addrMode != AddressingMode.INDIRECT_X;
    return (false, shouldIncrementTime ? 1 : 0);
}

func executeEOR(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    let (address, crossedPage) = getAddress(cpu, instr.addrMode);
    assert(address != nil);
    cpu.REG_ACC = cpu.REG_ACC ^ cpu.memory[Int(address!)];
    
    let shouldIncrementTime = crossedPage && instr.addrMode != AddressingMode.INDIRECT_X;
    return (false, shouldIncrementTime ? 1 : 0);
}

func executeORA(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    let (address, crossedPage) = getAddress(cpu, instr.addrMode);
    assert(address != nil);
    cpu.REG_ACC = cpu.REG_ACC | cpu.memory[Int(address!)];
    
    let shouldIncrementTime = crossedPage && instr.addrMode != AddressingMode.INDIRECT_X;
    return (false, shouldIncrementTime ? 1 : 0);
}

func executeBIT(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    let (address, crossedPage) = getAddress(cpu, instr.addrMode);
    assert(address != nil);
    
    let memoryValue = cpu.memory[Int(address!)];
    cpu.flags!.FLAG_ZERO = (cpu.REG_ACC & memoryValue) == 0;
    cpu.flags!.FLAG_SIGN = ((memoryValue >> 7) & 1) == 1;
    cpu.flags!.FLAG_OVERFLOW = ((memoryValue >> 6) & 1) == 1;
    
    return (false, 0);
}

func executeADC(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    assert(!cpu.flags!.FLAG_DECIMAL_MODE); // Decimal mode not supported yet
    
    let (address, crossedPage) = getAddress(cpu, instr.addrMode);
    assert(address != nil);

    let memoryValue = cpu.memory[Int(address!)];
    var newValue: UInt = UInt(cpu.REG_ACC) + UInt(memoryValue) + UInt(cpu.flags!.FLAG_CARRY ? 1 : 0);
    
    cpu.flags!.FLAG_OVERFLOW = (((UInt(cpu.REG_ACC) ^ newValue) & 0x80) != 0) &&
                               (((UInt(cpu.REG_ACC) ^ UInt(memoryValue)) & 0x80) == 0);

    if newValue > 0xff
    {
        cpu.flags!.FLAG_CARRY = true;
        newValue = newValue & 0xff;
    }
    else
    {
        cpu.flags!.FLAG_CARRY = false;
    }
    
    cpu.REG_ACC = UInt8(newValue);
    
    let shouldIncrementTime = crossedPage && instr.addrMode != AddressingMode.INDIRECT_X;
    return (false, shouldIncrementTime ? 1 : 0);
}

func executeSBC(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    assert(!cpu.flags!.FLAG_DECIMAL_MODE); // Decimal mode not supported yet
    
    let (address, crossedPage) = getAddress(cpu, instr.addrMode);
    assert(address != nil);
    
    let memoryValue = cpu.memory[Int(address!)];
    var newValue: Int = Int(cpu.REG_ACC) - Int(memoryValue) - Int(cpu.flags!.FLAG_CARRY ? 0 : 1);
    
    cpu.flags!.FLAG_CARRY = newValue >= 0;
    cpu.flags!.FLAG_OVERFLOW = (((Int(cpu.REG_ACC) ^ newValue) & 0x80) != 0) &&
                               (((Int(cpu.REG_ACC) ^ Int(memoryValue)) & 0x80) != 0);
    
    if newValue < 0
    {
        newValue = newValue + 0x100;
    }

    assert(newValue >= 0);
    cpu.REG_ACC = UInt8(newValue);
    
    let shouldIncrementTime = crossedPage && instr.addrMode != AddressingMode.INDIRECT_X;
    return (false, shouldIncrementTime ? 1 : 0);
}

func executeComparison(cpu: CPU, instr: Instruction, otherValue: UInt8) -> (Bool, UInt8)
{
    let (address, crossedPage) = getAddress(cpu, instr.addrMode);
    assert(address != nil);
    
    let memoryValue = cpu.memory[Int(address!)];
    cpu.flags!.FLAG_ZERO = memoryValue == otherValue;
    cpu.flags!.FLAG_CARRY = memoryValue <= otherValue;
    cpu.flags!.FLAG_SIGN = (((Int(otherValue) - Int(memoryValue)) >> 7) & 1) == 1;
    
    let shouldIncrementTime = crossedPage && instr.addrMode != AddressingMode.INDIRECT_X;
    return (false, shouldIncrementTime ? 1 : 0);
}

func executeCMP(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    return executeComparison(cpu, instr, cpu.REG_ACC);
}

func executeCPX(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    return executeComparison(cpu, instr, cpu.REG_X);
}

func executeCPY(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    return executeComparison(cpu, instr, cpu.REG_Y);
}

func executeINC(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    let (address, crossedPage) = getAddress(cpu, instr.addrMode);
    assert(address != nil);
    
    let newValue: UInt8 = cpu.memory[Int(address!)] &+ 1;
    cpu.flags!.FLAG_ZERO = newValue == 0;
    cpu.flags!.FLAG_SIGN = ((newValue >> 7) & 1) == 1;
    cpu.memory[Int(address!)] = newValue;
    
    return (false, 0);
}

func executeDEC(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    let (address, crossedPage) = getAddress(cpu, instr.addrMode);
    assert(address != nil);
    
    let newValue: UInt8 = cpu.memory[Int(address!)] &- 1;
    cpu.flags!.FLAG_ZERO = newValue == 0;
    cpu.flags!.FLAG_SIGN = ((newValue >> 7) & 1) == 1;
    cpu.memory[Int(address!)] = newValue;
    
    return (false, 0);
}

func executeINX(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    cpu.REG_X = cpu.REG_X &+ 1;
    return (false, 0);
}

func executeDEX(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    cpu.REG_X = cpu.REG_X &- 1;
    return (false, 0);
}

func executeINY(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    cpu.REG_Y = cpu.REG_Y &+ 1;
    return (false, 0);
}

func executeDEY(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    cpu.REG_Y = cpu.REG_Y &- 1;
    return (false, 0);
}

func executeASL(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    if instr.addrMode == AddressingMode.ACCUMULATOR
    {
        cpu.flags!.FLAG_CARRY = ((cpu.REG_ACC >> 7) & 1) == 1;
        cpu.REG_ACC = (cpu.REG_ACC << 1) & 0xff;
        cpu.flags!.FLAG_SIGN = ((cpu.REG_ACC >> 7) & 1) == 1;
        cpu.flags!.FLAG_ZERO = cpu.REG_ACC == 0;
    }
    else
    {
        let (address, crossedPage) = getAddress(cpu, instr.addrMode);
        assert(address != nil);
        
        var memoryValue = cpu.memory[Int(address!)];
        cpu.flags!.FLAG_CARRY = ((memoryValue >> 7) & 1) == 1;
        memoryValue = (memoryValue << 1) & 0xff;
        cpu.flags!.FLAG_SIGN = ((memoryValue >> 7) & 1) == 1;
        cpu.flags!.FLAG_ZERO = memoryValue == 0;
        cpu.memory[Int(address!)] = memoryValue;
    }
    
    return (false, 0);
}

func executeLSR(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    if instr.addrMode == AddressingMode.ACCUMULATOR
    {
        cpu.flags!.FLAG_CARRY = (cpu.REG_ACC & 1) == 1;
        cpu.REG_ACC = cpu.REG_ACC >> 1; // This also sets the ZERO flag
    }
    else
    {
        let (address, crossedPage) = getAddress(cpu, instr.addrMode);
        assert(address != nil);
        
        var memoryValue = cpu.memory[Int(address!)];
        cpu.flags!.FLAG_CARRY = (memoryValue & 1) == 1;
        cpu.memory[Int(address!)] = memoryValue >> 1;
        cpu.flags!.FLAG_ZERO = cpu.memory[Int(address!)] == 0;
    }
    
    cpu.flags!.FLAG_SIGN = false;
    
    return (false, 0);
}

func executeROL(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    var temp: UInt8 = 0;
    let add: UInt8 = cpu.flags!.FLAG_CARRY ? 1 : 0;
    
    if instr.addrMode == AddressingMode.ACCUMULATOR
    {
        temp = cpu.REG_ACC;
        cpu.flags!.FLAG_CARRY = ((temp >> 7) & 1) == 1;
        temp = (temp << 1) &+ add;
        cpu.REG_ACC = temp;
    }
    else
    {
        let (address, crossedPage) = getAddress(cpu, instr.addrMode);
        assert(address != nil);
        
        temp = cpu.memory[Int(address!)];
        cpu.flags!.FLAG_CARRY = ((temp >> 7) & 1) == 1;
        temp = (temp << 1) &+ add;
        cpu.memory[Int(address!)] = temp;
    }
    
    cpu.flags!.FLAG_SIGN = ((temp >> 7) & 1) == 1;
    cpu.flags!.FLAG_ZERO = temp == 0;

    return (false, 0);
}

func executeROR(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    var temp: UInt8 = 0;
    let add: UInt8 = cpu.flags!.FLAG_CARRY ? 0x80 : 0;
    
    if instr.addrMode == AddressingMode.ACCUMULATOR
    {
        cpu.flags!.FLAG_CARRY = cpu.REG_ACC & 1 == 1;
        temp = (cpu.REG_ACC >> 1) &+ add;
        cpu.REG_ACC = temp;
    }
    else
    {
        let (address, crossedPage) = getAddress(cpu, instr.addrMode);
        assert(address != nil);
        
        temp = cpu.memory[Int(address!)];
        cpu.flags!.FLAG_CARRY = temp & 1 == 1;
        temp = (temp >> 1) &+ add;
        cpu.memory[Int(address!)] = temp;
    }

    cpu.flags!.FLAG_SIGN = ((temp >> 7) & 1) == 1;
    cpu.flags!.FLAG_ZERO = temp == 0;

    return (false, 0);
}