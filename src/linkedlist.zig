const std = @import("std");
const Allocator = std.mem.Allocator;
const expect = std.testing.expect;

pub fn LinkedList(comptime T: type) type {
    return struct {
        length: usize,
        allocator: Allocator,
        head: ?*Node(T),
        const Self = @This();
        pub fn init(allocator: Allocator) Self {
            return .{ .length = 0, .allocator = allocator, .head = null };
        }
        pub fn append(self: *Self, comptime value: T) !void {
            const node = try Node(T).new(value, self.allocator);
            self.length += 1;
            if (self.head == null) {
                self.head = node;
                return;
            }
            var current = self.head.?;
            while (current.next) |next| {
                current.next = next;
            }
            current.next = node;
        }
        pub fn exists(self: *Self, comptime value: T) bool {
            if (self.head == null) {
                return false;
            }
            if (self.length == 1) {
                return (self.head.?.value == value);
            }
            var current = self.head;
            
            while (current) |node| {
                if (node.value == value) {
                    return true;
                    
                }
                current = node.next;
            }
            return false;
        }
        pub fn deinit(self: *Self) void {
            if (self.head == null) {
                return;
            }
            if (self.length == 1) {
                self.allocator.destroy(self.head.?);
                return;
            }
            var current = self.head;
            while (current) |node| {
                const next = node.next;
                self.allocator.destroy(node);
                current = next;
            }
        }
    };
}

pub fn Node(comptime T: type) type {
    return struct {
        value: T,
        next: ?*Node(T),
        const Self = @This();
        pub fn new(comptime value: T, allocator: Allocator) !*Self {
            const node = try allocator.create(Node(T));
            node.value = value;
            node.next = null;
            return node;
        }
    };
}

test "checking init of linked list" {
    const allocator = std.testing.allocator;
    var linkedList = LinkedList(u32).init(allocator);
    try linkedList.append(34);
    try linkedList.append(24);
    defer linkedList.deinit();
    try expect(linkedList.head.?.value == 34);
    try expect(linkedList.length == 2);
    try expect(linkedList.exists(34));
    try expect(!linkedList.exists(54));
}
