import XCTest
import swift6502

class swift6502Tests: XCTestCase
{
    func testFlags()
    {
        let cpu = CPU();
        let flags = cpu.flags!;
        
        XCTAssert(!flags.FLAG_CARRY);
        XCTAssert(flags.FLAG_ZERO);
        XCTAssert(flags.FLAG_INTERRUPT_DISABLE);
        XCTAssert(!flags.FLAG_DECIMAL_MODE);
        XCTAssert(flags.FLAG_BREAK);
        XCTAssert(flags.FLAG_UNUSED);
        XCTAssert(!flags.FLAG_OVERFLOW);
        XCTAssert(!flags.FLAG_SIGN);
        
        flags.FLAG_CARRY = true;
        XCTAssert(flags.FLAG_CARRY);
        
        flags.FLAG_ZERO = false;
        XCTAssert(!flags.FLAG_ZERO);
        
        flags.FLAG_INTERRUPT_DISABLE = false;
        XCTAssert(!flags.FLAG_INTERRUPT_DISABLE);
        
        flags.FLAG_DECIMAL_MODE = true;
        XCTAssert(flags.FLAG_DECIMAL_MODE);
        
        flags.FLAG_BREAK = false;
        XCTAssert(!flags.FLAG_BREAK);
        
        flags.FLAG_UNUSED = false;
        XCTAssert(!flags.FLAG_UNUSED);
        
        flags.FLAG_OVERFLOW = true;
        XCTAssert(flags.FLAG_OVERFLOW);
        
        flags.FLAG_SIGN = true;
        XCTAssert(flags.FLAG_SIGN);
    }
    
    func testAllSuiteA()
    {
        // Assembly code from https://code.google.com/p/hmc-6502/source/browse/trunk/emu/testvectors/AllSuiteA.asm
        // Assembled with The Ophis Assembler from https://hkn.eecs.berkeley.edu/~mcmartin/ophis/
        let cpu = CPU();
        XCTAssert(cpu.loadBinary("swift6502tests/AllSuiteA.bin", offset: 0x4000, entry: 0x4000));
        
        var prevPC: UInt16 = 0x0;
        while !cpu.step()
        {
            if prevPC == cpu.REG_PC &&
               Instructions[Int(cpu.memory[Int(cpu.REG_PC)])]!.operation == Mnemonics.JMP
            {
                // We are looping on a JMP - this means we have reached the end of the test
                break;
            }
            
            prevPC = cpu.REG_PC;
        }
        
        XCTAssert(cpu.memory[0x210] == 0xff);
    }
}
