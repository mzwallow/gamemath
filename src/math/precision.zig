const testing = @import("std").testing;

pub const Real = f32;
pub const EPSILON: Real = 0.00001;

pub fn approxEq(a: Real, b: Real) bool {
    const diff = @abs(a - b);

    // Absolute comparison for near-zero values
    if (diff <= EPSILON) return true;

    // Relative comparison for larger values
    const largest = @max(@abs(a), @abs(b));
    return diff <= EPSILON * largest;
}

pub fn isZero(value: Real) bool {
    return @abs(value) <= EPSILON;
}

// Tests
test "approxEq near-zero" {
    try testing.expect(approxEq(0.00001, 0.000001));
}

test "approxEq not equal" {
    try testing.expectEqual(false, approxEq(0.001, 0.1));
}

test "approxEq large numbers" {
    try testing.expect(approxEq(1000000.0, 1000000.1));
}

test "isZero exactly" {
    try testing.expect(isZero(0.0));
}

test "isZero within epsilon" {
    try testing.expect(isZero(0.000001));
}

test "isZero not zero" {
    try testing.expectEqual(false, isZero(0.1));
}
