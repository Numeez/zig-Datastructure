const std = @import("std");
const Allocator = std.mem.Allocator;


pub fn Stack (comptime T: type)type{
    return struct {
    items: []T,
    capacity: usize,
    length: usize,
    allocator: Allocator,
    const Self = @This();

    pub fn init(allocator: Allocator, capacity: usize) !Self {
        var buffer = try allocator.alloc(T, capacity);
        return .{
            .items = buffer[0..],
            .capacity = capacity,
            .length = 0,
            .allocator = allocator,
        };
    }

    pub fn push(self: *Self, value: T) !void {
        if (self.length + 1 > self.capacity) {
            var newBuffer = try self.allocator.alloc(T, self.capacity * 2);
            @memcpy(newBuffer[0..self.capacity], self.items);
            self.allocator.free(self.items);
            self.items = newBuffer;
            self.capacity *= 2;
        }
        self.items[self.length] = value;
        self.length += 1;
    }

    pub fn pop (self:*Self)void{
        if (self.length==0){
            return;
        }
        self.items[self.length-1] = undefined;
        self.length-=1;
    }

    pub fn deinit(self:*Self)void{
        self.allocator.free(self.items);
    }
};

}