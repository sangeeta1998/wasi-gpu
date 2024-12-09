use std::ffi::CString;
use std::os::raw::c_char;
use std::ptr;

extern "C" {
    fn launchVectorAdd(A: *const f32, B: *const f32, C: *mut f32, numElements: i32);
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let num_elements = 1024;
    let A: Vec<f32> = vec![1.0; num_elements];
    let B: Vec<f32> = vec![2.0; num_elements];
    let mut C: Vec<f32> = vec![0.0; num_elements];

    unsafe {
        launchVectorAdd(A.as_ptr(), B.as_ptr(), C.as_mut_ptr(), num_elements as i32);
    }

    println!("Result: {:?}", &C[..10]); // Print first 10 elements

    Ok(())
}