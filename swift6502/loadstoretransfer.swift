import Foundation;

func executeLDA(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    let (address, crossedPage) = getAddress(cpu, instr.addrMode);
    assert(address != nil)
    cpu.REG_ACC = cpu.memory[Int(address!)];
    
    let shouldIncrementTime = crossedPage && instr.addrMode != AddressingMode.INDIRECT_X;
    return (false, shouldIncrementTime ? 1 : 0);
}

func executeLDX(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    let (address, crossedPage) = getAddress(cpu, instr.addrMode);
    assert(address != nil)
    cpu.REG_X = cpu.memory[Int(address!)];

    return (false, crossedPage ? 1 : 0);
}

func executeLDY(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    let (address, crossedPage) = getAddress(cpu, instr.addrMode);
    assert(address != nil)
    cpu.REG_Y = cpu.memory[Int(address!)];
    
    return (false, crossedPage ? 1 : 0);
}

func executeSTA(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    let (address, crossedPage) = getAddress(cpu, instr.addrMode);
    assert(address != nil);
    cpu.memory[Int(address!)] = cpu.REG_ACC;
    
    return (false, 0);
}

func executeSTX(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    let (address, crossedPage) = getAddress(cpu, instr.addrMode);
    assert(address != nil);
    cpu.memory[Int(address!)] = cpu.REG_X;
    
    return (false, 0);
}

func executeSTY(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    let (address, crossedPage) = getAddress(cpu, instr.addrMode);
    assert(address != nil);
    cpu.memory[Int(address!)] = cpu.REG_Y;
    
    return (false, 0);
}

func executeTAX(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    cpu.REG_X = cpu.REG_ACC;
    return (false, 0);
}

func executeTAY(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    cpu.REG_Y = cpu.REG_ACC;
    return (false, 0);
}

func executeTXA(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    cpu.REG_ACC = cpu.REG_X;
    return (false, 0);
}

func executeTYA(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    cpu.REG_ACC = cpu.REG_Y;
    return (false, 0);
}