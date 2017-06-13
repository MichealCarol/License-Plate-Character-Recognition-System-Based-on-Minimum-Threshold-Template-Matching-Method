%*********  OCR�����о���������С��ֵģ��ƥ�䷨�ĳ���ʶ��ϵͳ����  **********%
%**********          ��дС�飺�����桢����ΰ����  ��            ***********%
clc ;
clear ;
close all;
%% Step1 ��ȡͼ��װ��������ɫͼ����ʾԭʼͼ��
[filename, pathname, filterindex] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
'*.*','All Files' }, 'ѡ�������ͼ��');
file = fullfile(pathname, filename);% �ļ�·�����ļ��������ϳ������ļ���
Img = imread(file);% ����·�����ļ�����ȡͼƬ��Img
[Plate,bw,Loc] = Pre_Process(Img); % ��������Ԥ����������ȡ��
%����ɫͼ��ת��Ϊ�ڰײ���ʾ
Sgray = rgb2gray(Plate);%rgb2grayת���ɻҶ�ͼ
%figure����ͬʱ��ʾ����ͼ��
%%%%%
figure,subplot(3,1,1),imshow(Plate),title('ԭʼ��ɫͼ�� ');
subplot(3,1,2),imshow(Sgray),title('ԭʼ�ڰ�ͼ�� ');
%%%%%
%% Step2 ͼ��Ԥ������Sgrayԭʼ�ڰ�ͼ����п������õ�ͼ�񱳾�
s=strel('disk',13);%strel����
Bgray=imopen(Sgray,s);%�� sgray sͼ��
%��ԭʼͼ���뱳��ͼ������������ǿͼ��
Egray=imsubtract(Sgray,Bgray);%����ͼ���
%%%%%
subplot(3,1,3),imshow(Egray);title('��ǿ�ڰ�ͼ�� ');%����ڰ�ͼ��
%%%%%
%% Step3 ��ȡ���ڹ��˵������ֵlevel

level = 0.55;
%% Step4 ����ͼ��Ķ�ֵ��������ֵ��ͼ������˲�����
bw1 = Plate_Process(Egray, level);%�˲���ֵͼ��bw1
%%%%%
figure,imshow(bw1);title('ͼ���ֵ�� ');%�õ���ֵͼ��
%%%%%
[hight,width] = size(bw1); %�˲���ֵͼ������������ȡ
%% Step5 ���㳵��ˮƽͶӰ������ˮƽͶӰ���з�ȷ���
histcol1=sum(bw1);%���㴹ֱͶӰ
histrow=sum(bw1');%����ˮƽͶӰ
%%%%%
figure,subplot(2,1,1),bar(histcol1);
title('��ֱͶӰ (���߿� )');%�����ֱͶӰ
subplot(2,1,2),bar(histrow);
title('ˮƽͶӰ (���߿� )');%���ˮƽͶӰ
%%%%%
%% Step6 ��ˮƽͶӰ���з�ȷ���
meanrow=mean(histrow);%��ˮƽͶӰ��ƽ��ֵ
minrow=min(histrow) ;%��ˮƽͶӰ����Сֵ
levelrow=(meanrow+minrow)/2;%��ˮƽͶӰ�ľ�ֵ��Ŀ�ģ�����ѹ�����
count1=0;
l=1;
for k=1:hight
if histrow(k)<=levelrow
    count1=count1+1;
else
    if count1>=1
    markrow(l)=k ;%ˮƽͶӰ������λ��
    markrow1(l)=count1;%ˮƽͶӰ�ȿ�� (�½�������һ�������� )
    l=l+1;
    end
 count1=0;
 end
end
markrow2=diff(markrow) ;%����� (�����������ľ��� )
[m1,n1]=size(markrow2);
n1=n1+1;
markrow(l)=hight ;%�����±�Եλ��
markrow1(l)=count1;%�ַ��±�Ե���±߿���ϱ�Եλ�ü��
markrow2(n1)=markrow(l)-markrow(l-1) ;%�����±�Եλ��-�±߿���ϱ�Եλ�ã����±߿���
l=0;
for k=1:n1
markrow3(k)=markrow(k+1)-markrow1(k+1) ;%ˮƽͶӰ��3���½���λ��
markrow4(k)=markrow3(k)-markrow(k) ;%���� (���������½��� )markrow4(1)Ϊ�ϱ߿��ȣ�markrow4(2)Ϊ�ַ��߶�
markrow5(k)=markrow3(k)-double(uint16(markrow4(k)/2)) ; %������λ��markrow5(1)Ϊ�ϱ߿�����λ��
end
%% Step7 ���㳵����ת�Ƕȣ��������תͼ��
[rbw]=Image_Rotate(bw1,markrow3,markrow4);%����ͼ����ת����
%% Step8 ��ת���ƺ����¼��㳵��ˮƽͶӰ��ȥ������ˮƽ�߿򣬻�ȡ�ַ��߶�
histcol1=sum(rbw); %���㴹ֱͶӰ
histrow=sum(rbw'); %����ˮƽͶӰ
%%%%%
figure,subplot(2,1,1),bar(histcol1);title('��ֱͶӰ (��ת�� )', 'FontWeight', 'Bold');
subplot(2,1,2),bar(histrow);        title('ˮƽͶӰ (��ת�� )', 'FontWeight', 'Bold');
%%%%%
%%%%%
figure,subplot(2,1,1),bar(histrow); title('ˮƽͶӰ (��ת�� )', 'FontWeight', 'Bold');
subplot(2,1,2),imshow(rbw);title('���ƶ�ֵ��ͼ (��ת�� )', 'FontWeight', 'Bold');
%%%%%
%ȥˮƽ (����)�߿� ,��ȡ����ַ��߶�
maxhight=max(markrow2);%ȡ���ķ��
findc=find(markrow2==maxhight) ;
rowtop=markrow(findc) ;%�ַ��ϱ�Եλ��
rowbot=markrow(findc+1)-markrow1(findc+1) ;%�ַ��±�Եλ��
sbw1=rbw(rowtop:rowbot,:); %��ͼΪ��ȥˮƽ (����)�߿��Ķ�ֵ��ͼ
maxhight=rowbot-rowtop+1; %����ַ��߶�maxhight
%% Step9 ��ת���ƺ���㳵�ƴ�ֱͶӰ��ȥ�����ƴ�ֱ�߿򣬲�ȷ��ÿ���ַ�����λ�ã���������ַ���� maxwidth
histcol=sum(sbw1); %���㴹ֱͶӰ
%%%%%
figure,subplot(2,1,1),bar(histcol);
title(['(ȥˮƽ�߿��)��ֱͶӰ '], 'FontWeight', 'Bold');%������ƵĴ�ֱͶӰͼ��
%%%%%
subplot(2,1,2),imshow(sbw1); %�������ͼ��ȥˮƽ�߿��
title([' �����ַ��߶ȣ�',int2str(maxhight)],'Color','r', 'FontWeight', 'Bold') ;%��������ַ��߶�
%%%%%
%�Դ�ֱͶӰ���з�ȷ���
meancol=mean(histcol);%��ֱͶӰ��ƽ��ֵ
mincol=min(histcol) ;%��ֱͶӰ����Сֵ
levelcol=(meancol+mincol)/4;%��ֱͶӰ���ķ־�ֵ��Ŀ�ģ��ķ�ѹ�����
count1=0;
l=1;
for k=1:width
    if histcol(k)<=levelcol
        count1=count1+1;
    else
        if count1>=1
        markcol(l)=k; %�ַ�������
        markcol1(l)=count1; %�ȿ�� (�½�������һ�������� )
        l=l+1;
        end
       count1=0;
    end
end
markcol2=diff(markcol) ;%�ַ����� (����������һ�������� )
[m1,n1]=size(markcol2);
n1=n1+1;
markcol(l)=width ;%�����ұ�Եλ��
markcol1(l)=count1;%�����ַ����ұ�Ե���ұ߿�����Եλ�ü��
markcol2(n1)=markcol(l)-markcol(l-1) ;%�����ұ�Եλ��-�ұ߿���ϱ�Եλ�ã�
                                      %���ұ߿���
for k=1:n1
    markcol3(k)=markcol(k+1)-markcol1(k+1) ;%��ֱͶӰ��10���½���λ��
    markcol4(k)=markcol3(k)-markcol(k) ; %�ַ���� (���������½��� )����
           %(���������½��� )markcol4(1)Ϊ��߿��ȣ�markrow4(2)Ϊ�ַ��߶�
    markcol5(k)=markcol3(k)-double(uint16(markcol4(k)/2)) ;%�ַ�����λ��
end
maxwidth = max(markcol4);%�������ַ����
sbw2 = sbw1(1:maxhight,markcol(2):markcol3(9));
figure,subplot(2,1,1),imshow(Plate),title('ԭʼ��ɫͼ��','Color','b', 'FontWeight', 'Bold');
subplot(2,1,2),imshow(sbw2); %�������ͼ��ȥ�߿��
title({['��������ַ���ȣ� ',int2str(maxwidth)],['�����ַ��߶ȣ� ',int2str(maxhight)],'ȥ�߿��Ķ�ֵͼ��'},'Color','b', 'FontWeight', 'Bold') ;
%% Step10 ��ȡ�ָ��ַ�,����ÿ���ַ�����ʶ�����
RecogReult=WordsRecognition(sbw1,maxhight,maxwidth,markcol5);%�����ַ�ʶ����WordsRecognition()
%% Step11 ʶ�����Ŀ��ӻ�
str = ['ʶ����Ϊ��',RecogReult];
msgbox(str,'����ʶ��', 'modal');%ʶ�����Ŀ��ӻ�