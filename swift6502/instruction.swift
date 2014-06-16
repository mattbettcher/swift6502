import Foundation;

struct Instruction
{
    let operation: Mnemonics;
    let addrMode: AddressingMode;
    let size: UInt8;
    let time: UInt8;
    
    init(operation: Mnemonics, addrMode: AddressingMode, size: UInt8, time: UInt8)
    {
        self.operation = operation;
        self.addrMode = addrMode;
        self.size = size;
        self.time = time;
    }
    
    func execute(cpu: CPU) -> (Bool, UInt8)
    {
        switch self.operation
        {
            case Mnemonics.LDA: return executeLDA(cpu, self);
            case Mnemonics.LDX: return executeLDX(cpu, self);
            case Mnemonics.LDY: return executeLDY(cpu, self);
            case Mnemonics.STA: return executeSTA(cpu, self);
            case Mnemonics.STX: return executeSTX(cpu, self);
            case Mnemonics.STY: return executeSTY(cpu, self);
            case Mnemonics.TAX: return executeTAX(cpu, self);
            case Mnemonics.TAY: return executeTAY(cpu, self);
            case Mnemonics.TXA: return executeTXA(cpu, self);
            case Mnemonics.TYA: return executeTYA(cpu, self);
            case Mnemonics.TSX: return executeTSX(cpu, self);
            case Mnemonics.TXS: return executeTXS(cpu, self);
            case Mnemonics.PHA: return executePHA(cpu, self);
            case Mnemonics.PHP: return executePHP(cpu, self);
            case Mnemonics.PLA: return executePLA(cpu, self);
            case Mnemonics.PLP: return executePLP(cpu, self);
            case Mnemonics.AND: return executeAND(cpu, self);
            case Mnemonics.EOR: return executeEOR(cpu, self);
            case Mnemonics.ORA: return executeORA(cpu, self);
            case Mnemonics.BIT: return executeBIT(cpu, self);
            case Mnemonics.ADC: return executeADC(cpu, self);
            case Mnemonics.SBC: return executeSBC(cpu, self);
            case Mnemonics.CMP: return executeCMP(cpu, self);
            case Mnemonics.CPX: return executeCPX(cpu, self);
            case Mnemonics.CPY: return executeCPY(cpu, self);
            case Mnemonics.INC: return executeINC(cpu, self);
            case Mnemonics.DEC: return executeDEC(cpu, self);
            case Mnemonics.INX: return executeINX(cpu, self);
            case Mnemonics.DEX: return executeDEX(cpu, self);
            case Mnemonics.INY: return executeINY(cpu, self);
            case Mnemonics.DEY: return executeDEY(cpu, self);
            case Mnemonics.CLC: return executeCLC(cpu, self);
            case Mnemonics.CLD: return executeCLD(cpu, self);
            case Mnemonics.CLI: return executeCLI(cpu, self);
            case Mnemonics.CLV: return executeCLV(cpu, self);
            case Mnemonics.SEC: return executeSEC(cpu, self);
            case Mnemonics.SED: return executeSED(cpu, self);
            case Mnemonics.SEI: return executeSEI(cpu, self);
            case Mnemonics.ASL: return executeASL(cpu, self);
            case Mnemonics.LSR: return executeLSR(cpu, self);
            case Mnemonics.ROL: return executeROL(cpu, self);
            case Mnemonics.ROR: return executeROR(cpu, self);
            case Mnemonics.JMP: return executeJMP(cpu, self);
            case Mnemonics.JSR: return executeJSR(cpu, self);
            case Mnemonics.RTS: return executeRTS(cpu, self);
            case Mnemonics.BCC: return executeBCC(cpu, self);
            case Mnemonics.BCS: return executeBCS(cpu, self);
            case Mnemonics.BEQ: return executeBEQ(cpu, self);
            case Mnemonics.BMI: return executeBMI(cpu, self);
            case Mnemonics.BNE: return executeBNE(cpu, self);
            case Mnemonics.BPL: return executeBPL(cpu, self);
            case Mnemonics.BVC: return executeBVC(cpu, self);
            case Mnemonics.BVS: return executeBVS(cpu, self);
            case Mnemonics.RTI: return executeRTI(cpu, self);
            case Mnemonics.BRK: return executeBRK(cpu, self);
            case Mnemonics.NOP: return (false, 0);
            default: assert(false); return (false, 0);
        }
    }
}

let Instructions = Array<Instruction?>(count: Constants.MAX_OPCODE, repeatedValue: nil);

func registerInstruction(operation: Mnemonics, opCode: UInt8, addrMode: AddressingMode, size: UInt8, time: UInt8)
{
    Instructions[Int(opCode)] = Instruction(operation: operation, addrMode: addrMode, size: size, time: time);
}

func registerInstructions()
{
    registerInstruction(Mnemonics.ADC, 0x69, AddressingMode.IMMEDIATE, 2, 2);
    registerInstruction(Mnemonics.ADC, 0x65, AddressingMode.ZERO_PAGE, 2, 3);
    registerInstruction(Mnemonics.ADC, 0x75, AddressingMode.ZERO_PAGE_X, 2, 4);
    registerInstruction(Mnemonics.ADC, 0x6D, AddressingMode.ABSOLUTE, 3, 4);
    registerInstruction(Mnemonics.ADC, 0x7D, AddressingMode.ABSOLUTE_X, 3, 4);
    registerInstruction(Mnemonics.ADC, 0x79, AddressingMode.ABSOLUTE_Y, 3, 4);
    registerInstruction(Mnemonics.ADC, 0x61, AddressingMode.INDIRECT_X, 2, 6);
    registerInstruction(Mnemonics.ADC, 0x71, AddressingMode.INDIRECT_Y, 2, 5);
    registerInstruction(Mnemonics.AND, 0x29, AddressingMode.IMMEDIATE, 2, 2);
    registerInstruction(Mnemonics.AND, 0x25, AddressingMode.ZERO_PAGE, 2, 3);
    registerInstruction(Mnemonics.AND, 0x35, AddressingMode.ZERO_PAGE_X, 2, 4);
    registerInstruction(Mnemonics.AND, 0x2D, AddressingMode.ABSOLUTE, 3, 4);
    registerInstruction(Mnemonics.AND, 0x3D, AddressingMode.ABSOLUTE_X, 3, 4);
    registerInstruction(Mnemonics.AND, 0x39, AddressingMode.ABSOLUTE_Y, 3, 4);
    registerInstruction(Mnemonics.AND, 0x21, AddressingMode.INDIRECT_X, 2, 6);
    registerInstruction(Mnemonics.AND, 0x31, AddressingMode.INDIRECT_Y, 2, 5);
    registerInstruction(Mnemonics.ASL, 0x0A, AddressingMode.ACCUMULATOR, 1, 2);
    registerInstruction(Mnemonics.ASL, 0x06, AddressingMode.ZERO_PAGE, 2, 5);
    registerInstruction(Mnemonics.ASL, 0x16, AddressingMode.ZERO_PAGE_X, 2, 6);
    registerInstruction(Mnemonics.ASL, 0x0E, AddressingMode.ABSOLUTE, 3, 6);
    registerInstruction(Mnemonics.ASL, 0x1E, AddressingMode.ABSOLUTE_X, 3, 7);
    registerInstruction(Mnemonics.BCC, 0x90, AddressingMode.RELATIVE, 2, 2);
    registerInstruction(Mnemonics.BCS, 0xB0, AddressingMode.RELATIVE, 2, 2);
    registerInstruction(Mnemonics.BEQ, 0xF0, AddressingMode.RELATIVE, 2, 2);
    registerInstruction(Mnemonics.BIT, 0x24, AddressingMode.ZERO_PAGE, 2, 3);
    registerInstruction(Mnemonics.BIT, 0x2C, AddressingMode.ABSOLUTE, 3, 4);
    registerInstruction(Mnemonics.BMI, 0x30, AddressingMode.RELATIVE, 2, 2);
    registerInstruction(Mnemonics.BNE, 0xD0, AddressingMode.RELATIVE, 2, 2);
    registerInstruction(Mnemonics.BPL, 0x10, AddressingMode.RELATIVE, 2, 2);
    registerInstruction(Mnemonics.BRK, 0x00, AddressingMode.IMPLICIT, 1, 7);
    registerInstruction(Mnemonics.BVC, 0x50, AddressingMode.RELATIVE, 2, 2);
    registerInstruction(Mnemonics.BVS, 0x70, AddressingMode.RELATIVE, 2, 2);
    registerInstruction(Mnemonics.CLC, 0x18, AddressingMode.IMPLICIT, 1, 2);
    registerInstruction(Mnemonics.CLD, 0xD8, AddressingMode.IMPLICIT, 1, 2);
    registerInstruction(Mnemonics.CLI, 0x58, AddressingMode.IMPLICIT, 1, 2);
    registerInstruction(Mnemonics.CLV, 0xB8, AddressingMode.IMPLICIT, 1, 2);
    registerInstruction(Mnemonics.CMP, 0xC9, AddressingMode.IMMEDIATE, 2, 2);
    registerInstruction(Mnemonics.CMP, 0xC5, AddressingMode.ZERO_PAGE, 2, 3);
    registerInstruction(Mnemonics.CMP, 0xD5, AddressingMode.ZERO_PAGE_X, 2, 4);
    registerInstruction(Mnemonics.CMP, 0xCD, AddressingMode.ABSOLUTE, 3, 4);
    registerInstruction(Mnemonics.CMP, 0xDD, AddressingMode.ABSOLUTE_X, 3, 4);
    registerInstruction(Mnemonics.CMP, 0xD9, AddressingMode.ABSOLUTE_Y, 3, 4);
    registerInstruction(Mnemonics.CMP, 0xC1, AddressingMode.INDIRECT_X, 2, 6);
    registerInstruction(Mnemonics.CMP, 0xD1, AddressingMode.INDIRECT_Y, 2, 5);
    registerInstruction(Mnemonics.CPX, 0xE0, AddressingMode.IMMEDIATE, 2, 2);
    registerInstruction(Mnemonics.CPX, 0xE4, AddressingMode.ZERO_PAGE, 2, 3);
    registerInstruction(Mnemonics.CPX, 0xEC, AddressingMode.ABSOLUTE, 3, 4);
    registerInstruction(Mnemonics.CPY, 0xC0, AddressingMode.IMMEDIATE, 2, 2);
    registerInstruction(Mnemonics.CPY, 0xC4, AddressingMode.ZERO_PAGE, 2, 3);
    registerInstruction(Mnemonics.CPY, 0xCC, AddressingMode.ABSOLUTE, 3, 4);
    registerInstruction(Mnemonics.DEC, 0xC6, AddressingMode.ZERO_PAGE, 2, 5);
    registerInstruction(Mnemonics.DEC, 0xD6, AddressingMode.ZERO_PAGE_X, 2, 6);
    registerInstruction(Mnemonics.DEC, 0xCE, AddressingMode.ABSOLUTE, 3, 6);
    registerInstruction(Mnemonics.DEC, 0xDE, AddressingMode.ABSOLUTE_X, 3, 7);
    registerInstruction(Mnemonics.DEX, 0xCA, AddressingMode.IMPLICIT, 1, 2);
    registerInstruction(Mnemonics.DEY, 0x88, AddressingMode.IMPLICIT, 1, 2);
    registerInstruction(Mnemonics.EOR, 0x49, AddressingMode.IMMEDIATE, 2, 2);
    registerInstruction(Mnemonics.EOR, 0x45, AddressingMode.ZERO_PAGE, 2, 3);
    registerInstruction(Mnemonics.EOR, 0x55, AddressingMode.ZERO_PAGE_X, 2, 4);
    registerInstruction(Mnemonics.EOR, 0x4D, AddressingMode.ABSOLUTE, 3, 4);
    registerInstruction(Mnemonics.EOR, 0x5D, AddressingMode.ABSOLUTE_X, 3, 4);
    registerInstruction(Mnemonics.EOR, 0x59, AddressingMode.ABSOLUTE_Y, 3, 4);
    registerInstruction(Mnemonics.EOR, 0x41, AddressingMode.INDIRECT_X, 2, 6);
    registerInstruction(Mnemonics.EOR, 0x51, AddressingMode.INDIRECT_Y, 2, 5);
    registerInstruction(Mnemonics.INC, 0xE6, AddressingMode.ZERO_PAGE, 2, 5);
    registerInstruction(Mnemonics.INC, 0xF6, AddressingMode.ZERO_PAGE_X, 2, 6);
    registerInstruction(Mnemonics.INC, 0xEE, AddressingMode.ABSOLUTE, 3, 6);
    registerInstruction(Mnemonics.INC, 0xFE, AddressingMode.ABSOLUTE_X, 3, 7);
    registerInstruction(Mnemonics.INX, 0xE8, AddressingMode.IMPLICIT, 1, 2);
    registerInstruction(Mnemonics.INY, 0xC8, AddressingMode.IMPLICIT, 1, 2);
    registerInstruction(Mnemonics.JMP, 0x4C, AddressingMode.ABSOLUTE, 3, 3);
    registerInstruction(Mnemonics.JMP, 0x6C, AddressingMode.INDIRECT, 3, 5);
    registerInstruction(Mnemonics.JSR, 0x20, AddressingMode.ABSOLUTE, 3, 6);
    registerInstruction(Mnemonics.LDA, 0xA9, AddressingMode.IMMEDIATE, 2, 2);
    registerInstruction(Mnemonics.LDA, 0xA5, AddressingMode.ZERO_PAGE, 2, 3);
    registerInstruction(Mnemonics.LDA, 0xB5, AddressingMode.ZERO_PAGE_X, 2, 4);
    registerInstruction(Mnemonics.LDA, 0xAD, AddressingMode.ABSOLUTE, 3, 4);
    registerInstruction(Mnemonics.LDA, 0xBD, AddressingMode.ABSOLUTE_X, 3, 4);
    registerInstruction(Mnemonics.LDA, 0xB9, AddressingMode.ABSOLUTE_Y, 3, 4);
    registerInstruction(Mnemonics.LDA, 0xA1, AddressingMode.INDIRECT_X, 2, 6);
    registerInstruction(Mnemonics.LDA, 0xB1, AddressingMode.INDIRECT_Y, 2, 5);
    registerInstruction(Mnemonics.LDX, 0xA2, AddressingMode.IMMEDIATE, 2, 2);
    registerInstruction(Mnemonics.LDX, 0xA6, AddressingMode.ZERO_PAGE, 2, 3);
    registerInstruction(Mnemonics.LDX, 0xB6, AddressingMode.ZERO_PAGE_Y, 2, 4);
    registerInstruction(Mnemonics.LDX, 0xAE, AddressingMode.ABSOLUTE, 3, 4);
    registerInstruction(Mnemonics.LDX, 0xBE, AddressingMode.ABSOLUTE_Y, 3, 4);
    registerInstruction(Mnemonics.LDY, 0xA0, AddressingMode.IMMEDIATE, 2, 2);
    registerInstruction(Mnemonics.LDY, 0xA4, AddressingMode.ZERO_PAGE, 2, 3);
    registerInstruction(Mnemonics.LDY, 0xB4, AddressingMode.ZERO_PAGE_X, 2, 4);
    registerInstruction(Mnemonics.LDY, 0xAC, AddressingMode.ABSOLUTE, 3, 4);
    registerInstruction(Mnemonics.LDY, 0xBC, AddressingMode.ABSOLUTE_X, 3, 4);
    registerInstruction(Mnemonics.LSR, 0x4A, AddressingMode.ACCUMULATOR, 1, 2);
    registerInstruction(Mnemonics.LSR, 0x46, AddressingMode.ZERO_PAGE, 2, 5);
    registerInstruction(Mnemonics.LSR, 0x56, AddressingMode.ZERO_PAGE_X, 2, 6);
    registerInstruction(Mnemonics.LSR, 0x4E, AddressingMode.ABSOLUTE, 3, 6);
    registerInstruction(Mnemonics.LSR, 0x5E, AddressingMode.ABSOLUTE_X, 3, 7);
    registerInstruction(Mnemonics.NOP, 0xEA, AddressingMode.IMPLICIT, 1, 2);
    registerInstruction(Mnemonics.ORA, 0x09, AddressingMode.IMMEDIATE, 2, 2);
    registerInstruction(Mnemonics.ORA, 0x05, AddressingMode.ZERO_PAGE, 2, 3);
    registerInstruction(Mnemonics.ORA, 0x15, AddressingMode.ZERO_PAGE_X, 2, 4);
    registerInstruction(Mnemonics.ORA, 0x0D, AddressingMode.ABSOLUTE, 3, 4);
    registerInstruction(Mnemonics.ORA, 0x1D, AddressingMode.ABSOLUTE_X, 3, 4);
    registerInstruction(Mnemonics.ORA, 0x19, AddressingMode.ABSOLUTE_Y, 3, 4);
    registerInstruction(Mnemonics.ORA, 0x01, AddressingMode.INDIRECT_X, 2, 6);
    registerInstruction(Mnemonics.ORA, 0x11, AddressingMode.INDIRECT_Y, 2, 5);
    registerInstruction(Mnemonics.PHA, 0x48, AddressingMode.IMPLICIT, 1, 3);
    registerInstruction(Mnemonics.PHP, 0x08, AddressingMode.IMPLICIT, 1, 3);
    registerInstruction(Mnemonics.PLA, 0x68, AddressingMode.IMPLICIT, 1, 4);
    registerInstruction(Mnemonics.PLP, 0x28, AddressingMode.IMPLICIT, 1, 4);
    registerInstruction(Mnemonics.ROL, 0x2A, AddressingMode.ACCUMULATOR, 1, 2);
    registerInstruction(Mnemonics.ROL, 0x26, AddressingMode.ZERO_PAGE, 2, 5);
    registerInstruction(Mnemonics.ROL, 0x36, AddressingMode.ZERO_PAGE_X, 2, 6);
    registerInstruction(Mnemonics.ROL, 0x2E, AddressingMode.ABSOLUTE, 3, 6);
    registerInstruction(Mnemonics.ROL, 0x3E, AddressingMode.ABSOLUTE_X, 3, 7);
    registerInstruction(Mnemonics.ROR, 0x6A, AddressingMode.ACCUMULATOR, 1, 2);
    registerInstruction(Mnemonics.ROR, 0x66, AddressingMode.ZERO_PAGE, 2, 5);
    registerInstruction(Mnemonics.ROR, 0x76, AddressingMode.ZERO_PAGE_X, 2, 6);
    registerInstruction(Mnemonics.ROR, 0x6E, AddressingMode.ABSOLUTE, 3, 6);
    registerInstruction(Mnemonics.ROR, 0x7E, AddressingMode.ABSOLUTE_X, 3, 7);
    registerInstruction(Mnemonics.RTI, 0x40, AddressingMode.IMPLICIT, 1, 6);
    registerInstruction(Mnemonics.RTS, 0x60, AddressingMode.IMPLICIT, 1, 6);
    registerInstruction(Mnemonics.SBC, 0xE9, AddressingMode.IMMEDIATE, 2, 2);
    registerInstruction(Mnemonics.SBC, 0xE5, AddressingMode.ZERO_PAGE, 2, 3);
    registerInstruction(Mnemonics.SBC, 0xF5, AddressingMode.ZERO_PAGE_X, 2, 4);
    registerInstruction(Mnemonics.SBC, 0xED, AddressingMode.ABSOLUTE, 3, 4);
    registerInstruction(Mnemonics.SBC, 0xFD, AddressingMode.ABSOLUTE_X, 3, 4);
    registerInstruction(Mnemonics.SBC, 0xF9, AddressingMode.ABSOLUTE_Y, 3, 4);
    registerInstruction(Mnemonics.SBC, 0xE1, AddressingMode.INDIRECT_X, 2, 6);
    registerInstruction(Mnemonics.SBC, 0xF1, AddressingMode.INDIRECT_Y, 2, 5);
    registerInstruction(Mnemonics.SEC, 0x38, AddressingMode.IMPLICIT, 1, 2);
    registerInstruction(Mnemonics.SED, 0xF8, AddressingMode.IMPLICIT, 1, 2);
    registerInstruction(Mnemonics.SEI, 0x78, AddressingMode.IMPLICIT, 1, 2);
    registerInstruction(Mnemonics.STA, 0x85, AddressingMode.ZERO_PAGE, 2, 3);
    registerInstruction(Mnemonics.STA, 0x95, AddressingMode.ZERO_PAGE_X, 2, 4);
    registerInstruction(Mnemonics.STA, 0x8D, AddressingMode.ABSOLUTE, 3, 4);
    registerInstruction(Mnemonics.STA, 0x9D, AddressingMode.ABSOLUTE_X, 3, 5);
    registerInstruction(Mnemonics.STA, 0x99, AddressingMode.ABSOLUTE_Y, 3, 5);
    registerInstruction(Mnemonics.STA, 0x81, AddressingMode.INDIRECT_X, 2, 6);
    registerInstruction(Mnemonics.STA, 0x91, AddressingMode.INDIRECT_Y, 2, 6);
    registerInstruction(Mnemonics.STX, 0x86, AddressingMode.ZERO_PAGE, 2, 3);
    registerInstruction(Mnemonics.STX, 0x96, AddressingMode.ZERO_PAGE_Y, 2, 4);
    registerInstruction(Mnemonics.STX, 0x8E, AddressingMode.ABSOLUTE, 3, 4);
    registerInstruction(Mnemonics.STY, 0x84, AddressingMode.ZERO_PAGE, 2, 3);
    registerInstruction(Mnemonics.STY, 0x94, AddressingMode.ZERO_PAGE_X, 2, 4);
    registerInstruction(Mnemonics.STY, 0x8C, AddressingMode.ABSOLUTE, 3, 4);
    registerInstruction(Mnemonics.TAX, 0xAA, AddressingMode.IMPLICIT, 1, 2);
    registerInstruction(Mnemonics.TAY, 0xA8, AddressingMode.IMPLICIT, 1, 2);
    registerInstruction(Mnemonics.TSX, 0xBA, AddressingMode.IMPLICIT, 1, 2);
    registerInstruction(Mnemonics.TXA, 0x8A, AddressingMode.IMPLICIT, 1, 2);
    registerInstruction(Mnemonics.TXS, 0x9A, AddressingMode.IMPLICIT, 1, 2);
    registerInstruction(Mnemonics.TYA, 0x98, AddressingMode.IMPLICIT, 1, 2);
}
