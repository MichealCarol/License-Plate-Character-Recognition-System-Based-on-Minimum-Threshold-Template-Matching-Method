function bw2 = Plate_Process(Egray, level, flag)
% ����������
% ���������
% plate������������
% level ���������ֵ
% flag ������ʾͼ����
% ���������
% result�������ͼ��
if nargin < 3
flag = 1;
end
%Im = Image_Rotate(plate1, id);
bw = im2bw(Egray, level); % ���������ֵ��
h = fspecial('average', 2); % ��ֵ�˲�ģ��
bw2 = imfilter(bw, h, 'replicate'); % ��ֵ�˲�
% figure(1)
% imshow(bw1)
%mask = Mask_Process(bw1, id); % ģ�崦��
%bw2 = bw1 .* mask; % ģ���˲�
if flag
%% %figure;
%% %subplot(2, 2, 1); imshow(Egray); title(' ��������ͼ��', 'FontWeight', 'Bold');
%% %subplot(2, 2, 2); imshow(Im); title(' ��������У��ͼ��', 'FontWeight', 'Bold');
%% %subplot(1, 2, 1); imshow(bw); title(' ���������ֵͼ��', 'FontWeight', 'Bold');
%% %subplot(1, 2, 2); imshow(bw2); title(' �˲���ֵͼ��', 'FontWeight', 'Bold');
end