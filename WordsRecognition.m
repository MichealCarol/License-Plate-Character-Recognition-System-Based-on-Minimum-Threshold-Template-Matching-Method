%WordsRecognition( )�ַ�ʶ��������ȡ�ָ��ַ�,����ÿ���ַ�����ʶ�����
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
      SegBw1 = sbw1(1:maxhight,markcol5(t+1)-maxwidth/2:markcol5(t+1)+maxwidth/2);%���ַ���ȡSegBw1��ÿ�δ��һ���ַ�
      SegBw2 = imresize(SegBw1,[32 16]);%�任Ϊ32��16�б�׼��ͼ
      SegBw2 = SegBw2+0;%��������ת�����߼�ֵתdouble��
  end
  name=strcat('�ַ�',int2str(T));
subplot(1,7,T),imshow(SegBw2),title(name);
fname=strcat('G:\MLData\segment\segimage',int2str(T),'.jpg');%���ɷָ��ַ���ͼ�ı���·��
imwrite(SegBw2,fname,'jpg') %����ָ��ַ���ͼ
  
  switch  t %ʶ���������Χ��ѡ�񣬼��������ַ�λ��ȷ��������Χ
     case 1  %��һλ����ʶ��
        kmin=37;
        kmax=67;
     case 2  %�ڶ�λA~Z ��ĸʶ��
        kmin=11;
        kmax=36;
     case 3  %����λ�ָ���'��'������ʶ��

     otherwise%��������λ0~9 ����ʶ��   
        kmin=1;
        kmax=36;
  end
  SumComm=[];
  if t==3
      RecogReult(t)='��';%����λ�ָ���'��'�Ķ���
  else    
  for r=kmin:kmax
   gname=strcat('G:\MLData\sample\sample',int2str(r),'.jpg');
   %����·�������ڶ�ȡʶ�������ֿ�
   SamBw2 = imread(gname);
   SamBw2 = im2double(SamBw2);
   SumComm(r-kmin+1)=sum(sum(abs(SegBw2-SamBw2))); %ȡŷ�Ͼ���������
  end
  MinSum=min(SumComm);%ȡ��Сŷ�Ͼ��룬Ҳ����С��ֵL
  findc=find(SumComm==MinSum) ;%����������С��ֵ��ͼ����ţ�ʵ���ַ�ʶ��
  if length(findc)>1
     findc=min(findc);%���ڳ����ϵ�����'0'����ĸ'O'��ͬ��ͬʱ����ʱȡ����'0'
  end  
  liccode=char(['0':'9' 'A':'Z' '�����弽ԥ���ɺ�����³�ո���������ʽ����¼�������ش�������']) ; %�����Զ�ʶ���ַ������
  RecogBw=liccode(findc+kmin-1);%ȡʶ����
  RecogReult(t)=RecogBw;%����ʶ����
  end
end