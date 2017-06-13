%WordsRecognition( )字符识别函数：提取分割字符,并对每个字符进行识别输出
function RecogReult=WordsRecognition(sbw1,maxhight,maxwidth,markcol5)
figure;
for t=1:8
  if t<=2
      T=t;
  elseif t>=4 && t<=8
      T=t-1;
  end
  if t== 3
  else
      SegBw1 = sbw1(1:maxhight,markcol5(t+1)-maxwidth/2:markcol5(t+1)+maxwidth/2);%单字符提取SegBw1，每次存放一个字符
      SegBw2 = imresize(SegBw1,[32 16]);%变换为32行16列标准子图
      SegBw2 = SegBw2+0;%数据类型转换：逻辑值转double型
  end
  name=strcat('字符',int2str(T));
subplot(1,7,T),imshow(SegBw2),title(name);
fname=strcat('G:\MLData\segment\segimage',int2str(T),'.jpg');%生成分割字符子图的保存路径
imwrite(SegBw2,fname,'jpg') %保存分割字符子图
  
  switch  t %识别参数（范围）选择，即：根据字符位置确定搜索范围
     case 1  %第一位汉字识别
        kmin=37;
        kmax=67;
     case 2  %第二位A~Z 字母识别
        kmin=11;
        kmax=36;
     case 3  %二三位分隔符'·'，无需识别

     otherwise%第三～七位0~9 数字识别   
        kmin=1;
        kmax=36;
  end
  SumComm=[];
  if t==3
      RecogReult(t)='·';%二三位分隔符'·'的定义
  else    
  for r=kmin:kmax
   gname=strcat('G:\MLData\sample\sample',int2str(r),'.jpg');
   %生成路径，用于读取识别样板字库
   SamBw2 = imread(gname);
   SamBw2 = im2double(SamBw2);
   SumComm(r-kmin+1)=sum(sum(abs(SegBw2-SamBw2))); %取欧氏距离相似性
  end
  MinSum=min(SumComm);%取最小欧氏距离，也即最小阈值L
  findc=find(SumComm==MinSum) ;%查找满足最小阈值的图像序号，实现字符识别
  if length(findc)>1
     findc=min(findc);%由于车牌上的数字'0'与字母'O'相同，同时出现时取数字'0'
  end  
  liccode=char(['0':'9' 'A':'Z' '京津沪渝冀豫云辽黑湘皖鲁苏赣浙粤鄂桂甘晋蒙陕吉闽贵青藏川宁新琼']) ; %建立自动识别字符代码表
  RecogBw=liccode(findc+kmin-1);%取识别结果
  RecogReult(t)=RecogBw;%保存识别结果
  end
end