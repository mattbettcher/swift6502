import XCTest;
import swift6502;

class addressing_tests: XCTestCase
{
    func testImplicit()
    {
        let (address, crossedPage) = getAddress(CPU(), AddressingMode.IMPLICIT);
        XCTAssert(address == nil);
        XCTAssert(!crossedPage);
    }
    
    func testAccumulator()
    {
        let cpu = CPU();
        
        cpu.REG_ACC = 0x42;
        let (address, crossedPage) = getAddress(cpu, AddressingMode.ACCUMULATOR);
        XCTAssert(address == 0x42);
        XCTAssert(!crossedPage);
    }
    
    func testImmediate()
    {
        let cpu = CPU();
        
        cpu.REG_PC = 0x42;
        var (address, crossedPage) = getAddress(cpu, AddressingMode.IMMEDIATE);
        XCTAssert(address == 0x43);
        XCTAssert(!crossedPage);
        
        cpu.REG_PC = 0xfffe;
        (address, crossedPage) = getAddress(cpu, AddressingMode.IMMEDIATE);
        XCTAssert(address == 0xffff);
        XCTAssert(!crossedPage);
        
        cpu.REG_PC = 0xffff;
        (address, crossedPage) = getAddress(cpu, AddressingMode.IMMEDIATE);
        XCTAssert(address == 0x0);
        XCTAssert(!crossedPage);
    }
    
    func testZeroPage()
    {
        let cpu = CPU();
        
        cpu.REG_PC = 0x42;
        cpu.memory[0x43] = 0x12;
        var (address, crossedPage) = getAddress(cpu, AddressingMode.ZERO_PAGE);
        XCTAssert(address == 0x12);
        XCTAssert(!crossedPage);
        
        cpu.REG_PC = 0xfffe;
        cpu.memory[0xffff] = 0x34;
        (address, crossedPage) = getAddress(cpu, AddressingMode.ZERO_PAGE);
        XCTAssert(address == 0x34);
        XCTAssert(!crossedPage);
        
        cpu.REG_PC = 0xffff;
        cpu.memory[0x0] = 0x56;
        (address, crossedPage) = getAddress(cpu, AddressingMode.ZERO_PAGE);
        XCTAssert(address == 0x56);
        XCTAssert(!crossedPage);
    }
    
    func testZeroPageXY()
    {
        let cpu = CPU();
        
        for i in 0...1
        {
            var addrMode = i == 0 ? AddressingMode.ZERO_PAGE_X : AddressingMode.ZERO_PAGE_Y;
            
            cpu.REG_PC = 0x42;
            cpu.memory[0x43] = 0x12;
            if (i == 0) { cpu.REG_X = 0x34; } else { cpu.REG_Y = 0x34 };
            var (address, crossedPage) = getAddress(cpu, addrMode);
            XCTAssert(address == 0x46);
            XCTAssert(!crossedPage);
            
            cpu.REG_PC = 0xfffe;
            cpu.memory[0xffff] = 0x56;
            if (i == 0) { cpu.REG_X = 0xa9; } else { cpu.REG_Y = 0xa9 };
            (address, crossedPage) = getAddress(cpu, addrMode);
            XCTAssert(address == 0xff);
            XCTAssert(!crossedPage);
            
            cpu.REG_PC = 0xffff;
            cpu.memory[0x0] = 0x78;
            if (i == 0) { cpu.REG_X = 0xdb; } else { cpu.REG_Y = 0xdb };
            (address, crossedPage) = getAddress(cpu, addrMode);
            XCTAssert(address == 0x53);
            XCTAssert(!crossedPage);
        }
    }

    func testRelative()
    {
        let cpu = CPU();
        
        cpu.REG_PC = 0x42;
        cpu.memory[0x43] = 0x12;
        var (address, crossedPage) = getAddress(cpu, AddressingMode.RELATIVE);
        XCTAssert(address == 0x56);
        XCTAssert(!crossedPage);
        
        cpu.REG_PC = 0xfffe;
        cpu.memory[0xffff] = 0x34;
        (address, crossedPage) = getAddress(cpu, AddressingMode.RELATIVE);
        XCTAssert(address == 0x34);
        XCTAssert(!crossedPage);
        
        cpu.REG_PC = 0xffff;
        cpu.memory[0x0] = 0x89;
        (address, crossedPage) = getAddress(cpu, AddressingMode.RELATIVE);
        XCTAssert(address == 0xff8a);
        XCTAssert(crossedPage);
        
        cpu.REG_PC = 0x1;
        cpu.memory[0x2] = 0x80;
        (address, crossedPage) = getAddress(cpu, AddressingMode.RELATIVE);
        XCTAssert(address == 0xff83);
        XCTAssert(crossedPage);
    }
    
    func testAbsolute()
    {
        let cpu = CPU();
        
        cpu.REG_PC = 0x42;
        cpu.memory[0x43] = 0xcd;
        cpu.memory[0x44] = 0xab;
        var (address, crossedPage) = getAddress(cpu, AddressingMode.ABSOLUTE);
        XCTAssert(address == 0xabcd);
        XCTAssert(!crossedPage);
        
        cpu.REG_PC = 0xfffe;
        cpu.memory[0xffff] = 0xfd;
        cpu.memory[0x0] = 0xff;
        (address, crossedPage) = getAddress(cpu, AddressingMode.ABSOLUTE);
        XCTAssert(address == 0xfffd);
        XCTAssert(!crossedPage);

        cpu.REG_PC = 0xffff;
        cpu.memory[0x0] = 0xff;
        cpu.memory[0x1] = 0xfd;
        (address, crossedPage) = getAddress(cpu, AddressingMode.ABSOLUTE);
        XCTAssert(address == 0xfdff);
        XCTAssert(!crossedPage);
    }
    
    func testAbsoluteXY()
    {
        let cpu = CPU();
    
        for i in 0...1
        {
            var addrMode = i == 0 ? AddressingMode.ABSOLUTE_X : AddressingMode.ABSOLUTE_Y;
            
            cpu.REG_PC = 0x42;
            cpu.memory[0x43] = 0xab;
            cpu.memory[0x44] = 0xcd;
            if (i == 0) { cpu.REG_X = 0xef; } else { cpu.REG_Y = 0xef; }
            var (address, crossedPage) = getAddress(cpu, addrMode);
            XCTAssert(address == 0xce9a);
            XCTAssert(crossedPage);
            
            cpu.REG_PC = 0xfffe;
            cpu.memory[0xffff] = 0xdf;
            cpu.memory[0x0] = 0xff;
            if (i == 0) { cpu.REG_X = 0xfc; } else { cpu.REG_Y = 0xfc; }
            (address, crossedPage) = getAddress(cpu, addrMode);
            XCTAssert(address == 0xdb);
            XCTAssert(crossedPage);
            
            cpu.REG_PC = 0xffff;
            cpu.memory[0x0] = 0xab;
            cpu.memory[0x1] = 0xff;
            if (i == 0) { cpu.REG_X = 0x54; } else { cpu.REG_Y = 0x54; }
            (address, crossedPage) = getAddress(cpu, addrMode);
            XCTAssert(address == 0xffff);
            XCTAssert(!crossedPage);
        }
    }
    
    func testIndirect()
    {
        let cpu = CPU();
        
        cpu.REG_PC = 0xabcd;
        cpu.memory[0xabce] = 0xdf;
        cpu.memory[0xabcf] = 0xcb;
        cpu.memory[0xcbdf] = 0x34;
        cpu.memory[0xcbe0] = 0x12;
        var (address, crossedPage) = getAddress(cpu, AddressingMode.INDIRECT);
        XCTAssert(address == 0x1234);
        XCTAssert(!crossedPage);
        
        cpu.REG_PC = 0xfffe;
        cpu.memory[0xffff] = 0xfa;
        cpu.memory[0x0] = 0xff;
        cpu.memory[0xfffa] = 0x78;
        cpu.memory[0xfffb] = 0x56;
        (address, crossedPage) = getAddress(cpu, AddressingMode.INDIRECT);
        XCTAssert(address == 0x5678);
        XCTAssert(!crossedPage);
        
        cpu.REG_PC = 0xff00;
        cpu.memory[0xff01] = 0xff;
        cpu.memory[0xff02] = 0xff;
        cpu.memory[0xffff] = 0xab;
        cpu.memory[0x0] = 0x90;
        (address, crossedPage) = getAddress(cpu, AddressingMode.INDIRECT);
        XCTAssert(address == 0x90ab);
        XCTAssert(!crossedPage);
    }
    
    func testIndirectX()
    {
        let cpu = CPU();
        
        cpu.REG_PC = 0x42;
        cpu.memory[0x43] = 0xab;
        cpu.memory[0xaa] = 0x34;
        cpu.memory[0xab] = 0x12;
        cpu.REG_X = 0xff;
        var (address, crossedPage) = getAddress(cpu, AddressingMode.INDIRECT_X);
        XCTAssert(address == 0x1234);
        XCTAssert(crossedPage);
        
        cpu.REG_PC = 0xfffe;
        cpu.memory[0xffff] = 0x6;
        cpu.memory[0x5] = 0x78;
        cpu.memory[0x6] = 0x56;
        cpu.REG_X = 0xff;
        (address, crossedPage) = getAddress(cpu, AddressingMode.INDIRECT_X);
        XCTAssert(address == 0x5678);
        XCTAssert(crossedPage);
        
        cpu.REG_PC = 0xffff;
        cpu.memory[0x0] = 0xfd;
        cpu.memory[0xfc] = 0xab;
        cpu.memory[0xfd] = 0x90;
        cpu.REG_X = 0xff;
        (address, crossedPage) = getAddress(cpu, AddressingMode.INDIRECT_X);
        XCTAssert(address == 0x90ab);
        XCTAssert(crossedPage);
    }
    
    func testIndirectY()
    {
        let cpu = CPU();
        
        cpu.REG_PC = 0x42;
        cpu.memory[0x43] = 0xab;
        cpu.memory[0xab] = 0x34;
        cpu.memory[0xac] = 0x12;
        cpu.REG_Y = 0xff;
        var (address, crossedPage) = getAddress(cpu, AddressingMode.INDIRECT_Y);
        XCTAssert(address == 0x1333);
        XCTAssert(crossedPage);
        
        cpu.REG_PC = 0xfffe;
        cpu.memory[0xffff] = 0xff;
        cpu.memory[0xff] = 0xfe;
        cpu.memory[0x100] = 0xff;
        cpu.REG_Y = 0xff;
        (address, crossedPage) = getAddress(cpu, AddressingMode.INDIRECT_Y);
        XCTAssert(address == 0xfd);
        XCTAssert(crossedPage);
        
        cpu.REG_PC = 0xffff;
        cpu.memory[0x0] = 0xcd;
        cpu.memory[0xcd] = 0x00;
        cpu.memory[0xce] = 0xff;
        cpu.REG_Y = 0xff;
        (address, crossedPage) = getAddress(cpu, AddressingMode.INDIRECT_Y);
        XCTAssert(address == 0xffff);
        XCTAssert(!crossedPage);
    }
}
