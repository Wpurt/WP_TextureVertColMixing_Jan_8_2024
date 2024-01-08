float4 generateMixMapTexture(float3 vertCol, float4 texOne, float4 texTwo){
    float4 mixMapOne = clamp(0, 1, smoothstep(0.1,.9,vertCol.r) / texOne);
    mixMapOne = smoothstep(.4,.6,mixMapOne);

    float4 mixMapTwo = (clamp(0, 1, smoothstep(0.1,.9,(vertCol.r * -1 + 1)) / texTwo) * -1 + 1);
    mixMapTwo = smoothstep(.4,.6,mixMapTwo);

    float4 mixMap = clamp(0, 1, mixMapOne + mixMapTwo);

    return mixMap;
}


