%Image_Rotate()图像旋转函数：基于水平投影分析结果，计算车牌旋转角度，并输出旋转图像
function [rbw]=Image_Rotate(bw1,markrow3,markrow4)
%(1)在上升点至下降点找第一个为 1的点
[m2,n2]=size(bw1);     %sbw1的图像大小
[m3,n3]=size(markrow4); %markrow4的大小
maxw=max(markrow4);     %最大宽度为字符
if markrow4(1) ~= maxw  %检测上边
ysite=1;
k1=1;
for l=1:n2
 for k=1:markrow3(ysite)%从顶边至第一个峰下降点扫描
  if bw1(k,l)==1
    xdata(k1)=l;
    ydata(k1)=k;
    k1=k1+1;
  break;
  end
 end
end
 else %检测下边
   ysite=n3;
 if markrow4(n3) ==0
    if markrow4(n3-1) ==maxw
    ysite= 0; %无下边
    else
      ysite= n3-1;
    end
 end
 if ysite ~=0
    k1=1;
   for l=1:n2
     k=m2;
    while k>=markrow(ysite) % 从底边至最后一个峰的上升点扫描
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
%(2)线性拟合，计算与水平轴的夹角
fresult = fit(xdata',ydata','poly1'); %poly1  Y = p1*x+p2
p1=fresult.p1;
angle=atan(fresult.p1)*180/pi; %弧度换为度， 360/2pi, pi=3.14
%(3)旋转车牌图象
rbw = imrotate(bw1,angle,'bilinear','crop');%旋转图像
%%%%%
figure,imshow(rbw);title('');%输出车牌旋转后的灰度图像
title(['车牌旋转角：',num2str(angle),'度'] ,'Color','r', 'FontWeight', 'Bold');%显示车牌的旋转角度
%%%%%