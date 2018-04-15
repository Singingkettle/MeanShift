% ===============================================================================
% This demo is about meanshift tracking
% Author: Shuo Chang
% E-mail: changshuo@bupt.edu.cn
% ===============================================================================

clear; close all; clc

% Load video 
mov = VideoReader('./data/Homework_video.mp4');

num_bin = 256;
kernel = 'normal';
dim = 2;

frame_index = 1;
while hasFrame(mov)
    if frame_index == 1  % First frame, create GUI
        fig_handle = figure('Name', 'MeanShift-Tracking');
        frame_data = readFrame(mov);
        imshow(frame_data);
        rect = getrect(fig_handle);
        hold on;
        rectangle('Position', rect, 'EdgeColor', 'g', 'LineWidth',2); 
        true_target_distribution = generate_target_distribution(rect, frame_data, dim, num_bin, kernel);
        text(10, 10, int2str(frame_index), 'color', [0 1 1]);
        hold off;
        axis off;
        axis image;
        set(gca, 'Units', 'normalized', 'Position', [0 0 1 1]);
        frame_index = frame_index + 1;
    else
        figure(fig_handle);
        frame_data = readFrame(mov);
        rect = mean_shift(rect, true_target_distribution, frame_data, dim, num_bin, 100, 30);
        imshow(frame_data);
        hold on;
        rectangle('Position', rect, 'EdgeColor', 'g', 'LineWidth', 2);
        text(10, 10, int2str(frame_index), 'color', [0 1 1]);
        hold off;
        frame_index = frame_index + 1;
    end
    drawnow;
end
close all;

