const std = @import("std");

pub fn main() void {
    std.debug.print("Hello, World!\n", .{});

    var cast_value = @as(u32, 5000);
    _ = cast_value; // no variable can be unused

    var arr = [_]i32{1, 2, 3, 4, 5, 6};
    std.debug.print("Array length: {d}\n", .{arr.len});

    for (arr, 0..) |i, idx| {
        std.debug.print("{d} at position {d}\n", .{i, idx});
    }

    var t: bool = true;
    if (t) {
        std.debug.print("I am true\n", .{});
    } else {
        std.debug.print("I am false\n", .{});
    }

    var i: i32 = 1;
    var sum: i32 = 0;
    while (sum < 20)  {
        sum += i;
    }
    std.debug.print("sum is {d}\n", .{sum});

    i = 1;
    sum = 0;
    while (i < 20) : (i += 1) {
        sum += i;
    }
    std.debug.print("sum is {d}\n", .{sum});
}
