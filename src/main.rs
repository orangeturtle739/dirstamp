#[macro_use]
extern crate clap;

use std::fs::File;
use std::path::Path;
use walkdir::WalkDir;

fn main() {
    let matches = clap_app!(dirstamp =>
        (version: "1.0")
        (author: "Jacob Glueck <swimgiraffe435@gmail.com>")
        (about: "Generates a .stamp file for a directory with an mtime equal to the newest file in the directory")
        (@arg verbose: --verbose "Be verbose")
        (@arg dir: +required "Input directory")
        (@arg stamp: "stamp file, defaults to dir.stamp")
    ).get_matches();

    let verbose = matches.is_present("verbose");
    let dir = Path::new(matches.value_of("dir").unwrap())
        .canonicalize()
        .unwrap();
    let stamp = match matches.value_of("stamp") {
        Some(stamp) => Path::new(stamp).to_path_buf(),
        None => {
            let mut buf = dir.file_name().unwrap().to_os_string();
            buf.push(".stamp");
            dir.with_file_name(buf)
        }
    };
    if verbose {
        println!("dir: {:#?}", dir);
        println!("stamp: {:#?}", stamp);
    }

    let dir_mtime = WalkDir::new(dir)
        .into_iter()
        .map(|entry| {
            entry
                .unwrap()
                .path()
                .symlink_metadata()
                .unwrap()
                .modified()
                .unwrap()
        })
        .max()
        .unwrap();
    let stamp_mtime = stamp
        .symlink_metadata()
        .ok()
        .map(|metadata| metadata.modified().unwrap());
    if verbose {
        println!("dir: {:#?}", dir_mtime);
        println!("stamp: {:#?}", stamp_mtime);
    }

    match stamp_mtime {
        Some(mtime) if mtime >= dir_mtime => {
            if verbose {
                println!("No update needed");
            }
        }
        _ => {
            if verbose {
                println!("Updating stamp file");
            }
            File::create(stamp).unwrap();
        }
    }
}
