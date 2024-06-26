const std = @import("std");
const print = std.debug.print;

const List = @import("list.zig").List;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var list = try List(u8).initFrom(allocator, "abcd", 4);
    defer list.deinit();
    debugList(&list);

    try list.push('1');
    debugList(&list);

    try list.push('2');
    debugList(&list);

    try list.push('3');
    debugList(&list);

    try list.append("efg", 3);
    debugList(&list);

    print("-> {c}\n", .{list.remove(2)});
    debugList(&list);
}

fn debugList(list: *const List(u8)) void {
    print("{d} / {}\n", .{ list.len, list.cap });
    for (0..list.len) |i| {
        print("{c}", .{list.items[i]});
    }
    print("\n", .{});
}
