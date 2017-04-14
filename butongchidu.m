clc
clear
f1=imread('lena.jpg');
image1=im2double(rgb2gray(f1));
[keypt1 desc1]=sift(image1);
%x=0:0.1:4;%不同尺度
%x=-90:4.5:90;%不同角度
x=0.5:0.0375:2;%不同大小
y=[];
%不同尺度：y=[317,317,316,288,255,235,217,200,187,169,162,158,153,150,133,136,132,134,128,120,124,124,126,121,116,115,118,114,118,117,123,122,118,118,118,118,120,116,120,119,119;]
%不同角度：y=[42,39,58,55,59,68,67,74,79,95,85,106,116,109,139,117,138,139,136,161,317,144,138,120,158,129,110,103,100,78,72,79,61,42,32,28,32,21,21,21,18;]
%不同大小：y=[41,27,31,39,25,25,37,57,69,94,109,125,178,250,222,177,154,146,133,108,109,87,77,63,44,33,32,23,31,23,33,30,29,35,42,47,59,58,52,55,71;]
for i=1:41;
matchset=[];

%G = fspecial('gaussian', [5 5],i/10);
%f2 = imfilter(f1,G,'same');%不同尺度
%f2=imrotate(f1,x(i),'nearest'); %不同角度
f2=imresize(f1,x(i),'nearest');%不同大小

image2=im2double(rgb2gray(f2));
[keypt2 desc2]=sift(image2);
cnt=size(keypt1,1);
S=3;
O=3;
sigm=1.6;
[n,d]=knnsearch(desc2,desc1,'k',2);
num=0;
[dist,idx]=sort(d(:,1));
for i=1:cnt
    if d(i,1)/d(i,2)<0.8%&&idx(i)<500
        num=num+1;
        matchset(num,1)=i;
        matchset(num,2)=n(i,1);
    end
end
 NMImatch=[keypt1(matchset(:,1),[1 2]) keypt2(matchset(:,2),[1 2]) keypt1(matchset(:,1),5)-keypt2(matchset(:,2),5)];
 matchset=matchset(find(abs(NMImatch(:,5))<0.05),:);
 num=size(matchset,1);
 y=[y num];
end
plot(x,y,'-+')

