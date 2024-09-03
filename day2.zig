const std = @import("std");
const testing = std.testing;

const test1 =
        \\A Y
        \\B X
        \\C Z
        ;

const ParseError = error{parse};

const Shape = enum(u32) {
    rock = 1,
    paper = 2,
    scissors = 3,

    pub fn outcome(self: Shape, other: Shape) u32 {
        const out: u32 = switch(self) {
            Shape.rock => switch(other) {
                Shape.rock => 3,
                Shape.paper => 0,
                Shape.scissors => 6,
            },
            Shape.paper => switch(other) {
                Shape.rock => 6,
                Shape.paper => 3,
                Shape.scissors => 0,
            },
            Shape.scissors => switch(other) {
                Shape.rock => 0,
                Shape.paper => 6,
                Shape.scissors => 3,
            },
        };
        return out;
    }

    pub fn parse(letter: u8) Shape {
        const out: Shape = switch(letter) {
            'A', 'X' => Shape.rock,
            'B', 'Y' => Shape.paper,
            'C', 'Z' => Shape.scissors,
            else => Shape.rock,
        };
        return out;
    }

    pub fn parse_strat(self: Shape, letter: u8) ParseError!Shape {
        const out: ParseError!Shape = switch(self) {
            Shape.rock => switch(letter) {
                'X' => Shape.scissors,
                'Y' => Shape.rock,
                'Z' => Shape.paper,
                else => ParseError.parse,
            },
            Shape.paper => switch(letter) {
                'X' => Shape.rock,
                'Y' => Shape.paper,
                'Z' => Shape.scissors,
                else => ParseError.parse,
            },
            Shape.scissors => switch(letter) {
                'X' => Shape.paper,
                'Y' => Shape.scissors,
                'Z' => Shape.rock,
                else => ParseError.parse,
            },
        };
        return out;
    }
};

pub fn sum_strat(content: []const u8) u32 {
    var result: u32 = 0;
    var read_iter = std.mem.tokenizeAny(u8, content, "\n");
    while (read_iter.next()) |line| {
        const them = Shape.parse(line[0]);
        const us = Shape.parse(line[2]);
        result += us.outcome(them) + @intFromEnum(us);
    }
    return result;
}

pub fn sum_strat2(content: []const u8) u32 {
    var result: u32 = 0;
    var read_iter = std.mem.tokenizeAny(u8, content, "\n");
    while (read_iter.next()) |line| {
        const them = Shape.parse(line[0]);
        const us = them.parse_strat(line[2]) catch unreachable;
        result += us.outcome(them) + @intFromEnum(us);
    }
    return result;
}

test "first part" {
    std.debug.print("test: {}\n", .{sum_strat(test1)});
    const input = @embedFile("data/day2-input");
    std.debug.print("input: {}\n", .{sum_strat(input)});
}

test "second part" {
    std.debug.print("test: {}\n", .{sum_strat(test1)});
    const input = @embedFile("data/day2-input");
    std.debug.print("input: {}\n", .{sum_strat2(input)});
}
