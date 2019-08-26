%code to compute an svd-based approximation of an image. 
%Based on a tutorial taught by Eric Kostelich at the 2016 MCRN summer
%school.

A = imread('./dog_bw.jpg'); %get image
B = double(A(:, :, 1)) ; 
B = B / 256; %convert image to something Matlab understands (shades in [0,1])

%plot original image
figure; set(gcf,'color','w'); 
image(repmat(B,1,1,3))
xticks([]); yticks([]); 
pbaspect([2448/3264 1 1]) %set the aspect ratio equal to the original photo
title('Original Photo')


r = 10; %VARY THIS! This sets the rank of the image approximation. 
%Try 5, 10, 20, 40, and any other values you like. 

if ~exist('V', 'var') %if you have not run this file already
    [U, S, V] = svd(B,'econ'); %compute the svd - slowest part of the code
end

%truncate the svd to get an approximation of the original image
Ur = U(:,1:r);
Sr = S(1:r,1:r);
Vr = V(:,1:r);
Br = Ur*Sr*Vr'; %Br is the approximation 

%Because Matlab wants a matrix of values for each colour, copy Br three
%times to make a big array, C
C = ones(size(A));
C(:, :, 1) = Br; 
C(:, :, 2) = Br;
C(:, :, 3) = Br;

%do some spring cleaning - make sure all entries are in [0,1] (occasionally
%numerical error makes an entry *very* slightly negative, or larger than 1)
C(:, :, :) = min(1, C(:, :, :)); 
C(:, :, :) = max(0, C(:, :, :)); 

%plot the svd approximation
figure; set(gcf,'color','w'); 
image(C)
xticks([]); yticks([]);
pbaspect([2448/3264 1 1])
title(['Rank ' num2str(r) ' approximation'])

%work out how much data we threw away
[B1,B2] = size(B);
disp(['Original photo was dimension ' num2str(B1*B2) ...
    ', and svd version is dimension ' num2str(r^2+B1*r+B2*r) '. '])

%extension project: fix my lazy choice to only work in black and white.
%Instead save a matrix B1 = A(:,:,1), B2 = A(:,:,2), B3 = A(:,:,3) 
%(B1 is red values, B2 is green, B3 is blue)
%Then do an svd decomposition on each of B1, B2, B3, truncate them
%individually, and save the results in C (e.g. C(:,:,1) = B1, and so on). 
%You'll need to import dog_c.jpg into A in line 5, instead of dog_bw.jpg.