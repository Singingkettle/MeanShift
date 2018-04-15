function rect = mean_shift(init_rect, true_d, frame_data, dim, num_bin, num_iter, step_var)

old_rect = init_rect;
iter_count = 0;
while true
    iter_count = iter_count + 1;
    % Step 1
    search_d = generate_target_distribution(old_rect, frame_data, dim, num_bin, 'normal');
    old_b_coefficent = true_d'*search_d;
    % Step 2
    weights = calculate_weights(old_rect, frame_data, true_d, search_d);
    % Step3
    new_rect = update_rect(old_rect, weights, dim, 'normal');
    new_search_d = generate_target_distribution(new_rect, frame_data, dim, num_bin, 'normal');
    % Step4 
    new_b_coefficent = true_d'*new_search_d;
    if new_b_coefficent < old_b_coefficent
        new_rect = (old_rect + new_rect)./2;
    end
    if sum((new_rect(1:2)-old_rect(1:2)).^2) < step_var
        rect = new_rect;
        break;
    else
        old_rect = new_rect;
    end
    if iter_count >=num_iter
        break;
    end
end


function weights = calculate_weights(rect, frame_data, true_d, search_d)

weights = zeros(floor(rect(4)), floor(rect(3)));
epsilon = 0.000001;
for h_index=1:rect(4)
    for w_index=1:rect(3)
        p_x = w_index + rect(1) -1;
        p_y = h_index + rect(2) -1;
        if p_x <= 1
            p_x = 1;
        end
        if p_y <= 1
            p_y = 1;
        end
        if p_x > size(frame_data, 2)
            p_x = size(frame_data, 2);
        end
        if p_y > size(frame_data, 1)
            p_y = size(frame_data, 1);
        end
        bin_index = frame_data(floor(p_y), floor(p_x))+1;
        weights(h_index, w_index) = sqrt(true_d(bin_index)/(search_d(bin_index)+epsilon));
    end
end

function new_rect = update_rect(rect, weights, dim, mode)

if ~strcmp(mode, 'normal')
    error('You should define your kernel function!')
end

c_x = rect(1)+rect(3)/2-1;
c_y = rect(2)+rect(4)/2-1;

new_rect = zeros(size(rect));

part_molecular = [0,0];
part_denominator = 0;
epsilon = 0.000001;
for h_index=1:floor(rect(4))
    for w_index=1:floor(rect(3))
        p_x = w_index + rect(1) -1;
        p_y = h_index + rect(2) -1;
        l2_dis = (p_y-c_y)^2+(p_x-c_x)^2;
        g_val = 1/(2*pi)^(dim/2)*exp(-1/2*l2_dis)/2;
        part_molecular = part_molecular + [p_x, p_y].*weights(h_index, w_index).*g_val;
        part_denominator = part_denominator + weights(h_index, w_index).*g_val;
    end
end

new_rect(1:2) = part_molecular./(part_denominator+epsilon);
new_rect(3:4) = rect(3:4);