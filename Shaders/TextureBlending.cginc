float4 generateMixMapTexture(float3 vertCol, float4 texOne, float4 texTwo, float4 _SmoothStepVars){
    float4 mixMapOne = clamp(0, 1, smoothstep(_SmoothStepVars.x,_SmoothStepVars.y,vertCol.r) / texOne) * vertCol.r;
    mixMapOne = smoothstep(.4,.6,mixMapOne);

    float4 mixMapTwo = (clamp(0, 1, smoothstep(_SmoothStepVars.z,_SmoothStepVars.w,(vertCol.r * -1 + 1)) / texTwo) * -1 + 1);
    mixMapTwo = smoothstep(.4,.6,mixMapTwo);

    float4 mixMap = clamp(0, 1, mixMapOne + mixMapTwo);

    return mixMapOne;
}


