// this method takes in the colors that each vertex is set to, a height map for both textures, 
// and arbitrary values for the smoothstep function
float4 generateMixMapTexture(float3 vertCol, float4 texOne, float4 texTwo, float4 _SmoothStepVars){

    // Mix map one and two is the result of mixing the first and second height map textures with the 
    // red component of the vertex color
    float4 mixMapOne = clamp(0, 1, smoothstep(_SmoothStepVars.x,_SmoothStepVars.y,vertCol.r) / texOne) * vertCol.r;
    mixMapOne = smoothstep(.4,.6,mixMapOne);

    float4 mixMapTwo = (clamp(0, 1, smoothstep(_SmoothStepVars.z,_SmoothStepVars.w,(vertCol.r * -1 + 1)) / texTwo) * -1 + 1);
    mixMapTwo = smoothstep(.4,.6,mixMapTwo);

    // the final mix map texture is the result of combining the two textures and clamping the range
    // from zero two one to prevent the colors from breaking on the final render
    float4 mixMap = clamp(0, 1, mixMapOne + mixMapTwo);

    return mixMapOne;
}


