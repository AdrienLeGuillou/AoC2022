const std = @import("std");
const expect = std.testing.expect;

const p1_test_input =
\\    [D]
\\[N] [C]
\\[Z] [M] [P]
\\ 1   2   3
\\
\\move 1 from 2 to 1
\\move 3 from 1 to 3
\\move 2 from 2 to 1
\\move 1 from 1 to 2
;

const ArrayList = std.ArrayList;
const Stack = ArrayList(u8);
const Floor = ArrayList(Stack);

const Action = struct {
    n: u8,
    from: u8,
    to: u8,
};
const Sequence = ArrayList(Action);

fn parse_input(content: []const u8, floor: *Floor, actions: *Sequence) !void {
    var read_iter = std.mem.splitSequence(u8, content, "\n");
    // parse the boxes
    while(read_iter.next()) |line| {
        if (line[1] == '1') { // case when we reach the "floor"
            _ = read_iter.next(); // consume the empty line after
            // reverse stacks
            break;
        }
        try parse_boxes(line, floor);
    }

    // reverse the stacks
    for (floor.items) |stack| {
        std.mem.reverse(u8, stack.items);
    }

    // parse the actions
    while(read_iter.next()) |line| {
        if (line.len == 0) break;
        try actions.append(parse_actions(line));
    }
}

fn parse_boxes(line: []const u8, floor: *Floor) !void {
    var box_pos: usize = 1;
    var box_n: usize = 0;
    while (box_pos < line.len) {
        if (floor.items.len <= box_n) {
            try floor.append(Stack.init(floor.allocator));
        }
        const box = line[box_pos];
        if (box != ' ') {
            try floor.items[box_n].append(box);
        }
        box_n += 1;
        box_pos += 4;
    }
}

fn parse_actions(line: []const u8) Action {
    var toks = std.mem.tokenizeAny(u8, line, " ");
    _ = toks.next(); // skip "move"
    const n: u8 =  std.fmt.parseInt(u8, toks.next().?, 10) catch 0;
    _ = toks.next(); // skip "from"
    const from : u8 =  std.fmt.parseInt(u8, toks.next().?, 10) catch 0;
    _ = toks.next(); // skip "to"
    const to: u8 =  std.fmt.parseInt(u8, toks.next().?, 10) catch 0;

    const out: Action = .{
        .n = n,
        .from = from - 1,
        .to = to - 1,
    };
    return out;
}

fn print_actions(action: Action) void {
    std.debug.print("move {} from {} to {}\n",
        .{action.n, action.from, action.to});
}

fn move_p1(action: Action, floor: *Floor) !void {
    var n = action.n;
    while (n > 0) : (n -= 1) {
        const box: u8 = floor.items[action.from].pop();
        try floor.items[action.to].append(box);
    }
}

fn move_p2(action: Action, floor: *Floor) !void {
    const len: usize = floor.items[action.from].items.len - action.n;
    const stack: []u8 = floor.items[action.from].items[len..];
    try floor.items[action.to].appendSlice(stack);
    for (0..action.n) |_| {
        _ = floor.items[action.from].pop();
    }
}

fn get_answer(floor: *Floor) void {
    for (floor.items) |stack| {
        std.debug.print("{c}", .{stack.getLast()});
    }
    std.debug.print("\n", .{});
}

test "p1" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        //fail test; can't try in defer as defer is executed after we return
        if (deinit_status == .leak) expect(false) catch @panic("TEST FAIL");
    }

    var floor = Floor.init(allocator);
    defer {
        for (floor.items) |stack| {
            stack.deinit();
        }
        floor.deinit();
    }
    var actions = Sequence.init(allocator);
    defer actions.deinit();

    // const input = p1_test_input;
    const input = @embedFile("data/day5-input");
    try parse_input(input, &floor, &actions);

    // for (actions.items) |action| print_actions(action);
    for (actions.items) |action| try move_p2(action, &floor);
    // for (floor.items) |stack| {
    //     for (stack.items) |box| {
    //         std.debug.print("{c}", .{box});
    //     }
    //     std.debug.print("\n", .{});
    // }
    get_answer(&floor);
}


