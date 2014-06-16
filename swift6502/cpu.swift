import Foundation;

class CPU
{    
    var REG_ACC: UInt8 = 0
    {
        willSet
        {
            self.flags!.FLAG_ZERO = newValue == 0;
            self.flags!.FLAG_SIGN = (newValue >> 7) == 1;
        }
    }
    
    var REG_X: UInt8 = 0
    {
        willSet
        {
            self.flags!.FLAG_ZERO = newValue == 0;
            self.flags!.FLAG_SIGN = (newValue >> 7) == 1;
        }
    }
    
    var REG_Y: UInt8 = 0
    {
        willSet
        {
            self.flags!.FLAG_ZERO = newValue == 0;
            self.flags!.FLAG_SIGN = newValue & 128 == 1;
        }
    }
    
    var REG_STATUS: UInt8
    {
        get
        {
            return self.flags!.getRegister();
        }
    
        set
        {
            self.flags!.setRegister(newValue);
        }
    }
    
    var REG_PC: UInt16 = 0;
    var REG_SP: UInt8 = 0;
    var memory = Array<UInt8>(count: Constants.MEMORY_SIZE, repeatedValue: 0);
    var flags: Flags?;
    
    init()
    {
        reset();
        registerInstructions();
    }
    
    func push(value: UInt8)
    {
        self.memory[Int(self.REG_SP) + 0x100] = value;
        self.REG_SP = self.REG_SP &- 1;
    }
    
    func pop() -> UInt8
    {
        self.REG_SP = self.REG_SP &+ 1;
        return self.memory[Int(self.REG_SP) + 0x100];
    }
    
    func reset()
    {
        self.flags = Flags();
        
        self.REG_ACC = 0;
        self.REG_X = 0;
        self.REG_Y = 0;
        self.REG_SP = 0xff; // Bottom of the stack page
        self.REG_PC = loadTwoBytes(self, 0xfffc);
        assert(self.flags!.FLAG_INTERRUPT_DISABLE);
    }

    func run()
    {
        while !step()
        {
        }
    }
    
    func step() -> Bool
    {
        if self.REG_PC == 0
        {
            return true; // Regard executing from location 0 as termiating the program
        }
        
        let instruction = Instructions[Int(self.memory[Int(self.REG_PC)])];
        if instruction == nil
        {
            return true; // Done
        }
        
        let instr = instruction!;
        
        let (isJump, additionalCycles) = instr.execute(self);
        
        if !isJump
        {
            self.REG_PC += UInt16(instr.size);
        }

        return false;
    }
    
    func loadBinary(fileName: String, offset: UInt16, entry: UInt16) -> Bool
    {
        if entry < offset
        {
            return false;
        }
        
        let data = NSData(contentsOfFile: fileName);
        if data == nil
        {
            return false;
        }
        
        let string = NSString(data: data, encoding: NSASCIIStringEncoding);
        assert(data.length == string.length);
        
        let lastByte = Int(offset) + data.length - 1;
        if lastByte >= Constants.MEMORY_SIZE || Int(entry) > lastByte
        {
            return false;
        }
        
        // Load the binary into memory
        for i in 0..Constants.MEMORY_SIZE
        {
            self.memory[i] = 0x0;
        }
        
        for i in 0..data.length
        {
            let byte = UInt8(string.characterAtIndex(i));
            assert(byte >= 0 && byte <= 255);
            self.memory[Int(offset) + i] = byte;
        }

        // Let the CPU know the entry point
        self.memory[0xfffc] = UInt8(entry & 0x00ff);
        self.memory[0xfffd] = UInt8((entry >> 8) & 0x00ff);
        
        reset();
        
        return true;
    }
}

func executeRTI(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    cpu.flags!.setRegister(cpu.pop());
    let lowByte = cpu.pop();
    let highByte = cpu.pop()
    cpu.REG_PC = (UInt16(highByte) << 8) | UInt16(lowByte);

    return (true, 0);
}


func executeBRK(cpu: CPU, instr: Instruction) -> (Bool, UInt8)
{
    cpu.REG_PC = cpu.REG_PC &+ 1;
    cpu.push(UInt8(cpu.REG_PC >> 8));
    cpu.push(UInt8(cpu.REG_PC & 0xff));
    cpu.flags!.FLAG_BREAK = true;
    cpu.push(cpu.REG_STATUS);
    cpu.REG_PC = loadTwoBytes(cpu, 0xfffe);
    
    return (true, 0);
}