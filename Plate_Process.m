function bw2 = Plate_Process(Egray, level, flag)
% 车牌区域处理
% 输入参数：
% plate——车牌区域
% level ——最佳阈值
% flag ——显示图像标记
% 输出参数：
% result——结果图像
if nargin < 3
flag = 1;
end
%Im = Image_Rotate(plate1, id);
bw = im2bw(Egray, level); % 车牌区域二值化
h = fspecial('average', 2); % 均值滤波模板
bw2 = imfilter(bw, h, 'replicate'); % 均值滤波
% figure(1)
% imshow(bw1)
%mask = Mask_Process(bw1, id); % 模板处理
%bw2 = bw1 .* mask; % 模板滤波
if flag
%% %figure;
%% %subplot(2, 2, 1); imshow(Egray); title(' 车牌区域图像', 'FontWeight', 'Bold');
%% %subplot(2, 2, 2); imshow(Im); title(' 车牌区域校正图像', 'FontWeight', 'Bold');
%% %subplot(1, 2, 1); imshow(bw); title(' 车牌区域二值图像', 'FontWeight', 'Bold');
%% %subplot(1, 2, 2); imshow(bw2); title(' 滤波二值图像', 'FontWeight', 'Bold');
end