clc;
clear;
img = imread ('library.jpg');
img = rgb2gray(img);
figure(1),imshow(img,[]);
img = double (img);

% Value for high and low thresholding
threshold_low = 0.035;
threshold_high = 0.175;
 
%% Gaussian filter definition (https://en.wikipedia.org/wiki/Canny_edge_detector)
G = [2, 4, 5, 4, 2; 4, 9, 12, 9, 4;5, 12, 15, 12, 5;4, 9, 12, 9, 4;2, 4, 5, 4, 2];
G = 1/159.* G;
 
%Filter for horizontal and vertical direction
dx = [1 0 -1];
dy = [1; 0; -1];

%% Convolution of image with Gaussian
Gx = conv2(G, dx, 'same');
Gy = conv2(G, dy, 'same');
 
% Convolution of image with Gx and Gy
Ix = conv2(img, Gx, 'same');
Iy = conv2(img, Gy, 'same');


%% Calculate magnitude and angle
magnitude = sqrt(Ix.*Ix+Iy.*Iy);
angle = atan2(Iy, Ix);
 
%% Edge angle conditioning
angle(angle<0) = pi+angle(angle<0);
angle(angle>7*pi/8) = pi-angle(angle>7*pi/8);

% Edge angle discretization into 0, pi/4, pi/2, 3*pi/4
angle(angle>=0&angle<pi/8) = 0;
angle(angle>=pi/8&angle<3*pi/8) = pi/4;
angle(angle>=3*pi/8&angle<5*pi/8) = pi/2;
angle(angle>=5*pi/8&angle<=7*pi/8) = 3*pi/4;

%% initialize the images
[nr, nc] = size(img);
edge = zeros(nr, nc);
 
%% Non-Maximum Supression
edge = non_maximum_suppression(magnitude, angle, edge); 
edge = edge.*magnitude;
figure(2),imshow(edge,[]);
%% Hysteresis thresholding
% for weak edge
threshold_low = threshold_low * max(edge(:));
% for strong edge
threshold_high = threshold_high * max(edge(:));  
linked_edge = zeros(nr, nc); 
linked_edge = hysteresis_thresholding(threshold_low, threshold_high, linked_edge, edge);
figure(3),imshow(linked_edge,[]);

%%
function edge = non_maximum_suppression(magnitude, angle, edge)
    [nr,nc] = size(edge);
    for y = 2 : (nr -1)
        for x = 2 : (nc - 1)
            switch angle(y,x)
                case 0
                    if magnitude(y,x) > magnitude(y,x - 1) && magnitude(y,x) > magnitude(y,x + 1)
                        edge(y,x) = 1;
                    end
                case pi/4
                     if magnitude(y,x) > magnitude(y + 1,x - 1) && magnitude(y,x) > magnitude(y - 1,x + 1)
                        edge(y,x) = 1;
                    end
                case pi/2
                     if magnitude(y,x) > magnitude(y + 1,x) && magnitude(y,x) > magnitude(y - 1,x)
                        edge(y,x) = 1;
                    end
                case 3*pi/4
                     if magnitude(y,x) > magnitude(y - 1,x - 1) && magnitude(y,x) > magnitude(y + 1,x + 1)
                        edge(y,x) = 1;
                    end
            end
        end
    end
end

function linked_edge = hysteresis_thresholding(threshold_low, threshold_high, linked_edge, edge)
    set(0,'RecursionLimit',10000);
    [nr,nc] = size(edge);
    for y = 2 : (nr -1)
        for x = 2 : (nc - 1)
            if edge(y,x) > threshold_high && linked_edge(y,x) ~= 1
                linked_edge(y,x) = 1;
                linked_edge = connect(threshold_low,linked_edge,edge,y,x);
            end
        end
    end
end

function linked_edge = connect(threshold_low, linked_edge,edge,y,x)
    neighbour=[-1 -1;-1 0;-1 1;0 -1;0 1;1 -1;1 0;1 1];
    [m,n] = size(edge);
    for k = 1:8
        yy = y + neighbour(k,1);
        xx = x + neighbour(k,2);
        if yy > 1 && yy <= m && xx > 1 && xx <=n
            if edge(yy,xx) > threshold_low && linked_edge(yy,xx) ~= 1
                linked_edge(yy,xx) = 1;
                linked_edge = connect(threshold_low, linked_edge, edge,yy,xx);
            end
        end
    end
end