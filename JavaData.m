clear
clc
desc1=load('lena_int.dat');
desc2=load('lena_rotate_int.dat');
cnt=size(desc1,1);
[n,d]=knnsearch(desc2,desc1,'k',2);
num=0;
% num=20;
[dist,idx]=sort(d(:,1));
% for i=1:num
%     matchset(i,1)=(idx(i));
%     matchset(i,2)=n(idx(i));
% end
for i=1:cnt
    if d(i,1)/d(i,2)<0.8%&&idx(i)<500
        num=num+1;
        matchset(num,1)=i;
        matchset(num,2)=n(i,1);
    end
end
