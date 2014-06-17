import XCTest;
import swift6502;

class decimal_mode_tests: XCTestCase
{
    func testInterpret()
    {
        for i in 0...9
        {
            for j in 0...9
            {
                XCTAssert(UInt8(i * 10 + j) == interpretAsDecimal(UInt8(i * 16 + j)))
                XCTAssert(UInt8(i * 16 + j) == interpretAsHex(UInt8(i * 10 + j)))
            }
        }
    }
    
    func testAllDecimal()
    {
        // Bruce Clark's decimal mode test at http://www.6502.org/tutorials/decimal_mode.html#B
        // Binary built by Zellyn Hunter at https://github.com/zellyn/go6502/blob/master/tests/6502_functional_test.bin
        let cpu = CPU();
        XCTAssert(cpu.loadBinary("swift6502tests/decimal_mode.bin", offset: 0x1000, entry: 0x1000));
        
        var prevPC: UInt16 = 0x0;
        while !cpu.step()
        {
            if prevPC == cpu.REG_PC &&
               Instructions[Int(cpu.memory[Int(cpu.REG_PC)])]!.operation == Mnemonics.BEQ
            {
                // Looping on a BEQ. Test is successful is we are at 0x1037
                XCTAssert(cpu.REG_PC == 0x1037);
                break;
            }
            
            prevPC = cpu.REG_PC;
        }
    }
}
