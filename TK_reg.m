% Load image
I = im2double(imread('Star_Trek.jpg'));
I = im2gray(I);
figure(1); imshow(I); title('Source image');
I_fft=fftshift(fft2(I));
Ifft=log(I_fft)/20;

% Blur image
PSF = fspecial('disk', 30);
Blurred1 = imfilter(I, PSF,'circular','conv' );
BI_fft=fftshift(fft2(Blurred1));
BIfft=log(BI_fft)/20;

%Degradation Model
K=abs(BI_fft./I_fft);
filename = 'K.mat';
save(filename)

% Add noise
noise_mean = 0;
noise_std=.05;
noise_var = noise_std^2;
Blurred = imnoise(Blurred1, 'gaussian', noise_mean, noise_var);
figure(2); imshow(Blurred); title('Blurred image');
estimated_nsr = noise_var / var(Blurred(:));

% Restore image
% figure(3), imshow(deconvwnr(Blurred, PSF, estimated_nsr)), title('Wiener');
uo=deconvreg(Blurred, PSF);
figure(3); imshow(uo); title('Regul');
imwrite(Blurred1,'f1.jpg')
imwrite(Blurred,'f.jpg')
imwrite(K,'K.jpg')
imwrite(uo,'uo.jpg')