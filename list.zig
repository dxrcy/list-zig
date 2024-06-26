const std = @import("std");
const assert = std.debug.assert;
const Allocator = std.mem.Allocator;

pub fn List(comptime T: type) type {
    return struct {
        const Self = @This();

        allocator: Allocator,

        items: []T,
        len: usize,
        cap: usize,

        fn capIncrease(cap: usize) usize {
            return cap * 2;
        }

        pub fn init(allocator: anytype, cap: usize) !Self {
            return Self{
                .allocator = allocator,
                .items = try allocator.alloc(T, cap),
                .len = 0,
                .cap = cap,
            };
        }

        pub fn initFrom(allocator: anytype, items: []const T, len: usize) !Self {
            var list = try Self.init(allocator, len);
            list.len = len;
            for (0..len) |i| {
                list.items[i] = items[i];
            }
            return list;
        }

        pub fn deinit(self: Self) void {
            self.allocator.free(self.items);
        }

        pub fn push(self: *Self, item: T) !void {
            if (self.len >= self.cap) {
                self.cap = capIncrease(self.len);
                self.items = try self.allocator.realloc(self.items, self.cap);
            }
            self.items[self.len] = item;
            self.len += 1;
        }

        pub fn append(self: *Self, items: []const T, len: usize) !void {
            if (self.len + len > self.cap) {
                self.cap = capIncrease(self.len + len);
                self.items = try self.allocator.realloc(self.items, self.cap);
            }
            for (0..len) |i| {
                self.items[self.len + i] = items[i];
            }
            self.len += len;
        }

        pub fn remove(self: *Self, index: usize) T {
            assert(index < self.len);
            const item = self.items[index];
            for (index..self.len - 1) |i| {
                self.items[i] = self.items[i + 1];
            }
            self.len -= 1;
            return item;
        }
    };
}
