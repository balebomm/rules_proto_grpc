"""Generated definition of rust_proto_library."""

load("//rust:rust_proto_compile.bzl", "rust_proto_compile")
load("//:defs.bzl", "bazel_build_rule_common_attrs", "proto_compile_attrs")
load("//rust:rust_proto_lib.bzl", "rust_proto_lib")
load("@rules_rust//rust:defs.bzl", "rust_library")

def rust_proto_library(name, **kwargs):  # buildifier: disable=function-docstring
    # Compile protos
    name_pb = name + "_pb"
    name_lib = name + "_lib"
    rust_proto_compile(
        name = name_pb,
        **{
            k: v
            for (k, v) in kwargs.items()
            if k in proto_compile_attrs.keys() or
               k in bazel_build_rule_common_attrs
        }  # Forward args
    )

    # Create lib file
    rust_proto_lib(
        name = name_lib,
        compilation = name_pb,
        externs = ["protobuf"],
    )

    # Create rust library
    rust_library(
        name = name,
        srcs = [name_pb, name_lib],
        deps = PROTO_DEPS + kwargs.get("deps", []),
        **{
            k: v
            for (k, v) in kwargs.items()
            if k in bazel_build_rule_common_attrs
        }  # Forward Bazel common args
    )

PROTO_DEPS = [
    Label("//rust/raze:protobuf"),
]
