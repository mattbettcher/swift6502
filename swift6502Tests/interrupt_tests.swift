import XCTest;
import swift6502;

class interrupt_tests: XCTestCase
{
    func testBRK()
    {
        let cpu = CPU();
        XCTAssert(cpu.loadBinary("swift6502tests/testBRK.bin", offset: 0x600, entry: 0x0600));
        
        // Set up interrupt vector
        cpu.memory[0xfffe] = 0x1a;
        cpu.memory[0xffff] = 0x6;
        
        cpu.run();
        
        XCTAssert(cpu.memory[0x200] == 0x67);
        XCTAssert(cpu.memory[0x201] == 0x78);
        XCTAssert(cpu.memory[0x203] == 0x45);
        XCTAssert(cpu.memory[0x204] == 0x56);
    }
}
