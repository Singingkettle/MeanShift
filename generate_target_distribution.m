function true_target_distribution = generate_target_distribution(rect, img, dim, num_bin, mode)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


img = rgb2gray(img);

true_target_distribution = zeros(num_bin, 1);
if ~strcmp(mode, 'normal')
    error('You should define your kernel function!')
end

c_x = rect(1)+rect(3)/2-1;
c_y = rect(2)+rect(4)/2-1;

C_val = 0;
for h_index=1:floor(rect(4))
    for w_index=1:floor(rect(3))
        p_x = w_index + rect(1) -1;
        p_y = h_index + rect(2) -1;
        if p_x <= 1
            p_x = 1;
        end
        if p_y <= 1
            p_y = 1;
        end
        if p_x > size(img, 2)
            p_x = size(img, 2);
        end
        if p_y > size(img, 1)
            p_y = size(img, 1);
        end
        l2_dis = (p_y-c_y)^2+(p_x-c_x)^2;
        k_val = 1/(2*pi)^(dim/2)*exp(-1/2*l2_dis);
        C_val = C_val + k_val;
        bin_index = img(floor(p_y), floor(p_x))+1;
        true_target_distribution(bin_index) = true_target_distribution(bin_index) + k_val;
    end
end

true_target_distribution = true_target_distribution./C_val;