import Foundation;

struct Constants
{
    static let MEMORY_SIZE = 0x10000;
    static let MAX_OPCODE = 0x100;
}

enum Mnemonics: UInt8
{
    case ADC; case AND; case ASL; case BCC; case BCS; case BEQ; case BIT; case BMI;
    case BNE; case BPL; case BRK; case BVC; case BVS; case CLC; case CLD; case CLI;
    case CLV; case CMP; case CPX; case CPY; case DEC; case DEX; case DEY; case EOR;
    case INC; case INX; case INY; case JMP; case JSR; case LDA; case LDX; case LDY;
    case LSR; case NOP; case ORA; case PHA; case PHP; case PLA; case PLP; case ROL;
    case ROR; case RTI; case RTS; case SBC; case SEC; case SED; case SEI; case STA;
    case STX; case STY; case TAX; case TAY; case TSX; case TXA; case TXS; case TYA;
}

enum AddressingMode: UInt8
{
    case RELATIVE;
    case IMPLICIT;
    case ACCUMULATOR;
    case IMMEDIATE;
    case ZERO_PAGE;
    case ZERO_PAGE_X;
    case ZERO_PAGE_Y;
    case ABSOLUTE;
    case ABSOLUTE_X;
    case ABSOLUTE_Y;
    case INDIRECT;
    case INDIRECT_X;
    case INDIRECT_Y;
}