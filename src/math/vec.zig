const std = @import("std");
const precision = @import("precision.zig");

fn Vector(comptime dim: usize) type {
    return struct {
        data: @Vector(dim, precision.Real),

        const Self = @This();

        pub fn negate(self: *Self) void {
            self.data = -self.data;
        }

        pub fn mulInPlace(self: *Self, scalar: precision.Real) void {
            self.data *= scalar;
        }

        pub fn addInPlace(self: *Self, other: Self) void {
            self.data += other.data;
        }

        pub fn subInPlace(self: *Self, other: Self) void {
            self.data -= other.data;
        }

        pub fn magnitudeSquared(self: Self) precision.Real {
            const squared = self.data * self.data;
            return @reduce(.Add, squared);
        }

        pub fn magnitude(self: Self) precision.Real {
            return @sqrt(magnitudeSquared(self));
        }
    };
}

pub const Vec2 = Vector(2);
pub const Vec3 = Vector(3);
pub const Vec4 = Vector(4);

// Tests
test "Vec2 magnitude" {
    const v = Vec2{ .data = .{ 3.0, 4.0 } };
    try std.testing.expectApproxEqAbs(5.0, v.magnitude(), 0.0001);
}

test "Vec3 magnitude" {
    const v = Vec3{ .data = .{ 1.0, 2.0, 2.0 } };
    try std.testing.expectApproxEqAbs(3.0, v.magnitude(), 0.0001);
}

test "Vec4 magnitude" {
    const v = Vec4{ .data = .{ 1.0, 1.0, 1.0, 1.0 } };
    try std.testing.expectApproxEqAbs(2.0, v.magnitude(), 0.0001);
}

test "zero vector magnitude" {
    const v = Vec3{ .data = .{ 0.0, 0.0, 0.0 } };
    try std.testing.expectApproxEqAbs(0.0, v.magnitude(), 0.0001);
}

test "magnitudeSquared" {
    const v = Vec3{ .data = .{ 3.0, 4.0, 0.0 } };
    try std.testing.expectApproxEqAbs(25.0, v.magnitudeSquared(), 0.0001);
    // magnitudeSquared should equal magnitude * magnitude
    const mag = v.magnitude();
    try std.testing.expectApproxEqAbs(mag * mag, v.magnitudeSquared(), 0.0001);
}
