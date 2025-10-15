const std = @import("std");
const stack_mod = @import("stack.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();
const Stacku8 = stack_mod.Stack(u8);
var stack = try Stacku8.init(allocator, 10);
defer stack.deinit();
try stack.push(1);
try stack.push(2);
try stack.push(3);
try stack.push(4);
try stack.push(5);
try stack.push(6);

std.debug.print("Stack len: {d}\n", .{stack.length});
std.debug.print("Stack capacity: {d}\n", .{stack.capacity});

stack.pop();
std.debug.print("Stack len: {d}\n", .{stack.length});
stack.pop();
std.debug.print("Stack len: {d}\n", .{stack.length});
std.debug.print(
    "Stack state: {any}\n",
    .{stack.items[0..stack.capacity]}
);
}