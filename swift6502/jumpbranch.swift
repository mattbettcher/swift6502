import Foundation;

func executeJMP(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    let (address, crossedPage) = getAddress(cpu, instr.addrMode);
    assert(address != nil);
    
    cpu.REG_PC = address!;
    return (true, 0);
}

func executeJSR(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    let pushedAddress = cpu.REG_PC &+ 2;
    
    cpu.push(UInt8(pushedAddress >> 8));
    cpu.push(UInt8(pushedAddress & 0xff));
    
    let (address, crossedPage) = getAddress(cpu, instr.addrMode);
    assert(address != nil);
    
    cpu.REG_PC = address!;
    
    return (true, 0);
}

func executeRTS(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    cpu.REG_PC = UInt16(cpu.pop());
    cpu.REG_PC = cpu.REG_PC + UInt16(cpu.pop()) << 8;
    cpu.REG_PC = cpu.REG_PC &+ 1;
    
    return (true, 0);
}

func executeBranch(condition: Bool, cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    if condition
    {
        let (address, crossedPage) = getAddress(cpu, instr.addrMode);
        assert(address != nil);
        cpu.REG_PC = address!
        
        if crossedPage
        {
            return (true, 2);
        }
        else
        {
            return (true, 1);
        }
    }
    else
    {
        return (false, 0);
    }
}

func executeBCC(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    return executeBranch(!cpu.flags!.FLAG_CARRY, cpu, instr);
}

func executeBCS(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    return executeBranch(cpu.flags!.FLAG_CARRY, cpu, instr);
}

func executeBEQ(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    return executeBranch(cpu.flags!.FLAG_ZERO, cpu, instr);
}

func executeBNE(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    return executeBranch(!cpu.flags!.FLAG_ZERO, cpu, instr);
}

func executeBMI(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    return executeBranch(cpu.flags!.FLAG_SIGN, cpu, instr);
}

func executeBPL(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    return executeBranch(!cpu.flags!.FLAG_SIGN, cpu, instr);
}

func executeBVC(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    return executeBranch(!cpu.flags!.FLAG_OVERFLOW, cpu, instr);
}

func executeBVS(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    return executeBranch(cpu.flags!.FLAG_OVERFLOW, cpu, instr);
}