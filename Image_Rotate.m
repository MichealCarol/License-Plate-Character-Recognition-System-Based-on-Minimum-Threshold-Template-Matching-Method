%Image_Rotate()ͼ����ת����������ˮƽͶӰ������������㳵����ת�Ƕȣ��������תͼ��
function [rbw]=Image_Rotate(bw1,markrow3,markrow4)
%(1)�����������½����ҵ�һ��Ϊ 1�ĵ�
[m2,n2]=size(bw1);     %sbw1��ͼ���С
[m3,n3]=size(markrow4); %markrow4�Ĵ�С
maxw=max(markrow4);     %�����Ϊ�ַ�
if markrow4(1) ~= maxw  %����ϱ�
ysite=1;
k1=1;
for l=1:n2
 for k=1:markrow3(ysite)%�Ӷ�������һ�����½���ɨ��
  if bw1(k,l)==1
    xdata(k1)=l;
    ydata(k1)=k;
    k1=k1+1;
  break;
  end
 end
end
 else %����±�
   ysite=n3;
 if markrow4(n3) ==0
    if markrow4(n3-1) ==maxw
    ysite= 0; %���±�
    else
      ysite= n3-1;
    end
 end
 if ysite ~=0
    k1=1;
   for l=1:n2
     k=m2;
    while k>=markrow(ysite) % �ӵױ������һ�����������ɨ��
    if bw1(k,l)==1
       xdata(k1)=l;
       ydata(k1)=k;
       k1=k1+1;
    break;
    end
    k=k-1;
    end
   end
 end
end
%(2)������ϣ�������ˮƽ��ļн�
fresult = fit(xdata',ydata','poly1'); %poly1  Y = p1*x+p2
p1=fresult.p1;
angle=atan(fresult.p1)*180/pi; %���Ȼ�Ϊ�ȣ� 360/2pi, pi=3.14
%(3)��ת����ͼ��
rbw = imrotate(bw1,angle,'bilinear','crop');%��תͼ��
%%%%%
figure,imshow(rbw);title('');%���������ת��ĻҶ�ͼ��
title(['������ת�ǣ�',num2str(angle),'��'] ,'Color','r', 'FontWeight', 'Bold');%��ʾ���Ƶ���ת�Ƕ�
%%%%%