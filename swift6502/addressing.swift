import Foundation;

func loadNextByteAsTwoBytes(cpu: CPU, address: UInt16) -> UInt16
{
    return UInt16(cpu.memory[(Int(address) + Int(1)) & 0xffff]);
}

func loadTwoBytes(cpu: CPU, address: UInt16) -> UInt16
{
    return UInt16(cpu.memory[Int(address)]) + loadNextByteAsTwoBytes(cpu, address) * UInt16(0x100);
}

func loadNextTwoBytes(cpu: CPU, address: UInt16) -> UInt16
{
    return loadNextByteAsTwoBytes(cpu, address) + loadNextByteAsTwoBytes(cpu, address &+ 1) * UInt16(0x100);
}

func checkCrossedPage(address1: UInt16, address2: UInt16) -> Bool
{
    return (address1 & 0xff00) != (address2 & 0xff00);
}

func getAddress(cpu: CPU, addrMode: AddressingMode) -> (UInt16?, Bool)
{
    var address: UInt16? = nil;
    var crossedPage: Bool = false;
    
    switch addrMode
    {
        case AddressingMode.IMPLICIT:
            address = nil;
        
        case AddressingMode.ACCUMULATOR:
            address = UInt16(cpu.REG_ACC);
        
        case AddressingMode.IMMEDIATE:
            address = cpu.REG_PC &+ 1;
        
        case AddressingMode.ZERO_PAGE:
            address = loadNextByteAsTwoBytes(cpu, cpu.REG_PC);
        
        case AddressingMode.ZERO_PAGE_X:
            address = (UInt16(cpu.REG_X) + loadNextByteAsTwoBytes(cpu, cpu.REG_PC)) & 0xff;
        
        case AddressingMode.ZERO_PAGE_Y:
            address = (UInt16(cpu.REG_Y) + loadNextByteAsTwoBytes(cpu, cpu.REG_PC)) & 0xff;
        
        case AddressingMode.RELATIVE:
            address = loadNextByteAsTwoBytes(cpu, cpu.REG_PC);
            cpu.REG_PC = cpu.REG_PC &+ 2;
            if address < 0x80 // Interpret as positive
            {
                address = address! &+ cpu.REG_PC;
            }
            else // Interpret as negative
            {
                let negative = UInt16(0x100) - UInt16(address!);
                address = cpu.REG_PC &- negative;
            }

            crossedPage = checkCrossedPage(cpu.REG_PC, address!);
    
        case AddressingMode.ABSOLUTE:
            address = loadNextTwoBytes(cpu, cpu.REG_PC);
        
        case AddressingMode.ABSOLUTE_X:
            let initialAddr = loadNextTwoBytes(cpu, cpu.REG_PC);
            address = initialAddr &+ UInt16(cpu.REG_X);
            crossedPage = checkCrossedPage(initialAddr, address!);
        
        case AddressingMode.ABSOLUTE_Y:
            let initialAddr = loadNextTwoBytes(cpu, cpu.REG_PC);
            address = initialAddr &+ UInt16(cpu.REG_Y);
            crossedPage = checkCrossedPage(initialAddr, address!);
        
        case AddressingMode.INDIRECT:
            address = loadTwoBytes(cpu, loadNextTwoBytes(cpu, cpu.REG_PC));
            
        case AddressingMode.INDIRECT_X:
            let initialAddr = loadNextByteAsTwoBytes(cpu, cpu.REG_PC);
            address = initialAddr + UInt16(cpu.REG_X);
            crossedPage = checkCrossedPage(initialAddr, address!);
            address = loadTwoBytes(cpu, address! & 0xff);
            
        case AddressingMode.INDIRECT_Y:
            let initialAddr = loadTwoBytes(cpu, loadNextByteAsTwoBytes(cpu, cpu.REG_PC));
            address = initialAddr &+ UInt16(cpu.REG_Y);
            crossedPage = checkCrossedPage(initialAddr, address!);
        
        default:
            assert(false);
    }

    return (address, crossedPage);
}