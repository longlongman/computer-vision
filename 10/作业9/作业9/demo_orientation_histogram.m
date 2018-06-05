
% demo_orientation_histogram

% Set the random seeds
seed = 1234;
RNDN_STATE = randn('state');  %#ok<*RAND>
randn('state', seed);
RND_STATE = rand('state');
rand('twister', seed);

% Make a 5 x 5 image patch from its gradient along x and y direction
gradx = randn(5,5) * 1.5;
grady = randn(5,5) * 1.5;

% Set the gradx(1,1) gradx(1,2) grady(1,1) grady(1,2) to coincide with the
% presentation
gradx(1,1) = 5.0 * cos(pi/4 + pi/16);
grady(1,1) = 5.0 * sin(pi/4 + pi/16);
gradx(1,2) = 6.5 * cos(2.5*pi/16);
grady(1,2) = 6.5 * sin(2.5*pi/16);

gradx = 0.2 * gradx;
grady = 0.2 * grady;

% Compute the Magnitute and the Orientation
mag = sqrt(gradx.^2 + grady.^2);
ori = atan2(grady, gradx);
ori(ori==pi) = -pi;

% magnitude image with orientation
figure(1);imagesc(mag); colormap gray; axis equal image off;
hold on;
[xx,yy] = meshgrid(1:5,1:5);
quiver(xx, yy, gradx, grady, 0, 'linewidth',2 );
hold off;
cdata = print('-RGBImage');
imwrite(cdata, 'magwori.png');

% only manitude image
figure(2);imagesc(mag); colormap gray; axis equal image off;
cdata = print('-RGBImage');
imwrite(cdata, 'mag.png');

% manitude image with the first orientation
figure(3);imagesc(mag); colormap gray; axis equal image off;
hold on;
quiver(xx(1,1), yy(1,1), gradx(1,1), grady(1,1), 0, 'linewidth',2 );
hold off;
cdata = print('-RGBImage');
imwrite(cdata, 'magwori1.png');

% manitude image with the first and 2nd orientation
figure(4);imagesc(mag); colormap gray; axis equal image off;
hold on;
quiver(xx(1,1:2), yy(1,1:2), gradx(1,1:2), grady(1,1:2), 0, 'linewidth',2 );
hold off;
cdata = print('-RGBImage');
imwrite(cdata, 'magwori12.png');

% manitude image with the 1st, 2nd, 3rd orientation
figure(5);imagesc(mag); colormap gray; axis equal image off;
hold on;
quiver(xx(1,1:3), yy(1,1:3), gradx(1,1:3), grady(1,1:3), 0, 'linewidth',2 );
hold off;
cdata = print('-RGBImage');
imwrite(cdata, 'magwori123.png');

% Get the histogram bins
num_bins = 8;
step_bin = 2 * pi/num_bins;
bins = -pi : step_bin : pi;
if(length(bins) > num_bins)
    bins = bins(1:end-1);
end

% Compute the Gaussian distance function
sigma = 1;
[xg,yg] = meshgrid(-2:2, -2:2);
G = exp(-(xg.^2+yg.^2)/(2*sigma^2));

%% Do the histogram calculation
% find the orientation difference
odiff = repmat(ori(:),[1 num_bins]) - repmat(bins(:)',[25,1]);
odiff = mod(odiff, 2*pi) - pi;
odiff = 1 - abs(odiff)/step_bin;
odiff(odiff<0) = 0;

wghts = odiff .* repmat(G(:).*mag(:), [1 num_bins]);

ohist = sum(wghts,1); % unormalized orientation histogram