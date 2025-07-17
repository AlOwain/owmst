# Branch

Investigate why you get a segmentation fault when trying to generate both VBO and EBO buffers with one glGenBuffers call, while it seemingly did give the same result in both, it crashed after the draw call.

It could be an issue with the casting of the temporary buffer object u32 array into two u32's
