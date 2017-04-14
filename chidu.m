f1=imread('lena.jpg');
imshow(im2double(f1));
for i=1:5
G = fspecial('gaussian', [3*i 3*i],3*i);
f2 = imfilter(f1,G,'same');
figure;
imshow(im2double(f2));
end