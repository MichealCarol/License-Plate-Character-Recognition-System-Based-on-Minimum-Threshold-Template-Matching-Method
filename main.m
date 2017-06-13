%*********  OCR问题研究：基于最小阈值模板匹配法的车牌识别系统程序  **********%
%**********          编写小组：蔡鑫奇、张永伟、武  阳            ***********%
clc ;
clear ;
close all;
%% Step1 获取图像装入待处理彩色图像并显示原始图像
[filename, pathname, filterindex] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
'*.*','All Files' }, '选择待处理图像');
file = fullfile(pathname, filename);% 文件路径和文件名创建合成完整文件名
Img = imread(file);% 根据路径和文件名读取图片到Img
[Plate,bw,Loc] = Pre_Process(Img); % 车牌区域预处理（区域提取）
%将彩色图像转换为黑白并显示
Sgray = rgb2gray(Plate);%rgb2gray转换成灰度图
%figure命令同时显示三幅图：
%%%%%
figure,subplot(3,1,1),imshow(Plate),title('原始彩色图像 ');
subplot(3,1,2),imshow(Sgray),title('原始黑白图像 ');
%%%%%
%% Step2 图像预处理，对Sgray原始黑白图像进行开操作得到图像背景
s=strel('disk',13);%strel函数
Bgray=imopen(Sgray,s);%打开 sgray s图像
%用原始图像与背景图像作减法，增强图像
Egray=imsubtract(Sgray,Bgray);%两幅图相减
%%%%%
subplot(3,1,3),imshow(Egray);title('增强黑白图像 ');%输出黑白图像
%%%%%
%% Step3 获取用于过滤的最佳阈值level

level = 0.55;
%% Step4 车牌图像的二值化，并二值化图像进行滤波处理
bw1 = Plate_Process(Egray, level);%滤波二值图像bw1
%%%%%
figure,imshow(bw1);title('图像二值化 ');%得到二值图像
%%%%%
[hight,width] = size(bw1); %滤波二值图像特征参数获取
%% Step5 计算车牌水平投影，并对水平投影进行峰谷分析
histcol1=sum(bw1);%计算垂直投影
histrow=sum(bw1');%计算水平投影
%%%%%
figure,subplot(2,1,1),bar(histcol1);
title('垂直投影 (含边框 )');%输出垂直投影
subplot(2,1,2),bar(histrow);
title('水平投影 (含边框 )');%输出水平投影
%%%%%
%% Step6 对水平投影进行峰谷分析
meanrow=mean(histrow);%求水平投影的平均值
minrow=min(histrow) ;%求水平投影的最小值
levelrow=(meanrow+minrow)/2;%求水平投影的均值，目的：二分压缩尖峰
count1=0;
l=1;
for k=1:hight
if histrow(k)<=levelrow
    count1=count1+1;
else
    if count1>=1
    markrow(l)=k ;%水平投影上升点位置
    markrow1(l)=count1;%水平投影谷宽度 (下降点至下一个上升点 )
    l=l+1;
    end
 count1=0;
 end
end
markrow2=diff(markrow) ;%峰距离 (相邻上升点间的距离 )
[m1,n1]=size(markrow2);
n1=n1+1;
markrow(l)=hight ;%车牌下边缘位置
markrow1(l)=count1;%字符下边缘与下边框的上边缘位置间隔
markrow2(n1)=markrow(l)-markrow(l-1) ;%车牌下边缘位置-下边框的上边缘位置，即下边框宽度
l=0;
for k=1:n1
markrow3(k)=markrow(k+1)-markrow1(k+1) ;%水平投影的3个下降点位置
markrow4(k)=markrow3(k)-markrow(k) ;%峰宽度 (上升点至下降点 )markrow4(1)为上边框宽度，markrow4(2)为字符高度
markrow5(k)=markrow3(k)-double(uint16(markrow4(k)/2)) ; %峰中心位置markrow5(1)为上边框中心位置
end
%% Step7 计算车牌旋转角度，并输出旋转图像
[rbw]=Image_Rotate(bw1,markrow3,markrow4);%调用图像旋转函数
%% Step8 旋转车牌后重新计算车牌水平投影，去掉车牌水平边框，获取字符高度
histcol1=sum(rbw); %计算垂直投影
histrow=sum(rbw'); %计算水平投影
%%%%%
figure,subplot(2,1,1),bar(histcol1);title('垂直投影 (旋转后 )', 'FontWeight', 'Bold');
subplot(2,1,2),bar(histrow);        title('水平投影 (旋转后 )', 'FontWeight', 'Bold');
%%%%%
%%%%%
figure,subplot(2,1,1),bar(histrow); title('水平投影 (旋转后 )', 'FontWeight', 'Bold');
subplot(2,1,2),imshow(rbw);title('车牌二值子图 (旋转后 )', 'FontWeight', 'Bold');
%%%%%
%去水平 (上下)边框 ,获取最大字符高度
maxhight=max(markrow2);%取最大的峰距
findc=find(markrow2==maxhight) ;
rowtop=markrow(findc) ;%字符上边缘位置
rowbot=markrow(findc+1)-markrow1(findc+1) ;%字符下边缘位置
sbw1=rbw(rowtop:rowbot,:); %子图为：去水平 (上下)边框后的二值子图
maxhight=rowbot-rowtop+1; %最大字符高度maxhight
%% Step9 旋转车牌后计算车牌垂直投影，去掉车牌垂直边框，并确定每个字符中心位置，计算最大字符宽度 maxwidth
histcol=sum(sbw1); %计算垂直投影
%%%%%
figure,subplot(2,1,1),bar(histcol);
title(['(去水平边框后)垂直投影 '], 'FontWeight', 'Bold');%输出车牌的垂直投影图像
%%%%%
subplot(2,1,2),imshow(sbw1); %输出车牌图像（去水平边框后）
title([' 车牌字符高度：',int2str(maxhight)],'Color','r', 'FontWeight', 'Bold') ;%输出车牌字符高度
%%%%%
%对垂直投影进行峰谷分析
meancol=mean(histcol);%求垂直投影的平均值
mincol=min(histcol) ;%求垂直投影的最小值
levelcol=(meancol+mincol)/4;%求垂直投影的四分均值，目的：四分压缩尖峰
count1=0;
l=1;
for k=1:width
    if histcol(k)<=levelcol
        count1=count1+1;
    else
        if count1>=1
        markcol(l)=k; %字符上升点
        markcol1(l)=count1; %谷宽度 (下降点至下一个上升点 )
        l=l+1;
        end
       count1=0;
    end
end
markcol2=diff(markcol) ;%字符距离 (上升点至下一个上升点 )
[m1,n1]=size(markcol2);
n1=n1+1;
markcol(l)=width ;%车牌右边缘位置
markcol1(l)=count1;%最右字符的右边缘与右边框的左边缘位置间隔
markcol2(n1)=markcol(l)-markcol(l-1) ;%车牌右边缘位置-右边框的上边缘位置，
                                      %即右边框宽度
for k=1:n1
    markcol3(k)=markcol(k+1)-markcol1(k+1) ;%垂直投影的10个下降点位置
    markcol4(k)=markcol3(k)-markcol(k) ; %字符宽度 (上升点至下降点 )峰宽度
           %(上升点至下降点 )markcol4(1)为左边框宽度，markrow4(2)为字符高度
    markcol5(k)=markcol3(k)-double(uint16(markcol4(k)/2)) ;%字符中心位置
end
maxwidth = max(markcol4);%获得最大字符宽度
sbw2 = sbw1(1:maxhight,markcol(2):markcol3(9));
figure,subplot(2,1,1),imshow(Plate),title('原始彩色图像','Color','b', 'FontWeight', 'Bold');
subplot(2,1,2),imshow(sbw2); %输出车牌图像（去边框后）
title({['车牌最大字符宽度： ',int2str(maxwidth)],['车牌字符高度： ',int2str(maxhight)],'去边框后的二值图像'},'Color','b', 'FontWeight', 'Bold') ;
%% Step10 提取分割字符,并对每个字符进行识别输出
RecogReult=WordsRecognition(sbw1,maxhight,maxwidth,markcol5);%调用字符识别函数WordsRecognition()
%% Step11 识别结果的可视化
str = ['识别结果为：',RecogReult];
msgbox(str,'车牌识别', 'modal');%识别结果的可视化