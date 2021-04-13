fn main() {
    let crate_dir = std::env::var("CARGO_MANIFEST_DIR").unwrap();

    let parse_config = cbindgen::ParseConfig {
        parse_deps: true,
        include: Some(vec!["allo-isolate".into()]),
        extra_bindings: vec!["allo-isolate".into()],
        ..Default::default()
    };

    let mut config = cbindgen::Config {
        language: cbindgen::Language::C,
        parse: parse_config,
        ..Default::default()
    };
    config.braces = cbindgen::Braces::SameLine;
    config.cpp_compat = true;
    config.style = cbindgen::Style::Both;
    cbindgen::Builder::new()
        .with_crate(crate_dir)
        .with_config(config)
        .generate()
        .expect("Unable to generate bindings")
        .write_to_file("binding.h");
}
