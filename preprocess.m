function [ output_image ] = preprocess( image )

throughput_image = rgb2hsv(image);
val = throughput_image(:,:,3);
sat = throughput_image(:,:,2);
val(val > .7) = 1;
sat(val > .7) = 0;
throughput_image(:,:,2) = sat;
throughput_image(:,:,3) = val;
output_image = hsv2rgb(throughput_image);
output_image = rgb2gray(output_image);
output_image(output_image < 1) = 0;
output_image = 1 - output_image;
[cc, n] = bwlabel(output_image);
sizes = zeros(1, n);
for i = 1:n
    sizes(i) = length(find(cc == i));
end
med = median(sizes);
for i = 1:n
    if (sizes(i) < 0.35*med || sizes(i) > 3*med)
        output_image(cc == i) = 0;
    end
end
output_image = 1 - output_image;

end

