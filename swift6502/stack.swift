import Foundation;

func executeTSX(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    cpu.REG_X = cpu.REG_SP;
    return (false, 0);
}

func executeTXS(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    cpu.REG_SP = cpu.REG_X;
    return (false, 0);
}

func executePHA(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    cpu.push(cpu.REG_ACC);
    return (false, 0);
}

func executePHP(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    cpu.flags!.FLAG_BREAK = true;
    cpu.push(cpu.REG_STATUS);
    return (false, 0);
}

func executePLA(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    cpu.REG_ACC = cpu.pop();
    return (false, 0);
}

func executePLP(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    cpu.REG_STATUS = cpu.pop();
    return (false, 0);
}